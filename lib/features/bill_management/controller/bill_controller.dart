import 'package:beatbox/core/notifiers/bill_notifier.dart';
import 'package:hive/hive.dart';
import 'package:beatbox/features/sales_management/model/sales_model.dart';

class BillController {
  static const String _boxName = 'salesBox';
  static late Box<SalesModel> _salesBox;

  static Future<void> initBox() async {
    if (!Hive.isBoxOpen(_boxName)) {
      _salesBox = await Hive.openBox<SalesModel>(_boxName);
    } else {
      _salesBox = Hive.box<SalesModel>(_boxName);
    }
    _refreshBillNotifier();
  }

  static void _refreshBillNotifier() {
    final sortedList =
        _salesBox.values.toList()
          ..sort((a, b) => b.billingDate.compareTo(a.billingDate));
    filteredBillNotifier.value = [...sortedList];
  }
}
