import 'package:flutter_test/flutter_test.dart';

import 'package:medibook/main.dart';
import 'package:medibook/providers/appointment_provider.dart';

void main() {
  testWidgets('Uygulama açılış ekranı yükleniyor', (WidgetTester tester) async {
    await tester.pumpWidget(
      MediBookApp(
        appointmentProvider: AppointmentProvider(),
      ),
    );

    expect(find.text('Giriş Yap'), findsOneWidget);
  });
}
