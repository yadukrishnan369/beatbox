import 'package:hive/hive.dart';

class GSTUtils {
  static const _boxName = 'gstBox';
  static const _key = 'gst_rate';

  //fetch GST rate
  static double getGSTPercentage() {
    final box = Hive.box(_boxName);
    return box.get(_key, defaultValue: 0.0);
  }

  // save GST rate
  static Future<void> setGSTRate(double value) async {
    final box = Hive.box(_boxName);
    await box.put(_key, value);
  }
}
