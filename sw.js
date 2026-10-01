const CACHE_NAME='bms-pwa-shell-v2';
const SHELL=[
  './',
  './index.html',
  './style.css?v=2218-rhpp-exact-cetak',
  './assets/bms_login_logo.jpg',
  './assets/bms_express_logo.jpg',
  './manifest.webmanifest'
];

self.addEventListener('install',event=>{
  self.skipWaiting();
  event.waitUntil(
    caches.open(CACHE_NAME).then(cache=>cache.addAll(SHELL)).catch(()=>{})
  );
});

self.addEventListener('activate',event=>{
  event.waitUntil(
    caches.keys().then(keys=>Promise.all(keys.filter(k=>k!==CACHE_NAME).map(k=>caches.delete(k))))
      .then(()=>self.clients.claim())
  );
});

self.addEventListener('fetch',event=>{
  const req=event.request;
  if(req.method!=='GET')return;
  const url=new URL(req.url);

  if(req.mode==='navigate'){
    event.respondWith(
      fetch(req,{cache:'no-store'}).then(res=>{
        const copy=res.clone();
        caches.open(CACHE_NAME).then(c=>c.put('./index.html',copy)).catch(()=>{});
        return res;
      }).catch(()=>caches.match('./index.html'))
    );
    return;
  }

  if(url.origin===self.location.origin && (
      url.pathname.endsWith('.js') ||
      url.pathname.endsWith('.css') ||
      url.pathname.endsWith('.webmanifest')
  )){
    event.respondWith(
      fetch(req,{cache:'no-store'}).then(res=>{
        const copy=res.clone();
        caches.open(CACHE_NAME).then(c=>c.put(req,copy)).catch(()=>{});
        return res;
      }).catch(()=>caches.match(req))
    );
    return;
  }

  event.respondWith(
    caches.match(req).then(hit=>hit||fetch(req).then(res=>{
      if(url.origin===self.location.origin){
        const copy=res.clone();
        caches.open(CACHE_NAME).then(c=>c.put(req,copy)).catch(()=>{});
      }
      return res;
    }))
  );
});


self.addEventListener('message',event=>{
  if(event.data&&event.data.type==='SKIP_WAITING')self.skipWaiting();
});
