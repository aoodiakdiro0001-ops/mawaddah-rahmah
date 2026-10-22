import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle, SystemChrome, DeviceOrientation;
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  final box = await Hive.openBox('mw');
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(MawApp(box: box));
}

/* ------------------------------------------------------------------ */
/* Labels                                                             */
/* ------------------------------------------------------------------ */

const Map<String, Map<String, String>> LABELS = {
  'ar': {
    'appTitle': 'مودة ورحمة',
    'tagline': 'مستشار الزوجية على سنّة',
    'onboardLead': 'توجيه عملي للزوجين مستمد من آيات مخرّجة وأحاديث في الصحاح — توعية عامة لا فتوى.',
    'spouse': 'من أنت؟',
    'husband': 'زوج',
    'wife': 'زوجة',
    'bothNote': 'ستحصل على توجيهات حالتك + العقد المشتركة الموجّهة للطرفين.',
    'start': 'ابدأ',
    'tipOfDay': 'نصيحة اليوم',
    'searchHint': 'ماذا أفعل إذا…؟',
    'all': 'الكل',
    'testTitle': 'اختبار التناغم الزوجي',
    'testEntry': '12 سؤالاً حول الأسنة — أجب ذاتياً أو بالتبادل بين الطرفين.',
    'goTest': 'ابدأ الاختبار',
    'self': 'ذاتي',
    'couple': 'بين الطرفين',
    'partnerA': 'الطرف الأول',
    'partnerB': 'الطرف الثاني',
    'score': 'النتيجة',
    'avgScore': 'متوسط الطرفين',
    'weakest': 'أضعف الأقسام',
    'openNode': 'عرض العقدة',
    'retake': 'إعادة',
    'home': 'الرئيسية',
    'settings': 'الإعدادات',
    'about': 'عن التطبيق',
    'changeProfile': 'تغيير النوع واللغة',
    'honesty': 'تنبيه أمانة: توجيه عام وليس فتوى — لكل حالة خاصة استشر جهة تبليغ شرعي معتمدة، والمحتوى يُراجَع عالماً شرعياً.',
    'kAction': 'التصرف الإسلامي (خطوات)',
    'kQuran': 'دليل من القرآن',
    'kHadith': 'دليل من السنة',
    'kWorldly': 'الأثر الدنيوي',
    'kAkhirah': 'الأثر الأخروي',
    'kNote': 'تنبيه',
    'scoreMax': 'من 36',
    'diffTitle': 'فروق كبيرة تستحق حواراً هادئاً',
    'langOnlyAr': 'المحتوى الشرعي عربياً في v1.0؛ الترجمات لاحقاً بعد المراجعة.',
    'version': 'v1.0.0 — يعمل كلياً بلا إنترنت',
  },
  'en': {
    'appTitle': 'Mawaddah & Rahmah',
    'tagline': 'Islamic couple guidance, cited & honest',
    'onboardLead': 'Practical guidance drawn from cited Quranic verses and authentic hadith — general education, not fatwa.',
    'spouse': 'Who are you?',
    'husband': 'Husband',
    'wife': 'Wife',
    'bothNote': 'You get case guidance aimed at you plus BOTH-target nodes.',
    'start': 'Start',
    'tipOfDay': 'Tip of the day',
    'searchHint': 'What do I do if…?',
    'all': 'All',
    'testTitle': 'Couple Harmony Test',
    'testEntry': '12 questions — answer alone or pass the phone to compare partners.',
    'goTest': 'Start test',
    'self': 'Self',
    'couple': 'Couple mode',
    'partnerA': 'Partner 1',
    'partnerB': 'Partner 2',
    'score': 'Score',
    'avgScore': 'Partners average',
    'weakest': 'Weakest areas',
    'openNode': 'Open guidance',
    'retake': 'Retake',
    'home': 'Home',
    'settings': 'Settings',
    'about': 'About',
    'changeProfile': 'Change gender & language',
    'honesty': 'Honesty: general education, not fatwa — for private cases consult a qualified scholar.',
    'kAction': 'Islamic action (steps)',
    'kQuran': 'Evidence from Quran',
    'kHadith': 'Evidence from Sunnah',
    'kWorldly': 'Worldly impact',
    'kAkhirah': 'Hereafter consequence',
    'kNote': 'Notice',
    'scoreMax': 'out of 36',
    'diffTitle': 'Large gaps worth discussing',
    'langOnlyAr': 'Guidance content is Arabic in v1.0; translations later after review.',
    'version': 'v1.0.0 — fully offline',
  }
};

