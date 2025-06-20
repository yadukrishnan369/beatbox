class AmountFormatter {
  // amount formatting
  static String format(double amount) {
    return amount
        .toStringAsFixed(1)
        .replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]},',
        );
  }
}
