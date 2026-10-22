# -*- coding: utf-8 -*-
"""Honest source-text audit for Mawaddah & Rahmah.

Quran : verbatim check against quran.com API v4 (text_uthmani). Word-level
        LCS alignment tolerates Uthmani/imlaa'i orthography at letter level;
        the goal is EXACT raw substring agreement with the API text.
Hadith: presence check against the sunnah.com reference page. Tanks:
        r.jina.ai proxy first, then a Wayback Machine snapshot of the exact
        page (div.arabic_hadith_full) used verbatim when wording differs.

usage:
  python3 verify_sources.py -c          report only (exit 1 on hard fail)
  python3 verify_sources.py -c --fix    patch make_content.py with exact
                                        fetched originals (re-run
                                        make_content.py, then re-verify).
"""
import html
import json
import re
import subprocess
import sys
import unicodedata

DATA = 'data/guidance.json'
SRC = 'make_content.py'

# combining marks, tatweel, waqf signs, bidi controls — WITHOUT U+0670 or hamza
DIAC = re.compile('[\u0610-\u061A\u0640\u064B-\u065F\u06D6-\u06ED\u200B-\u200F]')
PUNCT = re.compile("[\u060C\u061B\u061F\u06D4.,;:!?()\\[\\]{}«»\u2018\u2019"
                   "\u201C\u201D\\-\u2013\u2014\u2026•|\uFD3E\uFD3F'\"]")

# manually resolved fixes (validated against the archived reference page):
OVERRIDE_H = {
    # bukhari:6241 page text is the "استئذان من أجل البصر" story, not the
    # "الاستئذان ثلاث" wording that was mistakenly placed here. New text is
    # taken verbatim from the June-2026 archived sunnah.com/bukhari:6241 div.
    'privacy-knock-entry':
        'لَوْ أَعْلَمُ أَنَّكَ تَنْظُرُ لَطَعَنْتُ بِهِ فِي عَيْنِكَ، إِنَّمَا '
        'جُعِلَ الاِسْتِئْذَانُ مِنْ أَجْلِ الْبَصَرِ.',
}


def fetch(url, timeout=90):
    out = subprocess.run(['curl', '-sL', '--max-time', str(timeout), '-A',
                          'Mozilla/5.0 (compatible; MawaddahAudit/1.0)', url],
                         capture_output=True)
    txt = out.stdout.decode('utf-8', 'replace')
    if not txt.strip():
        raise RuntimeError('empty response for %s' % url)
    return txt


def norm(s):
    s = html.unescape(s)
    s = s.replace('\u00A0', ' ')
    s = unicodedata.normalize('NFKC', s)
    s = DIAC.sub('', s)
    # superscript alef IS the letter alef in Uthmani orthography
    s = s.replace('\u0670', '\u0627')
    s = s.replace('\u0671', '\u0627')  # alef wasla -> alef
    s = s.replace('\u0649', '\u064A')  # alef maqsura -> yeh
    # hamza-seat variants unify to plain alef: آ أ إ and standalone ء
    s = s.replace('\u0622', '\u0627')
    s = s.replace('\u0623', '\u0627')
    s = s.replace('\u0625', '\u0627')
    s = s.replace('\u0621', '\u0627')
    s = PUNCT.sub(' ', s)
    s = re.sub(r'\s+', ' ', s).strip()
    return s


def api_uthmani(ref, cache):
    if ref not in cache:
        url = ('https://api.quran.com/api/v4/verses/by_key/%s?fields=text_uthmani'
               % ref)
        d = json.loads(fetch(url, 40))
        cache[ref] = d['verse']['text_uthmani']
    return cache[ref]


def tokenize(text):
    out, i, n = [], 0, len(text)
    while i < n:
        while i < n and text[i].isspace():
            i += 1
        if i >= n:
            break
        s = i
        while i < n and not text[i].isspace():
            i += 1
        out.append({'rs': s, 're': i, 'w': norm(text[s:i])})
    return out


def align(tok, ours):
    """Word-level LCS between token words and our words. Returns pairs+coverage."""
    aw = [t['w'] for t in tok]
    ow = [w for w in norm(ours).split(' ') if w]
    m, n = len(aw), len(ow)
    dp = [[0] * (n + 1) for _ in range(m + 1)]
    for i in range(m - 1, -1, -1):
        for j in range(n - 1, -1, -1):
            if aw[i] == ow[j]:
                dp[i][j] = dp[i + 1][j + 1] + 1
            else:
                dp[i][j] = max(dp[i + 1][j], dp[i][j + 1])
    pairs, i, j = [], 0, 0
    while i < m and j < n:
        if aw[i] == ow[j]:
            pairs.append((i, j))
            i += 1
            j += 1
        elif dp[i + 1][j] >= dp[i][j + 1]:
            i += 1
        else:
            j += 1
    cov = (len(pairs) / len(ow)) if ow else 0.0
    return pairs, cov