/* ------------------------------------------------------------------ */
/* Models (light wrappers over JSON maps)                             */
/* ------------------------------------------------------------------ */

class GuidanceData {
  final List<dynamic> categories;
  final List<dynamic> nodes;
  final String disclaimerAr;
  GuidanceData(this.categories, this.nodes, this.disclaimerAr);

  factory GuidanceData.fromMap(Map<String, dynamic> m) => GuidanceData(
        m['categories'] as List<dynamic>? ?? <dynamic>[],
        m['nodes'] as List<dynamic>? ?? <dynamic>[],
        m['disclaimer_ar'] as String? ?? '',
      );
}

/* ------------------------------------------------------------------ */
/* Root widget                                                        */
/* ------------------------------------------------------------------ */

class MawApp extends StatelessWidget {
  final Box box;
  const MawApp({super.key, required this.box});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mawaddah & Rahmah',
      debugShowCheckedModeBanner: false,
      theme: mawTheme(),
      home: SplashScreen(box: box),
    );
  }

  ThemeData mawTheme() {
    const olive = Color(0xFF55613A);
    const oliveDark = Color(0xFF3E4829);
    const beige = Color(0xFFF2E8D5);
    const navy = Color(0xFF1F2A44);
    final base = ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: olive,
        primary: olive,
        secondary: navy,
      ),
      scaffoldBackgroundColor: beige,
    );
    return base.copyWith(
      appBarTheme: const AppBarTheme(
        backgroundColor: olive,
        foregroundColor: Color(0xFFFDFBF5),
        elevation: 0,
        centerTitle: false,
      ),
      cardTheme: const CardTheme(
        color: Color(0xFFFDFBF5),
        elevation: 0,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: Color(0xFFE4D6B8)),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: olive,
          foregroundColor: const Color(0xFFFDFBF5),
          minimumSize: const Size.fromHeight(52),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFFFDFBF5),
        border: OutlineInputBorder(
          borderSide: const BorderSide(color: Color(0xFFE4D6B8)),
          borderRadius: BorderRadius.circular(14),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Color(0xFFE4D6B8)),
          borderRadius: BorderRadius.circular(14),
        ),
      ),
      textTheme: base.textTheme.apply(
        bodyColor: const Color(0xFF26291E),
        displayColor: oliveDark,
      ),
    );
  }
}

/* ------------------------------------------------------------------ */
/* Splash: load JSON then route to onboarding/home                     */
/* ------------------------------------------------------------------ */

class SplashScreen extends StatefulWidget {
  final Box box;
  const SplashScreen({super.key, required this.box});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  GuidanceData? data;
  List<dynamic>? tips;
  Map<String, dynamic>? test;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final d = jsonDecode(await rootBundle.loadString('assets/content/guidance.json'))
        as Map<String, dynamic>;
    final t = jsonDecode(await rootBundle.loadString('assets/content/tips.json'))
        as Map<String, dynamic>;
    final h = jsonDecode(await rootBundle.loadString('assets/content/harmony.json'))
        as Map<String, dynamic>;
    if (!mounted) return;
    setState(() {
      data = GuidanceData.fromMap(d);
      tips = _asList(t['tips']);
      test = h;
    });
  }

  @override
  Widget build(BuildContext context) {
    final dir =
        (widget.box.get('lang') ?? 'ar') == 'ar' ? TextDirection.rtl : TextDirection.ltr;
    final body = Directionality(
      textDirection: dir,
      child: (data == null)
          ? const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            )
          : (widget.box.get('gender') == null)
              ? OnboardPage(box: widget.box, data: data!)
              : HomePage(
                  box: widget.box,
                  data: data!,
                  tips: tips!,
                  test: test!,
                ),
    );
    return body;
  }
}

