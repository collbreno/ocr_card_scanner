import 'package:ocr_card_scanner/src/card_scanner_mask.dart';

class CardScannerResult {
  final String number;
  final CardScannerMask mask;
  final String? cvv;
  final String? expiration;

  const CardScannerResult({
    required this.number,
    required this.mask,
    required this.cvv,
    required this.expiration,
  });

  @override
  int get hashCode => Object.hash(number, cvv, expiration);

  @override
  bool operator ==(Object other) {
    return other is CardScannerResult &&
        other.runtimeType == runtimeType &&
        other.number == number &&
        other.cvv == cvv &&
        other.expiration == expiration;
  }
}
