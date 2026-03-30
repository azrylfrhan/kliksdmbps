# 📘 PANDUAN SETUP BACKEND SUPABASE — KLIK-SDM
## Dari Nol Sampai Berjalan 100%

---

## 📁 STRUKTUR FILE

```
klik-sdm-backend/
├── supabase/
│   ├── 01_schema.sql              ← Buat semua tabel + data awal
│   ├── 02_rls_policies.sql        ← Row Level Security policies
│   └── functions/
│       └── api/
│           └── index.ts           ← Edge Function (API utama)
├── index_updated.html             ← Frontend yang sudah diupdate
└── SETUP_GUIDE.md                 ← File ini
```

---

## 🚀 LANGKAH SETUP (Urutan Wajib)

### LANGKAH 1 — Buat Proyek Supabase

1. Buka https://supabase.com → Login atau daftar
2. Klik **"New Project"**
3. Isi:
   - **Name**: `klik-sdm`
   - **Database Password**: buat yang kuat (simpan!)
   - **Region**: pilih `Southeast Asia (Singapore)` untuk performa terbaik
4. Tunggu ±2 menit hingga proyek siap

---

### LANGKAH 2 — Catat Kredensial

Di **Project Settings → API**, catat:

```
Project URL  : https://XXXXXXXX.supabase.co
anon key     : eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.XXXXXXXX...
service_role : eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.XXXXXXXX...
```

> ⚠️ **service_role** bersifat rahasia! Jangan diekspos ke publik/frontend.

---

### LANGKAH 3 — Buat Storage Bucket

Untuk menyimpan foto gallery dan tim kerja:

1. Buka menu **Storage** di sidebar Supabase
2. Klik **"New Bucket"**
3. Isi:
   - **Name**: `images`
   - **Public bucket**: ✅ Aktifkan (centang)
4. Klik **Create Bucket**
5. Di bucket `images`, klik **Policies** → **New Policy** → pilih **For full customization**
6. Tambahkan policy:
   ```sql
   -- Allow public to read/view all images
   CREATE POLICY "Public Access" ON storage.objects
     FOR SELECT USING (bucket_id = 'images');
   
   -- Allow service role to upload/delete
   CREATE POLICY "Service Role Full Access" ON storage.objects
     FOR ALL USING (auth.role() = 'service_role');
   ```

---

### LANGKAH 4 — Jalankan SQL Schema

1. Buka **SQL Editor** di sidebar Supabase
2. Klik **"New query"**
3. Copy-paste seluruh isi file `01_schema.sql`
4. Klik **Run** (▶)
5. Pastikan tidak ada error merah
6. Ulangi untuk `02_rls_policies.sql`

---

### LANGKAH 5 — Deploy Edge Function

Pastikan Supabase CLI sudah terinstall:

```bash
# Install Supabase CLI
npm install -g supabase

# Atau via brew (Mac)
brew install supabase/tap/supabase
```

Kemudian:

```bash
# Login ke Supabase
supabase login

# Masuk ke folder proyek
cd klik-sdm-backend

# Inisialisasi Supabase di folder ini
supabase init

# Link ke proyek Supabase Anda (ambil Project ID dari dashboard)
supabase link --project-ref XXXXXXXX

# Deploy Edge Function
supabase functions deploy api

# Set environment variables (otomatis dari supabase.com)
# Tidak perlu set manual: SUPABASE_URL dan SUPABASE_SERVICE_ROLE_KEY
# sudah otomatis tersedia di Edge Functions runtime
```

**Verifikasi deploy berhasil:**
```bash
# Test endpoint
curl "https://XXXXXXXX.supabase.co/functions/v1/api?endpoint=settings" \
  -H "apikey: YOUR_ANON_KEY"
```

Respons yang diharapkan:
```json
{"scrolling_text":"Selamat Datang di KLIK-SDM..."}
```

---

### LANGKAH 6 — Update Frontend (index_updated.html)

Buka file `index_updated.html`, temukan bagian ini dan ganti dengan nilai asli:

```javascript
const SUPABASE_URL      = 'https://XXXXXXXX.supabase.co';   // ← GANTI
const EDGE_FUNCTION_URL = `${SUPABASE_URL}/functions/v1/api`;
const ANON_KEY          = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.XXXXXXXX'; // ← GANTI
```

---

### LANGKAH 7 — Test Login Admin

Buka `index_updated.html` di browser, klik **Login**:

| Username       | Password       | Role              |
|----------------|----------------|-------------------|
| `admin`        | `Admin@2024`   | Admin Pengelola   |
| `kepegawaian`  | `Kepeg@2024`   | Admin Kepegawaian |