List<dynamic> _asList(dynamic v) => v is List<dynamic> ? v : <dynamic>[];

/* ------------------------------------------------------------------ */
/* Onboarding                                                          */
/* ------------------------------------------------------------------ */

class OnboardPage extends StatefulWidget {
  final Box box;
  final GuidanceData data;
  const OnboardPage({super.key, required this.box, required this.data});
  @override
  State<OnboardPage> createState() => _OnboardPageState();
}

class _OnboardPageState extends State<OnboardPage> {
  String lang = 'ar';
  String? gender;

  @override
  void initState() {
    super.initState();
    lang = widget.box.get('lang') ?? 'ar';
  }

  Map<String, String> get L => LABELS[lang]!;

  @override
  Widget build(BuildContext context) {
    final dir = lang == 'ar' ? TextDirection.rtl : TextDirection.ltr;
    return Directionality(
      textDirection: dir,
      child: Scaffold(
        appBar: AppBar(title: Text(L['appTitle']!)),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text(L['onboardLead']!,
                style: const TextStyle(fontSize: 14.5, height: 1.9)),
            const SizedBox(height: 8),
            Text(L['langOnlyAr']!,
                style: const TextStyle(fontSize: 12, color: Color(0xFF33436B))),
            const SizedBox(height: 18),
            Text(L['spouse']!,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Row(
              children: [
                _genOpt('MALE', L['husband']!, '👨'),
                const SizedBox(width: 10),
                _genOpt('FEMALE', L['wife']!, '👩'),
              ],
            ),
            const SizedBox(height: 12),
            Text(L['bothNote']!,
                style: const TextStyle(fontSize: 12, color: Color(0xFF33436B))),
            const SizedBox(height: 22),
            ElevatedButton(
              onPressed: gender == null
                  ? null
                  : () {
                      widget.box.put('lang', lang);
                      widget.box.put('gender', gender!);
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (_) => SplashScreen(box: widget.box),
                      ));
                    },
              child: Text(L['start']!),
            ),
          ],
        ),
      ),
    );
  }

  Widget _genOpt(String val, String label, String emoji) {
    final active = gender == val;
    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () => setState(() => gender = val),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 18),
          decoration: BoxDecoration(
            color: active ? const Color(0x1455613A) : const Color(0xFFFDFBF5),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: active ? const Color(0xFF55613A) : const Color(0xFFE4D6B8),
              width: 1.5,
            ),
          ),
          child: Column(
            children: [
              Text(emoji, style: const TextStyle(fontSize: 30)),
              const SizedBox(height: 6),
              Text(label,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
            ],
          ),
        ),
      ),
    );
  }
}

/* ------------------------------------------------------------------ */
/* Home                                                                */
/* ------------------------------------------------------------------ */

class HomePage extends StatefulWidget {
  final Box box;
  final GuidanceData data;
  final List<dynamic> tips;
  final Map<String, dynamic> test;
  const HomePage({
    super.key,
    required this.box,
    required this.data,
    required this.tips,
    required this.test,
  });
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String chip = 'all';
  String query = '';
  Map<String, dynamic>? openNode;

  String get lang => (widget.box.get('lang') ?? 'ar') as String;
  String get gender => (widget.box.get('gender') ?? 'MALE') as String;
  Map<String, String> get L => LABELS[lang]!;
  TextDirection get dir => lang == 'ar' ? TextDirection.rtl : TextDirection.ltr;

  String nodeTitle(Map<String, dynamic> n) {
    if (lang == 'en' && (n['situation_title_en'] ?? '') != '') {
      return n['situation_title_en'] as String;
    }
    return n['situation_title'] as String;
  }

