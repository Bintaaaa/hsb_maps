import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hsb_kurir/main.dart';
import 'package:integration_test/integration_test.dart';

void main(){
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets("Invalid Credential", (tester) async {
    await tester.pumpWidget(MyApp());
    
    await tester.enterText(find.byKey(const Key("loginUsername")), "text");
    await tester.pump(const Duration(seconds: 3));


    await tester.enterText(find.byKey(const Key("loginPassword")), "text");
    await tester.pump(const Duration(seconds: 3));

    await tester.tap(find.byKey(const Key("loginButton")));
    await tester.pump(const Duration(seconds: 3));

    expect(find.byKey(const Key("loginErrorDialog")), findsOneWidget);

    await tester.tap(find.byKey(const Key("ok_button")));
    await tester.pumpAndSettle();
    await tester.pump(const Duration(seconds: 3));

    expect(find.byKey(const Key("loginErrorDialog")), findsNothing);
  });


  testWidgets("Valid Credential", (tester) async {
    await tester.pumpWidget(MyApp());
    
    await tester.enterText(find.byKey(const Key("loginUsername")), "kurir");
    await tester.pump(const Duration(seconds: 3));


    await tester.enterText(find.byKey(const Key("loginPassword")), "123456");
    await tester.pump(const Duration(seconds: 3));

    await tester.tap(find.byKey(const Key("loginButton")));
    await tester.pump(const Duration(seconds: 3));

    expect(find.text("Daftar Tugas"), findsOneWidget);
    await tester.pump(const Duration(seconds: 5));

    await tester.tap(find.text('Kirim Dokumen Kontrak'));
    await tester.pumpAndSettle();
    await tester.pump(const Duration(seconds: 5));
    expect(find.text("Detail Tugas"), findsOneWidget);
  });
}


