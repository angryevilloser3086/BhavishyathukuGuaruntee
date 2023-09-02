'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"assets/AssetManifest.json": "c9de427eca0780b2c684eaa599b3b3c2",
"assets/AssetManifest.smcbin": "6176b0835a767b7aea8a1aeaeb08b96b",
"assets/assets/fonts/Noto_Serif_Telugu/NotoSerifTelugu-VariableFont_wght.ttf": "be601c6f279d65e413a0f446c39186b7",
"assets/assets/images/123.pdf": "b9b13cc9e3b9b41f20ed1a636cea0e1f",
"assets/assets/images/Annadatha.png": "71b4a34b87d36b442083dfa82db675bd",
"assets/assets/images/BC.png": "2620b202347bec5843a0683ece696653",
"assets/assets/images/BG-Logo-small%25201.png": "975177f0bc2a170d109795d99812ab35",
"assets/assets/images/bg_official_video.mp4": "52544fe5053ec0e579de5e9dfc0cf98a",
"assets/assets/images/Desktop%2520-%252014.png": "a9e5c645bb38ef71851447b43dfeb7d2",
"assets/assets/images/Desktop%2520-%252015.png": "8b401050d64fea0800c7a808c2299c95",
"assets/assets/images/Desktop%2520-%252016.png": "50b4890fec7661f8aa34d74712acf3ee",
"assets/assets/images/Desktop%2520-%252017.png": "a7d716a139ff5470e0576d3b06d93986",
"assets/assets/images/Desktop%2520-%252018.png": "3b09b2667571a14c762310505adc4541",
"assets/assets/images/Frame%2520106.svg": "8fe762c158ea2cf4c41aedcdb9bf62fb",
"assets/assets/images/Frame_30_1.png": "31e68eb48f0b818aa08248541bff1c41",
"assets/assets/images/Group%2520343.png": "7d24cd20020f84974725dc0e5107ce67",
"assets/assets/images/header-website.png1_.png": "90b265ea621fae4e1e0ae47a07417bf1",
"assets/assets/images/ic_bg_1.png": "37902a251e252292e48248b5432ba8db",
"assets/assets/images/ic_fb_box.png": "cb1de0c5b5dba292d4e9fc5610ecc079",
"assets/assets/images/ic_grid_bg.png": "589b88281c35e9041b28b55ae26635b2",
"assets/assets/images/ic_header_2.png": "98d0923a247636efd34434312ab97d19",
"assets/assets/images/ic_headline.png": "8df21cd106609bdcfa532bc91e270d57",
"assets/assets/images/ic_insta+box.png": "88531e65fe1fe82c7008a352f808ef47",
"assets/assets/images/ic_new_logo.png": "43a462cf48d5a31b60b265f7b56cc07f",
"assets/assets/images/ic_pdf_header.png": "cbf84af5598672e795d1cc80765cadf4",
"assets/assets/images/ic_pdf_image_1.png": "e553e41eea7e89d0f4e072b5c810a08f",
"assets/assets/images/ic_pdf_img_2.png": "8a435e0554e77030b995225e2fa8828f",
"assets/assets/images/ic_qr.png": "0f8129397632e83e34745feba3d4476d",
"assets/assets/images/ic_subhead_secondCard.png": "4d5895891ad8f4cd39837664cbeab86b",
"assets/assets/images/ic_tick.png": "03ca585751ab2476c2e43ee6d916163f",
"assets/assets/images/ic_yt_box.png": "0e76e3bc9fd7d9d64930f76290ad8de9",
"assets/assets/images/Logo%25201.png": "a869bfc226a521bda9da15624804657c",
"assets/assets/images/mahashakti.png": "678c68a3e624f7cf1591b6a856899d6c",
"assets/assets/images/Poor.png": "750dd21e4f69c0e82acb3fcff8746196",
"assets/assets/images/quiz_logo.png": "6d580b1975cf74e973e512d78bd11c64",
"assets/assets/images/table.png": "b8caec38b20f4319645f1e3180c36a77",
"assets/assets/images/twitter_ic.png": "55d17740a38cd825dd2125d70713c9e1",
"assets/assets/images/Water.png": "97ee1686ac22a5bc717ca45c1a8c000b",
"assets/assets/images/Yuvagalam.png": "40a271ec6e4c0aae04f02ecc70c544f4",
"assets/FontManifest.json": "7b2a36307916a9721811788013e65289",
"assets/fonts/MaterialIcons-Regular.otf": "e08205525c45f4a8d784cfad2bc606dc",
"assets/NOTICES": "626d3f16d95efbc3f6c5263e76c73f28",
"assets/shaders/ink_sparkle.frag": "f8b80e740d33eb157090be4e995febdf",
"canvaskit/canvaskit.js": "76f7d822f42397160c5dfc69cbc9b2de",
"canvaskit/canvaskit.wasm": "f48eaf57cada79163ec6dec7929486ea",
"canvaskit/chromium/canvaskit.js": "8c8392ce4a4364cbb240aa09b5652e05",
"canvaskit/chromium/canvaskit.wasm": "fc18c3010856029414b70cae1afc5cd9",
"canvaskit/skwasm.js": "1df4d741f441fa1a4d10530ced463ef8",
"canvaskit/skwasm.wasm": "6711032e17bf49924b2b001cef0d3ea3",
"canvaskit/skwasm.worker.js": "19659053a277272607529ef87acf9d8a",
"favicon.ico": "864dce19d4b9e396e4d7cfad2de215a4",
"favicon.png": "5dcef449791fa27946b3d35ad8803796",
"flutter.js": "6b515e434cea20006b3ef1726d2c8894",
"icons/apple-touch-icon.png": "063d35ee650dfab852ef55dba170af23",
"icons/favicon.ico": "864dce19d4b9e396e4d7cfad2de215a4",
"icons/icon-192-maskable.png": "16f2385afa683133ed9ca952eea71643",
"icons/icon-192.png": "88bee33470024aea0c63b5cb0bb64dae",
"icons/icon-512-maskable.png": "28e361daaaac75e247b90a8e706e4382",
"icons/icon-512.png": "dd5d681ccf4499f1bd7c4bb1ec35e334",
"index.html": "197f58f17dcab922e8ff6992d8e6c57d",
"/": "197f58f17dcab922e8ff6992d8e6c57d",
"main.dart.js": "a33361dc5fc68e00a56fcd071a329cae",
"manifest.json": "d6cb154c271add3622965d4d74bacbb5",
"version.json": "898f7869a1d22cc7f5be1a8266a020bd"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
"assets/AssetManifest.json",
"assets/FontManifest.json"];

// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});
// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        // Claim client to enable caching on first launch
        self.clients.claim();
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      // Claim client to enable caching on first launch
      self.clients.claim();
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});
// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
          return response;
        });
      })
    })
  );
});
self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});
// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}
// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