  String tipKey() {
    final day = DateTime.now()
        .difference(DateTime(DateTime.now().year))
        .inDays;
    final shift = gender == 'MALE' ? 1 : 3;
    final tips = widget.tips;
    if (tips.isEmpty) return '';
    final tip = tips[(day + shift) % tips.length] as Map<String, dynamic>;
    return tip['ar'] as String? ?? '';
  }

  List<Map<String, dynamic>> get filtered {
    final q = query.trim().toLowerCase();
    final out = <Map<String, dynamic>>[];
    for (final n0 in widget.data.nodes) {
      final n = n0 as Map<String, dynamic>;
      final g = n['gender_target'] as String? ?? 'BOTH';
      if (g != 'BOTH' && g != gender) continue;
      if (chip != 'all' && n['category'] != chip) continue;
      if (q.isNotEmpty) {
        final hay = ('${n['situation_title']} ${n['islamic_action']} ${n['dalil_quran']} ${n['dalil_hadith']}')
            .toLowerCase();
        if (!hay.contains(q)) continue;
      }
      out.add(n);
    }
    return out;
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: dir,
      child: Scaffold(
        appBar: AppBar(
          title: Text(L['appTitle']!),
          actions: [
            IconButton(
              tooltip: L['settings']!,
              icon: const Icon(Icons.settings_outlined),
              onPressed: () => _openSettings(context),
            ),
          ],
        ),
        body: ListView(
          padding: const EdgeInsets.all(14),
          children: [
            _tipCard(),
            const SizedBox(height: 12),
            _testCard(),
            const SizedBox(height: 12),
            TextField(
              decoration: InputDecoration(
                hintText: L['searchHint']!,
                prefixIcon: const Icon(Icons.search),
              ),
              onChanged: (v) => setState(() => query = v),
            ),
            const SizedBox(height: 12),
            _chips(),
            const SizedBox(height: 6),
            ...filtered.map(_nodeCard),
            const SizedBox(height: 24),
            Text(
              L['version']!,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 11.5, color: Color(0xFF33436B)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _tipCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFDFBF5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE4D6B8)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            const Text('☀️', style: TextStyle(fontSize: 15)),
            const SizedBox(width: 6),
            Text(
              L['tipOfDay']!,
              style: const TextStyle(
                color: Color(0xFF3E4829),
                fontWeight: FontWeight.bold,
                fontSize: 12.5,
              ),
            ),
          ]),
          const SizedBox(height: 8),
          Text(tipKey(), style: const TextStyle(fontSize: 16.5, height: 1.8)),
        ],
      ),
    );
  }

  Widget _testCard() {
    final questions = _asList(widget.test['questions']);
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () => Navigator.of(context).push(MaterialPageRoute(
        builder: (_) => TestPage(
          box: widget.box,
          test: widget.test,
          data: widget.data,
        ),
      )),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFFDFBF5),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE4D6B8)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              const Text('🤝', style: TextStyle(fontSize: 15)),
              const SizedBox(width: 6),
              Text(
                L['testTitle']!,
                style: const TextStyle(
                  color: Color(0xFF1F2A44),
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ]),
            const SizedBox(height: 6),
            Text(
              L['testEntry']!,
              style: const TextStyle(fontSize: 13.5, height: 1.8),
            ),
            const SizedBox(height: 6),
            Text('(${questions.length} ' +
                (lang == 'ar' ? 'سؤالاً' : 'questions') +
                ')',
                style: const TextStyle(fontSize: 11.5, color: Color(0xFF33436B))),
          ],
        ),
      ),
    );
  }

  Widget _chips() {
    final cats = widget.data.categories.cast<Map<String, dynamic>>();
    final list = <Widget>[
      ChoiceChip(
        label: Text(L['all']!),
        selected: chip == 'all',
        onSelected: (_) => setState(() => chip = 'all'),
        selectedColor: const Color(0xFF55613A),
        labelStyle: TextStyle(
          color: chip == 'all' ? const Color(0xFFFDFBF5) : const Color(0xFF3E4829),
        ),
      ),
    ];
    for (final c in cats) {
      final label = (lang == 'ar') ? c['ar'] as String : c['en'] as String;
      list.add(ChoiceChip(
        label: Text('${c['icon']} $label'),
        selected: chip == c['id'],
        onSelected: (_) => setState(() => chip = c['id'] as String),
        selectedColor: const Color(0xFF55613A),
        labelStyle: TextStyle(
          color: chip == c['id'] ? const Color(0xFFFDFBF5) : const Color(0xFF3E4829),
        ),
      ));
    }
    return SizedBox(
      height: 44,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: list,
      ),
    );
  }

  Widget _nodeCard(Map<String, dynamic> n) {
    final catIcon = _catIconOf(n);
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: () => Navigator.of(context).push(MaterialPageRoute(
        builder: (_) => NodePage(
          box: widget.box,
          node: n,
          data: widget.data,
        ),
      )),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFFFDFBF5),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFE4D6B8)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '$catIcon ${nodeTitle(n)}',
              style: const TextStyle(fontSize: 15, height: 1.6),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                _badge(_genderLabel(n)),
                const SizedBox(width: 6),
                _badge(_catNameOf(n)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _catIconOf(Map<String, dynamic> n) {
    for (final c in widget.data.categories) {
      final cm = c as Map<String, dynamic>;
      if (cm['id'] == n['category']) return cm['icon'] as String? ?? '📌';
    }
    return '📌';
  }

  String _catNameOf(Map<String, dynamic> n) {
    for (final c in widget.data.categories) {
      final cm = c as Map<String, dynamic>;
      if (cm['id'] == n['category']) {
        return (lang == 'ar' ? cm['ar'] : cm['en']) as String? ?? '';
      }
    }
    return '';
  }

  String _genderLabel(Map<String, dynamic> n) {
    final g = n['gender_target'] as String? ?? 'BOTH';
    if (g == 'MALE') return lang == 'ar' ? 'زوج' : 'Husband';
    if (g == 'FEMALE') return lang == 'ar' ? 'زوجة' : 'Wife';
    return 'BOTH';
  }

  Widget _badge(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: const Color(0xFFF2E8D5),
        borderRadius: BorderRadius.circular(7),
      ),
      child: Text(
        text,
        style: const TextStyle(fontSize: 11, color: Color(0xFF3E4829)),
      ),
    );
  }

  void _openSettings(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => SettingsPage(box: widget.box, data: widget.data),
    ));
  }
}

