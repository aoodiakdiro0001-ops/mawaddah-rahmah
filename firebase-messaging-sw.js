/* Mawaddah & Rahmah — FCM background handler (v1.1, optional).
   Only active when firebase-config.js supplies a real config.
   Registered with scope ./fcmscope/ (relative works on GitHub Pages path). */
importScripts('./firebase-config.js');

var cfg = self.MW_FIREBASE_CONFIG || null;

if (cfg && cfg.apiKey) {
  try {
    importScripts('https://www.gstatic.com/firebasejs/10.14.1/firebase-app-compat.js');
    importScripts('https://www.gstatic.com/firebasejs/10.14.1/firebase-messaging-compat.js');
    firebase.initializeApp(cfg);
    firebase.messaging().onBackgroundMessage(function (p) {
      var title = (p && p.notification && p.notification.title) ||
                  (p && p.data && p.data.title) || 'مودة ورحمة';
      var body = (p && p.notification && p.notification.body) ||
                 (p && p.data && p.data.body) || '';
      self.registration.showNotification(title, {
        body: body,
        icon: './icons/icon-192.png',
        badge: './icons/icon-192.png'
      });
    });
  } catch (e) {
    /* FCM init failed — app remains fully functional offline. */
  }
}
