# إعداد الإشعارات الاختياري — Firebase Cloud Messaging (v1.1)

> **الصدق أولاً:**
> v1.1 يسلّم **عميل الإشعارات كاملاً**: زر تفعيل، إذن المتصفح، قطعه
> `firebase-messaging-sw.js`، وعرض/نسخ رمز جهازك.
> **الإرسال الفعلي «نصيحة اليوم»** لم يُبنَ بعد — يحتاج: تخزين الرموز (Supabase
> مجاني) + مهمة مجدولة (Cloud Scheduler أو GitHub Actions cron عبر FCM HTTP v1).
> هذا ما يأتي في v1.2. حتى ذلك الحين لا شيء يُرسَل من هذا التطبيق.

## 1) متطلبات

- حساب Google (مجاني) + مشروع Firebase (خطة Spark المجانية).

## 2) إنشاء المشروع (نقرات)

1. افتح: https://console.firebase.google.com
2. زر «إضافة مشروع» → الاسم: `mawaddah-rahmah` → الخطة المجانية (Spark)
   (بدون Google Analytics — غير ضروري).
3. من صفحة المشروع، أيقونة **</> (Web)** → الاسم المستعار `mawaddah-rahmah`
   → «تسجيل التطبيق».
4. ستظهر تهيئة مثل:
   `apiKey: "AIza..." , authDomain: "...", projectId: "...",
    messagingSenderId: "...", appId: "1:...:web:..."`

## 3) الصق التهيئة

افتح `firebase-config.js`، واستبدل السطر `var cfg = null;` بكائن التهيئة:

```js
var cfg = {
  apiKey: 'AIza...',
  authDomain: 'mawaddah-rahmah.firebaseapp.com',
  projectId: 'mawaddah-rahmah',
  messagingSenderId: '123456789012',
  appId: '1:123456789012:web:abc123def456'
};
```

(التهيئة ليست سرية — أما مفاتيح الخادم فلا تُكتب في المستودع أبداً.)

## 4) مفتاح VAPID (للـ Web Push)

من لوحة المشروع:
- «Project settings» → «Cloud Messaging» → قسم **Web Push certificates**.
- زر «Generate key pair» → انسخ المفتاح المُولّد.
- أضِفه داخل نفس كائن `cfg`: `vapidKey: 'BB...'`.

## 5) تجربة بعد النشر

1. افتح الموقع المنشور → الإعدادات → «الإشعارات».
2. «تفعيل…» → موافقة على إذن المتصفح → يظهر رمز جهازك.
3. انسخ الرمز واحفظه (سيستخدم في v1.2). الرمز محفوظ على جهازك فقط في
   `localStorage` تحت المفتاح `mw_fcm_token`.
4. FCM يسجّل الرمز تلقائياً لمشروعك؛ لا يلزم أي خادم إضافي في هذه المرحلة.

## 6) ملاحظات تقنية

- `firebase-messaging-sw.js` يُسجَّل بنطاق `./fcmscope/` — الصيغة النسبية
  تعمل على GitHub Pages (الصيغة المطلقة `/firebase…push-scope`
  ترفض غالباً على مسار فرعي subdomain).
- بدون تهيئة (`cfg = null`) الميزة معطلة: الزر يوضح الدليل، والتطبيق يظل
  يعمل بلا إنترنت وبلا أي تتبع.
