/* FCM v1.1 — إعداد الاختياري لإشعارات "نصيحة اليوم".
   الصق تهيئة تطبيق الويب من Firebase هنا (الدليل: docs/firebase-setup.md):
   مثال متغير cfg:
   { apiKey:'AIza...', authDomain:'xxx.firebaseapp.com', projectId:'xxx',
     messagingSenderId:'123456789', appId:'1:123:web:abc', vapidKey:'BB...' }
   وبقي null = الميزة معطلة تماماً، والتطبيق يعمل بلا إنترنت وبلا أي تحليل. */
(function () {
  var cfg = null;
  if (typeof window !== 'undefined') window.MW_FIREBASE_CONFIG = cfg;
  if (typeof self !== 'undefined') self.MW_FIREBASE_CONFIG = cfg;
})();
