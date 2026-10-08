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
  const build='2384';
  assert.match(index,new RegExp('v='+build+'-kpi-reference-icons'));
  assert.match(sw,new RegExp('v'+build+'-kpi-reference-icons'));
  // Recovery schema/runbook are independently versioned recovery artifacts.
  // Their build number must not be forced to match a frontend-only cache/export build.
});

test('AUDIT-LOCK recovery schema contains latest business guards',()=>{
  const schema=read('supabase/schema_current.sql');
  assert.match(schema,/guard_external_meat_contract_price/);
  assert.match(schema,/with harvest_source as/);
  assert.match(schema,/marketing_external_meat_purchases/);
  assert.match(schema,/Harga beli aktual per Kg wajib lebih dari 0/);
  assert.doesNotMatch(schema,/new\.purchase_price_per_kg := v_price/);
  assert.match(schema,/m\.weight_kg\*cp\.price_per_kg/);
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


test('AUDIT-LOCK completion pack keeps reports filters status and correction controls wired',()=>{
  const logistics=read('modules/bms-master-logistics.js');
  const finance=read('modules/bms-finance.js');
  const production=read('modules/bms-production.js');
  const admin=read('modules/bms-admin.js');
  const schema=read('supabase/schema_current.sql');

  for(const id of [
    'mandiriPurchasePrint','shippingHistoryPrint','externalHistoryPrint','returnHistoryPrint',
    'externalReturnHistoryPrint','equipmentHistoryPrint','harvestMitraHistoryPrint',
    'harvestMandiriHistoryPrint','meatHistoryPrint'
  ]) assert.match(logistics+finance,new RegExp(id));

  for(const id of [
    'assetHistoryPrint','goodsHistoryPrint','mandiriReceivablePrint','mandiriReceiptHistoryPrint',
    'mandiriDebtPrint','mandiriSupplierHistoryPrint','mandiriReportPrint','fxPaymentHistoryPrint',
    'fxBopHistoryPrint','fxMaintenancePrint','warehouseStockPrint','warehouseSendPrint','expMasterPrint'
  ]) assert.match(finance,new RegExp(id));

  for(const id of ['recordingHistoryPrint','estimateHistoryPrint','abkHistoryPrint','leagueBarnPrint'])
    assert.match(production,new RegExp(id));

  assert.match(admin,/data-toggle-barn/);
  assert.match(admin,/data-toggle-item/);
  assert.match(admin,/assetMasterPrint/);
  assert.match(admin,/activityLogPrint/);
  assert.match(logistics,/marketingCustomerTable/);
  assert.match(logistics,/contractTemplatePrint/);
  assert.match(logistics,/performanceMasterPrint/);

  for(const rpc of [
    'delete_logistics_equipment_purchase_atomic',
    'correct_warehouse_stock_shipment_atomic',
    'delete_warehouse_stock_shipment_atomic',
    'finance_correct_stock_invoice_atomic',
    'finance_delete_stock_invoice_atomic',
    'finance_correct_asset_invoice_atomic',
    'finance_delete_asset_invoice_atomic'
  ]) assert.match(schema,new RegExp(rpc));
});


test('OWNER mobile navigation controls stay enabled while content remains read-only',()=>{
  const main=read('main-2321.js');
  assert.match(main,/btn\.closest\('nav,\.mobile-topbar,\.mobile-drawer-head'\)\)return/);
  assert.match(main,/btn\.hasAttribute\('data-tab'\)\|\|btn\.closest\('nav,\.mobile-topbar,\.mobile-drawer-head'\)\)return/);
});


test('OWNER global read-only keeps report filters interactive and blocks mutations',()=>{
  const main=read('main-2321.js');
  assert.match(main,/mutationText=/);
  assert.match(main,/if\(!mutating\)return;/);
  assert.match(main,/if\(isMutationButton\(btn\)\)\{btn\.disabled=true;btn\.hidden=true;\}/);
  assert.doesNotMatch(main,/form\.querySelectorAll\('input,select,textarea'\)\.forEach\(el=>\{el\.disabled=true;\}\)/);
});


