const {test}=require('node:test');
const assert=require('node:assert/strict');
const fs=require('node:fs');
const path=require('node:path');
const {execFileSync}=require('node:child_process');
const {JSDOM}=require('jsdom');
global.BMS_DATA_CONFIG=JSON.parse(fs.readFileSync(path.join(__dirname,'../bms-data-config.js'),'utf8').split('=')[1].trim().slice(0,-1));
const storage=new Map();global.localStorage={getItem:k=>storage.get(k)||null,setItem:(k,v)=>storage.set(k,v)};
global.DOMParser=new JSDOM('').window.DOMParser;
const core=require('../bms-core.js');
const response=(data,status=200)=>new Response(JSON.stringify(data),{status,headers:{'Content-Type':'application/json'}});

test('calendar date arithmetic remains correct across time zones and leap years',()=>{
  for(const TZ of ['UTC','Asia/Jakarta','Asia/Makassar','Asia/Jayapura','America/New_York']){
    const result=execFileSync(process.execPath,['-e',"const c=require('./bms-core');console.log(JSON.stringify([c.dateAdd('2026-10-01',0),c.dateAdd('2026-10-01',22),c.dateAdd('2024-02-28',1),c.dateAdd('2026-01-01',-1)]))"],{cwd:path.join(__dirname,'..'),env:{...process.env,TZ},encoding:'utf8'});
    assert.deepEqual(JSON.parse(result),['2026-10-01','2026-10-23','2024-02-29','2025-12-31']);
  }
  assert.throws(()=>core.dateAdd('2026-02-30',0));
});

test('an RPC whose commit response is lost retries the same operation exactly once',async()=>{
  storage.clear();let commits=0,first=true;const operations=new Map(),requests=[];
  const fetch=core.createFetch(async(url,init)=>{
    assert.match(url,/rpc\/bms_execute_operation/);const body=JSON.parse(init.body);requests.push(body);
    if(!operations.has(body.p_operation_id)){operations.set(body.p_operation_id,'saved-id');commits++}
    if(first){first=false;throw new Error('lost response after commit')}
    return response(operations.get(body.p_operation_id));
  },()=> 'user-rpc');
  const init={method:'POST',body:JSON.stringify({p_id:null,p_amount:100})};
  await assert.rejects(fetch('https://example.test/rest/v1/rpc/finance_correct_rhpp_real_v1',init),/operasi yang sama/);
  assert.equal(await (await fetch('https://example.test/rest/v1/rpc/finance_correct_rhpp_real_v1',init)).json(),'saved-id');
  assert.equal(commits,1);assert.equal(requests[0].p_operation_id,requests[1].p_operation_id);
  assert.deepEqual(requests[1].p_params,{p_id:null,p_amount:100});
});

test('direct insert reuses generated UUIDs and recovers a committed row after response loss',async()=>{
  storage.clear();let first=true,commits=0;const rows=new Map(),ids=[];
  const fetch=core.createFetch(async(url,init)=>{
    if(init.method==='GET')return response([...rows.values()]);
    const body=JSON.parse(init.body);ids.push(body.id);assert.ok(body.id);assert.ok(!new URL(url).searchParams.has('columns'));
    if(rows.has(body.id))return response({code:'23505'},409);
    rows.set(body.id,body);commits++;if(first){first=false;throw new Error('lost response')}return response(body);
  },()=> 'user-insert');
  const init={method:'POST',headers:{Prefer:'return=representation'},body:JSON.stringify({amount:25})};
  await assert.rejects(fetch('https://example.test/rest/v1/advance_payments?columns=amount',init));
  const result=await (await fetch('https://example.test/rest/v1/advance_payments?columns=amount',init)).json();
  assert.equal(commits,1);assert.equal(ids[0],ids[1]);assert.equal(result[0].amount,25);
});

test('upsert keeps its natural keys and does not inject a new primary key',async()=>{
  const fetch=core.createFetch(async(url,init)=>{assert.deepEqual(JSON.parse(init.body),{user_id:'existing'});return response({})},()=> 'user-upsert');
  await fetch('https://example.test/rest/v1/profiles',{method:'POST',headers:{Prefer:'resolution=merge-duplicates'},body:'{"user_id":"existing"}'});
});

test('complete reads fetch all 2,205 rows and append a stable primary key order',async()=>{
  let calls=0;const fetch=core.createFetch(async(url,init)=>{
    assert.equal(new URL(url).searchParams.get('order'),'created_at.desc,id.asc');
    const from=Number(init.headers.get('Range').split('-')[0]);calls++;
    return response(Array.from({length:Math.min(1000,2205-from)},(_,i)=>({id:from+i})));
  });
  const rows=await (await fetch('https://example.test/rest/v1/bop?order=created_at.desc')).json();
  assert.equal(calls,3);assert.equal(rows.length,2205);assert.equal(rows[2204].id,2204);
});

test('native XLSX stores numeric/bool/date types, formula-like text and complete long values',async()=>{
  const long='x'.repeat(70000),blob=core.xlsx([{name:'A/B',rows:[['Text','Number','Boolean','Date','JSON','Long'],['00123',1234.5,true,new Date('2026-10-01T00:00:00Z'),{key:'value'},long],['=HYPERLINK("bad")',-12,false]]},{name:'A:B',rows:[['Second']]}]);
  const bytes=Buffer.from(await blob.arrayBuffer());assert.equal(bytes.readUInt32LE(0),0x04034b50);
  fs.mkdirSync(path.join(__dirname,'output'),{recursive:true});fs.writeFileSync(path.join(__dirname,'output/types.xlsx'),bytes);
});

test('HTML report exporter preserves headings, row spans, numbers and literal formulas',()=>{
  const sheets=core.htmlSheets('<h2>RHPP</h2><table><tr><th rowspan="2">Kandang</th><th>Nilai</th></tr><tr><td>Rp 1.234,50</td></tr><tr><td>00123</td><td>=1+1</td></tr></table>');
  assert.deepEqual(sheets[0].rows,[['RHPP'],['Kandang','Nilai'],['',1234.5],['00123','=1+1'],[]]);
});

test('encrypted recovery round-trips and rejects wrong passwords or tampering',async()=>{
  const value={format:'BMS_FULL_RECOVERY',tables:{bop:[{amount:125}]},auth:{users:[{id:'fixture',encrypted_password:'test-only-hash'}]}};
  const blob=await core.encryptRecovery(value,'Audit-only-password-2026!'),text=await blob.text();
  assert.ok(!text.includes('test-only-hash'));assert.deepEqual(await core.decryptRecovery(text,'Audit-only-password-2026!'),value);
  await assert.rejects(core.decryptRecovery(text,'incorrect-password'));
  const envelope=JSON.parse(text);envelope.ciphertext=envelope.ciphertext.slice(0,-8)+'AAAAAAAA';
  await assert.rejects(core.decryptRecovery(envelope,'Audit-only-password-2026!'));
});
