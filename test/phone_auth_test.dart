import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lmrepaircrmapp/directcomplaintpage.dart';

void main() {
  Widget createWidgetUnderTest() {
    return const MaterialApp(
      home: DirectCustomerAuthPage(),
    );
  }

  group('DirectCustomerAuthPage - Phone Auth Tests', () {
    testWidgets('Renders initial Phone Auth UI elements correctly', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      expect(find.text('Customer Phone Verification'), findsOneWidget);
      expect(find.text('Direct Complaint Registration'), findsOneWidget);
      expect(find.text('Verify your mobile number to register a new complaint'), findsOneWidget);
      expect(find.byType(TextFormField), findsOneWidget);
      expect(find.text('Phone Number'), findsOneWidget);
      expect(find.text('Send OTP'), findsOneWidget);
    });

    testWidgets('Shows error if phone number is empty on Send OTP', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Send OTP'));
      await tester.pump();

      expect(find.text('Please enter a valid 10-digit phone number'), findsOneWidget);
    });

    testWidgets('Shows error if phone number has less than 10 digits', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextFormField), '98765');
      await tester.tap(find.text('Send OTP'));
      await tester.pump();

      expect(find.text('Please enter a valid 10-digit phone number'), findsOneWidget);
    });

    testWidgets('Transition to OTP screen when valid 10-digit phone number is submitted', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextFormField), '9876543210');
      await tester.tap(find.text('Send OTP'));
      await tester.pumpAndSettle();

      // Should now show OTP field and Verify button
      expect(find.text('Enter 6-Digit OTP'), findsOneWidget);
      expect(find.text('Verify OTP & Continue'), findsOneWidget);
      expect(find.text('Change Phone Number'), findsOneWidget);
    });

    testWidgets('Shows error if OTP is less than 6 digits', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      // Enter phone number and send OTP
      await tester.enterText(find.byType(TextFormField), '9876543210');
      await tester.tap(find.text('Send OTP'));
      await tester.pumpAndSettle();

      // Enter short OTP (3 digits)
      final otpField = find.widgetWithText(TextFormField, 'Enter 6-Digit OTP');
      await tester.enterText(otpField, '123');
      await tester.tap(find.text('Verify OTP & Continue'));
      await tester.pump();

      expect(find.text('Please enter a valid 6-digit OTP'), findsOneWidget);
    });

    testWidgets('Change Phone Number button resets state to phone input', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      // Send OTP
      await tester.enterText(find.byType(TextFormField), '9876543210');
      await tester.tap(find.text('Send OTP'));
      await tester.pumpAndSettle();

      expect(find.text('Enter 6-Digit OTP'), findsOneWidget);

      // Tap Change Phone Number
      await tester.tap(find.text('Change Phone Number'));
      await tester.pumpAndSettle();

      // OTP field should disappear and Send OTP button should return
      expect(find.text('Enter 6-Digit OTP'), findsNothing);
      expect(find.text('Send OTP'), findsOneWidget);
    });

    testWidgets('Successful OTP verification navigates to Complaint Registration with verified phone locked', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      // 1. Enter phone number
      await tester.enterText(find.byType(TextFormField), '9876543210');
      await tester.tap(find.text('Send OTP'));
      await tester.pumpAndSettle();

      // 2. Enter 6-digit OTP
      final otpField = find.widgetWithText(TextFormField, 'Enter 6-Digit OTP');
      await tester.enterText(otpField, '123456');
      await tester.tap(find.text('Verify OTP & Continue'));
      await tester.pumpAndSettle();

      // 3. Verify DirectComplaintRegistrationPage is displayed
      expect(find.byType(DirectComplaintRegistrationPage), findsOneWidget);
      expect(find.text('Direct Complaint Form'), findsOneWidget);
      expect(find.text('+919876543210'), findsOneWidget);
      expect(find.text('Verified'), findsOneWidget);
    });
  });
}
