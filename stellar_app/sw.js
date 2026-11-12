
self.addEventListener("push", (event) => {
  const data = event.data
    ? event.data.json()
    : {};

  const title = data.title || "Stellar Marketing";

  const options = {
    body: data.body || "Você tem uma nova notificação.",
    icon: "./apple-touch-icon.png",
    badge: "./apple-touch-icon.png",
    data: {
      url: data.url || "./"
    }
  };

  event.waitUntil(
    self.registration.showNotification(title, options)
  );
});

self.addEventListener("notificationclick", (event) => {
  event.notification.close();

  const url = new URL(
    event.notification.data?.url || "./",
    self.registration.scope
  ).href;

  event.waitUntil(
    clients.openWindow(url)
  );
});