/* ------------------------------------------------------------------ */
/* Node detail                                                         */
/* ------------------------------------------------------------------ */

class NodePage extends StatelessWidget {
  final Box box;
  final Map<String, dynamic> node;
  final GuidanceData data;
  const NodePage({
    super.key,
    required this.box,
    required this.node,
    required this.data,
  });

  Map<String, String> get L {
    final lang = (box.get('lang') ?? 'ar') as String;
    return LABELS[lang]!;
  }

  TextDirection get dir =>
      ((box.get('lang') ?? 'ar') as String) == 'ar' ? TextDirection.rtl : TextDirection.ltr;

  @override
  Widget build(BuildContext context) {
    final quran = node['quran'] as Map<String, dynamic>? ?? {};
    final hadith = node['hadith'] as Map<String, dynamic>? ?? {};
    final quranText = node['dalil_quran'] as String? ?? '';
    final hadithText = node['dalil_hadith'] as String? ?? '';
    return Directionality(
      textDirection: dir,
      child: Scaffold(
        appBar: AppBar(title: Text(node['situation_title'] as String? ?? '')),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _sec(L['kAction']!),
            _box(
              node['islamic_action'] as String? ?? '',
              const Color(0xFFFDFBF5),
              const Color(0xFFE4D6B8),
            ),
            const SizedBox(height: 14),
            if (quranText.isNotEmpty) ...[
              _sec(L['kQuran']!),
              _box(
                '﴿' + quranText + '﴾\n' + ((quran['ref'] ?? '') as String),
                const Color(0x1455613A),
                const Color(0xFF55613A),
              ),
              const SizedBox(height: 14),
            ],
            if (hadithText.isNotEmpty) ...[
              _sec(L['kHadith']!),
              _box(
                '«' + hadithText + '»\n' + ((hadith['source'] ?? '') as String),
                const Color(0x1AC9A227),
                const Color(0xFFC9A227),
              ),
              const SizedBox(height: 14),
            ],
            _sec(L['kWorldly']!),
            _box(
              node['worldly_impact'] as String? ?? '',
              const Color(0xFFF2E8D5),
              const Color(0xFFE4D6B8),
            ),
            const SizedBox(height: 14),
            _sec(L['kAkhirah']!),
            _box(
              node['afterlife_consequence'] as String? ?? '',
              const Color(0x141F2A44),
              const Color(0xFF1F2A44),
            ),
            const SizedBox(height: 14),
            _sec(L['kNote']!),
            _box(
              '${node['note']}\n${node['disclaimer_ar']}',
              const Color(0x148C3A2B),
              const Color(0xFF8C3A2B),
            ),
            const SizedBox(height: 10),
            Text(
              (quran['ref'] ?? '').toString() +
                  ((quran['link'] ?? '') == '' ? '' : '\n' + (quran['link'] as String)) +
                  (((hadith['link'] ?? '') == '')
                      ? ''
                      : '\n' + (hadith['link'] as String)),
              style: const TextStyle(fontSize: 11.5, color: Color(0xFF33436B)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sec(String t) => Padding(
        padding: const EdgeInsets.only(bottom: 6),
        child: Text(
          t,
          style: const TextStyle(
            fontSize: 12.5,
            fontWeight: FontWeight.bold,
            color: Color(0xFF3E4829),
          ),
        ),
      );

  Widget _box(String text, Color bg, Color border) => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(13),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: border),
        ),
        child: Text(
          text,
          style: const TextStyle(height: 1.9, fontSize: 15),
        ),
      );
}

/* ------------------------------------------------------------------ */
/* Harmony test                                                        */
/* ------------------------------------------------------------------ */

class TestPage extends StatefulWidget {
  final Box box;
  final Map<String, dynamic> test;
  final GuidanceData data;
  const TestPage({
    super.key,
    required this.box,
    required this.test,
    required this.data,
  });
  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  String mode = 'self';
  int stage = 0; // 0 intro, 1 asking (self or A), 2 asking (B), 3 result
  List<int> selfAns = [];
  List<int> aAns = [];
  List<int> bAns = [];

  String get lang => (widget.box.get('lang') ?? 'ar') as String;
  Map<String, String> get L => LABELS[lang]!;

  List<dynamic> get questions => _asList(widget.test['questions']);
  List<dynamic> get scale => _asList(widget.test['answer_scale']);

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: lang == 'ar' ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        appBar: AppBar(title: Text(L['testTitle']!)),
        body: _body(),
      ),
    );
  }

  Widget _body() {
    if (stage == 3) return _result();
    if (stage == 0) return _intro();
    return _question();
  }

  Widget _intro() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          widget.test['modes_note'] as String? ?? '',
          style: const TextStyle(fontSize: 13, height: 1.9, color: Color(0xFF33436B)),
        ),
        const SizedBox(height: 14),
        Row(
          children: [
            Expanded(child: _modeBtn('self', L['self']!)),
            const SizedBox(width: 10),
            Expanded(child: _modeBtn('couple', L['couple']!)),
          ],
        ),
        const SizedBox(height: 18),
        ElevatedButton(
          onPressed: () => setState(() {
            stage = 1;
            selfAns = [];
            aAns = [];
            bAns = [];
          }),
          child: Text(L['goTest']!),
        ),
      ],
    );
  }

  Widget _modeBtn(String val, String label) {
    final active = mode == val;
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        side: BorderSide(
          color: active ? const Color(0xFF55613A) : const Color(0xFFE4D6B8),
          width: 1.5,
        ),
        padding: const EdgeInsets.symmetric(vertical: 14),
      ),
      onPressed: () => setState(() => mode = val),
      child: Text(
        label,
        style: TextStyle(
          color: active ? const Color(0xFF3E4829) : const Color(0xFF26291E),
          fontWeight: active ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }

  List<int> get _currentList =>
      mode == 'self' ? selfAns : (stage == 1 ? aAns : bAns);

  Widget _question() {
    final idx = _currentList.length;
    final q = questions[idx] as Map<String, dynamic>;
    final whoLabel =
        mode == 'couple' ? (stage == 1 ? L['partnerA']! : L['partnerB']!) : '';
    final pct = idx / questions.length;
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        LinearProgressIndicator(value: pct, minHeight: 7, borderRadius: BorderRadius.circular(5)),
        const SizedBox(height: 16),
        Text(
          '$whoLabel ${idx + 1}/${questions.length}',
          style: const TextStyle(fontSize: 12, color: Color(0xFF33436B)),
        ),
        const SizedBox(height: 8),
        Text(
          q['ar'] as String,
          style: const TextStyle(fontSize: 17.5, height: 1.9),
        ),
        const SizedBox(height: 18),
        ...scale.map(_scaleBtn),
        const SizedBox(height: 18),
        Row(
          children: [
            if (_currentList.isNotEmpty)
              TextButton(
                onPressed: () => setState(() => _currentList.removeLast()),
                child: const Text('←'),
              ),
          ],
        ),
      ],
    );
  }

  Widget _scaleBtn(dynamic opt0) {
    final opt = opt0 as Map<String, dynamic>;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 15),
          side: const BorderSide(color: Color(0xFFE4D6B8), width: 1.5),
        ),
        onPressed: () => setState(() {
          _currentList.add((opt['v'] as num).toInt());
          final done = _currentList.length == questions.length;
          if (!done) return;
          if (mode == 'self') {
            stage = 3;
          } else if (stage == 1) {
            stage = 2;
            bAns = [];
          } else {
            stage = 3;
          }
        }),
        child: Text((opt['ar'] ?? '') as String),
      ),
    );
  }

  List<int> _scoreArr() {
    if (mode == 'self') return selfAns;
    if (aAns.length != questions.length || bAns.length != questions.length) {
      return aAns; // shouldn't reach here
    }
    final out = <int>[];
    for (var i = 0; i < aAns.length; i++) {
      out.add(((aAns[i] + bAns[i]) / 2).round());
    }
    return out;
  }

  Widget _result() {
    final arr = mode == 'couple' ? _scoreArr() : selfAns;
    var total = 0;
    final byTheme = <String, int>{};
    for (var i = 0; i < arr.length; i++) {
      total += arr[i];
      final th = (questions[i] as Map<String, dynamic>)['theme'] as String? ?? '';
      byTheme[th] = (byTheme[th] ?? 0) + arr[i];
    }
    final themes = _asList(widget.test['themes']).cast<Map<String, dynamic>>();
    final weakKeys = byTheme.keys.toList()
      ..sort((x, y) => (byTheme[x] ?? 0).compareTo(byTheme[y] ?? 0));
    final bands = _asList(widget.test['bands']).cast<Map<String, dynamic>>();
    Map<String, dynamic> band = bands.last;
    for (final b0 in bands) {
      if (total >= (b0['min'] as num).toInt()) {
        band = b0;
        break;
      }
    }
    final heading = mode == 'self' ? L['score']! : L['avgScore']!;

    final widgets = <Widget>[
      Text(
        '$total / 36',
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 44,
          fontWeight: FontWeight.w800,
          color: Color(0xFF3E4829),
        ),
      ),
      Text(
        heading,
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 13, color: Color(0xFF33436B)),
      ),
      const SizedBox(height: 10),
      Text(
        band['ar'] as String? ?? '',
        style: const TextStyle(fontSize: 15.5, height: 1.8),
      ),
      Text(
        band['nodes_hint'] as String? ?? '',
        style: const TextStyle(fontSize: 12.5, color: Color(0xFF33436B)),
      ),
      const SizedBox(height: 12),
      Text(
        L['weakest']!,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12.5),
      ),
    ];

    for (final key in weakKeys.take(3)) {
      Map<String, dynamic> theme = {
        'id': key,
        'ar': key,
        'nodes': <dynamic>[],
      };
      for (final t0 in themes) {
        if (t0['id'] == key) {
          theme = t0;
          break;
        }
      }
      final nodes = _asList(theme['nodes'].toString());
      final tile = Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: const Color(0xFFF2E8D5),
            borderRadius: BorderRadius.circular(11),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  theme['ar'] as String? ?? key,
                  style: const TextStyle(fontSize: 13.5),
                ),
              ),
              if (nodes.isNotEmpty)
                TextButton(
                  onPressed: () {
                    final first = nodes.first.toString();
                    Map<String, dynamic>? target;
                    for (final n0 in widget.data.nodes) {
                      final n = n0 as Map<String, dynamic>;
                      if (n['id'] == first) {
                        target = n;
                        break;
                      }
                    }
                    if (target == null) return;
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => NodePage(
                        box: widget.box,
                        node: target!,
                        data: widget.data,
                      ),
                    ));
                  },
                  child: Text(L['openNode']!),
                ),
            ],
          ),
        ),
      );
      widgets.add(tile);
    }

    widgets.add(const SizedBox(height: 14));
    widgets.add(ElevatedButton(
      onPressed: () => setState(() {
        stage = 0;
        selfAns = [];
        aAns = [];
        bAns = [];
      }),
      child: Text(L['retake']!),
    ));

    // couple gaps section
    List<Widget> gaps = const [];
    if (mode == 'couple' &&
        aAns.length == questions.length &&
        bAns.length == questions.length) {
      final diff = <int>[];
      for (var i = 0; i < aAns.length; i++) {
        if ((aAns[i] - bAns[i]).abs() >= 2) diff.add(i);
      }
      if (diff.isNotEmpty) {
        gaps = [
          const SizedBox(height: 10),
          Text(
            L['diffTitle']!,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12.5),
          ),
          ...diff.take(4).map((i) {
            final q = questions[i] as Map<String, dynamic>;
            return Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Text(
                '• ${q['ar']}\n   ${L['partnerA']}: ${aAns[i]} · ${L['partnerB']}: ${bAns[i]}',
                style: const TextStyle(fontSize: 13, height: 1.7),
              ),
            );
          }),
        ];
      }
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [...widgets, ...gaps],
    );
  }
}

