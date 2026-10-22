# 🏡 مودة ورحمة — Mawaddah & Rahmah

> **مستشار الزوجية على سنّة**: توجيه عملي لكل حالة زوجية: **التصرف الإسلامي (خطوات) + دليل قرآني مخرّج + دليل من السنة الصحّية + الأثر الدنيوي + العاقبة الأخروية** — بلا إنترنت، وهوية هادئة (أخضر زيتي/بيج/كحلي).

**مرايات حية**: [PWA — أزلها من متصفحك فوراً](https://aoodiakdiro0001-ops.github.io/mawaddah-rahmah/)
**APK**: صفحة [Releases](https://github.com/aoodiakdiro0001-ops/mawaddah-rahmah/releases) — يُبنَت آلياً بمجرد `git tag v*`.

---

## ⚡ بدء التشغيل

| المسار | الخطوات |
| --- | --- |
| **PWA (فوري)** | افتح الرابط أعلاه ← «أضف إلى الشاشة الرئيسية» ← يعمل Offline بعد أول فتح. |
| **Android (APK)** | حمّل `app-release.apk` من Releases وسجله بجهازك (يتطلّب صلاحية unknown sources). |
| **تطوير Flutter** | `cd flutter_app && flutter create . --platforms android --project-name mawaddah --org ly.mawaddah && flutter pub get && flutter run` |
| **التشغيل المحلي PWA** | أي سيرفر ثابت من جذر المستودع (مثل `python3 -m http.server 8080`) — Service Worker يحتاج HTTPS أو localhost. |

## 🧱 البنية (على نمط المواصفة)

```
mawaddah-rahmah/
├── index.html / app.js / styles.css / sw.js / manifest  ← PWA كاملة (Content-First)
├── data/            ← مصدر الحقيقة للمحتوى JSON (guidance / tips / harmony)
├── flutter_app/     ← واجهة Flutter (Dart/Hive) + نسخة مجلد assets/content
├── backend/schema.sql ← مخطط Supabase اختياري (Free Tier) — التطبيق يعمل بدونه 100%
└── .github/workflows/android.yml ← CI يبني APK مجاناً (يُنشئ android/ داخل CI)
```

- **Local-First**: فلاتر قراءة `assets/content/*.json`؛ التفضيلات في **Hive** (بلا adapters/codegen — حفظ آمن بلا adapters).
- **بنية Guidance_Node** (في `data/guidance.json`): `id, gender_target (MALE/FEMALE/BOTH), category, situation_title, islamic_action, dalil_quran, dalil_hadith, worldly_impact, afterlife_consequence, language` + حقول إثرائية للمصادر (مراجع/روابط).

## 🕌 الأمانة الشرعية (قواعد صارمة)

1. **الآيات نصّ حفص حرفية فقط** من قائمة آيات مُتحقَّق منها يدوياً، مع المرجع (سورة:آية) ورابط quran.com.
2. **الأحاديث من الصحاح المشهورة فقط** مع تخريجها الرقمي المعروف (البخاري/مسلم/الترمذي) وروابط sunnah.com.
3. **ممنوع اختراع دليل**: أينما لا يوجد دليل نصي خاص متأكد، يبقى الحقل **فارغاً** مع ملاحظة صريحة.
4. **تنبيه مراجعة**: كل عقدة تحمل `disclaimer_ar` (توعية عامة لا فتوى)، وهناك حقل `note` حيث الشدّ يوجب استشارة عالم.
5. **المحتوى عربياً في v1.0** — تُترجم الواجهة EN، وترجمات tr/ur/fr للمحتوى مؤجّلة بمُنظَّم لما يراجعها أهل علم.

> 🔒 **يمكنك المساعدة**: إن كنت عالماً شرعياً أو طالباً متخصصاً برموم اسنن — إصلاح أي صياغة عبر Pull Request أو Issue مباشرة، وسنتحقق سريعاً.

## 🚀 خريطة الطريق (صفر-تكلفة)

| الإصدار | ما يأتي | لا يزال مجاني؟ |
| --- | --- | --- |
| **v1.0 (الحالي)** | PWA صفحي + Flutter/Hive + CI-APK + منهاج تناغم لطرفين | ✅ GitHub Pages + Actions |
| **v1.1** | **إشعارات FCM لنصائح اليوم** (يتطلب نقرة إنشاء Firebase project في console) + أوقات صلاة/Iqamah | ✅ FCM Free |
| **v1.2** | مزامنة اختيارية عبر **Supabase Free Tier** (`backend/schema.sql` جاهز) + ترجمات tr/ur/fr | ✅ |

## 🧪 اختبار التناغم الزوجي

12 سؤالاً على ضوء السُنّة (ثقة، إنصات، مال، شكر، ضبط غضب، حدود أهل، وقت، قرب، مصالحة، ذكر الله):
- **وضعية ذاتي**: نتيجة + أضعف 3 أقسام مع ربط كل قسم بعقدته العلاجية مباشرة.
- **وضعية بين الطرفين**: يجيب كل طرف على الهاتف نفسه، ثم تقارن — تظهر **الفروق الكبيرة (فرق ≥ 2)** كمواضع حوار.
- النتائج محلية 100%.

## 🔒 الخصوصية

لا حسابات ولا تسجيل، لا تحليلات: التفضيلات وإجابات الاختبار في **localStorage/Hive** فقط. [سياسة الخصوصية](privacy.html).

---

## 🇬🇧 English summary

**Mawaddah & Rahmah** is a local-first Islamic marital guidance app (PWA + Flutter/Hive) built for zero cost: GitHub Pages hosts the PWA, GitHub Actions compiles the Flutter APK on every `v*` tag, and an optional Supabase schema (`backend/schema.sql`) exists for gratitude-level future sync. Every guidance node ships **practical Islamic steps + a cited Quranic verse (verbatim, Hafs) + an authenticated hadith with proper takhrij + worldly impact + hereafter consequence**; no invented evidences — empty field + "consult a scholar" note when no reliable text exists. Content is Arabic-only in v1.0; a harmony test (self / pass-the-phone) maps weakest areas to their guidance nodes. Honesty over breadth; scholar review is requested per the disclaimer in every screen.

## 📝 ملاحظات هندسية

- android/ مُستثنى عمداً — يُولَّد داخل CI بـ `flutter create` (لا ملفات gradle يدوية تتقادم).
- `flutter analyze --no-fatal-warnings --no-fatal-infos` تسمح للإرشادات informational: الفكرة تجنب مشاكل الإصدارات، فإذا تصاعدت إلى error يفشل CI.
- `make_content.py` يولّد `data/*.json` ويتحقق من التكوين (فرادة المعرفات، هياكل النطاقات)، وينسخ إلى أصول فلاتر تلقائياً.
