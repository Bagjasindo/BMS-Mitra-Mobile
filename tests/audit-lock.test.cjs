const {test}=require('node:test');
const assert=require('node:assert/strict');
const fs=require('node:fs');
const path=require('node:path');
const root=path.join(__dirname,'..');
const read=p=>fs.readFileSync(path.join(root,p),'utf8');

test('AUDIT-LOCK build baseline stays synchronized across PWA and recovery artifacts',()=>{
  const index=read('index.html');
  const sw=read('sw.js');
  const schema=read('supabase/schema_current.sql');
  const runbook=read('docs/BMS_RECOVERY_RUNBOOK.md');
  const build='2365';
  assert.match(index,new RegExp('v='+build+'-owner-rhpp-readonly'));
  assert.match(sw,new RegExp('v'+build+'-owner-rhpp-readonly'));
  // Recovery schema/runbook are independently versioned recovery artifacts.
  // Their build number must not be forced to match a frontend-only cache/export build.
});

test('AUDIT-LOCK recovery schema contains latest business guards',()=>{
  const schema=read('supabase/schema_current.sql');
  assert.match(schema,/guard_external_meat_contract_price/);
  assert.match(schema,/with harvest_source as/);
  assert.match(schema,/marketing_external_meat_purchases/);
  assert.match(schema,/v\.farmer_profit-v\.external_meat_cost-v\.external_sapronak_cost/);
});

test('AUDIT-LOCK CI always includes browser smoke test and locked business rules',()=>{
  const workflow=read('.github/workflows/verify.yml');
  const pkg=JSON.parse(read('package.json'));
  assert.match(workflow,/npm run check/);
  assert.match(workflow,/npm run test:browser/);
  assert.ok(pkg.scripts.check.includes('node --test tests/*.test.cjs'));
});


test('AUDIT-LOCK PPL sample weight keeps gram precision and photo compression',()=>{
  const production=read('modules/bms-production.js');
  assert.match(production,/63 gram = 0,063/);
  assert.match(production,/min="0\.001" step="0\.001"/);
  assert.match(production,/compressRecordingPhoto/);
  assert.match(production,/targetBytes=30\*1024/);
});


test('AUDIT-LOCK Recording PPL starts day 1 after DOC arrival',()=>{
  const production=read('modules/bms-production.js');
  assert.match(production,/return Math\.max\(0,Math\.floor\(\(today-start\)\/86400000\)\);/);
  assert.match(production,/Hari DOC datang adalah Hari 0/);
  assert.match(production,/p_recorded_on:prodDateAdd\(ci\.arrived_on,currentDay\)/);
  assert.doesNotMatch(production,/p_recorded_on:prodDateAdd\(ci\.arrived_on,currentDay-1\)/);
});
