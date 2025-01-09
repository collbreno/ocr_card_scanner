import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_scalable_ocr/flutter_scalable_ocr.dart';
import 'package:ocr_card_scanner/ocr_card_scanner.dart';

/// The widget responsible for displaying the camera and making Optical Character Recognition
/// from the card.
/// It will return the [CardScannerResult] via popping the Navigator.
/// It must be used in a separate page or dialog.
/// Example:
/// ```final result = await showDialog<CardScannerResult>(
///        context: context,
///        builder: (context) => CardScannerWidget(
///          service: CardScannerService(
///            masks: CardScannerMasks.all,
///          ),
///        ),
///);```
class CardScannerWidget extends StatefulWidget {
  /// Minimum amount of scans needed before returning the [CardScannerResult].
  /// Greater values means greater confidence, but also more time to proccess.
  /// Defaults to 5.
  final int minScans;

  /// The service used to parse the scanned text into card information.
  final CardScannerService service;

  /// Whether the card number should be validated using Luhn Algorithm.
  /// Using true increases the confidence. But some cards may not use this algorithm for validation.
  /// Defaults to true.
  final bool useLuhnAlgorithm;

  /// The title used in the AppBar of the scanner.
  final String appBarTitle;

  const CardScannerWidget({
    this.minScans = 5,
    this.useLuhnAlgorithm = true,
    this.appBarTitle = 'Scanning card',
    required this.service,
    super.key,
  });

  @override
  State<CardScannerWidget> createState() => _CardScannerWidgetState();
}

class _CardScannerWidgetState extends State<CardScannerWidget> {
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
