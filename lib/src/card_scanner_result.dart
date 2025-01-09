import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:ocr_card_scanner/src/card_scanner_mask.dart';

/// A class containing all the card information retrieved from scanning.
class CardScannerResult {
  /// The payment card number. It is the card identifier.
  final String number;

  /// The mask (or pattern) presented in the card.
  final CardScannerMask mask;

  /// The Card Verification Value. Can be null if not found or recognized.
  final String? cvv;

  /// The expiry date. Can be null if not found or recognized.
  final String? expiry;

  const CardScannerResult({
    required this.number,
    required this.mask,
    required this.cvv,
    required this.expiry,
  });

  String get formattedNummber {
    final mask = MaskTextInputFormatter(mask: this.mask.numberMask);
    return mask.maskText(number);
  }

  @override
  int get hashCode => Object.hash(number, cvv, expiry);

  @override
  bool operator ==(Object other) {
    return other is CardScannerResult &&
        other.runtimeType == runtimeType &&
        other.number == number &&
        other.cvv == cvv &&
        other.expiry == expiry;
  }
}
