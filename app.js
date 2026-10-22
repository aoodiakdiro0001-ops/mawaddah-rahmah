/* Mawaddah & Rahmah PWA — vanilla JS. No trackers, no accounts. */
(function () {
  'use strict';

  var view = document.getElementById('view');
  var langBtn = document.getElementById('langBtn');
  var setBtn = document.getElementById('setBtn');

  var S = {
    lang: localStorage.getItem('mw_lang') || 'ar',
    gender: localStorage.getItem('mw_gender') || null,
    chip: 'all',
    q: '',
    screen: 'home',
    answers: [],
    mode: 'self',
    couple: { a: [], b: [] },
    stage: 0,
    data: null,
    tips: null,
    test: null,
    node: null
  };

  var L = {
    ar: {
      tagline: 'توعية زوجية على سنن الله في السكن',
      onboardLead: 'توجيه عملي للأزواج والزوجات مستمد من آيات مخرّجة وأحاديث في الصحاح — لا فتوى في القضايا الخاصة.',
      chooseLang: 'اختر لغة الواجهة',
      arOnlyNote: 'المحتوى الشرعي متوفر عربياً في الإصدار الأول؛ ترجمات tr/ur/fr لاحقاً بعد مراجعة عالم.',
      spouse: 'من أنت؟',
      husband: 'زوج',
      husbandSub: 'أريد توجيهات للزوج',
      wife: 'زوجة',
      wifeSub: 'أريد توجيهات للزوجة',
      bothNote: 'ستحصل على التوجيهات الموجهة لك + العقد المشتركة (BOTH).',
      start: 'ابدأ',
      tipOfDay: 'نصيحة اليوم',
      stats: 'عداد المحتوى',
      nodes: 'حالة',
      cats: 'فئة',
      countries: null,
      catsAll: 'الكل',
      searchPh: 'ماذا أفعل إذا…؟ (ابحث في الحالات)',
      testTitle: 'اختبار التناغم الزوجي',
      testEntry: '12 سؤالاً — أجب أنت أو بينكما (تبادل الهاتف) لمعرفة أقوى وأضعف المناطق على ضوء السُنّة.',
      goTest: 'ابدأ الاختبار',
      self: 'ذاتي',
      couple: 'بين الطرفين',
      partnerA: 'الطرف الأول',
      partnerB: 'الطرف الثاني',
      score: 'نتيجتك',
      coupleScore: 'متوسط الطرفين',
      weakest: 'أضعف المناطق',
      openNode: 'افتح التوجيه',
      again: 'أعد الاختبار',
      home: 'الرئيسية',
      settings: 'الإعدادات',
      about: 'عن التطبيق',
      changeProf: 'تغيير النوع واللغة',
      version: 'الإصدار',
      notif: 'الإشعارات',
      notifBtn: 'تفعيل إشعارات نصيحة اليوم (تجريبي)',
      notifNoCfg: 'إعداد FCM غير مفعّل بعد — الدليل: docs/firebase-setup.md. التطبيق يعمل كلياً بلا إنترنت وبدون هذه الميزة.',
      notifDenied: 'الإذن مرفوض؛ يمكن تغييره من إعدادات هذا الموقع في المتصفح.',
      notifOk: 'تم التفعيل — رمز جهازك:',
      notifCopy: 'انسخ الرمز',
      notifCopied: 'نُسخ الرمز.',
      notifWait: 'جارٍ التفعيل…',
      notifErr: 'تعذّر التفعيل: ',
      notifHint: 'الرمز يُسجَّل في جهازك فقط. الإرسال الفعلي «نصيحة اليوم» يأتي في v1.2 عبر خادم مجاني — لا إرسال من هذه الصفحة.',
      disclaimer: 'تنبيه أمانة: المحتوى توعية عامة وليس فتوى. آيات مخرّجة بحرفيتها وأحاديث صحاح بتخريجها. لكل حالة خاصة استشر جهة تبليغ شرعي معتمدة، ويُراجع المحتوى عالماً شرعياً.',
      sources: 'مصادر النصوص',
      quranLink: 'الآية',
      hadithLink: 'الحديث',
      actionK: 'التصرف العملي (خطوات)',
      quranK: 'دليل من القرآن',
      hadithK: 'دليل من السنة',
      worldlyK: 'في الدنيا — أثر البيت',
      akhirahK: 'في الآخرة',
      noteK: 'ملاحظة',
      disclaimerK: 'تنبيه',
      noData: 'لا نتائج مطابقة — جرّب كلمة أخرى أو فئة أوسع.',
      privacy: 'الخصوصية',
      privacyNote: 'لا حسابات ولا تتبّع: إجابات الاختبار تُحفظ في جهازك فقط.',
      repo: 'المستودع المفتوح',
      offline: 'يعمل بلا إنترنت بعد أول فتح.',
      diffTitle: 'فروق كبيرة تستحق حواراً',
      ok: 'أكمل'
    },
    en: {
      tagline: 'Islamic marital guidance built on cited Qur\u2019an & authentic hadith',
      onboardLead: 'Practical guidance for husbands and wives drawn from cited Qur\u2019anic verses and authentic hadith collections \u2015 not fatwas for specific cases.',
      chooseLang: 'Choose interface language',
      arOnlyNote: 'The guidance content itself is Arabic-only in v1; tr/ur/fr translations come later (after scholar review).',
      spouse: 'Who are you?',
      husband: 'Husband',
      husbandSub: 'Guidance aimed at the husband',
      wife: 'Wife',
      wifeSub: 'Guidance aimed at the wife',
      bothNote: 'You will get nodes aimed at you + shared (BOTH) nodes.',
      start: 'Start',
      tipOfDay: 'Tip of the day',
      stats: 'Content stats',
      nodes: 'cases',
      cats: 'categories',
      catsAll: 'All',
      searchPh: 'What do I do if\u2026? (search cases)',
      testTitle: 'Couple Harmony Test',
      testEntry: '12 questions \u2014 answer alone or pass the phone to compare both partners.',
      goTest: 'Start the test',
      self: 'Self',
      couple: 'Couple mode',
      partnerA: 'Partner 1',
      partnerB: 'Partner 2',
      score: 'Your score',
      coupleScore: 'Both partners average',
      weakest: 'Weakest areas',
      openNode: 'Open guidance',
      again: 'Retake',
      home: 'Home',
      settings: 'Settings',
      about: 'About',
      changeProf: 'Change gender & language',
      version: 'Version',
      notif: 'Notifications',
      notifBtn: 'Enable daily-tip notifications (beta)',
      notifNoCfg: 'FCM config not set yet — guide: docs/firebase-setup.md. The app works fully offline without this.',
      notifDenied: 'Permission denied; change it from this site\u2019s settings in your browser.',
      notifOk: 'Enabled \u2014 your device token:',
      notifCopy: 'Copy token',
      notifCopied: 'Token copied.',
      notifWait: 'Enabling\u2026',
      notifErr: 'Enable failed: ',
      notifHint: 'Token stays on this device only. Actual daily-tip sending arrives in v1.2 via a free server \u2014 nothing is sent from this page.',
      disclaimer: 'Honesty notice: general education, not fatwa. Qur\u2019an quoted verbatim; hadith cited from the authentic collections with references. For private cases consult a qualified scholar.',
      sources: 'Text sources',
      quranLink: 'The verse',
      hadithLink: 'Hadith',
      actionK: 'Practical steps',
      quranK: 'Evidence from Qur\u2019an',
      hadithK: 'Evidence from Sunnah',
      worldlyK: 'In this world \u2014 impact at home',
      akhirahK: 'In the hereafter',
      noteK: 'Note',
      disclaimerK: 'Notice',
      noData: 'No matches \u2014 try another keyword or a wider category.',
      privacy: 'Privacy',
      privacyNote: 'No accounts, no tracking: your test answers stay on your device only.',
      repo: 'Open-source repository',
      offline: 'Works offline after first open.',
      diffTitle: 'Large gaps worth discussing',
      ok: 'Done'
    }
  };

  function T(k) { return L[S.lang][k]; }
  function esc(s) {
    return String(s == null ? '' : s)
      .replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;')
      .replace(/"/g, '&quot;');
  }
  function save() {
    localStorage.setItem('mw_lang', S.lang);
    localStorage.setItem('mw_gender', S.gender || '');
  }
  function setLang(l) {
    S.lang = l;
    document.documentElement.lang = l;
    document.documentElement.dir = (l === 'ar') ? 'rtl' : 'ltr';
    langBtn.textContent = (l === 'ar') ? 'EN' : 'AR';
    save();
    render();
  }

  function imgOk(n) {
    var g = n.gender_target;
    if (g === 'BOTH') return true;
    return g === S.gender;
  }
  function filterNodes() {
    var q = S.q.trim();
    var out = [];
    var nodes = (S.data && S.data.nodes) || [];
    for (var i = 0; i < nodes.length; i++) {
      var n = nodes[i];
      if (!imgOk(n)) continue;
      if (S.chip !== 'all' && n.category !== S.chip) continue;
      if (q) {
        var hay = (n.situation_title + ' ' + n.islamic_action + ' ' + n.dalil_quran + ' ' + n.dalil_hadith).toLowerCase();
        if (hay.indexOf(q.toLowerCase()) === -1) continue;
      }
      out.push(n);
    }
    return out;
  }

  function dayOY() {
    var d = new Date();
    var start = new Date(d.getFullYear(), 0, 0);
    return Math.floor((d - start) / 86400000);
  }
  function tipOfDay() {
    if (!S.tips || !S.tips.length) return '';
    var gi = S.gender === 'MALE' ? 1 : 3;
    return S.tips[(dayOY() + gi) % S.tips.length];
  }
  function catName(id) {
    var cats = (S.data && S.data.categories) || [];
    for (var i = 0; i < cats.length; i++) {
      if (cats[i].id === id) return (S.lang === 'ar') ? cats[i].ar : cats[i].en + ' \u00b7 ' + cats[i].icon;
    }
    return id;
  }
  function catIcon(id) {
    var cats = (S.data && S.data.categories) || [];
    for (var i = 0; i < cats.length; i++) if (cats[i].id === id) return cats[i].icon;
    return '📌';
  }

  /* ---------- screens ---------- */

  function renderOnboarding() {
    view.innerHTML =
      '<div class="ob">' +
      '<div class="card"><h2>مودة ورحمة</h2><p class="lead">' + esc(T('onboardLead')) + '</p>' +
      '<p class="lead" style="font-size:12.5px">' + esc(T('arOnlyNote')) + '</p>' +
      '<div class="grid">' +
      '<div class="opt lang ' + (S.lang === 'ar' ? 'active' : '') + '" data-l="ar"><b>العربية</b><span>مباشر وافتراضي</span></div>' +
      '<div class="opt lang ' + (S.lang === 'en' ? 'active' : '') + '" data-l="en"><b>English</b><span>UI labels only</span></div>' +
      '</div></div>' +
      '<div class="card"><h2>' + esc(T('spouse')) + '</h2>' +
      '<div class="grid">' +
      '<div class="opt gen ' + (S.gender === 'MALE' ? 'active' : '') + '" data-g="MALE"><b>' + T('husband') + ' 👨</b><span>' + esc(T('husbandSub')) + '</span></div>' +
      '<div class="opt gen ' + (S.gender === 'FEMALE' ? 'active' : '') + '" data-g="FEMALE"><b>' + T('wife') + ' 👩</b><span>' + esc(T('wifeSub')) + '</span></div>' +
      '</div>' +
      '<p class="lead" style="font-size:12px">' + esc(T('bothNote')) + '</p>' +
      '<button class="go" id="goBtn" ' + (S.gender ? '' : 'disabled') + '>' + esc(T('start')) + ' ﷽</button>' +
      '</div></div>';
    var opts = view.querySelectorAll('.opt');
    for (var i = 0; i < opts.length; i++) {
      opts[i].addEventListener('click', function (e) {
        var el = e.currentTarget;
        if (el.dataset.l) { setLang(el.dataset.l); }
        else { S.gender = el.dataset.g; save(); renderOnboarding(); }
      });
    }
    document.getElementById('goBtn').addEventListener('click', function () { save(); render(); });
  }

  function nodeCardHtml(n) {
    var glabel = (n.gender_target === 'MALE') ? T('husband') : (n.gender_target === 'FEMALE') ? T('wife') : 'BOTH';
    return '<div class="node-card" data-id="' + esc(n.id) + '">' +
      '<h3>' + catIcon(n.category) + ' ' + esc(n.situation_title) + '</h3>' +
      '<div class="mrow"><span class="nbad g">' + esc(glabel) + '</span>' +
      '<span class="nbad">' + esc(catName(n.category)) + '</span></div>' +
      '</div>';
  }

  function renderHome() {
    var nodes = filterNodes();
    var cats = S.data.categories;
    var chips = '<div class="chips"><button class="chip ' + (S.chip === 'all' ? 'active' : '') + '" data-c="all">' + esc(T('catsAll')) + ' ✦</button>';
    for (var i = 0; i < cats.length; i++) {
      chips += '<button class="chip ' + (S.chip === cats[i].id ? 'active' : '') + '" data-c="' + esc(cats[i].id) + '">' + esc(cats[i].icon + ' ' + (S.lang === 'ar' ? cats[i].ar : cats[i].en)) + '</button>';
    }
    chips += '</div>';

    var tip = tipOfDay();
    var list = '';
    if (!nodes.length) list = '<div class="empty">' + esc(T('noData')) + '</div>';
    for (var j = 0; j < nodes.length; j++) list += nodeCardHtml(nodes[j]);

    view.innerHTML =
      '<div class="card tip-card"><div class="tip-kicker">☀️ ' + esc(T('tipOfDay')) + '</div><div class="tip-text">' + esc(tip.ar) + '</div></div>' +
      '<div class="stat-row">' +
      '<div class="stat"><b>' + S.data.nodes.length + '</b><span>' + esc(T('nodes')) + '</span></div>' +
      '<div class="stat"><b>' + S.tips.length + '</b><span>نصيحة/يوم</span></div>' +
      '<div class="stat"><b>' + S.test.questions.length + '</b><span>سؤال تناغم</span></div>' +
      '</div>' +
      '<div class="card" style="border-inline-start:5px solid var(--navy)"><div class="tip-kicker">🤝 ' + esc(T('testTitle')) + '</div>' +
      '<div class="tip-text" style="font-size:14px">' + esc(T('testEntry')) + '</div>' +
      '<div class="links" style="margin-top:10px"><a href="#" id="goTest" style="background:var(--olive)">' + esc(T('goTest')) + ' →</a></div></div>' +
      '<div class="search-box"><span class="si">🔍</span><input id="qIn" placeholder="' + esc(T('searchPh')) + '" value="' + esc(S.q) + '"></div>' +
      chips + list +
      '<footer><div class="fine">✦ ' + esc(T('offline')) + ' ✦ ' + esc(T('privacyNote')) + '</div></footer>';

    var chipEls = view.querySelectorAll('.chip');
    for (var c = 0; c < chipEls.length; c++) {
      chipEls[c].addEventListener('click', function (e) { S.chip = e.currentTarget.dataset.c; render(); });
    }
    var cards = view.querySelectorAll('.node-card');
    for (var k = 0; k < cards.length; k++) {
      cards[k].addEventListener('click', function (e) { openNode(e.currentTarget.dataset.id); });
    }
    var qIn = document.getElementById('qIn');
    qIn.addEventListener('input', function (e) {
      S.q = e.target.value;
      var keep = qIn;
      renderHomeSoft();
      document.getElementById('qIn').focus();
      document.getElementById('qIn').value = keep.value;
      document.getElementById('qIn').setSelectionRange(keep.value.length, keep.value.length);
    });
    var gt = document.getElementById('goTest');
    if (gt) gt.addEventListener('click', function (e) { e.preventDefault(); S.stage = 0; S.answers = []; S.screen = 'test'; render(); });
  }

  function renderHomeSoft() {
    // re-render list only, keeping input focus state simple
    var nodes = filterNodes();
    var qIn = document.getElementById('qIn');
    var val = qIn ? qIn.value : S.q;
    var list = '';
    if (!nodes.length) list = '<div class="empty">' + esc(T('noData')) + '</div>';
    for (var j = 0; j < nodes.length; j++) list += nodeCardHtml(nodes[j]);
    var chips = view.querySelectorAll('.chips');
    var listWrap = document.createElement('div');
    listWrap.innerHTML = list;
    var old = document.querySelectorAll('.node-card, .empty');
    for (var i = 0; i < old.length; i++) old[i].remove();
    view.appendChild(listWrap);
    view.insertBefore(listWrap, chips.nextSibling);
    var cards = view.querySelectorAll('.node-card');
    for (var k = 0; k < cards.length; k++) {
      cards[k].addEventListener('click', function (e) { openNode(e.currentTarget.dataset.id); });
    }
    var q2 = document.getElementById('qIn');
    if (q2) {
      q2.value = val;
      q2.addEventListener('input', function (e) { S.q = e.target.value; debounceSoft(); });
    }
  }
  var softTimer = null;
  function debounceSoft() {
    if (softTimer) clearTimeout(softTimer);
    softTimer = setTimeout(function () { renderHomeSoft(); }, 180);
  }

  function openNode(id) {
    var nodes = S.data.nodes;
    for (var i = 0; i < nodes.length; i++) if (nodes[i].id === id) { S.node = nodes[i]; break; }
    var n = S.node;
    if (!n) return;
    var glabel = (n.gender_target === 'MALE') ? T('husband') : (n.gender_target === 'FEMALE') ? T('wife') : 'BOTH';
    var q = n.quran || { text: '', ref: '', link: '' };
    var h = n.hadith || { text: '', source: '', link: '' };
    var html =
      '<div class="sheet" id="sheet"><div class="inner">' +
      '<div class="closebar"><b>' + esc(glabel) + ' · ' + esc(catName(n.category)) + '</b><button id="closeBtn">✕</button></div>' +
      '<h2>' + esc(n.situation_title) + '</h2>' +
      '<div class="engl">' + esc(n.situation_title_en || '') + '</div>' +
      '<div class="sec-kicker">👣 ' + esc(T('actionK')) + '</div>' +
      '<div class="action">' + esc(n.islamic_action) + '</div>';
    if (q.text) {
      html += '<div class="sec-kicker">📖 ' + esc(T('quranK')) + '</div>' +
        '<div class="building q">﴿' + esc(q.text) + '﴾' +
        '<span class="src">' + esc(q.ref) + '</span></div>';
    }
    if (h.text) {
      html += '<div class="sec-kicker">🕌 ' + esc(T('hadithK')) + '</div>' +
        '<div class="building h">«' + esc(h.text) + '»' +
        '<span class="src">' + esc(h.source) + '</span></div>';
    }
    html += '<div class="sec-kicker">🌍 ' + esc(T('worldlyK')) + '</div>' +
      '<div class="building w">' + esc(n.worldly_impact) + '</div>';
    html += '<div class="sec-kicker">🕊️ ' + esc(T('akhirahK')) + '</div>' +
      '<div class="building a">' + esc(n.afterlife_consequence) + '</div>';
    if (n.note) html += '<div class="sec-kicker">🧭 ' + esc(T('noteK')) + '</div>' +
      '<div class="mnote">' + esc(n.note) + '</div>';
    html += '<div class="sec-kicker">⚠️ ' + esc(T('disclaimerK')) + '</div>' +
      '<div class="mnote" style="color:var(--olive-dark); border-color:rgba(85,97,58,.5); background:rgba(85,97,58,.06)">' + esc(n.disclaimer_ar) + '</div>';
    html += '<div class="links">';
    if (q.link) html += '<a target="_blank" rel="noopener" href="' + esc(q.link) + '">' + esc(T('quranLink')) + ' ← ' + esc(q.ref) + '</a>';
    if (h.link) html += '<a target="_blank" rel="noopener" href="' + esc(h.link) + '">' + esc(T('hadithLink')) + ' ← ' + esc(h.source) + '</a>';
    html += '</div></div></div>';

    var wrap = document.createElement('div');
    wrap.innerHTML = html;
    document.body.appendChild(wrap.firstElementChild);
    document.getElementById('closeBtn').addEventListener('click', closeSheet);
    document.getElementById('sheet').addEventListener('click', function (e) {
      if (e.target.id === 'sheet') closeSheet();
    });
  }
  function closeSheet() {
    var el = document.getElementById('sheet');
    if (el) el.remove();
  }

  /* ---------- harmony test ---------- */

  var SCALE = [{ v: 3 }, { v: 2 }, { v: 1 }, { v: 0 }];

  function scaleLabels() {
    var labels = [];
    if (S.lang === 'ar') labels = ['كثيراً', 'أحياناً', 'نادراً', 'لا أبداً'];
    else labels = ['Often', 'Sometimes', 'Rarely', 'Never'];
    return labels;
  }

  function renderTest() {
    var modeHtml =
      '<div class="card"><div class="tip-kicker">🤝 ' + esc(T('testTitle')) + '</div>' +
      '<div class="tip-text" style="font-size:13.5px">' + esc(T('testEntry')) + '</div>' +
      '<div class="mode-row">' +
      '<button id="mSelf" class="' + (S.mode === 'self' ? 'active' : '') + '">' + esc(T('self')) + '</button>' +
      '<button id="mCouple" class="' + (S.mode === 'couple' ? 'active' : '') + '">' + esc(T('couple')) + '</button>' +
      '</div></div>';
    if (S.stage === 0) {
      view.innerHTML = modeHtml +
        '<div class="card" style="text-align:center"><p style="font-size:14.5px;line-height:2">' +
        (S.mode === 'couple' ? esc(T('partnerA')) + ' — ' : '') + esc(S.lang === 'ar' ? 'جاهز؟ سؤال من 12' : 'Ready? 1 of 12 — you chose ' + S.mode) +
        '</p><div class="links" style="justify-content:center">' +
        '<a href="#" id="startTest" style="background:var(--olive)">' + esc(S.lang === 'ar' ? 'ابدأ' : 'Start') + ' →</a></div></div>' +
        '<div class="links" style="justify-content:center"><a href="#" id="backHome">' + '← ' + esc(T('home')) + '</a></div>';
    } else if (S.stage === 1 || S.stage === 2) {
      var arr = (S.mode === 'couple') ? (S.stage === 1 ? S.couple.a : S.couple.b) : S.answers;
      var q = S.test.questions[arr.length];
      var pct = Math.round((arr.length / S.test.questions.length) * 100);
      var labels = scaleLabels();
      var btns = '';
      for (var i = 0; i < labels.length; i++) btns += '<button data-v="' + SCALE[i].v + '">' + esc(labels[i]) + '</button>';
      var who = S.mode === 'couple' ? (S.stage === 1 ? T('partnerA') : T('partnerB')) + ' — ' : '';
      view.innerHTML = modeHtml +
        '<div class="card"><div class="progress"><i style="width:' + pct + '%"></i></div>' +
        '<div class="qhead"><span class="qi">' + esc(who) + (arr.length + 1) + ' / ' + S.test.questions.length + '</span></div>' +
        '<div class="qtext">' + esc(q.ar) + '</div>' +
        '<div class="scale">' + btns + '</div></div>' +
        '<div class="links" style="justify-content:center"><a href="#" id="backHome">← ' + esc(T('home')) + '</a></div>';
    } else {
      renderResult();
      return;
    }
    var ms = document.getElementById('mSelf');
    var mc = document.getElementById('mCouple');
    if (ms) ms.addEventListener('click', function () { S.mode = 'self'; S.stage = 0; S.answers = []; render(); });
    if (mc) mc.addEventListener('click', function () { S.mode = 'couple'; S.stage = 0; S.couple = { a: [], b: [] }; render(); });
    var st = document.getElementById('startTest');
    if (st) st.addEventListener('click', function (e) {
      e.preventDefault();
      S.stage = S.mode === 'self' ? 1 : 1; S.answers = [];
      if (S.mode === 'couple') { S.couple = { a: [], b: [] }; }
      render();
    });
    var sBtns = view.querySelectorAll('.scale button');
    for (var b = 0; b < sBtns.length; b++) {
      sBtns[b].addEventListener('click', function (e) { answer(parseInt(e.currentTarget.dataset.v, 10)); });
    }
    var bh = document.getElementById('backHome');
    if (bh) bh.addEventListener('click', function (e) { e.preventDefault(); goHome(); });
  }

  function answer(v) {
    if (S.mode === 'self') {
      S.answers.push(v);
      if (S.answers.length === S.test.questions.length) { S.stage = 3; persistResult(S.answers); saveLast(S.answers, null); }
      renderTest();
    } else {
      var arr = (S.stage === 1) ? S.couple.a : S.couple.b;
      arr.push(v);
      if (arr.length === S.test.questions.length) {
        if (S.stage === 1) { S.stage = 2; S.couple.b = []; }
        else { S.stage = 3; persistResult(null); saveLast(null, [S.couple.a, S.couple.b]); }
      }
      renderTest();
    }
  }

  function saveLast(a, pair) {
    try {
      localStorage.setItem('mw_last', JSON.stringify({ date: Date.now(), self: a, pair: pair }));
    } catch (e) { }
  }

  function scaleAr(v) {
    return v === 3 ? 'كثيراً' : v === 2 ? 'أحياناً' : v === 1 ? 'نادراً' : 'لا أبداً';
  }

  function bandFor(score) {
    var bands = S.test.bands;
    for (var i = 0; i < bands.length; i++) if (score >= bands[i].min) return bands[i];
    return bands[bands.length - 1];
  }

  function themeName(id) {
    var themes = S.test.themes;
    for (var i = 0; i < themes.length; i++) if (themes[i].id === id) return themes[i];
    return { id: id, ar: id, nodes: [] };
  }

  function analyze(arr) {
    var total = 0;
    var byTheme = {};
    for (var i = 0; i < arr.length; i++) {
      total += arr[i];
      var th = S.test.questions[i].theme;
      if (!byTheme[th]) byTheme[th] = 0;
      byTheme[th] += arr[i];
    }
    var weak = [];
    for (var k in byTheme) weak.push([k, byTheme[k]]);
    weak.sort(function (x, y) { return x[1] - y[1]; });
    return { total: total, weak: weak };
  }

  function renderResultBase(score, weak, opts) {
    var band = bandFor(score);
    var html = '<div class="card"><div class="score-wrap">' +
      '<div class="big">' + score + '<span style="font-size:16px;color:var(--navy-soft)">/36</span></div>' +
      '<div class="small">' + esc(opts ? opts.title : T('score')) + '</div></div>' +
      '<div class="band">' + esc(band.ar) + '<br><span style="font-size:12.5px;color:var(--navy-soft)">' + esc(band.nodes_hint) + '</span></div>' +
      '<div class="sec-kicker">' + esc(T('weakest')) + '</div>' +
      '<div class="weak-list">';
    for (var i = 0; i < Math.min(3, weak.length); i++) {
      var th = themeName(weak[i][0]);
      var nid = (th.nodes && th.nodes[0]) || null;
      var btn = nid ? '<button data-id="' + esc(nid) + '">' + esc(T('openNode')) + '</button>' : '';
      html += '<div class="weak-item"><span>' + esc(th.ar) + '</span>' + btn + '</div>';
    }
    html += '</div><div class="links" style="justify-content:center">' +
      '<a href="#" id="retake">' + '↺ ' + esc(T('again')) + '</a> ' +
      '<a href="#" id="backHome2">← ' + esc(T('home')) + '</a></div></div>';
    view.innerHTML = html;
    var wBtns = view.querySelectorAll('.weak-item button');
    for (var w = 0; w < wBtns.length; w++) {
      wBtns[w].addEventListener('click', function (e) {
        S.screen = 'home';
        render();
        openNode(e.currentTarget.dataset.id);
      });
    }
    document.getElementById('retake').addEventListener('click', function (e) {
      e.preventDefault();
      S.stage = 0; S.answers = []; S.couple = { a: [], b: [] }; S.screen = 'test'; render();
    });
    document.getElementById('backHome2').addEventListener('click', function (e) { e.preventDefault(); goHome(); });
  }

  function renderResult() {
    if (S.mode === 'self') {
      var a = analyze(S.answers);
      renderResultBase(a.total, a.weak, { title: T('score') });
    } else {
      var totalA = 0, totalB = 0;
      var diffs = [];
      for (var i = 0; i < S.couple.a.length; i++) {
        totalA += S.couple.a[i];
        totalB += S.couple.b[i];
        if (Math.abs(S.couple.a[i] - S.couple.b[i]) >= 2) {
          diffs.push(i);
        }
      }
      var avg = Math.round((totalA + totalB) / 2);
      var arr = [];
      for (var j = 0; j < S.couple.a.length; j++) arr.push(Math.round((S.couple.a[j] + S.couple.b[j]) / 2));
      var an = analyze(arr);
      renderResultBase(avg, an.weak, { title: T('coupleScore') + ' (' + T('partnerA') + ' ' + totalA + ' · ' + T('partnerB') + ' ' + totalB + ')' });
      if (diffs.length) {
        var list = '<div class="card"><div class="tip-kicker">🧭 ' + esc(T('diffTitle')) + '</div><div class="tip-text" style="font-size:14px">';
        for (var d = 0; d < Math.min(4, diffs.length); d++) {
          var q = S.test.questions[diffs[d]];
          list += '• ' + esc(q.ar) + ' — <span style="color:var(--navy-soft)">' + esc(T('partnerA')) + ': ' + scaleAr(S.couple.a[diffs[d]]) + ' / ' + esc(T('partnerB')) + ': ' + scaleAr(S.couple.b[diffs[d]]) + '</span><br>';
        }
        list += '</div></div><div class="links" style="justify-content:center"><a href="#" id="backHome3">← ' + esc(T('home')) + '</a></div>';
        var node = document.createElement('div');
        node.innerHTML = list;
        view.appendChild(node);
        document.getElementById('backHome3').addEventListener('click', function (e) { e.preventDefault(); goHome(); });
      }
    }
  }

  function persistResult(selfArr) {
    /* placeholder for future Supabase sync; v1 keeps results local only */
  }

  /* ---------- settings ---------- */

  function renderSettings() {
    var n = S.data.nodes.length;
    view.innerHTML =
      '<div class="card"><div class="tip-kicker">⚙️ ' + esc(T('settings')) + '</div>' +
      '<div class="mode-row">' +
      '<button id="chgProf">' + esc(T('changeProf')) + '</button>' +
      '</div></div>' +
      '<div class="card"><div class="tip-kicker">🔔 ' + esc(T('notif')) + '</div>' +
      '<div class="mode-row"><button id="fcmBtn">' + esc(T('notifBtn')) + '</button></div>' +
      '<div id="fcmOut" class="tip-text" style="font-size:12px;margin-top:8px"></div>' +
      '<div class="tip-text" style="font-size:11px;color:var(--navy-soft)">' + esc(T('notifHint')) + '</div></div>' +
      '<div class="card"><div class="tip-kicker">🧾 ' + esc(T('about')) + '</div>' +
      '<div class="tip-text" style="font-size:13.5px">' + esc(T('disclaimer')) + '</div>' +
      '<div class="tip-text" style="font-size:12px;margin-top:8px">📖 ' + esc(S.data.sources_note_ar || '') + '</div>' +
      '<div class="links" style="margin-top:10px">' +
      '<a target="_blank" rel="noopener" href="https://quran.com">quran.com</a>' +
      '<a target="_blank" rel="noopener" href="https://sunnah.com">sunnah.com</a>' +
      '<a target="_blank" rel="noopener" href="https://github.com/aoodiakdiro0001-ops/mawaddah-rahmah">' + esc(T('repo')) + '</a>' +
      '<a href="privacy.html">🔒 ' + esc(T('privacy')) + '</a>' +
      '</div></div>' +
      '<div class="card"><div class="tip-text" style="font-size:12px;color:var(--navy-soft)">' +
      esc(T('version')) + ': v1.1.0 — ' + n + ' ' + esc(T('nodes')) + ' · ' + S.tips.length + ' tips · ' + S.test.questions.length + ' Q</div></div>';
    document.getElementById('chgProf').addEventListener('click', function () {
      S.gender = null; S.screen = 'home'; save(); renderOnboarding();
    });
    document.getElementById('fcmBtn').addEventListener('click', function () {
      enableFcm(document.getElementById('fcmOut'));
    });
  }

  /* ---------- notifications (FCM v1.1 — optional, device-local token) ---------- */

  function loadScriptOnce(src) {
    return new Promise(function (res, rej) {
      var s = document.createElement('script');
      s.src = src;
      s.onload = function () { res(true); };
      s.onerror = function () { rej(new Error('load failed: ' + src)); };
      document.head.appendChild(s);
    });
  }

  function enableFcm(out) {
    var cfg = window.MW_FIREBASE_CONFIG || null;
    if (!cfg || !cfg.apiKey) {
      out.textContent = '⚠️ ' + T('notifNoCfg');
      return;
    }
    if (!('Notification' in window) || !('serviceWorker' in navigator)) {
      out.textContent = '⚠️ ' + T('notifErr') + 'Notification/SW API';
      return;
    }
    out.textContent = T('notifWait');
    Notification.requestPermission().then(function (p) {
      if (p !== 'granted') {
        out.textContent = '⚠️ ' + T('notifDenied');
        return;
      }
      loadScriptOnce('https://www.gstatic.com/firebasejs/10.14.1/firebase-app-compat.js')
        .then(function () {
          return loadScriptOnce('https://www.gstatic.com/firebasejs/10.14.1/firebase-messaging-compat.js');
        })
        .then(function () {
          try { firebase.initializeApp(cfg); } catch (e) { /* dup init fine */ }
          return navigator.serviceWorker.register('firebase-messaging-sw.js',
            { scope: './fcmscope/' }).then(function (reg) {
              return firebase.messaging().getToken({
                serviceWorkerRegistration: reg,
                vapidKey: cfg.vapidKey || undefined
              });
            });
        })
        .then(function (token) {
          if (!token) throw new Error('empty token');
          try { localStorage.setItem('mw_fcm_token', token); } catch (e) { /* quiet */ }
          out.textContent = T('notifOk');
          var t = document.createElement('div');
          t.className = 'tip-text';
          t.style.marginTop = '6px';
          t.style.fontSize = '11px';
          t.style.wordBreak = 'break-all';
          t.textContent = token;
          var cp = document.createElement('button');
          cp.textContent = T('notifCopy');
          cp.style.marginTop = '6px';
          cp.addEventListener('click', function () {
            if (navigator.clipboard && navigator.clipboard.writeText) {
              navigator.clipboard.writeText(token).then(function () {
                out.textContent = T('notifCopied');
              });
            } else {
              out.textContent = token;
            }
          });
          out.parentNode.appendChild(t);
          out.parentNode.appendChild(cp);
        })
        .catch(function (e) {
          out.textContent = '⚠️ ' + T('notifErr') + e.message;
        });
    });
  }

  function goHome() {
    S.screen = 'home';
    S.answers = [];
    S.couple = { a: [], b: [] };
    S.stage = 0;
    render();
  }

  /* ---------- boot ---------- */

  function render() {
    closeSheet();
    if (!S.gender) { renderOnboarding(); return; }
    if (S.screen === 'test') renderTest();
    else renderHome();
  }

  langBtn.addEventListener('click', function () { setLang(S.lang === 'ar' ? 'en' : 'ar'); });
  setBtn.addEventListener('click', function () { renderSettings(); });

  Promise.all([
    fetch('data/guidance.json').then(function (r) { return r.json(); }),
    fetch('data/tips.json').then(function (r) { return r.json(); }),
    fetch('data/harmony.json').then(function (r) { return r.json(); })
  ]).then(function (res) {
    S.data = res[0];
    S.tips = res[1].tips;
    S.test = res[2];
    setLang(S.lang);
  }).catch(function (err) {
    console.error(err);
  });
})();
