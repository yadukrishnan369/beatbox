import 'package:beatbox/core/notifiers/sales_notifier.dart';
import 'package:beatbox/features/sales_management/model/sales_model.dart';
import 'package:hive/hive.dart';

class SalesController {
  static const String _boxName = 'salesBox';
  static late Box<SalesModel> _salesBox;

  // initialize box
  static Future<void> initBox() async {
    if (!Hive.isBoxOpen(_boxName)) {
      _salesBox = await Hive.openBox<SalesModel>(_boxName);
    } else {
      _salesBox = Hive.box<SalesModel>(_boxName);
    }
    _refreshNotifier();
  }

  // add a new sale and refresh notifier
  static Future<void> addSale(SalesModel sale) async {
    await _salesBox.add(sale);
    _refreshNotifier();
  }

  // get all sales
  static List<SalesModel> getAllSales() {
    return _salesBox.values.toList()
      ..sort((a, b) => b.billingDate.compareTo(a.billingDate));
  }

  // get total sold items
  static int getTotalSoldItems() {
    return _salesBox.values
        .expand((sale) => sale.cartItems)
        .fold(0, (sum, item) => sum + item.quantity);
  }

  // get total number of sales
  static int getSalesCount() {
    return _salesBox.length;
  }

  // delete a single sale by index
  static Future<void> deleteSale(int index) async {
    await _salesBox.deleteAt(index);
    _refreshNotifier();
  }

  // refresh notifier with all sales
  static void _refreshNotifier() {
    final sortedList =
        _salesBox.values.toList()
          ..sort((a, b) => b.billingDate.compareTo(a.billingDate));
    filteredSalesNotifier.value = [...sortedList];
  }
}
