# Modul 4 & Modul Lanjutan — Operasi CRUD dengan API CodeIgniter 4 & Framework Flutter

| Informasi | Detail |
|---|---|
| **Nama** | Muhammad Faqih Muhyiddin |
| **NIM** | H1D024068 |
| **Shift** | D (KRS: E) |
| **Aplikasi Flutter** | `tokokita` |
| **Backend REST API** | CodeIgniter 4 (`backend_api/toko-api` & `C:\xampp\htdocs\toko-api`) |
| **Database** | MySQL / MariaDB (`database/toko_api.sql`) |

---

## 1. Deskripsi Praktikum

Praktikum ini mengimplementasikan integrasi arsitektur sistem client-server melalui **RESTful API** serta penerapan pola **BLoC (Business Logic Component)** dan **Helper Layer** pada aplikasi mobile Flutter:
1. **Frontend Mobile (Flutter)**: Aplikasi `tokokita` yang mengelola form registrasi, login, autentikasi berbasis session token, auto-login, serta antarmuka penuh operasi CRUD produk (Create, Read, Update, Delete) yang responsif dan tervalidasi menggunakan dialog interaktif (`SuccessDialog` & `WarningDialog`).
2. **Business Logic & Helpers (BLoC Pattern)**: Memisahkan UI dari logika jaringan dan data:
   - **`helpers/`**: Mengelola request HTTP, penanganan status exception (`AppException`), konfigurasi URL terpusat, dan sesi `SharedPreferences`.
   - **`bloc/`**: Bertindak sebagai penghubung data antara antarmuka (UI) dan REST API backend.
   - **`widget/`**: Komponen dialog kustom modal (*Success* dan *Warning*) dengan tampilan konsisten.
3. **Backend Server (CodeIgniter 4)**: Menyediakan RESTful API endpoint menggunakan format data JSON terstandar (`code`, `status`, `data`).
4. **Database (MySQL)**: Database `toko_api` yang menyimpan data kredensial pengguna terenkripsi (`member`), token autentikasi aktif (`member_token`), dan katalog data barang (`produk`).

---

## 2. Demo Video

https://github.com/user-attachments/assets/497b3188-a6f5-4dae-8e44-9f606c18fa3d

---

## 3. Struktur Repositori Terpadu (All-in-One Repository)

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
│   ├── bloc/                     # Lapisan Business Logic Component (BLoC)
│   │   ├── login_bloc.dart       # Logika proses autentikasi login
│   │   ├── logout_bloc.dart      # Logika logout & pembersihan session
│   │   ├── produk_bloc.dart      # Logika CRUD produk (get, add, update, delete)
│   │   └── registrasi_bloc.dart  # Logika registrasi user baru
│   ├── helpers/                  # Lapisan Helper Jaringan & Sesi
│   │   ├── api.dart              # HTTP Client Service (GET, POST, DELETE & error handling)
│   │   ├── api_url.dart          # Konfigurasi Base URL dan daftar endpoint
│   │   ├── app_exception.dart    # Custom Exception (FetchData, BadRequest, Unauthorised, dll)
│   │   └── user_info.dart        # Pengelolaan SharedPreferences (Token & UserID)
│   ├── model/                    # Data Models Deserialisasi JSON
│   │   ├── login.dart            # Model parsing respon login & pesan validasi
│   │   ├── registrasi.dart       # Model parsing respon registrasi
│   │   └── produk.dart           # Model entitas produk
│   ├── ui/                       # Antarmuka Pengguna (View)
│   │   ├── login_page.dart       # Halaman login form dengan validasi & WarningDialog
│   │   ├── registrasi_page.dart  # Form registrasi dengan validasi & Success/Warning Dialog
│   │   ├── produk_page.dart      # List produk real-time via FutureBuilder & Drawer logout
│   │   ├── produk_form.dart      # Form dinamis Tambah / Ubah data produk
│   │   └── produk_detail.dart    # Detail produk dengan tombol aksi Edit & dialog konfirmasi Hapus
│   ├── widget/                   # Custom Reusable Widgets
│   │   ├── success_dialog.dart   # Modal dialog visual sukses (hijau)
│   │   └── warning_dialog.dart   # Modal dialog visual gagal / peringatan (merah)
│   └── main.dart                 # Root widget & Auto-login check (isLogin)
└── README.md
```

---

## 4. Penjelasan Arsitektur & Modul Lanjutan

### A. Helper Layer (`lib/helpers/`)
- **`user_info.dart`**: Menyimpan dan mengambil `token` autentikasi serta `userID` pengguna secara asinkron menggunakan `SharedPreferences`.
- **`app_exception.dart`**: Mengklasifikasikan error HTTP menjadi exception spesifik (`FetchDataException`, `BadRequestException`, `UnauthorisedException`, `InvalidInputException`) agar mudah ditangani pada antarmuka.
- **`api.dart`**: Mengirim permintaan HTTP dengan menyisipkan header `Authorization: Bearer <token>` secara otomatis serta mengevaluasi respon status kode.
- **`api_url.dart`**: Menyediakan endpoint URL terpusat sehingga mudah disesuaikan ketika berganti IP server atau domain.

### B. BLoC Layer (`lib/bloc/`)
- Memisahkan logika jaringan dari tampilan antarmuka (UI). UI hanya perlu memanggil method static pada BLoC (misal `ProdukBloc.getProduks()` atau `LoginBloc.login(...)`), dan BLoC akan mengurus serialisasi JSON serta komunikasi via Helper `Api`.

### C. Dialog Kustom (`lib/widget/`)
- **`SuccessDialog`**: Menampilkan popup berdesain kartu modern dengan ikon status sukses hijau ketika operasi registrasi berhasil.
- **`WarningDialog`**: Menampilkan popup peringatan merah ketika terjadi kesalahan login, gagal simpan, atau kesalahan jaringan.

### D. Fitur Auto-Login (`main.dart`)
- Saat aplikasi dibuka, method `isLogin()` memeriksa apakah terdapat `token` yang tersimpan pada `UserInfo`. Jika ditemukan, aplikasi otomatis langsung menampilkan `ProdukPage`, dan jika belum login diarahkan ke `LoginPage`.

---

## 5. Spesifikasi RESTful API

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
| 6 | **Update Produk** | `POST` / `PUT` | `/produk/{id}/update` atau `/produk/{id}` | `kode_produk`, `nama_produk`, `harga` | Memperbarui atribut data produk berdasarkan ID. |
| 7 | **Delete Produk** | `DELETE` | `/produk/{id}` | *-* | Menghapus record produk dari tabel database. |

---

## 6. Panduan Menjalankan Sistem

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
