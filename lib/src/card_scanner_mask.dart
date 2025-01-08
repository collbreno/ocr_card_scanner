class CardScannerMask {
  final RegExp cvvRegex;
  final RegExp numberRegex;
  final RegExp expirationRegex;

  CardScannerMask({
    required String cvvMask,
    required String numberMask,
  })  : cvvRegex = _maskToRegExp(cvvMask),
        numberRegex = _maskToRegExp(numberMask),
        expirationRegex = RegExp(r'(?<=^| )\d{2}/(\d{2}|\d{4})(?=$| )');

  static RegExp _maskToRegExp(String mask) {
    String regex = RegExp.escape(mask).replaceAll('#', r'\d');
    return RegExp(r'(?<=^| )' + regex + r'(?=$| )');
  }
}

abstract class CardScannerMasks {
  static final americanExpress = CardScannerMask(
    cvvMask: '####',
    numberMask: '#### ###### #####',
  );

  static final dinnersClub = CardScannerMask(
    cvvMask: '###',
    numberMask: '#### ###### ####',
  );

  static final generic13 = CardScannerMask(
    cvvMask: '###',
    numberMask: '#### ### ## ####',
  );

  static final generic16 = CardScannerMask(
    cvvMask: '###',
    numberMask: '#### #### #### ####',
  );

  static final all = [
    americanExpress,
    dinnersClub,
    generic13,
    generic16,
  ];
}
