import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lmrepaircrmapp/directcomplaintpage.dart';

void main() {
  group('DirectCustomerAuthPage UI & Validation Tests', () {
    Widget createAuthWidget() {
      return const MaterialApp(
        home: DirectCustomerAuthPage(),
      );
    }

    testWidgets('Renders initial Phone Auth UI elements correctly', (WidgetTester tester) async {
      await tester.pumpWidget(createAuthWidget());
      await tester.pumpAndSettle();

      expect(find.text('Customer Phone Verification'), findsOneWidget);
      expect(find.text('Direct Complaint Registration'), findsOneWidget);
      expect(find.text('Verify your mobile number to register a new complaint'), findsOneWidget);
      expect(find.byType(TextFormField), findsOneWidget);
      expect(find.text('Phone Number'), findsOneWidget);
      expect(find.text('Send OTP'), findsOneWidget);
    });

    testWidgets('Shows error if phone number is empty on Send OTP', (WidgetTester tester) async {
      await tester.pumpWidget(createAuthWidget());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Send OTP'));
      await tester.pump();

      expect(find.text('Please enter a valid 10-digit phone number'), findsOneWidget);
    });

    testWidgets('Shows error if phone number has less than 10 digits', (WidgetTester tester) async {
      await tester.pumpWidget(createAuthWidget());
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextFormField), '98765');
      await tester.tap(find.text('Send OTP'));
      await tester.pump();

      expect(find.text('Please enter a valid 10-digit phone number'), findsOneWidget);
    });

    testWidgets('Displays real error message when Firebase platform service is unavailable', (WidgetTester tester) async {
      await tester.pumpWidget(createAuthWidget());
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextFormField), '9876543210');
      await tester.tap(find.text('Send OTP'));
      await tester.pumpAndSettle();

      // Since mock fallback was removed, real error is captured & displayed
      expect(find.byIcon(Icons.error_outline), findsOneWidget);
    });
  });

  group('DirectComplaintRegistrationPage Form Tests', () {
    Widget createRegistrationWidget(String verifiedPhone) {
      return MaterialApp(
        home: DirectComplaintRegistrationPage(
          verifiedPhoneNumber: verifiedPhone,
        ),
      );
    }

    testWidgets('Displays locked verified phone number badge', (WidgetTester tester) async {
      const testPhone = '+919876543210';
      await tester.pumpWidget(createRegistrationWidget(testPhone));
      await tester.pumpAndSettle();

      expect(find.text('Direct Complaint Form'), findsOneWidget);
      expect(find.text(testPhone), findsOneWidget);
      expect(find.text('Verified'), findsOneWidget);
      expect(find.text('Customer Name *'), findsOneWidget);
      expect(find.text('Address *'), findsOneWidget);
      expect(find.text('Category *'), findsOneWidget);
    });

    testWidgets('Validates required fields on submission', (WidgetTester tester) async {
      await tester.pumpWidget(createRegistrationWidget('+919876543210'));
      await tester.pumpAndSettle();

      // Scroll to submit button and tap
      final submitButton = find.text('Submit Complaint');
      await tester.ensureVisible(submitButton);
      await tester.tap(submitButton);
      await tester.pumpAndSettle();

      expect(find.text('Please enter your name'), findsOneWidget);
      expect(find.text('Please enter address'), findsOneWidget);
      expect(find.text('Please select a category'), findsOneWidget);
    });
  });
}
