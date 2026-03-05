import 'package:flutter/material.dart';
import 'package:tech_gadol_flutter_assessment_fasil_adugna_jibriel/features/product/presentation/widgets/product_detail_body.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({super.key, required this.productId});

  final int productId;

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: ProductDetailBody(productId: widget.productId),
    );
  }
}