> ⚠️ **Wajib ganti password setelah deploy!** Gunakan SQL Editor:
> ```sql
> UPDATE users SET password = 'PasswordBaruAnda' WHERE username = 'admin';
> UPDATE users SET password = 'PasswordBaruLain' WHERE username = 'kepegawaian';
> ```

---

## 🗄️ DAFTAR TABEL DATABASE

| Tabel                        | Fungsi                                |
|------------------------------|---------------------------------------|
| `settings`                   | Scrolling text & konfigurasi          |
| `users`                      | Akun admin (login)                    |
| `pengumuman`                 | Daftar pengumuman beranda             |
| `gallery`                    | Foto galeri SDM                       |
| `tim_kerja`                  | Anggota tim SDM & Hukum               |
| `faq`                        | Pertanyaan & jawaban FAQ              |
| `kp_data`                    | Data pegawai kenaikan pangkat         |
| `kp_requirements`            | Persyaratan dokumen kenaikan pangkat  |
| `kp_jadwal`                  | Jadwal periode kenaikan pangkat       |
| `kgb_data`                   | Data KGB per kab/kota per bulan       |
| `uji_kompetensi`             | Peserta uji kompetensi                |
| `peraturan`                  | Daftar peraturan kepegawaian          |
| `tugas_belajar_persyaratan`  | Persyaratan tugas belajar             |
| `tugas_belajar_dokumen`      | Dokumen tugas belajar                 |

---

## 🔌 DAFTAR ENDPOINT API

Base URL: `https://XXXXXXXX.supabase.co/functions/v1/api?endpoint=`

| Endpoint           | GET | POST | PUT | DELETE | Auth?    |
|--------------------|-----|------|-----|--------|----------|
| `settings`         | ✅  |      | ✅  |        | PUT only |
| `login`            |     | ✅   |     |        | No       |
| `pengumuman`       | ✅  | ✅   |     | ✅     | POST/DEL |
| `gallery`          | ✅  | ✅   |     | ✅     | POST/DEL |
| `tim_kerja`        | ✅  | ✅   |     | ✅     | POST/DEL |
| `faq`              | ✅  | ✅   | ✅  | ✅     | PUT/DEL  |
| `kp_data`          | ✅  | ✅   |     | ✅     | POST/DEL |
| `kp_requirements`  | ✅  | ✅   | ✅  | ✅     | POST+    |
| `kp_jadwal`        | ✅  | ✅   |     | ✅     | POST/DEL |
| `kgb_data`         | ✅  | ✅   |     | ✅     | POST/DEL |
| `uji_kompetensi`   | ✅  | ✅   |     | ✅     | POST/DEL |
| `peraturan`        | ✅  | ✅   |     | ✅     | POST/DEL |
| `tb_persyaratan`   | ✅  | ✅   |     | ✅     | POST/DEL |
| `tb_dokumen`       | ✅  | ✅   |     | ✅     | POST/DEL |

---

## 🔐 MEKANISME AUTENTIKASI

Token yang digunakan adalah base64 encoding sederhana:
```
token = btoa("username:password:role")
```

Token dikirim via header:
```
Authorization: Bearer <token>
```

Edge Function mendekode token dan memverifikasi ke database.

> 📝 Untuk produksi yang lebih aman, pertimbangkan menggunakan
> Supabase Auth (JWT) menggantikan sistem token sederhana ini.

---

## ⚠️ TROUBLESHOOTING

### Error: "Function not found"
→ Edge Function belum di-deploy. Ulangi `supabase functions deploy api`

### Error: "Unauthorized"
→ Token tidak valid. Pastikan login ulang dan cek username/password di tabel `users`

### Error: "Upload gagal"
→ Storage bucket `images` belum dibuat atau policy belum diset

### Error: CORS
→ Edge Function sudah include CORS headers. Jika masih error, pastikan URL `SUPABASE_URL` benar di frontend

### Scrolling text tidak muncul
→ Cek apakah data `scrolling_text` ada di tabel `settings`:
```sql
SELECT * FROM settings WHERE key = 'scrolling_text';
```

---

## 📊 MONITORING

Di Supabase Dashboard tersedia:
- **Table Editor** — lihat/edit data langsung
- **Logs** — log Edge Function realtime
- **Database → Replication** — backup otomatis
- **API** — usage & performance metrics

---

## 🔄 UPDATE PASSWORD (WAJIB!)

```sql
-- Ganti password admin pengelola
UPDATE users 
SET password = 'PasswordBaru123!' 
WHERE username = 'admin';

-- Ganti password admin kepegawaian
UPDATE users 
SET password = 'PasswordLain456!' 
WHERE username = 'kepegawaian';
```

---

*Dibuat untuk KLIK-SDM — BPS Provinsi Sulawesi Utara*
