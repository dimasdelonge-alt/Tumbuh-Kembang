'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"flutter.js": "24bc71911b75b5f8135c949e27a2984e",
"assets/FontManifest.json": "dc3d03800ccca4601324923c0b1d6d57",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "33b7d9392238c04c131b6ce224e13711",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/shaders/stretch_effect.frag": "40d68efbbf360632f614c731219e95f0",
"assets/assets/kpsp/kpsp_48_3.png": "4d8469a743e7fe74d6700468c1656c41",
"assets/assets/kpsp/kpsp_48_2.png": "cb800ba3b9d70e987acac7e94324a8cf",
"assets/assets/kpsp/kpsp_36_2.png": "6c8843e1182cc61bb0bc91d276026d54",
"assets/assets/kpsp/kpsp_42_1.png": "6c8843e1182cc61bb0bc91d276026d54",
"assets/assets/kpsp/kpsp_54_3.png": "e0fb1f5fe78f7adcc4676d9157682982",
"assets/assets/kpsp/kpsp_6_5.png": "132772d016882afb56da68f3b9af25ab",
"assets/assets/kpsp/kpsp_3_10.png": "90430282861471ec8c91dc1226bd7424",
"assets/assets/kpsp/kpsp_60_1.png": "55315eb94c9d8edcc0b20c491415b463",
"assets/assets/kpsp/kpsp_6_1.png": "15f9c9c4593f923ecbd3eddac53cd466",
"assets/assets/kpsp/kpsp_36_3.png": "4d8469a743e7fe74d6700468c1656c41",
"assets/assets/kpsp/kpsp_54_1.png": "55315eb94c9d8edcc0b20c491415b463",
"assets/assets/kpsp/kpsp_30_3.png": "4d8469a743e7fe74d6700468c1656c41",
"assets/assets/kpsp/kpsp_9_1.png": "d58e6616a41cbe0a284d2f3c5030373e",
"assets/assets/kpsp/kpsp_3_9.png": "da938b4b47e1d412ed5683a2975b3980",
"assets/assets/kpsp/kpsp_42_3.png": "4d8469a743e7fe74d6700468c1656c41",
"assets/assets/kpsp/kpsp_21_3.png": "8ebbe2b3a77a8ebfb9705632966ab267",
"assets/assets/kpsp/kpsp_48_1.png": "171440a649b3b795f9fba5ba154280ae",
"assets/assets/kpsp/kpsp_72_1.png": "cd5032b910f128e76cc71958070720be",
"assets/assets/kpsp/kpsp_30_2.png": "6c8843e1182cc61bb0bc91d276026d54",
"assets/assets/kpsp/kpsp_66_1.png": "1cd36130b5e57795a0ee52727dcd5e92",
"assets/assets/kpsp/kpsp_6_3.png": "32d77df9e863163d943c59db9920d757",
"assets/assets/kpsp/kpsp_3_7.png": "dddcce79dfb564b156418650cb1c0c95",
"assets/assets/kpsp/kpsp_3_8.png": "f09474d7cede20e06698f124776c1ad5",
"assets/assets/kpsp/kpsp_66_2.png": "cd5032b910f128e76cc71958070720be",
"assets/assets/kpsp/kpsp_6_2.png": "d9997065d90c40f49f8cbe7963dbebe8",
"assets/assets/kpsp/kpsp_54_2.png": "a6762466dc70996f56b9be8be1e81fd6",
"assets/assets/kpsp/kpsp_9_9.png": "81bffc4aee1031547bbd57096eec20bd",
"assets/assets/kpsp/kpsp_3_6.png": "3c83cbec67f3228ab9849303ce5fd2f1",
"assets/assets/kpsp/kpsp_12_2.png": "ee1da246f4b8c6c2ca8f89d8fbb0dde9",
"assets/assets/kpsp/kpsp_72_2.png": "a4d925c203e7dea2ea9a5e7ab2f6013a",
"assets/assets/kpsp/kpsp_66_3.png": "a4d925c203e7dea2ea9a5e7ab2f6013a",
"assets/assets/kpsp/kpsp_60_2.png": "e0fb1f5fe78f7adcc4676d9157682982",
"assets/assets/who/wfl_P.json": "b5faa9455e4a4014b00ec39610917389",
"assets/assets/who/bmifa_L.json": "f39da48815a34c3bc4a06961936ffb23",
"assets/assets/who/wfa_P.json": "01214c521e8a1b490fffde6fd0992ec0",
"assets/assets/who/wfh_L.json": "765d171d57d875389ff3345b0665694f",
"assets/assets/who/lhfa_L.json": "e522d0f394d12a7ff96589610486172e",
"assets/assets/who/lhfa_P.json": "65e5b37b9851ab3c1b51020c949568ed",
"assets/assets/who/hcfa_P.json": "0deed81aece4d681536110ca849b555b",
"assets/assets/who/hcfa_L.json": "e25ff8240206ba67c6410a5fb5fa5b2b",
"assets/assets/who/wfl_L.json": "7fc1d2d5b270ccfc2e4f728ae70159c3",
"assets/assets/who/wfh_P.json": "380d92152b91a7fe89890c86c733b3fc",
"assets/assets/who/wfa_L.json": "c4f44de089359891e68d64063d831f1f",
"assets/assets/who/bmifa_P.json": "2a2c922a8bc0705ddda5273ba688fdcc",
"assets/AssetManifest.bin.json": "bb247aa50b4a397ecb972a128a5ad6aa",
"assets/fonts/MaterialIcons-Regular.otf": "a800426df2e262a6bdce1c0d643ad965",
"assets/AssetManifest.bin": "71309285271a3098579f4774b5e359fc",
"assets/NOTICES": "e7c9f3b8d49131ac692827e854e67118",
"icons/Icon-512.png": "7c92f1302b0d2aed6999655cfd7cbaa0",
"icons/Icon-maskable-512.png": "3d035db912290f0d27a35e14c4f174ed",
"icons/Icon-maskable-192.png": "0bff72e781305e6611a4b8ee7d8720c6",
"icons/Icon-192.png": "0f2c424b1a43ce22de0e081bb4bf4272",
"flutter_bootstrap.js": "29a46240ac95d75828f46d5501da0076",
"sqlite3.wasm": "2e9fc1ccbb9d15199fccf405b0ceee53",
"canvaskit/skwasm.wasm": "7e5f3afdd3b0747a1fd4517cea239898",
"canvaskit/skwasm.js.symbols": "3a4aadf4e8141f284bd524976b1d6bdc",
"canvaskit/chromium/canvaskit.js": "a80c765aaa8af8645c9fb1aae53f9abf",
"canvaskit/chromium/canvaskit.js.symbols": "e2d09f0e434bc118bf67dae526737d07",
"canvaskit/chromium/canvaskit.wasm": "a726e3f75a84fcdf495a15817c63a35d",
"canvaskit/canvaskit.js": "8331fe38e66b3a898c4f37648aaf7ee2",
"canvaskit/skwasm_heavy.js": "740d43a6b8240ef9e23eed8c48840da4",
"canvaskit/canvaskit.js.symbols": "a3c9f77715b642d0437d9c275caba91e",
"canvaskit/skwasm_heavy.js.symbols": "0755b4fb399918388d71b59ad390b055",
"canvaskit/canvaskit.wasm": "9b6a7830bf26959b200594729d73538e",
"canvaskit/skwasm.js": "8060d46e9a4901ca9991edd3a26be4f0",
"canvaskit/skwasm_heavy.wasm": "b0be7910760d205ea4e011458df6ee01",
"index.html": "5163b3e22a7cf771f9f8cf5279ed9d38",
"/": "5163b3e22a7cf771f9f8cf5279ed9d38",
"main.dart.js": "0a5a551520f5022bb2ab46df84d9e3c4",
"favicon.png": "b4fb9fc8fd0d3bbd1db6d50c6503bae1",
"manifest.json": "f193af2e5b7215ae5b23c7411ee3d921",
"drift_worker.js.deps": "4325d299936413c6cf1f0071253474e2",
"version.json": "d72ad2c0e811ce669c30cfdb59774891",
"drift_worker.dart": "2febc71e9e2c8cde7aba210fd873c12c",
"drift_worker.js.map": "5d617946d3706cbf31ad2c4cb6314826",
"drift_worker.js": "2da584cdd8917d0fd61d04135afb0795"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
"flutter_bootstrap.js",
"assets/AssetManifest.bin.json",
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