test('mobile PDF saves real files instead of routing PDF buttons through print',()=>{
  const core=read('bms-core.js');
  const main=read('main-2321.js');
  const logistics=read('modules/bms-master-logistics.js');
  const production=read('modules/bms-production.js');
  const finance=read('modules/bms-finance.js');
  const rhpp=read('modules/bms-rhpp-users.js');
  const reports=read('modules/bms-dashboard-reports.js');
  assert.match(core,/function pdfBlobFromHtml/);
  assert.match(core,/async function savePdfHtml/);
  assert.match(core,/application\/pdf/);
  assert.match(core,/navigator\.share/);
  for(const src of [main,logistics,production,finance,rhpp,reports])assert.match(src,/BMSCore\.savePdfHtml/);
  for(const src of [main,logistics,production,finance,rhpp,reports])assert.doesNotMatch(src,/Pdf[^\n]{0,160}onclick[^\n]{0,160}(?:print\(|openPrint|printOpen)/);
});


test('desktop neon theme stays desktop-only and preserves mobile styles',()=>{
  const css=read('style.css');
  const marker=css.indexOf('/* desktop-neon-blue-2376 */');
  assert.ok(marker>=0);
  const block=css.slice(marker);
  assert.match(block,/@media \(min-width:901px\)\{/);
  assert.match(block,/--desk-bg:#020b18/);
  assert.match(block,/background:linear-gradient\(180deg,rgba\(2,14,29/);
  assert.match(block,/border-color:rgba\(37,153,255/);
  assert.doesNotMatch(block,/@media\(max-width:700px\)/);
});


test('desktop dashboard neon refinement removes light owner surfaces',()=>{
  const css=read('style.css');
  const marker=css.indexOf('/* desktop-dashboard-neon-refine-2377 */');
  assert.ok(marker>=0);
  const block=css.slice(marker);
  assert.match(block,/\.owner-hero\{/);
  assert.match(block,/\.owner-barn-card\{/);
  assert.match(block,/\.owner-metrics div\{/);
  assert.match(block,/\.owner-estimate-card\{/);
  assert.match(block,/linear-gradient\(145deg,rgba\(8,35,62/);
  assert.doesNotMatch(block,/@media\(max-width:700px\)/);
});


test('final desktop neon override loads after mobile stylesheet',()=>{
  const html=read('index.html');
  const css=read('desktop-neon.css');
  const mobilePos=html.indexOf('mobile-form-responsive.css');
  const neonPos=html.indexOf('desktop-neon.css');
  assert.ok(mobilePos>=0&&neonPos>mobilePos);
  assert.match(css,/@media \(min-width:901px\)/);
  assert.match(css,/\.owner-hero\{/);
  assert.match(css,/\.owner-barn-card\{/);
  assert.match(css,/\.owner-table td,\.owner-league td/);
});


test('desktop premium polish remains desktop-only',()=>{
  const css=read('desktop-neon.css');
  const marker=css.indexOf('/* premium-desktop-polish-2379 */');
  assert.ok(marker>=0);
  const block=css.slice(marker);
  assert.match(block,/@media \(min-width:901px\)/);
  assert.match(block,/#appSidebar nav button\.active/);
  assert.match(block,/\.owner-kpis \.card:hover/);
  assert.match(block,/\.owner-barn-card:hover/);
  assert.match(block,/\.owner-table th,\.owner-league th/);
  assert.doesNotMatch(block,/@media\s*\(max-width:/);
});


test('desktop dashboard compact flow removes empty vertical stretch',()=>{
  const css=read('desktop-neon.css');
  const marker=css.indexOf('/* compact-dashboard-flow-2380 */');
  assert.ok(marker>=0);
  const block=css.slice(marker);
  assert.match(block,/\.owner-grid-main\{\s*align-items:start!important;/);
  assert.match(block,/\.owner-performance,[\s\S]*min-height:0!important;/);
  assert.match(block,/height:auto!important;/);
  assert.doesNotMatch(block,/@media\s*\(max-width:/);
});


test('desktop KPI neon cards use icon and waveform structure',()=>{
  const css=read('desktop-neon.css');
  const reports=read('modules/bms-dashboard-reports.js');
  const marker=css.indexOf('/* kpi-neon-cards-2381 */');
  assert.ok(marker>=0);
  const block=css.slice(marker);
  assert.match(block,/\.owner-kpi-card/);
  assert.match(block,/\.owner-kpi-icon/);
  assert.match(block,/\.owner-kpi-wave/);
  assert.match(reports,/owner-kpi-icon/);
  assert.match(reports,/owner-kpi-wave/);
  assert.match(reports,/kpiIcons/);
  assert.doesNotMatch(block,/@media\s*\(max-width:/);
});


test('KPI SVG hard fix prevents giant filled icons',()=>{
  const css=read('desktop-neon.css');
  const marker=css.indexOf('/* kpi-icon-hard-fix-2382 */');
  assert.ok(marker>=0);
  const block=css.slice(marker);
  assert.match(block,/\.owner-kpi-icon\{[\s\S]*width:50px!important;/);
  assert.match(block,/\.owner-kpi-icon svg\{[\s\S]*width:27px!important;/);
  assert.match(block,/fill:none!important;/);
  assert.match(block,/\.owner-kpi-icon svg path,/);
  assert.match(block,/vector-effect:non-scaling-stroke!important;/);
});


test('desktop hides redundant dashboard hero',()=>{
  const css=read('desktop-neon.css');
  const marker=css.indexOf('/* hide-redundant-dashboard-hero-2383 */');
  assert.ok(marker>=0);
  const block=css.slice(marker);
  assert.match(block,/\.owner-hero\{\s*display:none!important;/);
  assert.doesNotMatch(block,/@media\s*\(max-width:/);
});


test('KPI reference icons use poultry feed production and mortality symbols',()=>{
  const reports=read('modules/bms-dashboard-reports.js');
  const css=read('desktop-neon.css');
  assert.match(reports,/M8 4h8l-1\.3 3/);
  assert.match(reports,/M5 19V13h3v6/);
  assert.match(reports,/M12 20s-7-4\.1-7-9\.1/);
  assert.match(css,/kpi-reference-icon-polish-2384/);
  assert.match(css,/\.owner-kpi-4 \.owner-kpi-icon svg\{stroke:#ff9fc4!important\}/);
});
