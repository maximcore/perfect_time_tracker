import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:perfect_time_tracker/common_widgets/custom_elevated_button.dart';

void main() {
  testWidgets('onPressed callback', (WidgetTester tester) async {
    var pressed = false;
    await tester.pumpWidget(MaterialApp(
        home: CustomElevatedButton(
      onPressed: () => pressed = true,
    )));
    final button = find.byType(ElevatedButton);
    expect(button, findsOneWidget);
    expect(find.byType(Container), findsNothing);
    await tester.tap(button);
    expect(pressed, true);
  });
}
