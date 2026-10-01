async function financeRhppRealPage(){
  const [sr,rr,ar,br,cr]=await Promise.all([
    db.from('rhpp_system_final').select('*').order('created_at',{ascending:false}),
    db.from('rhpp_real').select('*').order('created_at',{ascending:false}),
    db.from('logistics_contract_assignments').select('id,barn_id,master_contract_id,start_date,active,cycle_type'),
    db.from('barns').select('id,code,name'),
    db.from('contracts').select('id,number').is('cycle_id',null)
  ]);
  const systems=sr.data||[],reals=rr.data||[],assignments=ar.data||[],barns=br.data||[],contractsRows=cr.data||[];
  const err=[sr,rr,ar,br,cr].find(x=>x.error)?.error;
  const canInput=['ADMIN','KEUANGAN'].includes(profile.role);
  const today=new Intl.DateTimeFormat('en-CA',{timeZone:'Asia/Jakarta',year:'numeric',month:'2-digit',day:'2-digit'}).format(new Date());

  window.__financeRhppRealState=window.__financeRhppRealState||{selected:'',barn:'',assignment:'',status:'',shown:false,editRealId:''};
  const st=window.__financeRhppRealState;
  if(st.barn===undefined)st.barn='';
  if(st.assignment===undefined)st.assignment='';

  let cards=systems.map(s=>{
    const a=assignments.find(x=>x.id===s.contract_assignment_id);
    const b=barns.find(x=>x.id===s.barn_id);
    const k=contractsRows.find(x=>x.id===a?.master_contract_id);
    const real=reals.find(x=>x.contract_assignment_id===s.contract_assignment_id);
    const diff=real?prodNum(real.amount)-prodNum(s.system_amount):null;
    const diffLabel=diff===null?'MENUNGGU':diff===0?'SESUAI':diff>0?'REAL LEBIH BESAR':'REAL LEBIH KECIL';
    return {s,a,b,k,real,diff,diffLabel};
  });

  cards=cards.filter(x=>{
    if(st.barn&&x.s.barn_id!==st.barn)return false;
    if(st.assignment&&x.s.contract_assignment_id!==st.assignment)return false;
    if(st.status==='WAITING'&&x.real)return false;
    if(st.status==='DONE'&&!x.real)return false;
    return true;
  });
  const rhppBarns=[...new Map(systems.map(s=>{const b=barns.find(x=>x.id===s.barn_id);return b?[b.id,b]:null}).filter(Boolean)).values()];
  const rhppCycles=assignments.filter(a=>(!st.barn||a.barn_id===st.barn)&&systems.some(s=>s.contract_assignment_id===a.id));

  if(st.selected&&!systems.some(x=>x.contract_assignment_id===st.selected)){
    st.selected='';
  }

  let html=RHPP_SCREEN_STYLE+'<div class="rhpp-ui"><section class="panel"><h3>RHPP Real Keuangan</h3><p class="muted">Data CLOSED wajib dipilih berdasarkan Kandang dan Siklus agar periode tidak tertukar. Input nominal sesuai PDF RHPP Real; tanggal penerimaan dipilih sesuai uang benar-benar diterima dan nominal langsung masuk Arus Kas.</p>'+
    '<form id="rhppRealFilter" class="form-vertical">'+
      '<label>Kandang<select name="barn" id="rhppRealBarn"><option value="">Semua Kandang</option>'+rhppBarns.map(b=>'<option value="'+esc(b.id)+'" '+(st.barn===b.id?'selected':'')+'>'+esc(shortBarnLabel(b))+'</option>').join('')+'</select></label>'+
      '<label>Siklus<select name="assignment" id="rhppRealCycle"><option value="">Semua Siklus</option>'+rhppCycles.map(a=>'<option value="'+esc(a.id)+'" '+(st.assignment===a.id?'selected':'')+'>'+esc(assignmentCycleLabel(assignments,a)+' · '+prodDateId(a.start_date))+'</option>').join('')+'</select></label>'+
      '<label>Status<select name="status"><option value="" '+(!st.status?'selected':'')+'>Semua</option><option value="WAITING" '+(st.status==='WAITING'?'selected':'')+'>Menunggu Input</option><option value="DONE" '+(st.status==='DONE'?'selected':'')+'>Sudah Input</option></select></label>'+
      '<button type="submit">Tampilkan</button>'+
    '</form></section>';

  if(!systems.length){
    html+='<section class="panel"><p>Belum ada RHPP Sistem Final dari Administrator.</p></section>';
    html+='</div>';layout(html);if(err)msg(err.message);return;
  }

  if(st.shown)html+='<section class="panel"><h3>Daftar RHPP Real</h3>'+
    '<div class="tablewrap"><table><thead><tr><th>Kandang</th><th>Kontrak</th><th>Close Sistem</th><th>RHPP Sistem</th><th>Status Real</th><th>Selisih</th><th>Aksi</th></tr></thead><tbody>'+
    cards.map(x=>'<tr>'+
      '<td>'+esc(x.b?shortBarnLabel(x.b):'-')+'</td>'+
      '<td>'+esc(shortContractLabel(x.k?.number)||'-')+'</td>'+
      '<td>'+prodDateId(x.s.closed_on)+'</td>'+
      '<td>Rp '+prodFmt(x.s.system_amount,0)+'</td>'+
      '<td><strong>'+(x.real?'SUDAH INPUT':'MENUNGGU')+'</strong></td>'+
      '<td>'+(x.real?'Rp '+prodFmt(x.diff,0):'-')+'</td>'+
      '<td><button type="button" data-open-rhpp-real="'+esc(x.s.contract_assignment_id)+'">'+(st.selected===x.s.contract_assignment_id?'Tutup':'Buka')+'</button></td>'+
    '</tr>').join('')+
    '</tbody></table></div>'+
    (!cards.length?'<p class="muted">Tidak ada data sesuai filter.</p>':'')+
    '</section>';

  const selected=st.shown?systems.find(x=>x.contract_assignment_id===st.selected):null;
  if(selected){
    const a=assignments.find(x=>x.id===selected.contract_assignment_id);
    const b=barns.find(x=>x.id===selected.barn_id);
    const k=contractsRows.find(x=>x.id===a?.master_contract_id);
    const real=reals.find(x=>x.contract_assignment_id===selected.contract_assignment_id);
    const editingReal=real&&st.editRealId===real.id;
    const diff=real?prodNum(real.amount)-prodNum(selected.system_amount):null;
    const diffLabel=diff===null?'MENUNGGU':diff===0?'SESUAI':diff>0?'REAL LEBIH BESAR':'REAL LEBIH KECIL';

    html+='<section class="panel" id="rhppRealDetail">'+
      '<div class="rhpp-section-head"><div><h3>'+esc(assignmentIdentity(assignments,barns,contractsRows,a))+'</h3>'+
      '<p class="muted">RHPP Sistem Close '+prodDateId(selected.closed_on)+'</p></div><div class="report-actions"><button type="button" id="rhppRealPrint">Cetak / PDF</button><button type="button" id="rhppRealPrintExcel">Excel</button></div></div>'+
      '<div class="tablewrap"><table><tbody>'+
        '<tr><td>RHPP Sistem Final</td><td><strong>Rp '+prodFmt(selected.system_amount,0)+'</strong></td></tr>'+
        '<tr><td>RHPP Real Diterima</td><td><strong>'+(real?'Rp '+prodFmt(real.amount,0):'MENUNGGU INPUT KEUANGAN')+'</strong></td></tr>'+
        '<tr><td>Selisih Real − Sistem</td><td><strong>'+(real?'Rp '+prodFmt(diff,0):'-')+'</strong></td></tr>'+
        '<tr><td>Status Selisih</td><td><strong>'+diffLabel+'</strong></td></tr>'+
      '</tbody></table></div>'+
      (real?
        (canInput?
          (editingReal?
            '<form class="form-vertical" data-rhpp-real-edit-form="'+esc(real.id)+'">'+
              '<label>Tanggal RHPP Real<input name="received_on" type="date" value="'+esc(real.received_on||today)+'" required></label>'+
              '<label>Nominal RHPP Real sesuai PDF<input name="amount" type="text" inputmode="decimal" data-number="1" value="'+fmtNumber(real.amount)+'" required></label>'+
              '<label>Referensi<input name="reference" value="'+esc(real.reference||'')+'" placeholder="Opsional"></label>'+
              '<label>Catatan<textarea name="notes">'+esc(real.notes||'')+'</textarea></label>'+
              '<div class="report-actions"><button type="submit">Simpan Koreksi</button><button type="button" id="rhppRealEditCancel">Batal Koreksi</button>'+adminDeleteTxnButton('rhpp_real',real.id)+'</div>'+
            '</form>':
            '<div class="report-actions"><button type="button" id="rhppRealEdit">Koreksi RHPP Real</button>'+adminDeleteTxnButton('rhpp_real',real.id)+'</div>'+
            '<p class="muted">RHPP Real tersimpan '+prodDateId(real.received_on)+'. Gunakan Koreksi jika tanggal/nominal salah.</p>'
          ):
          '<p class="muted">RHPP Real tersimpan '+prodDateId(real.received_on)+'.</p>'
        ):
        canInput?
          '<form class="form-vertical" data-rhpp-real-form="'+esc(selected.contract_assignment_id)+'">'+
            '<label>Tanggal Uang Diterima<input name="received_on" type="date" value="'+esc(today)+'" required></label>'+
            '<label>Referensi / Bukti<input name="reference" placeholder="Nomor transfer / RHPP"></label>'+
            '<label>Nominal RHPP Real sesuai PDF<input name="amount" type="text" inputmode="decimal" data-number="1" required placeholder="Rp"></label>'+
            '<p class="muted">Gunakan tanggal uang benar-benar diterima. Setelah disimpan, nominal otomatis masuk Arus Kas sebagai RHPP REAL.</p>'+
            '<button type="submit">Simpan RHPP Real</button>'+
          '</form>':
          '<p class="muted">Menunggu Keuangan menginput RHPP Real.</p>'
      )+
    '</section>';
  }

  html+='</div>';
  layout(html);bindNumberInputs();if(err)msg(err.message);const rhppRealPrint=document.getElementById('rhppRealPrint');if(rhppRealPrint)rhppRealPrint.onclick=()=>printFinanceDocument('rhppRealDetail','RHPP Real');const rhppRealExcel=document.getElementById('rhppRealPrintExcel');if(rhppRealExcel)rhppRealExcel.onclick=()=>exportFinanceDocumentExcel('rhppRealDetail','RHPP Real');

  const filter=document.getElementById('rhppRealFilter');
  const rhppBarn=document.getElementById('rhppRealBarn');
  if(rhppBarn)rhppBarn.onchange=async()=>{st.barn=rhppBarn.value||'';st.assignment='';st.selected='';st.shown=false;await financeRhppRealPage();};
  if(filter)filter.onsubmit=async ev=>{
    ev.preventDefault();
    const fd=new FormData(filter);
    st.barn=String(fd.get('barn')||'');
    st.assignment=String(fd.get('assignment')||'');
    st.status=String(fd.get('status')||'');
    st.selected='';
    st.shown=true;
    await financeRhppRealPage();
  };

  root.querySelectorAll('[data-open-rhpp-real]').forEach(btn=>btn.onclick=async()=>{
    const id=btn.dataset.openRhppReal;
    st.selected=st.selected===id?'':id;st.editRealId='';
    await financeRhppRealPage();
  });

  const editBtn=document.getElementById('rhppRealEdit');if(editBtn)editBtn.onclick=async()=>{const real=reals.find(x=>x.contract_assignment_id===st.selected);if(real)st.editRealId=real.id;await financeRhppRealPage();document.querySelector('[data-rhpp-real-edit-form]')?.scrollIntoView({behavior:'smooth',block:'start'});};
  const editCancel=document.getElementById('rhppRealEditCancel');if(editCancel)editCancel.onclick=async()=>{st.editRealId='';await financeRhppRealPage();};
  bindAdminTransactionDeletes(()=>{st.editRealId='';st.selected='';return financeRhppRealPage();});

  if(canInput)root.querySelectorAll('[data-rhpp-real-edit-form]').forEach(form=>form.onsubmit=async ev=>{
    ev.preventDefault();
    const fd=new FormData(form),amount=normalizeInputID(fd.get('amount'));
    if(amount===null||amount<0)return msg('Nominal RHPP Real tidak valid.');
    if(!await appConfirm('Koreksi RHPP Real menjadi Rp '+prodFmt(amount,0)+'? Arus Kas dan laba/rugi terkait akan mengikuti nilai baru.'))return;
    const {error}=await db.rpc('finance_correct_rhpp_real_v1',{
      p_id:form.dataset.rhppRealEditForm,p_received_on:String(fd.get('received_on')||''),
      p_amount:amount,p_reference:String(fd.get('reference')||'')||null,p_notes:String(fd.get('notes')||'')||null
    });
    if(error)return msg(error.message);
    st.editRealId='';
    await financeRhppRealPage();
    msg('Koreksi RHPP Real berhasil disimpan.',true);
  });

  if(canInput)root.querySelectorAll('[data-rhpp-real-form]').forEach(form=>form.onsubmit=async ev=>{
    ev.preventDefault();
    const fd=new FormData(form);
    const amount=normalizeInputID(fd.get('amount'));
    if(amount===null||amount<0)return msg('Nominal RHPP Real tidak valid.');
    if(!await appConfirm('Simpan RHPP Real sebesar Rp '+prodFmt(amount,0)+'? Nominal akan masuk Arus Kas dan dapat dikoreksi dari menu ini bila terjadi salah input.'))return;
    const {error}=await db.rpc('finance_save_rhpp_real_atomic',{
      p_contract_assignment_id:form.dataset.rhppRealForm,
      p_amount:amount,
      p_received_on:String(fd.get('received_on')||''),
      p_reference:String(fd.get('reference')||'').trim()||null,
      p_notes:null
    });
    if(error)return msg(error.message);
    st.selected='';
    await financeRhppRealPage();
    msg('RHPP Real berhasil disimpan dan otomatis masuk Arus Kas sesuai tanggal penerimaan.',true);
  });
}

