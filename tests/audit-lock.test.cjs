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
  const build='2340';
  assert.match(index,new RegExp('v='+build+'-dead-code-cleanup'));
  assert.match(sw,new RegExp('v'+build+'-dead-code-cleanup'));
  assert.match(schema,new RegExp('build '+build));
  assert.match(runbook,new RegExp('build '+build));
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
