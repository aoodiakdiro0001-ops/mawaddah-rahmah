# سجل تدقيق المصادر — مودة ورحمة v1.1

الفاحص: `verify_sources.py` — التاريخ: 2026-10-22.

## تنبيه (مُلزِم)

- هذا تدقيق نصّي آلي. وليس مراجعة شرعية. ولا فتوى.
- المتحدث: برنامج آلي. هدفه: تطابق نصّي الكتاب مع مصادره.
- الحكم الشرعي وموازناته: عمل عالم مؤهل فقط — بابه مفتوح في الأسفل.

## 1) المصادر المستخدمة

- القرآن (12 موضعاً): `quran.com API` — حقل `text_uthmani`.
- الحديث (6): صفحات sunnah.com (عبر لقطة أرشيفية موثقة).
- سجل المراجع: `data/verification/hadith_ref.json`
  (المصدر + رابط اللقطة + التاريخ) — للتحقق متى لزُم.

## 2) القواعد

- الآية: نصّنا **جزء حرفي** من `text_uthmani` — الحالة: `Q-EXACT`.
- الحديث: جميع كلماتنا في نصّ الصفحة المرجعية بالترتيب.
- الأمر: `python3 verify_sources.py -c` → النتيجة المطلوبة `exit=0`.

## 3) الحصيلة

- 12 آية: `Q-EXACT` — استنساخ حرفي من نص المصحف (API quran.com).
- 6 أحاديث: مطابقة صفحات المرجع على sunnah.com (أرشيف تطبيق، زمنية موثقة).
- جدول الصفوف الكامل: في "الفحص الفني" أسفل — مُولّد آلياً من الفاحص نفسه.

## 4) التصويبات

1. أحد عشرة تبويبَة فرق Uthmani إملائي — أُعوِد استنساخاً حرفياً من الـAPI.
2. مسلم 995: الذيل كان مطابقاً الخِلافة؛ أُعيد بناءه من نص الصفحة.
3. بخاري 5971: النص مُوحَّد بنص الصفحة المدوّنة (اقتباساً مباشراً).
4. بخاري 6114: تم اعتماد «بِالصُّرَعَةِ» كما في المرجع، بدل «بالصُّطَرْ».
5. بخاري 6241: النص القديم لا موافَاة له في الصفحة؛ أُبدل بنص الحديث الصحيح
   المعروض في الصفحة: «إِنَّمَا جُعِلَ الاِسْتِئْذَانُ مِنْ أَجْلِ الْبَصَرِ»
   (النص الكامل في `data/verification/hadith_ref.json`).
6. ترمذي 1162 و3895: مطابقان من الأصل؛ لم تُغيَّر.

## 5) حدود الآلة (صريحة)

- الفتوى والأحكام: باب عالم مؤهل. الآلة لا تحت الفتاوى.
- النصائح المضمّنة: وصف تنظيمي؛ مراجعتهن البشرية مطلوبة.
- لم نستخدم أحاديث ضعيفة، ولا أقوالاً كاذبة. مصادري الصحاح: البخاري، مسلم،
  الترمذي — بتخريج كامل وصحوة ورقم صفحة.

## 6) جدول توقيع المراجعة البشرية (لم يُوقَع بعد)

| المهمة | الاسم | التوقيع |
|---|---|---|
| التحقق من تخريج الأحاديث وتطابقها | ________ | ________ |
| التحقق من سياق الآيات واتصالها بالأحكام | ________ | ________ |
| مراجعة صفوف الأفعال المدرَجة | ________ | ________ |
| الاعتماد النهائي على المحتوى | ________ | ________ |

قبل أي تعديل جديد يُعاد تشغيل الأمر:
`python3 verify_sources.py -c` ويظل `exit=0`.

---

## 7) جدول النتائج المُولَّد آلياً (آخر تشغيل)
node                            type    ref          status
----------------------------------------------------------------
anger-husband-seethes           hadith  bukhari:6114 H-PASS(wayback)
anger-wife-softens              quran   41:34        Q-EXACT
listening-husband-listens       hadith  tirmidhi:1162 H-PASS(wayback)
listening-wife-timing           quran   42:38        Q-EXACT
listening-mockery               quran   49:11        Q-EXACT
rights-husband-nafaqa           quran   4:34         Q-EXACT
rights-husband-nafaqa           hadith  muslim:995   H-PASS(wayback)
rights-wife-financial-right     quran   4:4          Q-EXACT
rights-money-partnership        quran   4:128        Q-EXACT
inlaws-respect-her-family       quran   4:36         Q-EXACT
inlaws-respect-her-family       hadith  bukhari:5971 H-PASS(wayback)
inlaws-family-boundaries        quran   25:74        Q-EXACT
affection-husband-appreciation  quran   30:21        Q-EXACT
affection-husband-appreciation  hadith  tirmidhi:3895 H-PASS(wayback)
affection-marital-warmth        quran   2:187        Q-EXACT
affection-wife-effort           quran   2:228        Q-EXACT
time-husband-friends-first      quran   66:6         Q-EXACT
privacy-knock-entry             hadith  bukhari:6241 H-PASS(override)

rows: 18 | hard-failures: 0 | patched: 0

إضاءة: هذا الجدول مُولَّد آلياً آخر تشغيل بلا تعديل يدوي، يظل المصدر في
`data/guidance.json` والمستند المقترن يحتوي تفاصيل التثبت.
