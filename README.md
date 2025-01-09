<!--
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/guides/libraries/writing-package-pages).

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-library-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/developing-packages).
-->

# ocr_card_scanner
A Flutter package to scan credit card details using Optical Character Recognition.

## Features

- ✅ Scans card number, expiry date and CVV
- ✅ Supports horizontal and vertical cards
- ✅ Uses Luhn Algorithm for number validation (optional)
- ✅ Supports most of major credit card brands, like Amex, Dinners Club, Visa, Mastercard, Maestro etc
- 🚀 Great performance and confidence

## Requirements
Since this package uses [Google ML Kit](https://pub.dev/packages/google_mlkit_commons), check this [requirements](https://github.com/flutter-ml/google_ml_kit_flutter#requirements) before using the package.

## Usage

1. Follow the install guide
2. Import the library
   ```dart
   import 'package:ocr_card_scanner/ocr_card_scanner.dart';
   ```
3. Open the card scanner
   ```dart
   final result = await showDialog<CardScannerResult>(
     context: context,
     builder: (context) => CardScannerWidget(
       service: CardScannerService(
         masks: CardScannerMasks.all,
       ),
     ),
   );
   ```
4. Use the result
   ```dart
   if (result != null && mounted) {
        setState(() {
            _ccNumController.text = result.formattedNumber;
            _cvvController.text = result.cvv ?? '';
            _expiryController.text = result.expiry ?? '';
        });
   }
   ```
