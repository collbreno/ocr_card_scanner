import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_scalable_ocr/flutter_scalable_ocr.dart';
import 'package:ocr_card_scanner/ocr_card_scanner.dart';

class CreditCardScanner extends StatefulWidget {
  final int minScans;
  final CardScannerService service;
  final bool useLuhnAlgorithm;
  final String appBarTitle;
  const CreditCardScanner({
    this.minScans = 5,
    this.useLuhnAlgorithm = true,
    this.appBarTitle = 'Scanning card',
    required this.service,
    super.key,
  });

  @override
  State<CreditCardScanner> createState() => _CreditCardScannerState();
}

class _CreditCardScannerState extends State<CreditCardScanner> {
  late final Map<CardScannerResult, int> _results;
  late bool _popScheduled;

  @override
  void initState() {
    _results = {};
    _popScheduled = false;
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
              _results[parsed]! > widget.minScans &&
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
        title: Text(widget.appBarTitle),
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
              boxLeftOff: 5,
              boxBottomOff: 6,
              boxRightOff: 5,
              boxTopOff: 6,
              getScannedText: _onScannedText,
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
