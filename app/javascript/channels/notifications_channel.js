import consumer from "./consumer"

consumer.subscriptions.create({ channel: "NotificationsChannel"}, {
  connected() {
    // Called when the subscription is ready for use on the server
    console.log("Connected to NotificationsChannel");
  },

  disconnected() {
    // Called when the subscription has been terminated by the server
    console.log("Disconnected from NotificationsChannel");
  },

  received(data) {
    // Called when there's incoming data on the websocket for this channel
    alert(data.message);
    const notificationLIst = document.getElementById("notification-list");
    if (notificationLIst) {
      const li = document.createElement("li");
      li.textContent = data.message;
      notificationLIst.appendChild(li);
    }
  }
});