def window(tok, pairs, ow_len):
    """Raw slice between first/last matched tokens, extended only when the
    unmatched ours-word sits at an EDGE (its api counterpart is adjacent)."""
    first, last = pairs[0][0], pairs[-1][0]
    if pairs[0][1] != 0 and first > 0:
        first -= 1
    if pairs[-1][1] != ow_len - 1 and last < len(tok) - 1:
        last += 1
    return tok[first]['rs'], tok[last]['re']


def clean_ar(raw):
    raw = raw.replace('\u200F', '').replace('\u200E', '')
    raw = raw.replace('"', '').replace('\u201C', '').replace('\u201D', '')
    raw = re.sub(r'\s*\.\s*', '. ', raw)
    raw = re.sub(r'\s+', ' ', raw).strip()
    if raw and not raw.endswith('.'):
        raw += '.'
    return raw


def compare_q(api, ours, fix, src, patched):
    tok = tokenize(api)
    pairs, cov = align(tok, ours)
    if cov >= 0.6 and pairs:
        rs, re_ = window(tok, pairs, len(norm(ours).split(' ')))
        win = api[rs:re_].strip()
        if win == ours:
            return 'Q-EXACT', win, src, patched
        if norm(win) == norm(ours):
            status = 'Q-NORM'
        else:
            status = 'Q-NEAR(cov=%.2f)' % cov
        if fix and src is not None:
            key = 'qtext="%s"' % ours
            if key in src and src.count(key) == 1:
                src = src.replace(key, 'qtext="%s"' % win)
                patched += 1
                status += '+FIXED'
            else:
                status += '(key-not-unique)'
        return status, win, src, patched
    return 'Q-DIVERGE(cov=%.2f)' % cov, None, src, patched


def sunnah_jina(collection, number):
    try:
        return fetch('https://r.jina.ai/https://sunnah.com/%s:%d'
                     % (collection, number), 60)
    except Exception:
        return ''


def sunnah_wayback(collection, number):
    """Return (arabic_div_text, snapshot_url) or (None, None)."""
    for attempt in (1, 2):
        url = None
        try:
            d = json.loads(fetch('https://archive.org/wayback/available?url=sunnah.com/%s:%d'
                                 % (collection, number), 40))
            snap = (d.get('archived_snapshots') or {}).get('closest') or {}
            url = snap.get('url')
        except Exception:
            url = None
        if not url:
            url = 'https://web.archive.org/web/2026/https://sunnah.com/%s:%d' % (
                collection, number)
        try:
            raw = fetch(url, 90)
        except Exception:
            if attempt == 2:
                return None, None
            import time
            time.sleep(2)
            continue
        m = re.search(r'class="arabic_hadith_full[^"]*"[^>]*>(.*?)</div>', raw,
                      re.S)
        if not m:
            if attempt == 2:
                return None, None
            import time
            time.sleep(2)
            continue
        t = re.sub(r'<[^>]+>', ' ', m.group(1))
        t = html.unescape(t)
        t = re.sub(r'\s+', ' ', t).strip()
        if t:
            return t, url
        if attempt == 2:
            return None, None
        import time
        time.sleep(2)
    return None, None


CACHE_PATH = 'data/verification/hadith_ref.json'


def load_cache():
    try:
        return json.load(open(CACHE_PATH, encoding='utf-8'))
    except Exception:
        return {}


def save_cache(cache):
    import os
    os.makedirs(os.path.dirname(CACHE_PATH), exist_ok=True)
    with open(CACHE_PATH, 'w', encoding='utf-8') as fh:
        json.dump(cache, fh, ensure_ascii=False, indent=1, sort_keys=True)


def get_ref(coll, num, cache):
    """Cached reference text for the exact sunnah.com page; records provenance."""
    key = '%s:%d' % (coll, num)
    rec = cache.get(key)
    if rec and rec.get('text'):
        return rec
    div, url = sunnah_wayback(coll, num)
    if div:
        rec = {'source': 'wayback', 'url': url, 'text': div}
    else:
        md = sunnah_jina(coll, num)
        if md:
            rec = {'source': 'jina', 'url': 'https://sunnah.com/%s:%d'
                   % (coll, num), 'text': ''}
            rec['page_md_head'] = norm(md)[:300]
            rec['text'] = ''
        else:
            rec = None
    if rec:
        import time
        rec['fetched'] = time.strftime('%Y-%m-%dT%H:%M:%SZ', time.gmtime())
        cache[key] = rec
        save_cache(cache)
    return rec


