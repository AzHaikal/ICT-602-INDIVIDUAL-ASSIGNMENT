# ICT602 – SkyBaggage (Flutter)

An individual Mobile Technology Assignment app to calculate excess baggage charges for air travel, following the provided 2-page ICT602 assignment brief.

## 1. Cara buka projek dalam VS Code

Pastikan Flutter SDK, Android SDK, dan VS Code extensions **Flutter** dan **Dart** sudah dipasang.

1. Extract ZIP ini.
2. Buka VS Code → **File → Open Folder** → pilih folder `ict602_baggage_calculator` yang diekstrak.
3. Buka **Terminal → New Terminal** dan jalankan:

   ```bash
   flutter create .
   flutter pub get
   dart run flutter_launcher_icons
   flutter run
   ```

   `flutter create .` menjana folder asli Android/iOS yang tidak disertakan dalam ZIP ini. Ia diperlukan sekali sahaja. Pastikan nama folder projek menggunakan huruf kecil dan underscore seperti `ict602_baggage_calculator`.

4. Sebelum `flutter run`, pilih Android emulator dalam VS Code (bahagian kanan bawah) atau sambungkan telefon Android menggunakan USB debugging.
5. Untuk jalankan ujian pengiraan:

   ```bash
   flutter test
   ```

Jika menggunakan Windows PowerShell, arahan di atas adalah sama. Jika emulator tiada, buka Android Studio → Device Manager → Create Virtual Device, kemudian start emulator.

## 2. Apa yang mesti tukar sebelum submit

Dalam `lib/main.dart`, cari bahagian `CUSTOMIZE THESE DETAILS BEFORE SUBMISSION`:

- `authorName`: nama pelajar (telah diisi dan boleh dikemaskini)
- `matricNumber`: **WAJIB ganti** dengan nombor matrik sebenar
- `courseName`: `ICT602` (boleh tambahkan nama kursus jika perlu)
- `githubRepositoryUrl`: **WAJIB ganti** dengan pautan repo GitHub projek ini seperti `https://github.com/USERNAME/ict602_baggage_calculator`

Link GitHub asal (`https://github.com/`) dibuka dengan butang About, tetapi **belum memenuhi syarat URL repositori milik anda** sehingga dikemaskini.

## 3. Fungsi aplikasi

- **Input 1:** checked baggage weight (kg) – TextFormField.
- **Input 2:** class Economy / Business – SegmentedButton (widget input lain).
- **Input 3:** excess baggage rate (RM/kg) – TextFormField.
- **Output 1:** excess baggage weight (kg; tidak negatif).
- **Output 2:** excess baggage charge (RM).
- **Output 3:** total amount payable (RM; sudah termasuk service tax 8%).
- Papar caj cukai 8% secara tambahan untuk memudahkan semakan.
- Input kosong, bukan nombor atau nombor negatif akan paparkan mesej ralat.
- Home dan About dalam bottom navigation menu; tajuk aplikasi sentiasa dipaparkan.
- About ada app icon, nama, matric, course, copyright, dan pautan GitHub yang boleh ditekan.
- Theme, title bar, dan ikon khas; arahan ringkas, helper texts, snackbar berjaya, reset.

### Formula

```
allowanceKg = economy ? 20 : 40
excessKg = max(0, baggageKg - allowanceKg)
chargeRm = excessKg * ratePerKgRm
taxRm = chargeRm * 0.08
totalRm = chargeRm + taxRm
```

### Test case daripada PDF assignment

| Weight (kg) | Ticket class | RM/kg | Excess (kg) | Charge (RM) | Total (RM) |
|---:|---|---:|---:|---:|---:|
| 25 | Economy | 15 | 5 | 75.00 | **81.00** |
| 18 | Economy | 15 | 0 | 0.00 | **0.00** |
| 55 | Business | 12 | 15 | 180.00 | **194.40** |
| 42.5 | Business | 12 | 2.5 | 30.00 | **32.40** |

## 4. Upload kod ke GitHub

Selepas projek boleh run:

1. Cipta **new repository** pada GitHub, misalnya `ict602_baggage_calculator`.
2. Upload semua fail projek; jangan upload folder `build/` dan `.dart_tool/`.
3. Copy URL repo sebenar dan masukkan dalam `githubRepositoryUrl` di `lib/main.dart`.
4. Run semula app, buka tab **About**, tekan **Open GitHub Repository** dan pastikan repo dibuka.
5. Pastikan `matricNumber` bukan lagi placeholder.

## 5. Demo semasa presentation (Week 8 – Lab)

1. **Home**: terangkan 3 input dan class allowance (Economy 20 kg, Business 40 kg).
2. Input `25`, pilih Economy, rate `15` → **RM81.00**.
3. Input `18`, Economy, rate `15` → **RM0.00** (tidak boleh berat negatif).
4. Input `55`, Business, rate `12` → **RM194.40**.
5. Input `42.5`, Business, rate `12` → **RM32.40**.
6. Cuba input kosong atau `-5` → tunjuk error message; tekan Reset.
7. Buka **About** → tunjuk icon, nama, matric, course, copyright, URL GitHub yang boleh ditekan.

**Tarikh dalam brief:** Present pada *Week 8 Lab session*. GitHub source code URL melalui UFuture sebelum **11:55 PM, Week 8**. Sahkan tarikh Week 8 sebenar dengan jadual kursus.

## Notes

The ZIP contains the app source, a custom 1024×1024 PNG launcher icon, icon generator configuration, and five unit test cases. It does **not** include generated Android/iOS platform folders or compiled APK. A Flutter SDK is not available in the authoring environment, so the app has not been runtime-tested here. Run `flutter create .`, `flutter pub get`, `flutter test` and `flutter run` locally before submission.