async function ownerProfitLossPage(){
  const [xr,rr,br,ar,cr]=await Promise.all([
    db.rpc('finance_cycle_profit_loss_v2'),
    db.from('rhpp_real').select('contract_assignment_id'),
    db.from('barns').select('id,code,name'),
    db.from('logistics_contract_assignments').select('id,barn_id,master_contract_id,start_date,active,cycle_type'),
    db.from('contracts').select('id,number').is('cycle_id',null)
  ]);
  const rows=xr.data||[],barns=br.data||[],assignments=ar.data||[],contractsRows=cr.data||[];
  const err=[xr,rr,br,ar,cr].find(x=>x.error)?.error;
  const realIds=new Set((rr.data||[]).map(x=>x.contract_assignment_id).filter(Boolean));
  const assignmentOf=x=>assignments.find(a=>a.id===x.contract_assignment_id);
  const finalRows=rows.filter(x=>{
    const a=assignmentOf(x);
    return !x.active&&(a?.cycle_type==='MANDIRI'||realIds.has(x.contract_assignment_id));
  });
  const sum=(arr,k)=>arr.reduce((n,x)=>n+prodNum(x[k]),0);
  const totalRevenue=sum(finalRows,'rhpp_real');
  const totalBop=sum(finalRows,'bop_produksi');
  const totalSapronak=sum(finalRows,'sapronak_luar');
  const totalMeat=sum(finalRows,'tambah_daging');
  const totalMaint=sum(finalRows,'perawatan_jangka_panjang');
  const totalOperational=sum(finalRows,'laba_operasional_produksi');
  const totalNet=sum(finalRows,'laba_bersih_akhir');

  let html='<section class="panel"><h3>Owner · Laba/Rugi Kandang</h3>'+
    '<p class="muted">Semua siklus FINAL MITRA + MANDIRI dibaca bersama. Angka kumulatif tidak dipisah berdasarkan jenis siklus.</p>'+
    '<div class="rhpp-summary-cards">'+
      '<div class="rhpp-summary-card"><span>Total Pendapatan Kandang</span><strong>Rp '+prodFmt(totalRevenue,0)+'</strong><small>MITRA + MANDIRI</small></div>'+
      '<div class="rhpp-summary-card"><span>Total BOP Produksi</span><strong>Rp '+prodFmt(totalBop,0)+'</strong><small>Seluruh kandang final</small></div>'+
      '<div class="rhpp-summary-card"><span>Total Biaya Sapronak</span><strong>Rp '+prodFmt(totalSapronak,0)+'</strong><small>Seluruh kandang final</small></div>'+
      '<div class="rhpp-summary-card"><span>Laba Bersih Kandang</span><strong>Rp '+prodFmt(totalNet,0)+'</strong><small>Setelah perawatan kandang</small></div>'+
    '</div></section>';

  if(!finalRows.length){
    html+='<section class="panel"><p>Belum ada siklus FINAL yang dapat dihitung.</p></section>';
    layout(html);if(err)msg(err.message);return;
  }

  html+='<section class="panel"><div class="tablewrap"><table><thead><tr>'+
    '<th>Kandang / Siklus</th><th>Jenis</th><th>Pendapatan</th><th>BOP</th><th>Biaya Sapronak</th><th>Tambah Daging</th><th>Perawatan</th><th>Laba Operasional</th><th>Laba Bersih</th>'+
    '</tr></thead><tbody>'+
    finalRows.map(x=>{
      const a=assignmentOf(x);
      const ident=a?assignmentIdentity(assignments,barns,contractsRows,a):(x.barn_code+' · '+x.barn_name);
      return '<tr><td>'+esc(ident)+'</td><td><strong>'+esc(a?.cycle_type||'MITRA')+'</strong></td>'+
        '<td>Rp '+prodFmt(x.rhpp_real,0)+'</td>'+
        '<td>Rp '+prodFmt(x.bop_produksi,0)+'</td>'+
        '<td>Rp '+prodFmt(x.sapronak_luar,0)+'</td>'+
        '<td>Rp '+prodFmt(x.tambah_daging,0)+'</td>'+
        '<td>Rp '+prodFmt(x.perawatan_jangka_panjang,0)+'</td>'+
        '<td><strong>Rp '+prodFmt(x.laba_operasional_produksi,0)+'</strong></td>'+
        '<td><strong>Rp '+prodFmt(x.laba_bersih_akhir,0)+'</strong></td></tr>';
    }).join('')+
    '</tbody><tfoot>'+
      '<tr><th colspan="2">TOTAL KUMULATIF</th><th>Rp '+prodFmt(totalRevenue,0)+'</th><th>Rp '+prodFmt(totalBop,0)+'</th><th>Rp '+prodFmt(totalSapronak,0)+'</th><th>Rp '+prodFmt(totalMeat,0)+'</th><th>Rp '+prodFmt(totalMaint,0)+'</th><th>Rp '+prodFmt(totalOperational,0)+'</th><th>Rp '+prodFmt(totalNet,0)+'</th></tr>'+
    '</tfoot></table></div></section>';

  layout(html);if(err)msg(err.message);
}

