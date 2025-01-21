self.addEventListener('install', function(event) {
  // The promise that skipWaiting() returns can be safely ignored.
  self.skipWaiting();
  console.log('Installed', event);
});

self.addEventListener('activate', function(event) {
  console.log('Activated', event);
}   );

self.addEventListener('fetch', function(event) {        
  console.log('Fetched', event);
}           );  