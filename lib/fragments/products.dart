import 'package:best_frontend/api.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ProductsGrid extends StatefulWidget {
  const ProductsGrid({super.key});

  @override
  State<ProductsGrid> createState() => _ProductsGridState();
}

class _ProductsGridState extends State<ProductsGrid> {
  final List<Product> _products = [];
  int _page = 1;
  final int _limit = 10;
  bool _isLoading = false;
  bool _hasMore = true;
  final ScrollController _controller = ScrollController();

  @override
  void initState() {
    super.initState();
    _fetchProducts();
    _controller.addListener(() {
      if (_controller.position.pixels >=
              _controller.position.maxScrollExtent - 200 &&
          !_isLoading &&
          _hasMore) {
        _fetchProducts();
      }
    });
  }

  Future<void> _fetchProducts() async {
    if (_isLoading || !_hasMore) return;

    setState(() {
      _isLoading = true;
    });

    final api = APIService();
    final products = await api.fetchAllProducts(page: _page, limit: _limit);

    setState(() {
      _products.addAll(products);
      _page++;
      _isLoading = false;
      if (products.length < _limit) _hasMore = false;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildProductCard(Product product) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Product Image
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(12),
              ),
              child: Image.network(
                "${APIService().getBaseURL()}/${product.image}",
                fit: BoxFit.fitWidth,
                height: 500,
                errorBuilder: (context, error, stackTrace) {
                  if (kDebugMode) {
                    print(error);
                    print(stackTrace);
                  }
                  return const Center(child: Icon(Icons.broken_image));
                },
              ),
            ),
          ),

          // Product Info
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              spacing: 4,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),

                RichText(
                  text: TextSpan(
                    style: const TextStyle(fontSize: 13, color: Colors.black87),
                    children: [
                      TextSpan(
                        text: '৳ ',
                        style: const TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.w700,
                          fontSize: 20,
                        ),
                      ),
                      TextSpan(
                        text: '${product.price.toStringAsFixed(0)}  ',
                        style: const TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      WidgetSpan(
                        alignment: PlaceholderAlignment.middle,
                        child: Icon(
                          Icons.inventory_2_rounded,
                          size: 16,
                          color: Colors.blueGrey,
                        ),
                      ),
                      TextSpan(
                        text: ' Stock: ${product.stock}',
                        style: const TextStyle(
                          color: Colors.blueGrey,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),

                Text(
                  "Condition: ${product.condition}",
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red.shade600,
                      foregroundColor: Colors.white,
                      elevation: 4,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      alignment: Alignment.center,
                      textStyle: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    onPressed: () {
                      // TODO: Add to cart functionality
                    },
                    icon: const Icon(Icons.shopping_bag_outlined, size: 18),
                    label: const Text("Add to Cart"),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      controller: _controller,
      padding: const EdgeInsets.all(8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        childAspectRatio: 0.75,
      ),
      itemCount: _hasMore ? _products.length + 1 : _products.length,
      itemBuilder: (context, index) {
        if (index < _products.length) {
          return _buildProductCard(_products[index]);
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
