# Railway Deployment Guide

Panduan lengkap untuk deploy KLIK-SDM ke [Railway](https://railway.app).

## Prasyarat

- GitHub account dengan repository sudah ter-push ✅
- Railway account (free tier tersedia)
- Docker configuration siap ✅

---

## Step 1: Buat Railway Account

1. Buka [railway.app](https://railway.app)
2. Sign up dengan GitHub (recommended)
3. Buat project baru

---

## Step 2: Hubungkan GitHub Repository

1. Di Railway dashboard, klik **New Project**
2. Pilih **Deploy from GitHub repo**
3. Authenticate dengan GitHub
4. Pilih repository: `azrylfrhan/kliksdmbps`
5. Klik **Deploy**

Railway akan otomatis:
- Detect Dockerfile di root
- Build Docker image
- Deploy container
- Assign public URL (contoh: `kliksdmbps.up.railway.app`)

---

## Step 3: Verifikasi Deployment

Setelah Railway menunjukkan "Deploy Success":

### Test 1: Homepage muncul
Buka URL di browser → seharusnya menampilkan halaman KLIK-SDM

### Test 2: Coba login
- Username: `admin`
- Password: `Admin@2024`

### Test 3: Cek console
Buka DevTools (F12) → Console → tidak ada error CORS

---

## Cara Kerja Deployment

### Dockerfile
- Menggunakan `nginx:alpine` (lightweight HTTP server)
- Serve semua file project sebagai static HTML/CSS/JS
- Listen pada `$PORT` (Railway set ini)
- Route semua request ke `/index.html` (SPA fallback)

### nginx.template.conf
- **SPA Routing:** `try_files $uri $uri/ /index.html;`
  - Pastikan route seperti `/pengumuman` serve index.html, bukan 404
- **Caching:**
  - `index.html`: No cache (selalu check untuk update)
  - Static assets: Cache 1 tahun
- **Security:** Block akses ke `.git/`, `.env*` files

---

## Troubleshooting

### Deploy Gagal
**Error:** `Dockerfile not found`
- **Fix:** Pastikan `Dockerfile` di root (bukan subfolder)

### Halaman Blank/404
**Error:** `Cannot GET /`
- **Fix:** Verify `index.html` di root level
- Check Railway logs

### Login Error 401
**Error:** Console: `401 Unauthorized`
- **Fix:** Expected jika Supabase credentials berbeda
- Check Supabase user table

### CORS Error
**Error:** `Access to XMLHttpRequest blocked by CORS policy`
- Network tab seharusnya show request ke Supabase URL yang benar

---

## URL References

| Component | URL |
|-----------|-----|
| Railway App | `https://kliksdmbps.up.railway.app` |
| Supabase | https://tgxjozaszglngxmozbxn.supabase.co |
| GitHub | https://github.com/azrylfrhan/kliksdmbps |

---

## Dokumentasi Resmi

- Railway: https://docs.railway.app
- Supabase: https://supabase.com/docs
