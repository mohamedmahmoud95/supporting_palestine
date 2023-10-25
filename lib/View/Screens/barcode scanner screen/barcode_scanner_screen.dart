import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProductInfo {
  final String productName;
  final String companyName;
  final List<String> keywords;
  final List<String> allergens;
  final String countries;
  final String imageUrl;

  ProductInfo({
    required this.productName,
    required this.companyName,
    required this.keywords,
    required this.allergens,
    required this.countries,
    required this.imageUrl,
  });

  factory ProductInfo.fromJson(Map<String, dynamic> json) {
    final productData = json['product'];
    return ProductInfo(
      productName: productData['product_name'] ?? '',
      companyName: productData['brands'] ?? '',
      keywords: List<String>.from(productData['_keywords'] ?? []),
      allergens: List<String>.from(productData['allergens_tags'] ?? []),
      countries: productData['countries'] ?? '',
      imageUrl: productData['image_url'] ?? '',
    );
  }
}

Future<ProductInfo> getProductInfo(String barcode) async {
  final response = await http.get(Uri.parse('https://world.openfoodfacts.org/api/v0/product/$barcode.json'));

  if (response.statusCode == 200) {
    final Map<String, dynamic> jsonResponse = jsonDecode(response.body);

    if (jsonResponse.containsKey('product')) {
      return ProductInfo.fromJson(jsonResponse);
    }
  }

  throw Exception('Failed to get product info for barcode $barcode');
}

class BarcodeScannerScreen extends StatefulWidget {
  const BarcodeScannerScreen({Key? key}) : super(key: key);

  @override
  State<BarcodeScannerScreen> createState() => _BarcodeScannerScreenState();
}

class _BarcodeScannerScreenState extends State<BarcodeScannerScreen> {
  String result = '';
  var _scanBarcode;
  late ProductInfo productInfo = ProductInfo(
    productName: '',
    companyName: '',
    keywords: [],
    allergens: [],
    countries: '',
    imageUrl: '',
  );

  void resetProductInfo(ProductInfo productInfo)
  {
    productInfo = ProductInfo(
      productName: '',
      companyName: '',
      keywords: [],
      allergens: [],
      countries: '',
      imageUrl: '',
    );
  }

  Future<void> scanBarcodeNormal() async {
    setState(() {
      resetProductInfo(productInfo);
    });
    String barcodeScanRes;

    barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
        "#ff6666", "Cancel", true, ScanMode.QR);

    productInfo = await getProductInfo(barcodeScanRes);

    setState(() {
      _scanBarcode = barcodeScanRes;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              onPressed: () async {
                await scanBarcodeNormal();
              },
              child: const Text('Open Scanner'),
            ),
            Text('Barcode Result: $_scanBarcode'),
            Text('Product Name: ${productInfo.productName}'),
            Text('Company Name: ${productInfo.companyName}'),
            Text('Keywords: ${productInfo.keywords.join(", ")}'),
            Text('Allergens: ${productInfo.allergens.join(", ")}'),
            Text('Countries: ${productInfo.countries}'),
            Text('Image URL: ${productInfo.imageUrl}'),
          ],
        ),
      ),
    );
  }
}
