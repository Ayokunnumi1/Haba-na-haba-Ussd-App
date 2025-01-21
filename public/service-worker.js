self.addEventListener('install', function(event) {
  self.skipWaiting();
  self.clients.matchAll().then(clients => {
    clients.forEach(client => client.postMessage('Service worker installed'));
  });
});

self.addEventListener('activate', function(event) {
  self.clients.matchAll().then(clients => {
    clients.forEach(client => client.postMessage('Service worker activated'));
  });
});

self.addEventListener('fetch', function(event) {
  self.clients.matchAll().then(clients => {
    clients.forEach(client => client.postMessage(`Fetching: ${event.request.url}`));
  });
});