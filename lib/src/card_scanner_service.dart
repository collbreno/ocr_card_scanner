import 'package:ocr_card_scanner/src/card_scanner_mask.dart';
import 'package:ocr_card_scanner/src/card_scanner_result.dart';

class CardScannerService {
  final List<CardScannerMask> masks;

  CardScannerService({required this.masks});

  bool checkLuhn(String input) {
    try {
      final ccNum = input.replaceAll(RegExp(r'\D'), '');
      var sum = 0;
      var isSecond = false;
      for (var i = ccNum.length - 1; i >= 0; i--) {
        var d = int.parse(ccNum[i]);
        if (isSecond) {
          d *= 2;
          if (d > 9) {
            d -= 9;
          }
        }
        sum += d;
        isSecond = !isSecond;
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