async function financeRhppPage(){
  window.__financeRhppState=window.__financeRhppState||{assignment:''};
  const [pr,rr,hr,mr,sr,sir,rtr,rir,ir,esr,esir,errh,erir,tir,cir,cpr]=await Promise.all([
    db.rpc('finance_rhpp_summary_v6'),
    db.from('rhpp_system_final').select('*').order('created_at',{ascending:false}),
    db.from('marketing_contract_harvests').select('*').order('harvested_on',{ascending:true}).order('created_at',{ascending:true}),
    db.from('marketing_external_meat_purchases').select('*').order('purchase_date',{ascending:true}).order('created_at',{ascending:true}),
    db.from('logistics_shipments').select('id,contract_assignment_id,shipment_date'),
    db.from('logistics_shipment_items').select('shipment_id,item_id,quantity,quantity_kg,unit_price'),
    db.from('logistics_returns').select('id,contract_assignment_id,return_date'),
    db.from('logistics_return_items').select('return_id,item_id,quantity,quantity_kg,unit_price'),
    db.from('items').select('id,name,category,feed_phase,unit,kg_per_unit'),
    db.from('logistics_external_shipments').select('id,contract_assignment_id,shipment_date'),
    db.from('logistics_external_shipment_items').select('external_shipment_id,item_id,quantity,quantity_kg,purchase_unit_price'),
    db.from('logistics_external_returns').select('id,contract_assignment_id,return_date'),
    db.from('logistics_external_return_items').select('external_return_id,item_id,quantity,quantity_kg,purchase_unit_price'),
    db.from('logistics_external_return_transfers').select('target_contract_assignment_id,item_id,quantity,quantity_kg,unit_price'),
    db.from('chick_ins').select('contract_assignment_id,arrived_on,received,doa'),
    db.from('company_profile').select('company_name,legal_name,logo_url,address,phone,email,website').eq('id',true).maybeSingle()
  ]);
  const rows=pr.data||[],finals=rr.data||[],harvests=hr.data||[],meats=mr.data||[],ships=sr.data||[],shipItems=sir.data||[],returns=rtr.data||[],returnItems=rir.data||[],items=ir.data||[];
  const extShips=esr.data||[],extShipItems=esir.data||[],extReturns=errh.data||[],extReturnItems=erir.data||[],transfersIn=tir.data||[],chickIns=cir.data||[],company=cpr.data||{};
  const err=[pr,rr,hr,mr,sr,sir,rtr,rir,ir,esr,esir,errh,erir,tir,cir,cpr].find(x=>x.error)?.error;

  let html=RHPP_SCREEN_STYLE+'<div class="rhpp-ui"><div class="rhpp-page" id="rhppExportArea"><section class="panel rhpp-panel rhpp-intro"><div class="rhpp-section-head"><div><h3>RHPP Otomatis</h3>'+
    '<p class="muted">RHPP dihitung langsung dari Chick-In, Logistik, Retur, Panen Marketing, Master Performa, dan Bonus Kontrak. BOP kandang tidak masuk RHPP.</p></div></div></section>';

  if(!rows.length){
    html+='<section class="panel rhpp-panel"><p>Belum ada data yang dapat dihitung.</p></section></div>';
    layout(html);
    if(err)msg(err.message);
    return;
  }

  const activeRows=rows.filter(x=>!!x.active);
  let selectedAssignment=window.__financeRhppState.assignment||'';
  if(selectedAssignment&&!activeRows.some(x=>x.contract_assignment_id===selectedAssignment)){
    selectedAssignment='';
    window.__financeRhppState.assignment='';
  }
  html+='<section class="panel rhpp-panel"><h3>Pilih Kandang</h3>'+
    '<p class="muted">Pilih kandang terlebih dahulu untuk membuka rincian RHPP. Satu kandang ditampilkan dalam satu waktu.</p>'+
    '<label>Kandang / Periode<select id="rhppBarnSelect"><option value="">Pilih kandang</option>'+
      activeRows.map(x=>'<option value="'+esc(x.contract_assignment_id)+'" '+(selectedAssignment===x.contract_assignment_id?'selected':'')+'>'+
        esc((x.barn_code||'')+' · '+(x.barn_name||'')+' · '+(x.contract_number||'')+' · Aktif')+
      '</option>').join('')+
    '</select></label></section>';

  if(!activeRows.length){
    html+='<section class="panel rhpp-panel"><p class="muted">Tidak ada periode kandang aktif. Periode yang sudah Closed disembunyikan dari daftar.</p></section></div>';
    layout(html);
    if(err)msg(err.message);
    return;
  }

  if(!selectedAssignment||!activeRows.some(x=>x.contract_assignment_id===selectedAssignment)){
    html+='<section class="panel rhpp-panel"><p class="muted">Belum ada kandang dipilih. Rincian RHPP tidak ditampilkan.</p></section></div>';
    layout(html);
    if(err)msg(err.message);
    const sel=document.getElementById('rhppBarnSelect');
    if(sel)sel.onchange=async()=>{
      window.__financeRhppState.assignment=sel.value||'';
      await financeRhppPage();
    };
    return;
  }

  const selectedRows=activeRows.filter(x=>x.contract_assignment_id===selectedAssignment);
  selectedRows.forEach(x=>{
    const fin=finals.find(r=>r.contract_assignment_id===x.contract_assignment_id);
    const ready=!fin&&!!x.active&&prodNum(x.chick_in_birds)>0&&prodNum(x.total_harvest_birds)>0&&prodNum(x.total_harvest_kg)>0&&prodNum(x.net_feed_kg)>0&&prodNum(x.sapronak_cost)>0;
    const status=fin?'CLOSED · RHPP SISTEM FINAL':ready?'SIAP DICEK & CLOSE':'BELUM SIAP';
    const hs=harvests.filter(h=>h.contract_assignment_id===x.contract_assignment_id);
    const ms=meats.filter(m=>m.contract_assignment_id===x.contract_assignment_id);
    const ci=chickIns.find(v=>v.contract_assignment_id===x.contract_assignment_id);
    const effectiveDocPrice=prodNum(x.chick_in_birds)>0?prodNum(x.main_doc_cost)/prodNum(x.chick_in_birds):0;

    const shipIds=new Set(ships.filter(s=>s.contract_assignment_id===x.contract_assignment_id).map(s=>s.id));
    const retIds=new Set(returns.filter(r=>r.contract_assignment_id===x.contract_assignment_id).map(r=>r.id));
    const feedMap=new Map();
    shipItems.filter(v=>shipIds.has(v.shipment_id)).forEach(v=>{
      const it=items.find(i=>i.id===v.item_id);
      if(it?.category!=='PAKAN')return;
      const key='MAIN:'+v.item_id;
      const o=feedMap.get(key)||{name:'Utama · '+(it?.name||'-'),inQty:0,inKg:0,retQty:0,retKg:0,inValue:0,retValue:0};
      o.inQty+=prodNum(v.quantity);o.inKg+=prodNum(v.quantity_kg);o.inValue+=prodNum(v.quantity)*prodNum(v.unit_price);feedMap.set(key,o);
    });
    returnItems.filter(v=>retIds.has(v.return_id)).forEach(v=>{
      const it=items.find(i=>i.id===v.item_id);
      if(it?.category!=='PAKAN')return;
      const key='MAIN:'+v.item_id;
      const o=feedMap.get(key)||{name:'Utama · '+(it?.name||'-'),inQty:0,inKg:0,retQty:0,retKg:0,inValue:0,retValue:0};
      o.retQty+=prodNum(v.quantity);o.retKg+=prodNum(v.quantity_kg);o.retValue+=prodNum(v.quantity)*prodNum(v.unit_price);feedMap.set(key,o);
    });

    const extShipIds=new Set(extShips.filter(s=>s.contract_assignment_id===x.contract_assignment_id).map(s=>s.id));
    const extRetIds=new Set(extReturns.filter(r=>r.contract_assignment_id===x.contract_assignment_id).map(r=>r.id));
    extShipItems.filter(v=>extShipIds.has(v.external_shipment_id)).forEach(v=>{
      const it=items.find(i=>i.id===v.item_id);
      if(it?.category!=='PAKAN')return;
      const key='EXT:'+v.item_id;
      const o=feedMap.get(key)||{name:'Tambah Sapronak · '+(it?.name||'-'),inQty:0,inKg:0,retQty:0,retKg:0,inValue:0,retValue:0};
      o.inQty+=prodNum(v.quantity);o.inKg+=prodNum(v.quantity_kg);o.inValue+=prodNum(v.quantity)*prodNum(v.purchase_unit_price);feedMap.set(key,o);
    });
    extReturnItems.filter(v=>extRetIds.has(v.external_return_id)).forEach(v=>{
      const it=items.find(i=>i.id===v.item_id);
      if(it?.category!=='PAKAN')return;
      const key='EXT:'+v.item_id;
      const o=feedMap.get(key)||{name:'Tambah Sapronak · '+(it?.name||'-'),inQty:0,inKg:0,retQty:0,retKg:0,inValue:0,retValue:0};
      o.retQty+=prodNum(v.quantity);o.retKg+=prodNum(v.quantity_kg);o.retValue+=prodNum(v.quantity)*prodNum(v.purchase_unit_price);feedMap.set(key,o);
    });
    transfersIn.filter(v=>v.target_contract_assignment_id===x.contract_assignment_id).forEach(v=>{
      const it=items.find(i=>i.id===v.item_id);
      if(it?.category!=='PAKAN')return;
      const key='TRANSFER:'+v.item_id;
      const o=feedMap.get(key)||{name:'Alih Masuk · '+(it?.name||'-'),inQty:0,inKg:0,retQty:0,retKg:0,inValue:0,retValue:0};
      o.inQty+=prodNum(v.quantity);o.inKg+=prodNum(v.quantity_kg);o.inValue+=prodNum(v.quantity)*prodNum(v.unit_price);feedMap.set(key,o);
    });
    const feedRows=[...feedMap.values()];
    const feedNetValue=feedRows.reduce((sum,v)=>sum+prodNum(v.inValue)-prodNum(v.retValue),0);

    html+='<section class="panel rhpp-panel rhpp-head"><div class="rhpp-section-head"><div><h3>Identitas Siklus</h3><p class="muted">Ringkasan periode yang sedang diperiksa.</p></div><span class="rhpp-count">'+status+'</span></div>'+
      '<div class="tablewrap"><table><tbody>'+
        '<tr><td>Kandang / Peternak</td><td><strong>'+esc((x.barn_code||'')+' · '+(x.barn_name||''))+'</strong></td></tr>'+
        '<tr><td>Kontrak</td><td>'+esc(x.contract_number||'-')+'</td></tr>'+
        '<tr><td>Tanggal Chick-In</td><td>'+prodDateId(ci?.arrived_on)+'</td></tr>'+
        '<tr><td>Populasi Chick-In</td><td>'+prodFmt(x.chick_in_birds,0)+' ekor</td></tr>'+
        '<tr><td>Status RHPP</td><td><strong>'+status+'</strong></td></tr>'+
      '</tbody></table></div></section>'+
      '<section class="panel rhpp-panel rhpp-wide"><div class="rhpp-section-head"><div><h3>Rincian DOC & Kontrak</h3><p class="muted">Acuan awal populasi dan biaya DOC yang sudah dipakai oleh perhitungan RHPP.</p></div></div>'+
      '<div class="tablewrap"><table><tbody>'+
        '<tr><td>Kontrak</td><td>'+esc(x.contract_number||'-')+'</td></tr>'+
        '<tr><td>DOC Diterima</td><td>'+prodFmt(ci?.received,0)+' ekor</td></tr>'+
        '<tr><td>DOA</td><td>'+prodFmt(ci?.doa,0)+' ekor</td></tr>'+
        '<tr><td>Populasi Netto Chick-In</td><td><strong>'+prodFmt(x.chick_in_birds,0)+' ekor</strong></td></tr>'+
        '<tr><td>Harga DOC / Ekor</td><td>Rp '+prodFmt(effectiveDocPrice,0)+'</td></tr>'+
        '<tr><td>Total Nilai DOC</td><td><strong>Rp '+prodFmt(x.main_doc_cost,0)+'</strong></td></tr>'+
      '</tbody></table></div></section>';

    html+='<section class="panel rhpp-panel rhpp-wide rhpp-harvest"><div class="rhpp-section-head"><div><h3>Rincian Panen</h3><p class="muted">Data panen Marketing yang menjadi sumber nilai produksi RHPP.</p></div><span class="rhpp-count">'+hs.length+' transaksi</span></div>'+
      '<div class="tablewrap rhpp-harvest-wrap"><table class="rhpp-harvest-table"><thead><tr>'+
      '<th class="rhpp-sticky-col">Tanggal</th><th>Pembeli / RPA</th><th>No. Kendaraan</th><th class="num">Ekor</th><th class="num">Berat (Kg)</th><th class="num">BW</th><th class="num">Harga/Kg</th><th class="num rhpp-money-col">Nilai Produksi</th>'+
      '</tr></thead><tbody>'+
      hs.map(h=>'<tr><td class="rhpp-sticky-col">'+prodDateId(h.harvested_on)+'</td><td>'+esc(h.buyer_name||'-')+'</td><td>'+esc(h.vehicle_number||'-')+'</td><td class="num">'+prodFmt(h.birds,0)+'</td><td class="num">'+prodFmt(h.net_weight_kg,2)+'</td><td class="num">'+prodFmt(h.avg_weight_kg,3)+'</td><td class="num">Rp '+prodFmt(h.price_per_kg,0)+'</td><td class="num rhpp-money-col">Rp '+prodFmt(h.total_amount,0)+'</td></tr>').join('')+
      '<tr class="rhpp-total-row"><th colspan="3">TOTAL PANEN</th><th class="num">'+prodFmt(x.total_harvest_birds,0)+'</th><th class="num">'+prodFmt(x.total_harvest_kg,2)+'</th><th class="num">'+prodFmt(x.avg_bw_kg,3)+'</th><th></th><th class="num">Rp '+prodFmt(x.harvest_value,0)+'</th></tr>'+
      '</tbody></table></div>'+
      '</section>'+
      '<section class="panel rhpp-panel rhpp-wide rhpp-extra-cost"><div class="rhpp-section-head"><div><h3>Biaya Tambahan Marketing</h3><p class="muted">Dipisahkan dari rincian panen agar sumber pendapatan dan biaya tidak tercampur.</p></div></div>'+
      '<div class="rhpp-cost-line"><span>Tambah Daging Marketing</span><strong>Rp '+prodFmt(x.external_meat_cost,0)+'</strong></div>'+
      '</section>';

    html+='<section class="panel rhpp-panel rhpp-wide"><div class="rhpp-section-head"><div><h3>Rincian Sapronak & OVK</h3><p class="muted">Nilai komponen yang masuk ke biaya RHPP, ditampilkan terpisah agar mudah dicocokkan.</p></div></div>'+
      '<div class="tablewrap"><table><tbody>'+
        '<tr><td>DOC Utama</td><td>Rp '+prodFmt(x.main_doc_cost,0)+'</td></tr>'+
        '<tr><td>Pakan Utama</td><td>Rp '+prodFmt(x.main_feed_cost,0)+'</td></tr>'+
        '<tr><td>OVK Utama</td><td>Rp '+prodFmt(x.main_ovk_cost,0)+'</td></tr>'+
        '<tr><td>Retur RHPP</td><td>- Rp '+prodFmt(x.main_return_cost,0)+'</td></tr>'+
        '<tr><td>Tambah Sapronak Netto</td><td>Rp '+prodFmt(x.external_sapronak_cost,0)+'</td></tr>'+
        '<tr><td><strong>Total Sapronak</strong></td><td><strong>Rp '+prodFmt(x.sapronak_cost,0)+'</strong></td></tr>'+
      '</tbody></table></div></section>'+
      '<section class="panel rhpp-panel rhpp-wide rhpp-feed-panel"><h3>Pemakaian Pakan & Retur</h3><div class="tablewrap"><table class="rhpp-feed-table"><thead><tr>'+
      '<th>Jenis</th><th class="num">Masuk</th><th class="num">Retur</th><th class="num">Bersih</th><th class="num">Bersih Kg</th><th class="num">Nilai Bersih</th>'+
      '</tr></thead><tbody>'+
      feedRows.map(v=>{const parts=String(v.name||'').split(' · '),kind=parts[0]||'',item=parts.slice(1).join(' · ')||kind;return '<tr><td class="rhpp-feed-name"><span class="rhpp-feed-kind">'+esc(kind)+'</span><strong>'+esc(item)+'</strong></td><td class="num">'+prodFmt(v.inQty,2)+'</td><td class="num">'+prodFmt(v.retQty,2)+'</td><td class="num">'+prodFmt(v.inQty-v.retQty,2)+'</td><td class="num">'+prodFmt(v.inKg-v.retKg,2)+'</td><td class="num">Rp '+prodFmt(prodNum(v.inValue)-prodNum(v.retValue),0)+'</td></tr>';}).join('')+
      '<tr class="rhpp-total-row"><th>TOTAL BERSIH</th><th></th><th></th><th></th><th class="num">'+prodFmt(x.net_feed_kg,2)+'</th><th class="num">Rp '+prodFmt(feedNetValue,0)+'</th></tr>'+
      '</tbody></table></div></section>';

    html+='<div class="rhpp-grid">'+
      '<section class="panel rhpp-panel"><h3>Ringkasan Produksi</h3><div class="tablewrap"><table><tbody>'+
        '<tr><td>Nama Kandang / Peternak</td><td>'+esc(x.barn_name||'-')+'</td></tr>'+
        '<tr><td>Populasi Chick-In</td><td>'+prodFmt(x.chick_in_birds,0)+'</td></tr>'+
        '<tr><td>Total Panen (Ekor)</td><td>'+prodFmt(x.total_harvest_birds,0)+'</td></tr>'+
        '<tr><td>Total Panen (Kg)</td><td>'+prodFmt(x.total_harvest_kg,2)+'</td></tr>'+
        '<tr><td>BW Rataan</td><td>'+prodFmt(x.avg_bw_kg,3)+'</td></tr>'+
        '<tr><td>Umur Panen</td><td>'+prodFmt(x.weighted_age,2)+'</td></tr>'+
      '</tbody></table></div></section>'+

      '<section class="panel rhpp-panel"><h3>Kinerja Produksi</h3><div class="tablewrap"><table><tbody>'+
        '<tr><td>Mortalitas</td><td>'+prodFmt(x.mortality_pct,2)+'%</td></tr>'+
        '<tr><td>Bobot Badan</td><td>'+prodFmt(x.avg_bw_kg,3)+'</td></tr>'+
        '<tr><td>Pakan Utama Bersih</td><td>'+prodFmt(x.main_feed_kg,2)+'</td></tr>'+
        '<tr><td>Pakan Tambahan Bersih</td><td>'+prodFmt(x.external_feed_kg,2)+'</td></tr>'+
        '<tr><td>Total Pakan</td><td>'+prodFmt(x.net_feed_kg,2)+'</td></tr>'+
        '<tr><td>Umur Panen</td><td>'+prodFmt(x.weighted_age,2)+'</td></tr>'+
        '<tr><td>FCR</td><td>'+prodFmt(x.fcr_actual,3)+'</td></tr>'+
        '<tr><td>FCR Standar</td><td>'+prodFmt(x.fcr_standard,3)+'</td></tr>'+
        '<tr><td>DIFF FCR</td><td>'+prodFmt(x.diff_fcr,3)+'</td></tr>'+
        '<tr><td>Indeks Prestasi</td><td>'+prodFmt(x.ip,2)+'</td></tr>'+
      '</tbody></table></div></section>'+

      '<section class="panel rhpp-panel"><h3>Perhitungan RHPP</h3><div class="tablewrap"><table><tbody>'+
        '<tr><td>Mortalitas</td><td>'+prodFmt(x.mortality_pct,2)+'%</td></tr>'+
        '<tr><td>Nilai Panen</td><td>Rp '+prodFmt(x.harvest_value,0)+'</td></tr>'+
        '<tr><td>DOC Utama</td><td>Rp '+prodFmt(x.main_doc_cost,0)+'</td></tr>'+
        '<tr><td>Pakan Utama</td><td>Rp '+prodFmt(x.main_feed_cost,0)+'</td></tr>'+
        '<tr><td>OVK Utama</td><td>Rp '+prodFmt(x.main_ovk_cost,0)+'</td></tr>'+
        '<tr><td>Retur RHPP</td><td>- Rp '+prodFmt(x.main_return_cost,0)+'</td></tr>'+
        '<tr><td>Tambah Sapronak Netto</td><td>Rp '+prodFmt(x.external_sapronak_cost,0)+'</td></tr>'+
        '<tr><td>Total Sapronak</td><td>Rp '+prodFmt(x.sapronak_cost,0)+'</td></tr>'+

        '<tr><td><strong>Total Biaya RHPP</strong></td><td><strong>Rp '+prodFmt(x.total_rhpp_cost,0)+'</strong></td></tr>'+
        '<tr><td>Laba Dasar</td><td>Rp '+prodFmt(x.base_profit,0)+'</td></tr>'+
      '</tbody></table></div></section>'+

      '<section class="panel rhpp-panel"><h3>Bonus Kontrak & Nilai RHPP</h3><div class="tablewrap"><table><tbody>'+
        '<tr><td>IP Aktual</td><td>'+prodFmt(x.ip,2)+'</td></tr>'+
        '<tr><td>DIFF FCR</td><td>'+prodFmt(x.diff_fcr,3)+'</td></tr>'+
        '<tr><td>Deplesi / Mortalitas</td><td>'+prodFmt(x.mortality_pct,2)+'%</td></tr>'+
        '<tr><td>Bonus IP</td><td>Rp '+prodFmt(x.bonus_ip,0)+' ('+prodFmt(x.bonus_ip_rate,0)+'/kg)</td></tr>'+
        '<tr><td>Bonus FC</td><td>Rp '+prodFmt(x.bonus_fc,0)+' ('+prodFmt(x.bonus_fc_rate,0)+'/kg)</td></tr>'+
        '<tr><td>Bonus Deplesi</td><td>Rp '+prodFmt(x.bonus_mortality,0)+' ('+prodFmt(x.bonus_mortality_rate,0)+'/kg)</td></tr>'+
        '<tr><td><strong>Laba Peternak</strong></td><td><strong>Rp '+prodFmt(x.farmer_profit,0)+'</strong></td></tr>'+
        '<tr><td>Laba / Chick-In</td><td>Rp '+prodFmt(x.profit_per_chick_in,0)+'</td></tr>'+
        '<tr><td>Laba / Ekor Panen</td><td>Rp '+prodFmt(x.profit_per_harvested_bird,0)+'</td></tr>'+
      '</tbody></table></div>'+
      '<p><strong>Status: '+status+'</strong></p>'+
      (fin?'<p class="muted">Close Produksi '+prodDateId(fin.closed_on)+' · RHPP Sistem Rp '+prodFmt(fin.system_amount,0)+'</p>':ready?'<button type="button" class="btn-danger-soft" data-close-rhpp="'+esc(x.contract_assignment_id)+'">Deal & Close Produksi</button>':'<p class="muted">Lengkapi data operasional sebelum Close</p>')+
      '</section>'+
    '</div>';
  });

  html+='<section class="panel rhpp-panel rhpp-control"><h3>Kontrol RHPP Produksi</h3><p class="muted">Administrator periksa RHPP Sistem terlebih dahulu. Jika sudah deal, klik Close Produksi. Setelah Close, seluruh transaksi operasional periode terkunci. RHPP Real tetap menjadi urusan Keuangan.</p></section></div>';

  layout(html);
  if(err)msg(err.message);
  const rhppBarnSelect=document.getElementById('rhppBarnSelect');
  if(rhppBarnSelect)rhppBarnSelect.onchange=async()=>{
    window.__financeRhppState.assignment=rhppBarnSelect.value||'';
    await financeRhppPage();
  };

  const rhppExport=document.getElementById('rhppExportArea');
  const rhppDocHtml=(pdf=false)=>{
    const x=activeRows.find(v=>v.contract_assignment_id===selectedAssignment);
    if(!x)return '<!doctype html><html><body>Data RHPP tidak ditemukan.</body></html>';
    const hs=harvests.filter(h=>h.contract_assignment_id===selectedAssignment);
    const ci=chickIns.find(v=>v.contract_assignment_id===selectedAssignment);
    const shipIds=new Set(ships.filter(s=>s.contract_assignment_id===selectedAssignment).map(s=>s.id));
    const retIds=new Set(returns.filter(r=>r.contract_assignment_id===selectedAssignment).map(r=>r.id));
    const extShipIds=new Set(extShips.filter(s=>s.contract_assignment_id===selectedAssignment).map(s=>s.id));
    const extRetIds=new Set(extReturns.filter(r=>r.contract_assignment_id===selectedAssignment).map(r=>r.id));
    const feed=new Map();
    const feedRow=(itemId)=>{
      const it=items.find(i=>i.id===itemId);
      if(!it||it.category!=='PAKAN')return null;
      const phase=String(it.feed_phase||it.name||'').toLowerCase();
      let group='Suplayer Lain';
      if(phase.includes('free')||phase.includes('pre'))group='Free Starter';
      else if(phase.includes('finish')||phase.includes('finis'))group='Finisher';
      else if(phase.includes('starter'))group='Starter';
      const key=group;
      if(!feed.has(key))feed.set(key,{name:group,inQty:0,inKg:0,retQty:0,retKg:0,priceKg:0});
      return {it,row:feed.get(key)};
    };
    shipItems.filter(v=>shipIds.has(v.shipment_id)).forEach(v=>{
      const z=feedRow(v.item_id);if(!z)return;
      z.row.inQty+=prodNum(v.quantity);z.row.inKg+=prodNum(v.quantity_kg);
      const kgPer=prodNum(z.it.kg_per_unit);const p=kgPer>0?prodNum(v.unit_price)/kgPer:0;
      if(p>0)z.row.priceKg=p;
    });
    returnItems.filter(v=>retIds.has(v.return_id)).forEach(v=>{
      const z=feedRow(v.item_id);if(!z)return;
      z.row.retQty+=prodNum(v.quantity);z.row.retKg+=prodNum(v.quantity_kg);
      const kgPer=prodNum(z.it.kg_per_unit);const p=kgPer>0?prodNum(v.unit_price)/kgPer:0;
      if(!z.row.priceKg&&p>0)z.row.priceKg=p;
    });
    extShipItems.filter(v=>extShipIds.has(v.external_shipment_id)).forEach(v=>{
      const z=feedRow(v.item_id);if(!z)return;
      z.row.inQty+=prodNum(v.quantity);z.row.inKg+=prodNum(v.quantity_kg);
    });
    extReturnItems.filter(v=>extRetIds.has(v.external_return_id)).forEach(v=>{
      const z=feedRow(v.item_id);if(!z)return;
      z.row.retQty+=prodNum(v.quantity);z.row.retKg+=prodNum(v.quantity_kg);
    });
    transfersIn.filter(v=>v.target_contract_assignment_id===selectedAssignment).forEach(v=>{
      const z=feedRow(v.item_id);if(!z)return;
      z.row.inQty+=prodNum(v.quantity);z.row.inKg+=prodNum(v.quantity_kg);
      const kgPer=prodNum(z.it.kg_per_unit);const p=kgPer>0?prodNum(v.unit_price)/kgPer:0;
      if(!z.row.priceKg&&p>0)z.row.priceKg=p;
    });
    const feedOrder=['Free Starter','Starter','Finisher','Suplayer Lain'];
    const feedRows=feedOrder.map(n=>feed.get(n)||{name:n,inQty:0,inKg:0,retQty:0,retKg:0,priceKg:0});
    const cleanZak=feedRows.reduce((s,v)=>s+v.inQty-v.retQty,0);
    const cleanKg=feedRows.reduce((s,v)=>s+v.inKg-v.retKg,0);
    const returnDetail=[];
    returnItems.filter(v=>retIds.has(v.return_id)).forEach(v=>{
      const it=items.find(i=>i.id===v.item_id);if(it?.category!=='PAKAN')return;
      returnDetail.push({name:'Retur '+(it.feed_phase||it.name||'Pakan'),qty:prodNum(v.quantity),kg:prodNum(v.quantity_kg),value:prodNum(v.quantity)*prodNum(v.unit_price)});
    });
    extReturnItems.filter(v=>extRetIds.has(v.external_return_id)).forEach(v=>{
      const it=items.find(i=>i.id===v.item_id);if(it?.category!=='PAKAN')return;
      returnDetail.push({name:'Retur '+(it.feed_phase||it.name||'Pakan'),qty:prodNum(v.quantity),kg:prodNum(v.quantity_kg),value:prodNum(v.quantity)*prodNum(v.purchase_unit_price)});
    });
    const money=v=>prodFmt(v,0);
    const num2=v=>prodFmt(v,2);
    const val=(label,value)=>'<div class="kv"><span>'+esc(label)+'</span><b>:</b><strong>'+value+'</strong></div>';
    const chickIn=prodNum(x.chick_in_birds||((ci?.received||0)-(ci?.doa||0)));
    const feedPerBird=chickIn>0?prodNum(x.net_feed_kg)*1000/chickIn:0;
    const docPrice=chickIn>0?prodNum(x.main_doc_cost)/chickIn:0;
    const grossSapronak=prodNum(x.sapronak_cost)+prodNum(x.main_return_cost);
    const title=pdf?'RHPP_Sistem_PDF':'RHPP Sistem';
    const harvestRows=hs.map(h=>'<tr><td>'+prodDateId(h.harvested_on)+'</td><td>'+esc(h.buyer_name||'-')+'</td><td>'+esc(h.vehicle_number||'-')+'</td><td class="n">'+prodFmt(h.birds,0)+'</td><td class="n">'+num2(h.net_weight_kg)+'</td><td class="n">'+num2(h.avg_weight_kg)+'</td><td class="n">'+money(h.price_per_kg)+'</td><td class="n">'+money(h.total_amount)+'</td></tr>').join('');
    const feedHtml=feedRows.map(v=>{
      const netQty=v.inQty-v.retQty,netKg=v.inKg-v.retKg,price=v.priceKg||0;
      return '<tr><td>'+esc(v.name)+'</td><td class="n">'+num2(v.inQty)+'</td><td class="n">'+num2(v.retQty)+'</td><td class="n">'+num2(netQty)+'</td><td class="n">'+num2(netQty?netKg/netQty:0)+'</td><td class="n">'+num2(netKg)+'</td><td class="n">'+(price?money(price):'-')+'</td><td class="n">'+(price?money(netKg*price):'-')+'</td></tr>';
    }).join('');
    const retHtml=(returnDetail.length?returnDetail:[{name:'Retur Finisher',qty:0,kg:0,value:0}]).map(v=>'<tr><td>'+esc(v.name)+'</td><td class="n">'+num2(v.qty)+'</td><td class="n">'+num2(v.kg)+'</td><td class="n">'+money(v.value)+'</td></tr>').join('');
    const fin=finals.find(v=>v.contract_assignment_id===selectedAssignment);
    const closeLabel=fin?.closed_on?prodDateId(fin.closed_on):'BELUM CLOSE';
    const statusLabel=fin?'FINAL / CLOSED':'RHPP SISTEM / PROSES';
    const periodStart=ci?.arrived_on?prodDateId(ci.arrived_on):'-';
    const harvestDates=hs.map(v=>v.harvested_on).filter(Boolean).sort();
    const periodHarvest=harvestDates.length?(prodDateId(harvestDates[0])+' - '+prodDateId(harvestDates[harvestDates.length-1])):'-';
    const totalReturnKg=returnDetail.reduce((n,v)=>n+prodNum(v.kg),0);
    const avgFeedPrice=cleanKg>0?prodNum(x.main_feed_cost)/cleanKg:0;
    const ovkValue=prodNum(x.main_ovk_cost);
    const printStamp=new Intl.DateTimeFormat('id-ID',{timeZone:'Asia/Jakarta',dateStyle:'medium',timeStyle:'short'}).format(new Date())+' WIB';
    const companyName=company.company_name||company.legal_name||'Bagjasindo Mandiri Sindangkasih';
    const companyContact=[company.address,company.phone?('Tel/WA: '+company.phone):'',company.email||'',company.website||''].filter(Boolean).map(esc).join('<br>');
    const logo='<img class="logo" src="'+BMS_PRINT_LOGO+'" alt="Logo BMS">';
    const sig=(role)=>'<div class="sig"><strong>'+esc(role)+'</strong><div class="sig-space"></div><div class="sig-line"></div><span>Nama &amp; Tanda Tangan</span></div>';
    return '<!doctype html><html><head><meta charset="utf-8"><title>'+title+'</title>'+
      '<style>'+
      '@page{size:A4 landscape;margin:8mm}*{box-sizing:border-box}html,body{margin:0;padding:0;font-family:Arial,Helvetica,sans-serif;color:#10233f;font-size:9.2px;line-height:1.3;-webkit-print-color-adjust:exact!important;print-color-adjust:exact!important}body{background:#fff}.page{min-height:188mm;position:relative;padding-bottom:10mm}.page+.page{page-break-before:always}.head{display:grid;grid-template-columns:auto 1fr 250px;gap:12px;align-items:center;border-bottom:2px solid #153f73;padding:0 2px 8px;margin-bottom:9px}.logo{width:44px;height:44px;object-fit:contain}.logo-mark{width:44px;height:44px;border-radius:10px;background:#174d88!important;color:#fff!important;display:flex;align-items:center;justify-content:center;font-weight:800;font-size:13px}.company h1{font-size:18px;margin:0;color:#123b6d}.company p{margin:2px 0 0;color:#53657a;font-size:9px}.contact{text-align:right;color:#33465f;font-size:8.6px}.doc-title{text-align:center;margin:9px 0 12px}.doc-title h2{font-size:22px;letter-spacing:.1px;margin:0;color:#102e57}.doc-title p{margin:3px 0 0;font-size:12px;color:#445a75}.section{margin:0 0 10px;border:1px solid #c7d8ea;border-radius:7px;overflow:hidden;break-inside:avoid}.section-title{background:#dcecf9!important;color:#123b6d!important;padding:6px 9px;font-size:11.5px;font-weight:800;letter-spacing:.1px}.section-body{padding:8px 9px}.meta{display:grid;grid-template-columns:1fr 1fr;gap:4px 34px}.meta-row{display:grid;grid-template-columns:125px 10px 1fr;min-height:18px;align-items:center}.meta-row strong{font-weight:700}.pill{display:inline-block;background:#d7f4e4!important;color:#145c3b!important;border-radius:5px;padding:3px 8px;font-weight:800}.metrics{display:grid;grid-template-columns:repeat(5,1fr);border:1px solid #d6e0eb;border-radius:6px;overflow:hidden}.metric{padding:7px 8px;min-height:55px;border-right:1px solid #d6e0eb;border-bottom:1px solid #d6e0eb}.metric:nth-child(5n){border-right:0}.metric:nth-child(n+6){border-bottom:0}.metric span{display:block;color:#53657a;font-size:8px}.metric strong{display:block;color:#123b6d;font-size:15px;margin-top:3px}.metric small{color:#53657a;font-size:7.5px}table{width:100%;border-collapse:collapse;table-layout:fixed}.tbl th{background:#e4f0fa!important;color:#193b64!important;border:1px solid #b7ccdf;padding:5px 4px;text-align:center;font-size:8px}.tbl td{border:1px solid #cfdae6;padding:4px 4px;color:#24384f}.tbl .n{text-align:right}.tbl .total td,.tbl .total th{background:#eaf3fb!important;font-weight:800;color:#133961}.calc td:first-child{width:72%}.calc .em td{background:#dcecf9!important;font-weight:800}.calc .final td{background:#124a84!important;color:#fff!important;font-weight:800;font-size:12px;padding:8px}.note{padding:8px 10px;color:#33465f}.signatures{display:grid;grid-template-columns:repeat(4,1fr);gap:0}.sig{text-align:center;padding:9px 10px;border-right:1px solid #d6e0eb}.sig:last-child{border-right:0}.sig-space{height:34px}.sig-line{border-top:1px dotted #8190a2;margin:0 12px 4px}.sig span{font-size:7.5px;color:#66768a}.footer{position:absolute;left:0;right:0;bottom:0;border-top:1px solid #dbe4ed;padding-top:4px;display:flex;justify-content:space-between;color:#65768a;font-size:7.5px}.page-no{font-weight:700}.top-ref{text-align:right;font-size:8px;color:#51647c;margin:-3px 0 7px}.money{font-variant-numeric:tabular-nums}'+
      '@media print{.page{min-height:188mm}.section,.metrics,.tbl,.signatures{-webkit-print-color-adjust:exact!important;print-color-adjust:exact!important}}'+
      '</style></head><body>'+
      '<section class="page">'+
        '<header class="head">'+logo+'<div class="company"><h1>'+esc(companyName)+'</h1><p>Integritas Kemitraan untuk Peternakan Lebih Baik</p></div><div class="contact">'+companyContact+'</div></header>'+
        '<div class="doc-title"><h2>REKAP HASIL PEMELIHARAAN PETERNAK (RHPP)</h2><p>RHPP Sistem Final</p></div>'+
        '<div class="section"><div class="section-title">IDENTITAS PRODUKSI</div><div class="section-body meta">'+
          '<div class="meta-row"><strong>Kandang / Peternak</strong><b>:</b><span>'+esc(x.barn_name||'-')+'</span></div>'+
          '<div class="meta-row"><strong>Tanggal Close</strong><b>:</b><span>'+closeLabel+'</span></div>'+
          '<div class="meta-row"><strong>Nomor Kontrak</strong><b>:</b><span>'+esc(x.contract_number||'-')+'</span></div>'+
          '<div class="meta-row"><strong>Status</strong><b>:</b><span><span class="pill">'+statusLabel+'</span></span></div>'+
          '<div class="meta-row"><strong>Tanggal Chick-In</strong><b>:</b><span>'+periodStart+'</span></div>'+
          '<div class="meta-row"><strong>Periode Panen</strong><b>:</b><span>'+periodHarvest+'</span></div>'+
          '<div class="meta-row"><strong>Kode Kandang</strong><b>:</b><span>'+esc(x.barn_code||'-')+'</span></div>'+
          '<div class="meta-row"><strong>Sumber Data</strong><b>:</b><span>Chick-In · Logistik · Retur · Marketing · Master Performa</span></div>'+
        '</div></div>'+
        '<div class="section"><div class="section-title">RINGKASAN PRODUKSI</div><div class="section-body">'+
          '<div class="metrics">'+
            '<div class="metric"><span>Populasi Awal</span><strong>'+prodFmt(chickIn,0)+'</strong><small>ekor</small></div>'+
            '<div class="metric"><span>Total Panen Ekor</span><strong>'+prodFmt(x.total_harvest_birds,0)+'</strong><small>ekor</small></div>'+
            '<div class="metric"><span>Total Berat Panen</span><strong>'+num2(x.total_harvest_kg)+'</strong><small>kg</small></div>'+
            '<div class="metric"><span>BW Rata-rata</span><strong>'+prodFmt(x.avg_bw_kg,3)+'</strong><small>kg/ekor</small></div>'+
            '<div class="metric"><span>Umur Panen</span><strong>'+prodFmt(x.weighted_age,2)+'</strong><small>hari</small></div>'+
            '<div class="metric"><span>Mortalitas</span><strong>'+prodFmt(x.mortality_pct,2)+'%</strong><small>'+prodFmt(x.recorded_depletion_birds,0)+' ekor</small></div>'+
            '<div class="metric"><span>Total Pakan</span><strong>'+num2(x.net_feed_kg)+'</strong><small>kg</small></div>'+
            '<div class="metric"><span>FCR Aktual</span><strong>'+prodFmt(x.fcr_actual,3)+'</strong><small>aktual</small></div>'+
            '<div class="metric"><span>FCR Standar</span><strong>'+prodFmt(x.fcr_standard,3)+'</strong><small>standar</small></div>'+
            '<div class="metric"><span>IP (Indeks Prestasi)</span><strong>'+prodFmt(x.ip,2)+'</strong><small>nilai IP</small></div>'+
          '</div>'+
        '</div></div>'+
        '<div class="section"><div class="section-title">RINCIAN PANEN</div><div class="section-body">'+
          '<table class="tbl"><thead><tr><th style="width:5%">No.</th><th style="width:12%">Tanggal Panen</th><th style="width:16%">Pembeli / RPA</th><th style="width:13%">No. Kendaraan</th><th style="width:10%">Jumlah Ekor</th><th style="width:12%">Berat Total (Kg)</th><th style="width:10%">BW (Kg)</th><th style="width:10%">Harga/Kg</th><th style="width:12%">Nilai (Rp)</th></tr></thead><tbody>'+
          hs.map((h,idx)=>'<tr><td style="text-align:center">'+(idx+1)+'</td><td>'+prodDateId(h.harvested_on)+'</td><td>'+esc(h.buyer_name||'-')+'</td><td>'+esc(h.vehicle_number||'-')+'</td><td class="n">'+prodFmt(h.birds,0)+'</td><td class="n">'+num2(h.net_weight_kg)+'</td><td class="n">'+prodFmt(h.avg_weight_kg,3)+'</td><td class="n">'+money(h.price_per_kg)+'</td><td class="n money">'+money(h.total_amount)+'</td></tr>').join('')+
          '<tr class="total"><th colspan="4">TOTAL PANEN</th><td class="n">'+prodFmt(x.total_harvest_birds,0)+'</td><td class="n">'+num2(x.total_harvest_kg)+'</td><td class="n">'+prodFmt(x.avg_bw_kg,3)+'</td><td></td><td class="n money">'+money(x.harvest_value)+'</td></tr>'+
          '</tbody></table>'+
        '</div></div>'+
        '<footer class="footer"><div><strong>REKAP HASIL PEMELIHARAAN PETERNAK (RHPP)</strong><br>'+esc(companyName)+'</div><div style="text-align:right"><span class="page-no">Halaman 1 dari 2</span><br>Dicetak pada: '+esc(printStamp)+'</div></footer>'+
      '</section>'+
      '<section class="page">'+
        '<header class="head">'+logo+'<div class="company"><h1>'+esc(companyName)+'</h1><p>Integritas Kemitraan untuk Peternakan Lebih Baik</p></div><div class="contact">'+companyContact+'</div></header>'+
        '<div class="top-ref">'+esc(x.barn_name||x.barn_code||'-')+' &nbsp; | &nbsp; '+esc(x.contract_number||'-')+' &nbsp; | &nbsp; '+statusLabel+'</div>'+
        '<div class="section"><div class="section-title">RINCIAN SAPRONAK</div><div class="section-body">'+
          '<table class="tbl"><thead><tr><th style="width:6%">No.</th><th>Jenis Sapronak</th><th style="width:14%">Qty</th><th style="width:12%">Satuan</th><th style="width:18%">Harga Satuan (Rp)</th><th style="width:20%">Nilai (Rp)</th></tr></thead><tbody>'+
            '<tr><td style="text-align:center">1</td><td>DOC (Day Old Chick)</td><td class="n">'+prodFmt(chickIn,0)+'</td><td>ekor</td><td class="n">'+money(docPrice)+'</td><td class="n money">'+money(x.main_doc_cost)+'</td></tr>'+
            '<tr><td style="text-align:center">2</td><td>Pakan Bersih</td><td class="n">'+num2(cleanKg)+'</td><td>kg</td><td class="n">'+money(avgFeedPrice)+'</td><td class="n money">'+money(x.main_feed_cost)+'</td></tr>'+
            '<tr><td style="text-align:center">3</td><td>OVK</td><td class="n">'+(ovkValue>0?'1':'0')+'</td><td>paket</td><td class="n">'+money(ovkValue)+'</td><td class="n money">'+money(ovkValue)+'</td></tr>'+
            '<tr><td style="text-align:center">4</td><td>Retur Sapronak</td><td class="n">'+num2(totalReturnKg)+'</td><td>kg</td><td class="n">-</td><td class="n money">- '+money(x.main_return_cost)+'</td></tr>'+
            '<tr><td style="text-align:center">5</td><td>Tambah Sapronak Netto</td><td class="n">-</td><td>-</td><td class="n">-</td><td class="n money">'+money(x.external_sapronak_cost)+'</td></tr>'+
            '<tr class="total"><th colspan="5">TOTAL SAPRONAK</th><td class="n money">'+money(x.sapronak_cost)+'</td></tr>'+
          '</tbody></table>'+
        '</div></div>'+
        '<div class="section"><div class="section-title">PERHITUNGAN RHPP</div><div class="section-body">'+
          '<table class="tbl calc"><thead><tr><th style="width:7%">No.</th><th>Uraian</th><th style="width:28%">Nilai (Rp)</th></tr></thead><tbody>'+
            '<tr><td style="text-align:center">1</td><td>Nilai Produksi (Total Panen)</td><td class="n money">'+money(x.harvest_value)+'</td></tr>'+
            '<tr><td style="text-align:center">2</td><td>Total Sapronak</td><td class="n money">'+money(x.sapronak_cost)+'</td></tr>'+
            '<tr class="em"><td style="text-align:center">3</td><td>Laba Dasar</td><td class="n money">'+money(x.base_profit)+'</td></tr>'+
            '<tr><td style="text-align:center">4</td><td>Bonus IP · tarif '+money(x.bonus_ip_rate)+'/kg</td><td class="n money">'+money(x.bonus_ip)+'</td></tr>'+
            '<tr><td style="text-align:center">5</td><td>Bonus FC / FCR · tarif '+money(x.bonus_fc_rate)+'/kg</td><td class="n money">'+money(x.bonus_fc)+'</td></tr>'+
            '<tr><td style="text-align:center">6</td><td>Bonus Deplesi / Mortalitas · tarif '+money(x.bonus_mortality_rate)+'/kg</td><td class="n money">'+money(x.bonus_mortality)+'</td></tr>'+
            '<tr class="final"><td style="text-align:center">7</td><td>LABA PETERNAK / RHPP FINAL</td><td class="n money">'+money(x.farmer_profit)+'</td></tr>'+
          '</tbody></table>'+
        '</div></div>'+
        '<div class="section"><div class="section-title">CATATAN</div><div class="note">'+(fin?'Dokumen final berdasarkan snapshot saat Close Produksi. Nilai RHPP Sistem Final tidak dihitung ulang dari master terbaru.':'Dokumen masih dalam status proses dan belum menjadi snapshot final.')+'</div></div>'+
        '<div class="section"><div class="section-title">TANDA TANGAN</div><div class="signatures">'+sig('Peternak / ABK')+sig('PPL / Produksi')+sig('Administrator')+sig('Keuangan')+'</div></div>'+
        '<footer class="footer"><div><strong>REKAP HASIL PEMELIHARAAN PETERNAK (RHPP)</strong><br>'+esc(companyName)+'</div><div style="text-align:right"><span class="page-no">Halaman 2 dari 2</span><br>Dicetak pada: '+esc(printStamp)+'</div></footer>'+
      '</section>'+
      '</body></html>';
  };
  const rhppPrintOpen=(pdf=false)=>{
    const w=window.open('','_blank');if(!w)return msg('Popup cetak diblokir browser.');
    w.document.write(rhppDocHtml(pdf));w.document.close();
    setTimeout(()=>{w.focus();w.print();},500);
  };
  const printBtn=document.getElementById('rhppPrint');
  const pdfBtn=document.getElementById('rhppPdf');
  const excelBtn=document.getElementById('rhppExcel');
  if(printBtn)printBtn.onclick=()=>rhppPrintOpen(false);
  if(pdfBtn)pdfBtn.onclick=()=>rhppPrintOpen(true);
  if(excelBtn)excelBtn.onclick=()=>{
    const clone=rhppExport?.cloneNode(true);if(!clone)return;
    clone.querySelectorAll('button,.report-actions').forEach(x=>x.remove());
    const blob=BMSCore.excelBlob(['\ufeff<html><head><meta charset="utf-8"></head><body><h2>RHPP Sistem</h2>'+clone.innerHTML+'</body></html>']);
    const url=URL.createObjectURL(blob),a=document.createElement('a');
    a.href=url;a.download='RHPP_Sistem.xlsx';document.body.appendChild(a);a.click();a.remove();setTimeout(()=>URL.revokeObjectURL(url),1000);
  };

  root.querySelectorAll('[data-close-rhpp]').forEach(btn=>btn.onclick=async()=>{
    const x=rows.find(v=>v.contract_assignment_id===btn.dataset.closeRhpp);
    if(!x)return;
    if(!await appConfirm('RHPP Sistem sudah diperiksa dan DEAL? Close Produksi akan mengunci seluruh transaksi operasional periode ini.'))return;
    const {error}=await db.rpc('admin_close_production_atomic',{p_contract_assignment_id:x.contract_assignment_id});
    if(error)return msg(error.message);
    await financeRhppPage();
    msg('Produksi berhasil di-Close. RHPP Sistem terkunci dan menunggu RHPP Real dari Keuangan.',true);
  });
}

