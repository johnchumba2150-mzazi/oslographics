-- 1) Replace OWNER_EMAIL_HERE (10 places) with the admin email, then Run in Supabase > SQL Editor.
create table if not exists public.site_settings(id integer primary key check(id=1),settings jsonb not null default '{}'::jsonb,updated_at timestamptz not null default now());
alter table public.site_settings enable row level security;
drop policy if exists "Public can read site settings" on public.site_settings;
drop policy if exists "Admins can insert site settings" on public.site_settings;
drop policy if exists "Admins can update site settings" on public.site_settings;
create policy "Public can read site settings" on public.site_settings for select to anon,authenticated using(true);
create policy "Admins can insert site settings" on public.site_settings for insert to authenticated with check(lower(auth.jwt()->>'email')=lower('OWNER_EMAIL_HERE'));
create policy "Admins can update site settings" on public.site_settings for update to authenticated using(lower(auth.jwt()->>'email')=lower('OWNER_EMAIL_HERE')) with check(lower(auth.jwt()->>'email')=lower('OWNER_EMAIL_HERE'));
create table if not exists public.leads(id bigint generated always as identity primary key,created_at timestamptz default now(),name text,phone text,product text,qty text,deadline text,message text);
alter table public.leads enable row level security;
drop policy if exists "Anyone can send a quote" on public.leads;
drop policy if exists "Admin reads quotes" on public.leads;
create policy "Anyone can send a quote" on public.leads for insert to anon,authenticated with check(length(name) between 1 and 100 and length(phone) between 5 and 30 and length(coalesce(message,''))<1000 and length(coalesce(product,''))<100 and length(coalesce(qty,''))<60 and length(coalesce(deadline,''))<60);
create policy "Admin reads quotes" on public.leads for select to authenticated using(lower(auth.jwt()->>'email')=lower('OWNER_EMAIL_HERE'));
insert into storage.buckets(id,name,public,file_size_limit,allowed_mime_types) values('site-images','site-images',true,5242880,array['image/jpeg','image/png','image/webp']) on conflict(id) do update set public=true,file_size_limit=5242880,allowed_mime_types=array['image/jpeg','image/png','image/webp'];
drop policy if exists "Public can view site images" on storage.objects;
drop policy if exists "Owner uploads site images" on storage.objects;
create policy "Public can view site images" on storage.objects for select to anon,authenticated using(bucket_id='site-images');
create policy "Owner uploads site images" on storage.objects for insert to authenticated with check(bucket_id='site-images' and lower(auth.jwt()->>'email')=lower('OWNER_EMAIL_HERE'));

-- Orders, receipts and analytics
create table if not exists public.orders(id bigint generated always as identity primary key,created_at timestamptz default now(),ref text unique,name text,phone text,delivery text,needed_by text,notes text,items jsonb,subtotal numeric,discount_pct numeric default 0,total numeric,code text,status text not null default 'Pending');
alter table public.orders enable row level security;
drop policy if exists "Anyone can place an order" on public.orders;
drop policy if exists "Owner reads orders" on public.orders;
drop policy if exists "Owner updates orders" on public.orders;
create policy "Anyone can place an order" on public.orders for insert to anon,authenticated with check(length(name) between 1 and 100 and length(phone) between 5 and 30 and status='Pending' and subtotal>=0 and total>=0 and discount_pct between 0 and 90 and jsonb_array_length(items) between 1 and 50 and length(coalesce(notes,''))<600 and length(coalesce(code,''))<30);
create policy "Owner reads orders" on public.orders for select to authenticated using(lower(auth.jwt()->>'email')=lower('OWNER_EMAIL_HERE'));
create policy "Owner updates orders" on public.orders for update to authenticated using(lower(auth.jwt()->>'email')=lower('OWNER_EMAIL_HERE')) with check(lower(auth.jwt()->>'email')=lower('OWNER_EMAIL_HERE'));
create table if not exists public.visits(id bigint generated always as identity primary key,created_at timestamptz default now(),page text);
alter table public.visits enable row level security;
drop policy if exists "Anyone can log a visit" on public.visits;
drop policy if exists "Owner reads visits" on public.visits;
create policy "Anyone can log a visit" on public.visits for insert to anon,authenticated with check(length(coalesce(page,''))<40);
create policy "Owner reads visits" on public.visits for select to authenticated using(lower(auth.jwt()->>'email')=lower('OWNER_EMAIL_HERE'));
