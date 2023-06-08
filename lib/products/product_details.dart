import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'product.dart';

class ProductDetails extends StatelessWidget {
  final Product product;

  const ProductDetails({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(product.name),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              product.imageUrl,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '\$${product.price.toStringAsFixed(2)}',
                    style: const TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'BOOSTERS (850)',
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      // Implement add to cart functionality here
                    },
                    child:
                        const Text('Add to cart\nfunctionality\ncoming soon!'),
                  ),
                  const SizedBox(height: 16),
                  InkWell(
                    child: const Text(
                      'Contact Jeremy for more information.',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                      ),
                    ),
                    onTap: () async {
                      var emailUri = Uri(
                        scheme: 'mailto',
                        path: 'jfeusi@rigsat.com',
                        query: 'subject=More%20Information%20Required',
                      );

                      if (await canLaunchUrl(emailUri)) {
                        await launchUrl(emailUri);
                      } else {
                        throw 'Could not launch $emailUri';
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        onPressed: () {
                          // Share on Twitter
                          Share.share(
                              'Check out this product: ${product.name}');
                        },
                        icon: const Icon(Icons.share),
                      ),
                      IconButton(
                        onPressed: () {
                          // Share on Facebook
                          Share.share(
                              'Check out this product: ${product.name}');
                        },
                        icon: const Icon(Icons.share),
                      ),
                      IconButton(
                        onPressed: () {
                          // Pin on Pinterest
                          Share.share(
                              'Check out this product: ${product.name}');
                        },
                        icon: const Icon(Icons.share),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
