# KitaLaundry 🧺

KitaLaundry adalah sistem manajemen operasional dan layanan binatu (laundry) yang dibangun menggunakan arsitektur modern (Next.js untuk Frontend dan Ruby on Rails 8 API untuk Backend).

## ✨ Fitur Utama & Tech Stack
- **Frontend**: Next.js 14, React, Tailwind CSS, TypeScript.
- **Backend**: Ruby on Rails 8 (API mode), PostgreSQL.
- **Autentikasi & Keamanan**: JWT (JSON Web Tokens), `bcrypt`, **Google reCAPTCHA v3**.
- **Payment Gateway**: Integrasi **Xendit** (Pembuatan Invoice Otomatis & Webhook Callback).
- **Penyimpanan Berkas**: **Cloudinary** (via ActiveStorage) untuk Avatar, Struk Pembayaran, dan Bukti Kondisi Pakaian.
- **Notifikasi**: **Meta WhatsApp Cloud API** (Notifikasi pesanan dan konfirmasi pembayaran).
- **Real-Time**: ActionCable (WebSockets) untuk pembaruan status pesanan secara langsung.
- **Port Khusus**: Frontend (`:3000`), Backend (`:8000`).
- **Autentikasi Nyata**: Sinkronisasi login ke DB PostgreSQL menggunakan token JWT asli, dilindungi enkripsi. Verifikasi email dikirim (simulasi) dengan **Letter Opener**.
- **Role-Based Routing**: *Branch Manager* memiliki dashboard khusus `/branch/dashboard` yang terpisah dari pelanggan.
- **Manajemen Pengguna (CRUD)**: Admin Pusat dapat memantau dan mengedit informasi semua pelanggan, staf, maupun manager cabang.
- **Manajemen Alamat**: Pelanggan dapat mengatur banyak alamat pengiriman secara dinamis yang terhubung ke DB.
- **Sistem Notifikasi Internal**: Lonceng notifikasi pelanggan tersambung riil ke PostgreSQL untuk rekam jejak status order.
- **Barcode Scanner Terintegrasi**: Tersedia API khusus bagi admin untuk mengubah status pesanan secara instan hanya dengan memindai kode *barcode*.
- **100% Database-Driven**: Aplikasi tidak lagi menggunakan *dummy/mock data* di *frontend*, melainkan menarik seluruh kalkulasi dan statistik (Dasbor) secara *real-time* dari *database*.

---

## 🚀 Panduan Instalasi & Menjalankan Aplikasi

### 1. Prasyarat
- **Node.js** (v18+)
- **Ruby** (v3.2+)
- **PostgreSQL** (Sedang berjalan di sistem Anda)
- Kredensial Pihak Ketiga (Xendit, Cloudinary, Meta Developer, reCAPTCHA v3)

### 2. Setup Backend (Rails API)
1. Buka terminal/WSL dan navigasikan ke folder backend:
   ```bash
   cd backend
   ```
2. Instal *gem* dan dependensi:
   ```bash
   bundle install
   ```
3. Konfigurasi Environment Variables:
   - Salin file `.env.example` menjadi `.env`.
   - Isikan *API Keys* untuk Xendit, Cloudinary, Meta WhatsApp, dan reCAPTCHA Secret Key di dalamnya.
4. Setup Database & Migrasi:
   ```bash
   rails db:create db:migrate db:seed
   ```
5. Jalankan Server Backend (berjalan di `http://localhost:3000`):
   ```bash
   rails s
   ```

### 3. Setup Frontend (Next.js)
1. Buka terminal baru dan navigasikan ke folder frontend:
   ```bash
   cd frontend
   ```
2. Instal dependensi NPM:
   ```bash
   npm install
   ```
3. Konfigurasi Environment Variables:
   - Salin `.env.local.example` (jika ada) atau buat file `.env.local`.
   - Isikan `NEXT_PUBLIC_API_URL=http://localhost:3000`
   - Isikan `NEXT_PUBLIC_RECAPTCHA_SITE_KEY=<kunci-site-anda>`
4. Jalankan Server Frontend (berjalan di `http://localhost:3001` atau *port* lainnya):
   ```bash
   npm run dev
   ```

---

## 🧪 Panduan Testing / Uji Coba

Setelah menjalankan proses `rails db:seed` pada backend, sistem telah menyediakan beberapa data awal dan akun *dummy* untuk keperluan *testing*:

### Kredensial Akun Dummy:
| Peran (Role) | Email | Password | Hak Akses Utama |
|---|---|---|---|
| **Center Admin** | `admin@kitalaundry.com` | `password123` | Manajemen semua cabang, laporan, layanan, admin sistem. |
| **Branch Manager** | `manager.petisah@kitalaundry.com`,<br>`manager.baru@kitalaundry.com`,<br>`manager.timur@kitalaundry.com`,<br>`manager.sunggal@kitalaundry.com`,<br>`manager.johor@kitalaundry.com` | `password123` | Manajemen operasional khusus untuk cabangnya sendiri (Medan). |
| **Customer** | `customer1@gmail.com` s/d `customer15@gmail.com` | `password123` | Pembuatan pesanan, manajemen alamat, riwayat transaksi diri sendiri. |

### Skenario Testing 1: Lewat Postman (Backend Saja)
1. Buka aplikasi **Postman**.
2. **Login & Dapatkan Token:**
   - Metode: `POST`
   - URL: `http://localhost:3000/auth/login`
   - Body (JSON): 
     ```json
     {
       "email": "customer1@gmail.com",
       "password": "password123"
       // "recaptcha_token": "abaikan saat ini di lingkungan development jika tidak diwajibkan"
     }
     ```
   - Salin nilai `token` dari hasil *response*.
3. **Melihat Cabang (Tidak perlu token):**
   - Metode: `GET`
   - URL: `http://localhost:3000/branches`
4. **Membuat Pesanan (Perlu token):**
   - Metode: `POST`
   - URL: `http://localhost:3000/orders`
   - Headers: Tambahkan `Authorization: Bearer <token_anda>`
   - Body (JSON):
     ```json
     {
       "order": {
         "branch_id": 1,
         "pickup_address_id": 1,
         "delivery_address_id": 1
       },
       "order_items": [
         { "service_id": 1, "weight_kg": 2 }
       ]
     }
     ```
   - *Catatan: Jika integrasi WhatsApp dihidupkan, sistem akan otomatis mengirim pesan WA ke nomor yang didaftarkan pada `.env` Meta API.*

### Skenario Testing 2: Lewat Frontend Next.js
1. Buka *browser* dan kunjungi alamat lokal frontend Anda (biasanya `http://localhost:3001`).
2. Masuk ke halaman **Login**.
   - Sistem akan otomatis menghitung skor reCAPTCHA v3 di latar belakang untuk keamanan anti-bot.
3. Masuk menggunakan akun **Customer** (`customer1@gmail.com`).
4. **Buat Pesanan Baru**: Cobalah antarmuka pemesanan. Saat Anda memilih opsi *checkout* atau *bayar*, backend akan memanggil layanan Xendit dan *Invoice* / Kode Pembayaran akan muncul!
5. Masuk menggunakan akun **Center Admin** (`admin@kitalaundry.com`) untuk melihat data analitik, tabel seluruh pesanan, atau merespons tiket keluhan.

---
*Dokumentasi ini otomatis digenerate dan diperbarui pada rilis integrasi Fase 6 (Eksternal).*
