# MediBook App — Developer Agent Instructions & Rules

**CONTEXT:** This is a 6-step medical appointment wizard app built in Flutter. The code will be strictly evaluated by an automated testing pipeline (Maestro UI tests + Claude Code Review). Any deviation from the rules below will result in test failures and point deductions.

**CRITICAL PACKAGE RULE:** The app package name MUST exactly be `com.bmu1422.medibook`.

## 0. Design Reference & Visual Accuracy
Before writing any UI code, you MUST inspect and read all visual design screens located in the `app_design/` folder in the root directory. 
* Your Flutter code must accurately reflect the layout, spacing, typography, and UX flow shown in those mockups.
* **Color Palette:** Match the exact colors from the design (Primary Medical Blue `#1E88E5`, Background `#F8F9FA`, Surface `#FFFFFF`, Success Green `#4CAF50`).
* **Language:** All visible UI text generated in the code must remain in Turkish, exactly as depicted in the `app_design/` mockups.

## 1. Mandatory Folder Structure
To pass the "Claude Code Review" metric, the `lib/` folder must strictly follow this separation of concerns:
```text
lib/
 ├── models/       # Data classes (e.g., Patient, Appointment, Doctor)
 ├── providers/    # State management files (e.g., AppointmentProvider)
 ├── screens/      # UI screens for the 6 wizard steps and Auth
 ├── services/     # Business logic, Validators, API Mocks, SharedPreferences
 ├── widgets/      # Reusable UI components (Custom Inputs, Cards, etc.)
 └── main.dart     # Entry point, initializes Provider above MaterialApp

 2. State Management & Persistence
Global State: Use Provider for state management. The Provider MUST be placed above MaterialApp in main.dart.

Multi-step State: Data must be preserved when navigating back and forth between the 6 steps.

Draft Saving: Use SharedPreferences to save form drafts automatically after every step so the user doesn't lose progress if the app restarts.

3. Validation Rules (Strict)
Name/Surname: Only letters allowed, minimum 2 characters.

TC Identity (TC Kimlik): Must be exactly 11 digits and pass a custom Luhn-like algorithm validator.

TC Async Validation: Must check against a mock API/list to ensure the TC is unique/valid.

Phone Number: Must use an input mask formatted exactly as: 0(5XX) XXX XX XX.

Email: Must be validated using Regex.

Keyboard Management: Assign appropriate KeyboardType (number, email, multiline) to each field and implement Next action flow.

Accessibility: Use Semantics labels on all interactive elements (buttons, inputs) for screen reader compatibility.

4. Step-by-Step Logic Requirements
Step 1: Maximum date for DatePicker is today.

Step 2 (Conditional Logic): "Sigorta Firması" input is ONLY visible if "Özel" is selected from the insurance dropdown. "Alerji Detayı" textarea is ONLY visible if the Allergy switch is toggled ON.

Step 3 (Cascading Dropdowns): 4 levels (City → Hospital → Department → Doctor). If a higher-level selection changes, all lower-level selections MUST be reset/cleared.

Step 4 (Date & Time): DatePicker must disable weekends and holidays. 30-minute time slots must be generated; booked slots must be greyed out and unselectable.

Step 5: "KVKK" and "Açık Rıza" checkboxes are mandatory to proceed.

Step 6: Display a full summary. Calculate a mock total price. Generate a UUID upon successful submission and show a success screen.

5. GitHub & Build Constraints (Penalty Avoidance)
Do NOT commit the build/, .dart_tool/, or .idea/ folders. Ensure they are in .gitignore.

.gitattributes must include * text=auto for Windows/Mac compatibility.

pubspec.lock MUST be committed to the repository.

The code must compile perfectly (flutter build apk). If the APK build fails, the score is an automatic 0.

6. MANDATORY WIDGET KEYS (UI Testing Requirements)
The Maestro automated testing suite relies entirely on ValueKey to find and interact with widgets. If these keys are missing or mistyped, the tests will fail. Inject these exactly as written into the corresponding Flutter widgets:

Step 1 - Kişisel Bilgiler (9 Keys)
TextFormField(key: const ValueKey('input_ad'), ...)

TextFormField(key: const ValueKey('input_soyad'), ...)

TextFormField(key: const ValueKey('input_tc'), ...)

TextFormField(key: const ValueKey('input_email'), ...)

TextFormField(key: const ValueKey('input_telefon'), ...)

TextFormField(key: const ValueKey('input_dogum'), ...)

TextFormField(key: const ValueKey('input_adres'), ...)

Radio(key: const ValueKey('radio_erkek'), ...)

Radio(key: const ValueKey('radio_kadin'), ...)

Step 2 - Sigorta (4 Keys)
DropdownButton(key: const ValueKey('dropdown_sigorta'), ...)

TextFormField(key: const ValueKey('input_sigorta_firma'), ...)

Switch(key: const ValueKey('switch_alerji'), ...)

TextFormField(key: const ValueKey('input_alerji_aciklama'), ...)

Step 3 - Bölüm/Doktor (5 Keys)
DropdownButton(key: const ValueKey('dropdown_sehir'), ...)

DropdownButton(key: const ValueKey('dropdown_hastane'), ...)

DropdownButton(key: const ValueKey('dropdown_bolum'), ...)

DropdownButton(key: const ValueKey('dropdown_doktor'), ...)

ListTile(key: ValueKey('doktor_item_$index'), ...) (Dynamic Key)

Step 4 - Tarih/Saat (4 Keys)
ElevatedButton(key: const ValueKey('btn_tarih_sec'), ...)

InkWell(key: ValueKey('slot_${saat}'), ...) (Dynamic Key)

Switch(key: const ValueKey('switch_acil'), ...)

TextFormField(key: const ValueKey('input_notlar'), ...)

Step 5 - Ek Hizmetler (7 Keys)
FilterChip(key: const ValueKey('chip_kan_tahlili'), ...)

FilterChip(key: const ValueKey('chip_mr'), ...)

FilterChip(key: const ValueKey('chip_rontgen'), ...)

IconButton(key: const ValueKey('stepper_refakatci_plus'), ...)

IconButton(key: const ValueKey('stepper_refakatci_minus'), ...)

Checkbox(key: const ValueKey('checkbox_kvkk'), ...)

Checkbox(key: const ValueKey('checkbox_acik_riza'), ...)

Global Navigation (3 Keys - MUST be present on steps 1-5)
ElevatedButton(key: const ValueKey('btn_ileri'), ...)

ElevatedButton(key: const ValueKey('btn_geri'), ...)

ElevatedButton(key: const ValueKey('btn_onayla'), ...) (Only Step 6)