const {test}=require('node:test');
const assert=require('node:assert/strict');
const fs=require('node:fs');
const path=require('node:path');

const root=path.join(__dirname,'..');
const read=p=>fs.readFileSync(path.join(root,p),'utf8');
const main=read('main-2321.js');
const users=read('modules/bms-rhpp-users.js');
const admin=read('modules/bms-admin.js');
const schema=read('supabase/schema_current.sql');

test('OWNER sees Administrator navigation but remains read-only',()=>{
  assert.match(main,/if\(\['ADMIN','OWNER'\]\.includes\(profile\?\.role\)\)\{/);
  assert.match(main,/const ownerReadOnly=profile\?\.role==='OWNER'/);
  assert.match(main,/if\(ownerReadOnly\)return;/);
  assert.match(main,/const canRoleDeleteTxn=table=>profile\?\.role!=='OWNER'/);
  assert.match(main,/function enforceOwnerReadOnly\(\)/);
});

test('OWNER can open user master without admin mutation RPC',()=>{
  assert.match(users,/if\(profile\.role==='OWNER'\)\{/);
  assert.match(users,/Mode Owner · baca saja/);
  assert.match(users,/db\.from\('profiles'\)\.select\('user_id,full_name,role,active'\)/);
  assert.match(users,/const \{data,error\}=await db\.rpc\('admin_list_bms_users'\)/);
});

test('OWNER archive page is visible but has no export action',()=>{
  assert.match(admin,/if\(profile\?\.role==='OWNER'\)return layout\('/);
  assert.match(admin,/Backup\/recovery dikelola Administrator/);
});

test('OWNER database parity policies are SELECT-only',()=>{
  const tables=[
    'audit_events','user_activity_logs','profiles','barn_assets','expeditions','harvests',
    'rhpp_estimates','supplies','finance_stock_purchase_invoices','warehouse_stock_items',
    'warehouse_stock_shipments','finance_cash_requests','finance_cash_request_items'
  ];
  for(const table of tables){
    const re=new RegExp('CREATE POLICY "owner_read_all" ON "public"\\."' + table + '" AS PERMISSIVE FOR SELECT TO "authenticated"');
    assert.match(schema,re,table);
  }
});