async function employeeMasterPage(){
  const can=profile.role==='ADMIN';
  const {data,error}=await db.from('employees').select('*').order('code',{ascending:true});
  const rows=data||[];
  let html='<section class="panel"><h3>Master Karyawan</h3>';
  if(can){
    html+='<form id="employeeForm" class="form-vertical">'+
      '<input type="hidden" name="id">'+
      '<label>Nama<input name="name" required></label>'+
      '<label>Jenis<select name="kind"><option value="KARYAWAN">KARYAWAN</option><option value="ABK">ABK</option></select></label>'+
      '<label>Telepon<input name="phone"></label>'+
      '<label>Jabatan<input name="job_title"></label>'+
      '<label>Tanggal Masuk<input name="joined_on" type="date"></label>'+
      '<label>Catatan<textarea name="notes"></textarea></label>'+
      '<button type="submit" id="employeeSave">Simpan</button>'+
      '<button type="button" id="employeeCancelEdit" hidden>Batal Edit</button>'+
    '</form>';
  }
  html+='<div class="tablewrap"><table id="employeeMasterTable"><thead><tr><th>Kode</th><th>Nama</th><th>Jenis</th><th>Telepon</th><th>Jabatan</th><th>Tanggal Masuk</th><th>Status</th>'+(can?'<th>Aksi</th>':'')+'</tr></thead><tbody>'+
    rows.map(x=>'<tr><td>'+esc(x.code)+'</td><td>'+esc(x.name)+'</td><td>'+esc(x.kind)+'</td><td>'+esc(x.phone||'')+'</td><td>'+esc(x.job_title||'')+'</td><td>'+esc(x.joined_on||'')+'</td><td>'+(x.active?'Aktif':'Nonaktif')+'</td>'+(can?'<td><button type="button" data-edit-employee="'+esc(x.id)+'">Edit</button> <button type="button" data-toggle-employee="'+esc(x.id)+'">'+(x.active?'Nonaktifkan':'Aktifkan')+'</button></td>':'')+'</tr>').join('')+
    '</tbody></table></div>'+(!rows.length?'<p>Belum ada data.</p>':'')+'</section>';
  layout(html);
  attachListFilter({tableId:'employeeMasterTable',fields:[
    {label:'Kode',col:0,placeholder:'Kode'},
    {label:'Nama',col:1,placeholder:'Nama'},
    {label:'Jenis',col:2,type:'select',options:['KARYAWAN','ABK']},
    {label:'Telepon',col:3,placeholder:'Telepon'},
    {label:'Jabatan',col:4,placeholder:'Jabatan'},
    {label:'Tanggal Masuk',col:5,placeholder:'YYYY-MM-DD'},
    {label:'Status',col:6,type:'select',options:['Aktif','Nonaktif']}
  ]});
  if(error)msg(error.message);
  if(!can)return;
  const form=document.getElementById('employeeForm');
  const save=document.getElementById('employeeSave');
  const cancel=document.getElementById('employeeCancelEdit');
  const reset=()=>{
    form.reset();
    form.elements.id.value='';
    save.textContent='Simpan';
    cancel.hidden=true;
  };
  cancel.onclick=reset;
  root.querySelectorAll('[data-edit-employee]').forEach(btn=>btn.onclick=()=>{
    const x=rows.find(v=>v.id===btn.dataset.editEmployee);if(!x)return;
    form.elements.id.value=x.id;
    form.elements.name.value=x.name||'';
    form.elements.kind.value=x.kind||'KARYAWAN';
    form.elements.phone.value=x.phone||'';
    form.elements.job_title.value=x.job_title||'';
    form.elements.joined_on.value=x.joined_on||'';
    form.elements.notes.value=x.notes||'';
    save.textContent='Simpan Perubahan';
    cancel.hidden=false;
    form.scrollIntoView({behavior:'smooth',block:'start'});
  });
  root.querySelectorAll('[data-toggle-employee]').forEach(btn=>btn.onclick=async()=>{
    const x=rows.find(v=>v.id===btn.dataset.toggleEmployee);if(!x)return;
    const {error}=await db.from('employees').update({active:!x.active}).eq('id',x.id);
    if(error)return msg(error.message);
    await employeeMasterPage();
    msg(x.active?'Karyawan/ABK dinonaktifkan.':'Karyawan/ABK diaktifkan kembali.',true);
  });
  form.onsubmit=async ev=>{
    ev.preventDefault();
    const fd=new FormData(form),id=fd.get('id');
    const o={
      name:fd.get('name'),
      kind:fd.get('kind'),
      phone:fd.get('phone')||null,
      job_title:fd.get('job_title')||null,
      joined_on:fd.get('joined_on')||null,
      notes:fd.get('notes')||null
    };
    const q=id?db.from('employees').update(o).eq('id',id):db.from('employees').insert(o);
    const {error}=await q;
    if(error)return msg(error.message);
    await employeeMasterPage();
    msg(id?'Data karyawan diperbarui.':'Data karyawan tersimpan.',true);
  };
}