/* ------------------------------------------------------------------ */
/* Settings                                                            */
/* ------------------------------------------------------------------ */

class SettingsPage extends StatelessWidget {
  final Box box;
  final GuidanceData data;
  const SettingsPage({super.key, required this.box, required this.data});

  String get lang => (box.get('lang') ?? 'ar') as String;
  Map<String, String> get L => LABELS[lang]!;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: lang == 'ar' ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        appBar: AppBar(title: Text(L['settings']!)),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text(
              L['honesty']!,
              style: const TextStyle(fontSize: 13.5, height: 1.9),
            ),
            const SizedBox(height: 8),
            Text(
              data.disclaimerAr,
              style: const TextStyle(fontSize: 12.5, height: 1.9, color: Color(0xFF33436B)),
            ),
            const SizedBox(height: 18),
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 15),
              ),
              onPressed: () {
                box.delete('gender');
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (_) => SplashScreen(box: box),
                ));
              },
              child: Text(L['changeProfile']!),
            ),
            const SizedBox(height: 14),
            Text(
              'المصادر: quran.com · sunnah.com — ${data.nodes.length} عقد · تعمل بلا إنترنت (Hive).',
              style: const TextStyle(fontSize: 12, height: 1.8, color: Color(0xFF33436B)),
            ),
          ],
        ),
      ),
    );
  }
}
