class ValidatorService {
  static final RegExp _emailPattern = RegExp(
    r'^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$',
  );

  static final RegExp _lettersPattern = RegExp(
    r"^[A-Za-zÇçĞğİıÖöŞşÜü\s'-]{2,}$",
  );

  static String? requiredField(String? value, {String fieldName = 'Bu alan'}) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName zorunludur.';
    }
    return null;
  }

  static String? validateName(String? value, {String fieldName = 'Ad'}) {
    final requiredError = requiredField(value, fieldName: fieldName);
    if (requiredError != null) {
      return requiredError;
    }

    final normalized = value!.trim();
    if (!_lettersPattern.hasMatch(normalized)) {
      return '$fieldName en az 2 harf içermelidir.';
    }
    return null;
  }

  static String? validateEmail(String? value) {
    final requiredError = requiredField(value, fieldName: 'E-posta');
    if (requiredError != null) {
      return requiredError;
    }

    if (!_emailPattern.hasMatch(value!.trim())) {
      return 'Geçerli bir e-posta adresi giriniz.';
    }
    return null;
  }

  static String? validatePassword(String? value) {
    final requiredError = requiredField(value, fieldName: 'Şifre');
    if (requiredError != null) {
      return requiredError;
    }

    if (value!.trim().length < 6) {
      return 'Şifre en az 6 karakter olmalıdır.';
    }
    return null;
  }

  static String? validatePhone(String? value) {
    final requiredError = requiredField(value, fieldName: 'Telefon');
    if (requiredError != null) {
      return requiredError;
    }

    if ((value ?? '').trim().length != 15) {
      return 'Telefon numarası 0(5XX) XXX XX XX formatında olmalıdır.';
    }
    return null;
  }

  static String? validateTcKimlik(String? value) {
    final requiredError = requiredField(value, fieldName: 'TC Kimlik');
    if (requiredError != null) {
      return requiredError;
    }

    final normalized = value!.replaceAll(RegExp(r'\s+'), '');
    if (!RegExp(r'^\d{11}$').hasMatch(normalized)) {
      return 'TC Kimlik numarası 11 haneli olmalıdır.';
    }

    if (normalized.startsWith('0')) {
      return 'TC Kimlik numarası 0 ile başlayamaz.';
    }

    final digits = normalized.split('').map(int.parse).toList(growable: false);
    final oddSum = digits[0] + digits[2] + digits[4] + digits[6] + digits[8];
    final evenSum = digits[1] + digits[3] + digits[5] + digits[7];
    final tenthDigit = ((oddSum * 7) - evenSum) % 10;
    final eleventhDigit =
        digits.take(10).reduce((value, element) => value + element) % 10;

    if (digits[9] != tenthDigit || digits[10] != eleventhDigit) {
      return 'Geçerli bir TC Kimlik numarası giriniz.';
    }

    return null;
  }

  static Future<String?> validateUniqueTcKimlik(
    String value,
    List<String> existingTcs,
  ) async {
    await Future<void>.delayed(const Duration(milliseconds: 250));
    if (existingTcs.contains(value)) {
      return 'Bu TC Kimlik numarası sistemde kayıtlıdır.';
    }
    return null;
  }
}