async function users(){
  if(profile.role!=='ADMIN')return layout('<p>Akses hanya untuk Administrator.</p>');

  const {data,error}=await db.rpc('admin_list_bms_users');
  const rows=data||[];
  const rolesList=['ADMIN','LOGISTIK','PPL','MARKETING','KEUANGAN','OWNER'];

  let html='<section class="panel"><h3>Master Pengguna</h3>'+
    '<form id="createUserForm" class="form-vertical">'+
      '<label>Nama<input name="name" required></label>'+
      '<label>Email<input name="email" type="email" required></label>'+
      '<label>Role<select name="role">'+rolesList.map(r=>'<option value="'+r+'">'+r+'</option>').join('')+'</select></label>'+
      '<label>Password Awal<div class="password-wrap"><input id="newUserPassword1" name="password" type="password" autocomplete="new-password" required><button type="button" data-toggle-user-password="newUserPassword1">Lihat</button></div></label>'+
      '<label>Konfirmasi Password<div class="password-wrap"><input id="newUserPassword2" name="confirm_password" type="password" autocomplete="new-password" required><button type="button" data-toggle-user-password="newUserPassword2">Lihat</button></div></label>'+
      '<button type="submit">Buat Pengguna</button>'+
    '</form>'+
    '<p class="muted">Akun dibuat langsung oleh Administrator dan tidak memerlukan konfirmasi email.</p>'+
    '</section>';

  html+='<section class="panel"><h3>Daftar Pengguna</h3><div class="tablewrap"><table id="usersMasterTable"><thead><tr><th>Nama</th><th>Email</th><th>Role</th><th>Status</th><th>Aksi</th></tr></thead><tbody>'+
    rows.map(x=>'<tr><td>'+esc(x.full_name)+'</td><td>'+esc(x.email||'')+'</td><td>'+esc(x.role)+'</td><td>'+(x.active?'Aktif':'Nonaktif')+'</td><td>'+
      '<button type="button" data-edit-user="'+esc(x.user_id)+'">Edit</button> '+
      '<button type="button" data-toggle-user="'+esc(x.user_id)+'">'+(x.active?'Nonaktifkan':'Aktifkan')+'</button>'+
    '</td></tr>').join('')+
    '</tbody></table></div>'+(!rows.length?'<p>Belum ada pengguna.</p>':'')+'</section>';

  html+='<section class="panel" id="editUserPanel" hidden><h3>Edit Pengguna</h3>'+
    '<form id="editUserForm" class="form-vertical">'+
      '<input type="hidden" name="user_id">'+
      '<label>Nama<input name="name" required></label>'+
      '<label>Email<input name="email" type="email" readonly></label>'+
      '<label>Role<select name="role">'+rolesList.map(r=>'<option value="'+r+'">'+r+'</option>').join('')+'</select></label>'+
      '<label>Status<select name="active"><option value="true">Aktif</option><option value="false">Nonaktif</option></select></label>'+
      '<button type="submit">Simpan Perubahan</button>'+
      '<button type="button" id="cancelUserEdit">Batal</button>'+
    '</form></section>';

  layout(html);
  attachListFilter({tableId:'usersMasterTable',fields:[
    {label:'Nama',col:0,placeholder:'Nama pengguna'},
    {label:'Email',col:1,placeholder:'Email'},
    {label:'Role',col:2,type:'select',options:rolesList},
    {label:'Status',col:3,type:'select',options:['Aktif','Nonaktif']}
  ]});
  if(error)msg(error.message);

  document.querySelectorAll('[data-toggle-user-password]').forEach(btn=>btn.onclick=()=>{
    const input=document.getElementById(btn.dataset.toggleUserPassword);
    if(!input)return;
    const show=input.type==='password';
    input.type=show?'text':'password';
    btn.textContent=show?'Tutup':'Lihat';
  });

  document.getElementById('createUserForm').onsubmit=async ev=>{
    ev.preventDefault();
    const form=ev.currentTarget;
    const fd=new FormData(form);
    const p1=fd.get('password');
    const p2=fd.get('confirm_password');
    if(p1!==p2)return msg('Konfirmasi password tidak sama.');
    if(String(p1).length<8)return msg('Password minimal 8 karakter.');

    const {data:fnData,error:fnError}=await db.functions.invoke('admin-create-bms-user',{
      body:{
        name:fd.get('name'),
        email:fd.get('email'),
        role:fd.get('role'),
        password:p1
      }
    });
    if(fnError)return msg(fnError.message);
    if(fnData?.error)return msg(fnData.error);
    await users();
    msg('Pengguna berhasil dibuat dan langsung aktif.',true);
  };

  const panel=document.getElementById('editUserPanel');
  const editForm=document.getElementById('editUserForm');
  document.getElementById('cancelUserEdit').onclick=()=>{panel.hidden=true;editForm.reset();};

  root.querySelectorAll('[data-edit-user]').forEach(btn=>btn.onclick=()=>{
    const x=rows.find(v=>v.user_id===btn.dataset.editUser);if(!x)return;
    editForm.elements.user_id.value=x.user_id;
    editForm.elements.name.value=x.full_name||'';
    editForm.elements.email.value=x.email||'';
    editForm.elements.role.value=x.role;
    editForm.elements.active.value=String(!!x.active);
    panel.hidden=false;
    panel.scrollIntoView({behavior:'smooth',block:'start'});
  });

  root.querySelectorAll('[data-toggle-user]').forEach(btn=>btn.onclick=async()=>{
    const x=rows.find(v=>v.user_id===btn.dataset.toggleUser);if(!x)return;
    const {error}=await db.rpc('admin_update_bms_user',{
      p_user_id:x.user_id,
      p_name:x.full_name,
      p_role:x.role,
      p_active:!x.active
    });
    if(error)return msg(error.message);
    await users();
    msg(x.active?'Pengguna dinonaktifkan.':'Pengguna diaktifkan kembali.',true);
  });

  editForm.onsubmit=async ev=>{
    ev.preventDefault();
    const fd=new FormData(editForm);
    const {error}=await db.rpc('admin_update_bms_user',{
      p_user_id:fd.get('user_id'),
      p_name:fd.get('name'),
      p_role:fd.get('role'),
      p_active:fd.get('active')==='true'
    });
    if(error)return msg(error.message);
    await users();
    msg('Data pengguna diperbarui.',true);
  };
}
