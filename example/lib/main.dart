import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:ocr_card_scanner/ocr_card_scanner.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late final TextEditingController _ccNumController;
  late final TextEditingController _cvvController;
  late final TextEditingController _expiryController;

  @override
  void initState() {
    _ccNumController = TextEditingController();
    _cvvController = TextEditingController();
    _expiryController = TextEditingController();
    super.initState();
  }

  void _openScanner() async {
    final result = await showDialog<CardScannerResult>(
      context: context,
      builder: (context) => CardScannerWidget(
        service: CardScannerService(
          masks: CardScannerMasks.all,
        ),
      ),
    );

    if (result != null && mounted) {
      setState(() {
        _ccNumController.text =
            MaskTextInputFormatter(mask: result.mask.numberMask)
                .maskText(result.number);
        _cvvController.text = result.cvv ?? '';
        _expiryController.text = result.expiry ?? '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('OCR Card Scanner'),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        children: [
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _ccNumController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Card Number',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: IconButton(
                  onPressed: _openScanner,
                  icon: const Icon(Icons.camera_alt),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _expiryController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Expiry',
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: _cvvController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'CVV',
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
