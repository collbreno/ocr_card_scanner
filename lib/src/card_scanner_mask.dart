/// A simple class for defining the pattern that should be accepted as card number
/// and card verification value.
/// Can be used to format the card number when writing it into a TextField:
/// ```setState(() {
///        _ccNumController.text = MaskTextInputFormatter(mask: result.mask.numberMask)
///                                 .maskText(result.number);
///});```
class CardScannerMask {
  final RegExp cvvRegex;
  final RegExp numberRegex;
  final RegExp expirationRegex;
  final String numberMask;

  CardScannerMask({
    required String cvvMask,
    required this.numberMask,
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
