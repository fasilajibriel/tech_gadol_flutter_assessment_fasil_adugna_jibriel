// import 'package:intl/intl.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class Utils {
  // static final NumberFormat currencyFormatter = NumberFormat.currency(
  //   locale: "en_US",
  //   symbol: "ETB ",
  // );

  static Future<bool> hasInternetConnection() async {
    return InternetConnectionChecker.instance.hasConnection;
  }
}
