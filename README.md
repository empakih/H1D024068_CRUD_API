# Modul 4 — Operasi CRUD dengan API CodeIgniter 4 & Framework Flutter

| Informasi | Detail |
|---|---|
| **Nama** | Muhammad Faqih Muhyiddin |
| **NIM** | H1D024068 |
| **Shift** | D (KRS: E) |
| **Aplikasi Flutter** | `tokokita` (`c:\Users\faqih\AndroidStudioProjects\tokokita`) |
| **Backend REST API** | CodeIgniter 4 (`backend_api/toko-api` & `C:\xampp\htdocs\toko-api`) |
| **Database** | MySQL / MariaDB (`database/toko_api.sql`) |

---

## 1. Deskripsi Praktikum

Praktikum ini mengimplementasikan integrasi arsitektur sistem client-server melalui **RESTful API** antara:
1. **Frontend Mobile (Flutter)**: Aplikasi `tokokita` yang mengelola form registrasi, login, autentikasi berbasis session token, serta antarmuka penuh operasi CRUD produk (Create, Read, Update, Delete) yang responsif dan tervalidasi.
2. **Backend Server (CodeIgniter 4)**: Menyediakan RESTful API endpoint menggunakan format data JSON terstandar (`code`, `status`, `data`).
3. **Database (MySQL)**: Database `toko_api` yang menyimpan data kredensial pengguna terenkripsi (`member`), token autentikasi aktif (`member_token`), dan katalog data barang (`produk`).

---

## 2. Struktur Repositori Terpadu (All-in-One Repository)

Seluruh komponen pendukung (Frontend Flutter, Source Code Backend API, dan Skema Database) telah disatukan di dalam repositori ini:

```text
tokokita/
├── backend_api/
│   └── toko-api/                 # Source code lengkap CodeIgniter 4 RESTful API
│       ├── app/
│       │   ├── Config/Routes.php # Routing endpoint registrasi, login, dan produk
│       │   ├── Controllers/      # RestfulController, RegistrasiController, LoginController, ProdukController
│       │   └── Models/           # MRegistrasi, MMember, MLogin, MProduk
│       └── public/               # Entry point index.php & .htaccess server web
├── database/
│   └── toko_api.sql              # File export database MySQL (struktur tabel & data awal)
├── lib/
│   ├── helpers/
│   │   ├── api.dart              # HTTP Client Service untuk integrasi endpoint
│   │   ├── api_url.dart          # Konfigurasi Base URL dan alamat endpoint
│   │   └── user_info.dart        # Pengelolaan local storage SharedPreferences (Token & UserID)
│   ├── model/
│   │   ├── login.dart            # Model parsing respon login & pesan validasi
│   │   ├── registrasi.dart       # Model parsing respon registrasi
│   │   └── produk.dart           # Model entitas produk
│   ├── ui/
│   │   ├── login_page.dart       # Halaman form login dengan validasi & dialog interaktif
│   │   ├── registrasi_page.dart  # Form registrasi dengan validasi nama, regex email, password, konfirmasi
│   │   ├── produk_page.dart      # Katalog list produk real-time dari database & drawer logout
│   │   ├── produk_form.dart      # Form dinamis Tambah / Ubah data produk
│   │   └── produk_detail.dart    # Detail produk dengan tombol aksi Edit & dialog konfirmasi Hapus
│   └── main.dart                 # Root widget aplikasi (MaterialApp)
└── README.md
```

---

## 3. Spesifikasi RESTful API

Format standar respon JSON:
```json
{
  "code": 200,
  "status": true,
  "data": ...
}
```

### Tabel Endpoint API

| No | Modul / Fitur | HTTP Method | Endpoint URL | Request Body (JSON) | Deskripsi |
|:--:|---|:---:|---|---|---|
| 1 | **Registrasi** | `POST` | `/registrasi` | `nama`, `email`, `password` | Pendaftaran akun baru, enkripsi password via `password_hash()`. |
| 2 | **Login** | `POST` | `/login` | `email`, `password` | Autentikasi user & pembuatan token acak 100 karakter. |
| 3 | **List Produk** | `GET` | `/produk` | *-* | Mengambil seluruh katalog produk dari database. |
| 4 | **Create Produk** | `POST` | `/produk` | `kode_produk`, `nama_produk`, `harga` | Menambahkan data produk baru ke tabel `produk`. |
| 5 | **Detail Produk** | `GET` | `/produk/{id}` | *-* | Mengambil detail 1 produk berdasarkan primary key ID. |
| 6 | **Update Produk** | `PUT` / `POST` | `/produk/{id}` atau `/produk/{id}/update` | `kode_produk`, `nama_produk`, `harga` | Memperbarui atribut data produk berdasarkan ID. |
| 7 | **Delete Produk** | `DELETE` | `/produk/{id}` | *-* | Menghapus record produk dari tabel database. |

---

## 4. Panduan Menjalankan Sistem

### A. Persiapan Database (MySQL)
1. Buka **XAMPP Control Panel** dan klik **Start** pada modul **MySQL**.
2. Buka `http://localhost/phpmyadmin` di browser.
3. Buat database baru bernama `toko_api` (atau langsung klik menu **Import**).
4. Pilih file **`database/toko_api.sql`** yang ada di repositori ini, lalu klik **Import**.

### B. Menjalankan Backend (CodeIgniter 4)
1. Pastikan folder **`backend_api/toko-api`** disalin atau berada di **`C:\xampp\htdocs\toko-api`**.
2. Klik tombol **Start** pada modul **Apache** di XAMPP Control Panel.
3. API aktif dan dapat diakses di: `http://localhost/toko-api/public/` atau melalui IP lokal Wi-Fi laptop.

### C. Menjalankan Aplikasi Mobile (Flutter)
1. Pastikan HP dan Laptop terhubung dalam **jaringan Wi-Fi yang sama**.
2. Cek alamat IP Wi-Fi laptop Anda (misal `ipconfig` di command prompt).
3. Jika IP berbeda, sesuaikan `baseUrl` pada file `lib/helpers/api_url.dart`:
   ```dart
   static const String baseUrl = 'http://<IP_LAPTOP_ANDA>/toko-api/public';
   ```
4. Jalankan aplikasi melalui terminal atau tombol Run Android Studio:
   ```bash
   flutter pub get
   flutter run
   ```

### D. Akun Pengujian
- **Email**: `admin@admin.com`
- **Password**: `admin`
*(Atau lakukan pendaftaran akun baru secara langsung melalui halaman Registrasi pada aplikasi).*
