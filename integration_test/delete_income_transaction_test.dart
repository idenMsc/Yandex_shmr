import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:shmr_25/main.dart' as app;
import 'package:flutter/material.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Добавление и удаление транзакции через ExpensesScreen и IncomeHistoryScreen', (WidgetTester tester) async {
    app.main();
    await tester.pumpAndSettle();

    // 1. Нажать на иконку plus для вызова TransactionCreateModal
    final plusButton = find.byIcon(Icons.add); // Замените на Icons.plus, если используется другая иконка
    expect(plusButton, findsOneWidget);
    await tester.tap(plusButton);
    await tester.pumpAndSettle();

    // 2. Заполнить все обязательные поля
    final amountField = find.byKey(ValueKey('amount_field'));
    expect(amountField, findsOneWidget);
    await tester.enterText(amountField, '12345'); // уникальная сумма

    final categoryDropdown = find.byKey(ValueKey('category_dropdown'));
    expect(categoryDropdown, findsOneWidget);
    await tester.tap(categoryDropdown);
    await tester.pumpAndSettle();
    final categoryOption = find.text('Еда').last; // замените на нужную категорию
    await tester.tap(categoryOption);
    await tester.pumpAndSettle();

    final dateField = find.byKey(ValueKey('date_field'));
    if (dateField.evaluate().isNotEmpty) {
      await tester.tap(dateField);
      await tester.pumpAndSettle();
      // Выберите сегодняшнюю дату или любую доступную
      final today = find.text(DateTime.now().day.toString());
      if (today.evaluate().isNotEmpty) {
        await tester.tap(today);
        await tester.pumpAndSettle();
        final okButton = find.text('OK');
        if (okButton.evaluate().isNotEmpty) {
          await tester.tap(okButton);
          await tester.pumpAndSettle();
        }
      }
    }

    final commentField = find.byKey(ValueKey('comment_field'));
    if (commentField.evaluate().isNotEmpty) {
      await tester.enterText(commentField, 'test comment');
    }

    // 3. Сохранить транзакцию
    final saveButton = find.text('Сохранить');
    expect(saveButton, findsOneWidget);
    await tester.tap(saveButton);
    await tester.pumpAndSettle();

    // 4. Перейти на экран истории через IconButton в appBar
    final historyButton = find.byIcon(Icons.history);
    expect(historyButton, findsOneWidget);
    await tester.tap(historyButton);
    await tester.pumpAndSettle();

    // 5. Найти транзакцию по уникальной сумме
    final transactionTile = find.text('12345');
    expect(transactionTile, findsOneWidget);

    // 6. Открыть экран редактирования
    await tester.tap(transactionTile);
    await tester.pumpAndSettle();

    // 7. Нажать кнопку "Удалить"
    final deleteButton = find.text('Удалить');
    expect(deleteButton, findsOneWidget);
    await tester.tap(deleteButton);
    await tester.pumpAndSettle();

    // 8. Проверить, что транзакция исчезла из списка
    expect(transactionTile, findsNothing);
  });
} 