def compare_h(nid, coll, num, htext, fix, src, patched, cache):
    rec = get_ref(coll, num, cache)
    if rec is None:
        return 'H-BLOCKED(both)', None, src, patched
    canon = rec['text']

    if nid in OVERRIDE_H:
        new = OVERRIDE_H[nid]
        ok = norm(new)[:25] and norm(new)[:25] in norm(canon)
        if norm(htext) == norm(new):
            return 'H-PASS(override)%s' % ('' if ok else '(unsafe!)'), None, \
                src, patched
        if fix and src is not None and ok:
            key = 'htext="%s"' % htext
            if key in src and src.count(key) == 1:
                src = src.replace(key, 'htext="%s"' % new)
                patched += 1
                return 'H-OVERRIDE+FIXED(wayback)', new, src, patched
            return 'H-OVERRIDE(key-not-unique)', new, src, patched
        return 'H-OVERRIDE(pending%s)' % ('' if ok else '/absent'), new, \
            src, patched

    if canon:
        tok = tokenize(canon)
        pairs, cov = align(tok, htext)
        ow_len = len([w for w in norm(htext).split(' ') if w])
        full = len(pairs) == ow_len
        if full:
            return 'H-PASS(%s)' % rec['source'], None, src, patched
        if cov >= 0.8 and pairs:
            rs, re_ = window(tok, pairs, ow_len)
            new = clean_ar(canon[rs:re_])
            status = 'H-NEAR(cov=%.2f)' % cov
            if fix and src is not None:
                key = 'htext="%s"' % htext
                if key in src and src.count(key) == 1:
                    src = src.replace(key, 'htext="%s"' % new)
                    patched += 1
                    status += '+FIXED(%s)' % rec['source']
                else:
                    status += '(key-not-unique)'
            return status, new, src, patched
        return 'H-DIVERGE(cov=%.2f)' % cov, canon, src, patched

    md = rec.get('page_md_head') or ''
    head = norm(htext)[:25]
    if head and head in norm(md):
        return 'H-PASS(%s-head)' % rec['source'], None, src, patched
    return 'H-WEAK-REF(no-arabic-body)', None, src, patched


def main():
    fix = '--fix' in sys.argv
    debug = '-d' in sys.argv
    data = json.load(open(DATA, encoding='utf-8'))
    src = open(SRC, encoding='utf-8').read() if fix else None
    rows, patched = [], 0
    qcache = {}
    hcache = load_cache()

    for node in data['nodes']:
        nid = node['id']

        q = node.get('quran') or {}
        if q.get('text'):
            m = re.search(r'quran\.com/(\d+)/(\d+)', q.get('link') or '')
            if m:
                ref = '%d:%d' % (int(m.group(1)), int(m.group(2)))
                api = api_uthmani(ref, qcache)
                status, win, src, patched = compare_q(api, q['text'], fix, src,
                                                      patched)
                rows.append((nid, 'quran', ref, status))
                if debug and not status.startswith('Q-EXACT'):
                    print('  [%s] ours=%s' % (nid, norm(q['text'])[:70]))
                    print('  [%s] ref => %s' % (nid, (win or '')[:70]))
            else:
                rows.append((nid, 'quran', '?', 'Q-NO-LINK'))

        h = node.get('hadith') or {}
        if h.get('text') and h.get('link'):
            m2 = re.search(r'sunnah\.com/([a-z]+):(\d+)', h['link'])
            if m2:
                coll, num = m2.group(1), int(m2.group(2))
                status, cand, src, patched = compare_h(nid, coll, num,
                                                       h['text'], fix, src,
                                                       patched, hcache)
                rows.append((nid, 'hadith', '%s:%d' % (coll, num), status))
                if debug and not status.startswith('H-PASS'):
                    print('  [%s] ours=%s' % (nid, norm(h['text'])[:60]))
                    print('  [%s] ref => %s' % (nid, (cand or '')[:60]))
            else:
                rows.append((nid, 'hadith', '?', 'H-NO-LINK'))

    width = max(len(r[0]) for r in rows) if rows else 10
    print('%-*s  %-7s %-12s %s' % (width, 'node', 'type', 'ref', 'status'))
    print('-' * (width + 34))
    fails = 0
    for nid, kind, ref, status in rows:
        print('%-*s  %-7s %-12s %s' % (width, nid, kind, ref, status))
        if 'DIVERGE' in status or 'BLOCKED' in status or 'NO-LINK' in status:
            fails += 1
    print('\nrows: %d | hard-failures: %d | patched: %d'
          % (len(rows), fails, patched))
    if fix and patched:
        open(SRC, 'w', encoding='utf-8').write(src)
        print('NOTE: re-run make_content.py, then re-run WITHOUT --fix.')
    sys.exit(1 if fails else 0)


main()
