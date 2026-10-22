-- ============================================================
-- Mawaddah & Rahmah — optional Supabase backend (free tier)
-- هذا المخطط اختياري 100%: التطبيق يعمل محلياً بلا أي سيرفر.
-- عند تفعيل المزامنة لاحقاً (v1.1): أنشئ مشروعاً في supabase.com
-- ثم نفّذ هذا الملف عبر SQL Editor، وحدّث flutter_app لدفع الدفعات.
-- ============================================================

create type gender_target as enum ('MALE', 'FEMALE', 'BOTH');

create table guidance_node (
  id                    text primary key,
  gender_target         gender_target not null default 'BOTH',
  category              text not null,
  situation_title       text not null,
  islamic_action        text not null,
  dalil_quran           text default '',
  dalil_hadith          text default '',
  worldly_impact        text default '',
  afterlife_consequence text default '',
  language              text not null default 'ar',
  quran_ref             text default '',
  quran_link            text default '',
  hadith_source         text default '',
  hadith_link           text default '',
  note                  text default '',
  disclaimer_ar         text default '',
  created_at            timestamptz not null default now(),
  updated_at            timestamptz not null default now()
);

create index guidance_node_category_idx on guidance_node (category);
create index guidance_node_gender_idx   on guidance_node (gender_target);
create index guidance_node_lang_idx     on guidance_node (language);

-- قراءة عامة للجميع (المحتوى توعوي عموم)؛ الكتابة تصحح فقط عبر لوحة Supabase (auth) أو service key.
alter table guidance_node enable row level security;

create policy "public read guidance"
  on guidance_node for select
  using (true);

-- سجل نتائج اختبار التناغم (اختياري: مفعّل فقط إذا فعّلت المزامنة وحساباً)
create table harmony_result (
  id          uuid primary key default gen_random_uuid(),
  user_hash   text not null,          -- hash عشوائي من الجهاز (لا ملفات شخصية)
  mode        text not null default 'self',  -- self | couple
  score       int  not null,
  answers     jsonb not null default '[]'::jsonb,
  created_at  timestamptz not null default now()
);

alter table harmony_result enable row level security;

create policy "owner-only write harmony"
  on harmony_result for insert
  with check (user_hash is not null and length(user_hash) <= 64);
