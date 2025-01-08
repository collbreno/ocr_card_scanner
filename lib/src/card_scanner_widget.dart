import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_scalable_ocr/flutter_scalable_ocr.dart';
import 'package:ocr_card_scanner/src/card_scanner_result.dart';
import 'package:ocr_card_scanner/src/card_scanner_service.dart';

class CreditCardScanner extends StatefulWidget {
  final int min;
  final CardScannerService service;
  final bool useLuhnAlgorithm;
  const CreditCardScanner({
    this.min = 5,
    this.useLuhnAlgorithm = true,
    required this.service,
    super.key,
  });

  @override
  State<CreditCardScanner> createState() => _CreditCardScannerState();
}

class _CreditCardScannerState extends State<CreditCardScanner> {
  late final Map<CardScannerResult, int> _results;
  late bool _popScheduled;
  late Offset _selectedOffset;
  static const _horizontalModeOffset = Offset(6, 4);
  static const _verticalModeOffset = Offset(3, 10);

  @override
  void initState() {
    _results = {};
    _popScheduled = false;
    _selectedOffset = _horizontalModeOffset;
    super.initState();
  }

  void _onScannedText(String input) {
    if (input.isNotEmpty) {
      final parsed = widget.service.parse(input);
      if (parsed != null) {
        SchedulerBinding.instance.addPostFrameCallback((_) {
          setState(() {
            _results[parsed] = (_results[parsed] ?? 0) + 1;
          });
          if ((!widget.useLuhnAlgorithm ||
                  widget.service.checkLuhn(parsed.number)) &&
              _results[parsed]! > widget.min &&
              mounted &&
              !_popScheduled) {
            setState(() {
              _popScheduled = true;
            });
            Navigator.pop(context, parsed);
          }
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Escanear cartão'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Column(
          children: [
            ScalableOCR(
              paintboxCustom: Paint()
                ..style = PaintingStyle.stroke
                ..strokeWidth = 2.0
                ..color = const Color.fromARGB(153, 102, 160, 241),
              boxLeftOff: _selectedOffset.dx,
              boxBottomOff: _selectedOffset.dy,
              boxRightOff: _selectedOffset.dx,
              boxTopOff: _selectedOffset.dy,
              getScannedText: _onScannedText,
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
