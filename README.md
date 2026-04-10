**Ad Soyad:** Mohamed Ali Mohamed
**Öğrenci No:** 22080410213
**Üniversite:** Bitlis Eren Üniversitesi
**Bölüm:** Bilgisayar Mühendisliği

---

# MediBook — Akıllı Hastane Randevu Sistemi 🏥

MediBook, Flutter ile geliştirilmiş 6 adımlı akıllı bir hastane randevu sistemidir. Bu proje, gelişmiş form doğrulama (validation), state yönetimi, asenkron veri işleme ve dinamik arayüz (UI) oluşturma tekniklerini sergileyen kapsamlı bir final projesi olarak hazırlanmıştır. 

Proje, tam otomatik Maestro UI testleri ve Claude Code Review metriklerinden geçmek üzere özel olarak tasarlanmış olup, istenen tüm `ValueKey` tanımlayıcılarına ve katı mimari kurallara birebir uymaktadır.

## 🚀 Özellikler

* **Çok Adımlı Form Akışı:** İleri ve geri gezinmelerde girilen veriyi koruyan 6 farklı randevu adımı.
* **Gelişmiş Doğrulama (Validation):** TC Kimlik numarası için özel Luhn algoritması, e-posta Regex kontrolü ve özel telefon maskelemesi (`0(5XX) XXX XX XX`).
* **Dinamik Arayüz:** Seçilen sigorta türüne ve alerji durumuna göre ekranda anlık olarak beliren veya kaybolan koşullu (conditional) alanlar.
* **Bağımlı Seçimler (Cascading Dropdowns):** Şehir → Hastane → Bölüm → Doktor şeklinde ilerleyen ve üst seviye bir seçim değiştiğinde alt seviyeleri otomatik olarak sıfırlayan 4 aşamalı filtreleme.
* **Akıllı Takvim ve Saat:** Hafta sonlarını otomatik olarak devre dışı bırakan DatePicker ve sahte veri tabanındaki (mock data) dolu randevu saatlerini pasif (grileştirilmiş) duruma getiren dinamik saat ızgarası.
* **Taslak Kaydetme (Draft Saving):** Kullanıcının her adımda girdiği verilerin cihaz hafızasına (`SharedPreferences`) anlık olarak kaydedilmesi.
* **State Yönetimi:** Tüm uygulamanın çok adımlı durum yönetimi `Provider` paketi kullanılarak global seviyede sağlanmıştır.

---

## 🧪 Test Verileri (Test Credentials)

Uygulamayı test ederken Maestro testlerinden ve doğrulama (validation) kurallarından sorunsuz geçmek için aşağıdaki verileri kullanabilirsiniz:

**Giriş (Login) Bilgileri:**
* **E-posta:** `test@test.com` (veya kayıt ekranından oluşturacağınız herhangi bir e-posta)
* **Şifre:** `123456` (En az 6 karakter)

**Geçerli TC Kimlik Numaraları:**
Luhn algoritmasını geçen ve `mock_data` içerisinde tanımlı olan TC Kimlik numaraları:
* `10000000146`
* `20000000146`
* `30000000146`

**Telefon Numarası Formatı:**
* `0555 123 45 67` şeklinde klavyeden girildiğinde maske otomatik olarak `0(555) 123 45 67` formatına çevirecektir.

---

## 🛠 Teknik Altyapı ve Mimari

* **Framework:** Flutter (Dart)
* **Paket Adı:** `com.bmu1422.medibook`
* **State Yönetimi:** `Provider`
* **Yerel Depolama:** `SharedPreferences`
* **Klasör Yapısı:** Clean Architecture prensiplerine uygun ayrım (`models/`, `providers/`, `screens/`, `services/`, `widgets/`)

---

## 🤖 AI Asistan Kullanımı

Bu proje; kod mimarisinin hızla kurulması, otomatik test kurallarının (ValueKey'ler) eksiksiz entegre edilmesi ve karmaşık state yönetimi süreçlerinin hatasız yürütülmesi amacıyla yapay zeka kodlama asistanları yardımıyla geliştirilmiştir.

* **Kullanılan AI Asistanları:** Arayüz tasarımı promptlarının oluşturulması (prompt stitch) ve süreç planlaması için **Gemini**, kodlama süreçleri için ise **Codex Agent** kullanılmıştır.

### 5 Örnek Prompt

Geliştirme süreci boyunca AI asistanını yönlendirmek için kullanılan İngilizce komutlardan 5 tanesi aşağıdadır:

**Prompt 1: Proje Kurulumu ve Kuralların Tanımlanması**
> "You are an expert Flutter developer. We are building 'MediBook', a 6-step medical appointment wizard. Before generating any code, you MUST read the `AGENTS.md` file to understand the strict project rules, folder structure, mandatory widget keys, and validation requirements. Create a new Flutter project with the exact package name `com.bmu1422.medibook` and set up the `Provider` architecture above `MaterialApp`."

**Prompt 2: Ana UI (Arayüz) Tasarım Komutu**
> "Create a comprehensive, high-fidelity, multi-screen mobile application UI for a Smart Hospital Appointment System called 'MediBook'. The overall color palette should be: Primary Medical Blue (#1E88E5), White surfaces (#FFFFFF), Light Gray background (#F8F9FA). Generate a storyboard/flow showing 6 steps, including a DatePicker where weekends are disabled, cascading dropdowns for doctors, and an exact UI matching the Maestro test requirements. All visible UI text MUST be in Turkish."

**Prompt 3: Karmaşık Doğrulama (Validation) Mantığı**
> "Let's implement the Validator logic and Steps 1-3. Create a robust `validator_service.dart`. Implement an exact 11-digit TC Kimlik Luhn algorithm validator, an Email Regex validator, and a phone mask formatted exactly as `0(5XX) XXX XX XX`. For Step 3, read `placeholder_data.json` to power 4 cascading dropdowns (Şehir -> Hastane -> Bölüm -> Doktor). If a user changes the City, you MUST clear the selected Hospital, Department, and Doctor."

**Prompt 4: DatePicker ve Saat Dilimi Mantığı**
> "Finish the MediBook wizard by implementing Steps 4 to 6. Implement a DatePicker that completely disables weekends. Generate a grid of 30-minute time slots. Cross-reference the selected date and doctor with `booked_slots` from our JSON data. If a slot is booked, make it visually disabled (greyed out) and unselectable using the dynamic key `ValueKey('slot_${saat}')`."

**Prompt 5: Final Kalite Kontrol (QA) ve Maestro Testi Denetimi**
> "Act as an aggressive QA Tester. Perform a deep audit of the entire codebase to guarantee this app scores 15/15 on the automated Maestro UI tests. Verify the empty submit validation, the TC Kimlik Luhn algorithm, that Provider preserves state when navigating back and forth, and do a global search to confirm absolutely ALL 30 static keys and 2 dynamic keys exist and have no typos."