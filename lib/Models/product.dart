
class Product {
  final String productName;
  final String companyName;
  final List<String> keywords;
  final String countries;
  final String imageUrl;
  final String productCode;
  final String creator;
  // final String nutritionData;
  // final String nutritionDataPer;
  // final String servingQuantity;
  // final String servingSize;
  final String productStatus;

  Product({
    required this.productName,
    required this.companyName,
    required this.keywords,
    required this.countries,
    required this.imageUrl,
    required this.productCode,
    required this.creator,
    required this.productStatus,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    final productData = json['product'];
    return Product(
      productName: productData['product_name'] ?? 'unknown',
      companyName: productData['brands'] ?? 'unknown',
      keywords: List<String>.from(productData['_keywords'] ?? []),
      countries: productData['countries'] ?? 'unknown',
      imageUrl: productData['image_url'] ?? 'unknown',
      productCode: productData['code'] ?? 'unknown',
      creator: productData['creator'] ?? 'unknown',
      productStatus: json['status_verbose'] ?? 'unknown',
    );
  }
}