import 'package:flutter_test/flutter_test.dart';
import 'package:ocr_card_scanner/src/card_scanner_mask.dart';
import 'package:ocr_card_scanner/src/card_scanner_service.dart';

void main() {
  late CardScannerService service;

  setUp(() {
    service = CardScannerService(masks: CardScannerMasks.all);
  });

  test('find mask', () {
    expect(
      service.findMask('4220 0340 4576 8665'),
      CardScannerMasks.generic16,
    );
    expect(
      service.findMask('4220 0340 4576 8665 08/29 269'),
      CardScannerMasks.generic16,
    );
    expect(
      service.findMask('4220 0340 4576 8665 269 08/29'),
      CardScannerMasks.generic16,
    );
    expect(
      service.findMask('Contral do 4220 0340 4576 8665 08/29 0778-3 269'),
      CardScannerMasks.generic16,
    );
    expect(
      service.findMask('3760 679445 96704'),
      CardScannerMasks.americanExpress,
    );
    expect(
      service.findMask('3760 679445 96704 02/30 2979'),
      CardScannerMasks.americanExpress,
    );
    expect(
      service.findMask('3760 679445 96704 2979 02/30'),
      CardScannerMasks.americanExpress,
    );
    expect(
      service.findMask('3760 679445 96704 valid thru 02/30 member since 09'),
      CardScannerMasks.americanExpress,
    );
    expect(
      service.findMask('1234 567 89 1011'),
      CardScannerMasks.generic13,
    );
    expect(
      service.findMask('1234 567 89 1011 946 05/30'),
      CardScannerMasks.generic13,
    );
    expect(
      service.findMask('1234 567 89 1011 05/30 946'),
      CardScannerMasks.generic13,
    );
    expect(
      service.findMask('3611 165678 0009'),
      CardScannerMasks.dinnersClub,
    );
    expect(
      service.findMask('3611 165678 0009 946 05/30'),
      CardScannerMasks.dinnersClub,
    );
    expect(
      service.findMask('3611 165678 0009 05/30 946'),
      CardScannerMasks.dinnersClub,
    );
  });

  group('check luhn', () {
    test('valid card numbers', () {
      expect(service.checkLuhn("4263 9826 4026 9299"), isTrue);
      expect(service.checkLuhn("4539 3195 0343 6467"), isTrue);
      expect(service.checkLuhn("7992 7398 713"), isTrue);
      expect(service.checkLuhn("4263982640269299"), isTrue);
      expect(service.checkLuhn("4539319503436467"), isTrue);
      expect(service.checkLuhn("79927398713"), isTrue);
    });

    test('invalid card numbers', () {
      expect(service.checkLuhn("4223 9826 4026 9299"), isFalse);
      expect(service.checkLuhn("4539 3195 0343 6476"), isFalse);
      expect(service.checkLuhn("8273 1232 7352 0569"), isFalse);
      expect(service.checkLuhn("4223982640269299"), isFalse);
      expect(service.checkLuhn("4539319503436476"), isFalse);
      expect(service.checkLuhn("8273123273520569"), isFalse);
    });
  });
  group('card scanner parse', () {
    group('delimiters', () {
      test('dash should not work as delimiter', () {
        final result = service.parse('4220 0340 4576 8665 123-6');

        expect(result, isNotNull);
        expect(result!.mask, CardScannerMasks.generic16);
        expect(result.number, '4220034045768665');
        expect(result.cvv, isNull);
        expect(result.expiration, isNull);
      });

      test('dot should not work as delimiter', () {
        final result = service.parse('4220 0340 4576 8665 123.6');

        expect(result, isNotNull);
        expect(result!.mask, CardScannerMasks.generic16);
        expect(result.number, '4220034045768665');
        expect(result.cvv, isNull);
        expect(result.expiration, isNull);
      });

      test('slash should not work as delimiter', () {
        final result = service.parse('4220 0340 4576 8665 01/01/20');

        expect(result, isNotNull);
        expect(result!.mask, CardScannerMasks.generic16);
        expect(result.number, '4220034045768665');
        expect(result.cvv, isNull);
        expect(result.expiration, isNull);
      });
    });

    group('generic 16', () {
      test('generic 16 (only numbers)', () {
        final result = service.parse(
          '4220 0340 4576 8665',
        );

        expect(result, isNotNull);
        expect(result!.mask, CardScannerMasks.generic16);
        expect(result.number, '4220034045768665');
        expect(result.cvv, isNull);
        expect(result.expiration, isNull);
      });

      test('generic 16 (order 1)', () {
        final result = service.parse(
          '4220 0340 4576 8665 08/29 269',
        );

        expect(result, isNotNull);
        expect(result!.mask, CardScannerMasks.generic16);
        expect(result.number, '4220034045768665');
        expect(result.cvv, '269');
        expect(result.expiration, '08/29');
      });

      test('generic 16 (order 2)', () {
        final result = service.parse(
          '4220 0340 4576 8665 269 08/29',
        );

        expect(result, isNotNull);
        expect(result!.mask, CardScannerMasks.generic16);
        expect(result.number, '4220034045768665');
        expect(result.cvv, '269');
        expect(result.expiration, '08/29');
      });

      test('generic 16 (with trash)', () {
        final result = service.parse(
          'Contral do 4220 0340 4576 8665 08/29 0778-3 269',
        );

        expect(result, isNotNull);
        expect(result!.mask, CardScannerMasks.generic16);
        expect(result.number, '4220034045768665');
        expect(result.cvv, '269');
        expect(result.expiration, '08/29');
      });
    });

    group('american express', () {
      test('american express (only numbers)', () {
        final result = service.parse(
          '3760 679445 96704',
        );

        expect(result, isNotNull);
        expect(result!.mask, CardScannerMasks.americanExpress);
        expect(result.number, '376067944596704');
        expect(result.cvv, isNull);
        expect(result.expiration, isNull);
      });

      test('american express (order 1)', () {
        final result = service.parse(
          '3760 679445 96704 02/30 2979',
        );

        expect(result, isNotNull);
        expect(result!.mask, CardScannerMasks.americanExpress);
        expect(result.number, '376067944596704');
        expect(result.cvv, '2979');
        expect(result.expiration, '02/30');
      });

      test('american express (order 2)', () {
        final result = service.parse(
          '3760 679445 96704 2979 02/30',
        );

        expect(result, isNotNull);
        expect(result!.mask, CardScannerMasks.americanExpress);
        expect(result.number, '376067944596704');
        expect(result.cvv, '2979');
        expect(result.expiration, '02/30');
      });

      test('american express (with trash)', () {
        final result = service.parse(
          '3760 679445 96704 valid thru 02/30 member since 09',
        );

        expect(result, isNotNull);
        expect(result!.mask, CardScannerMasks.americanExpress);
        expect(result.number, '376067944596704');
        expect(result.cvv, isNull);
        expect(result.expiration, '02/30');
      });
    });

    group('generic 13', () {
      test('generic 13 (only numbers)', () {
        final result = service.parse(
          '1234 567 89 1011',
        );

        expect(result, isNotNull);
        expect(result!.mask, CardScannerMasks.generic13);
        expect(result.number, '1234567891011');
        expect(result.cvv, isNull);
        expect(result.expiration, isNull);
      });

      test('generic 13 (order 1)', () {
        final result = service.parse(
          '1234 567 89 1011 946 05/30',
        );

        expect(result, isNotNull);
        expect(result!.mask, CardScannerMasks.generic13);
        expect(result.number, '1234567891011');
        expect(result.cvv, '946');
        expect(result.expiration, '05/30');
      });

      test('generic 13 (order 2)', () {
        final result = service.parse(
          '1234 567 89 1011 05/30 946',
        );

        expect(result, isNotNull);
        expect(result!.mask, CardScannerMasks.generic13);
        expect(result.number, '1234567891011');
        expect(result.cvv, '946');
        expect(result.expiration, '05/30');
      });
    });

    group('dinners club', () {
      test('dinners club (only numbers)', () {
        final result = service.parse(
          '3611 165678 0009',
        );

        expect(result, isNotNull);
        expect(result!.mask, CardScannerMasks.dinnersClub);
        expect(result.number, '36111656780009');
        expect(result.cvv, isNull);
        expect(result.expiration, isNull);
      });

      test('dinners club (order 1)', () {
        final result = service.parse(
          '3611 165678 0009 946 05/30',
        );

        expect(result, isNotNull);
        expect(result!.mask, CardScannerMasks.dinnersClub);
        expect(result.number, '36111656780009');
        expect(result.cvv, '946');
        expect(result.expiration, '05/30');
      });

      test('dinners club (order 2)', () {
        final result = service.parse(
          '3611 165678 0009 05/30 946',
        );

        expect(result, isNotNull);
        expect(result!.mask, CardScannerMasks.dinnersClub);
        expect(result.number, '36111656780009');
        expect(result.cvv, '946');
        expect(result.expiration, '05/30');
      });
    });
  });
}
