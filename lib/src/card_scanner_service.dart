import 'package:ocr_card_scanner/src/card_scanner_mask.dart';
import 'package:ocr_card_scanner/src/card_scanner_result.dart';

class CardScannerService {
  final List<CardScannerMask> masks;

  CardScannerService({required this.masks});

  bool checkLuhn(String ccNum) {
    if (ccNum.length < 2) {
      return false;
    }

    String cNum = ccNum.replaceAll(RegExp(r'\D'), '');
    int mod = cNum.length % 2;
    int sum = 0;

    try {
      for (int pos = cNum.length - 1; pos >= 0; pos--) {
        int digit = int.parse(cNum[pos]);

        if (pos % 2 == mod) {
          digit *= 2;
          if (digit > 9) {
            digit -= 9;
          }
        }

        sum += digit;
      }

      return sum % 10 == 0;
    } on Exception {
      return false;
    }
  }

  CardScannerMask? findMask(String input) {
    for (var mask in masks) {
      if (mask.numberRegex.hasMatch(input)) {
        return mask;
      }
    }
    return null;
  }

  CardScannerResult? parse(String text) {
    final cardMask = findMask(text);
    if (cardMask != null) {
      var input = text;
      final number = cardMask.numberRegex.stringMatch(text)!;
      input = input.replaceFirst(number, '');
      final cvv = cardMask.cvvRegex.stringMatch(input);
      if (cvv != null) {
        input = input.replaceFirst(cvv, '');
      }
      final expiration = cardMask.expirationRegex.stringMatch(input);

      return CardScannerResult(
        mask: cardMask,
        number: number.replaceAll(' ', ''),
        cvv: cvv,
        expiration: expiration,
      );
    } else {
      return null;
    }
  }
}
