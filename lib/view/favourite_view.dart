import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../controller/favourite_controller.dart';
import '../controller/product_controller.dart';

class FavoritePage extends StatelessWidget {
  final favoriteController = Get.find<FavoriteController>();
  final productController = Get.find<ProductController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Favorite Products"),
      ),
      body: Obx(() {
        if (favoriteController.favoriteProductIds.isEmpty) {
          return Center(
            child: Text("Your favorite list is empty"),
          );
        }

        return ListView.builder(
          itemCount: favoriteController.favoriteProductIds.length,
          itemBuilder: (context, index) {
            final productId = favoriteController.favoriteProductIds[index];
            final product = productController.productList.firstWhere((p) => p.id == productId);
            return Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              padding: EdgeInsets.all(8),
              child: ListTile(
                contentPadding: EdgeInsets.zero,
                leading: _buildProductImage(product.imageLink),
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 4),
                    Text(
                      "Price: \$${product.price}",
                    ),
                  ],
                ),
                trailing: GestureDetector(
                  onTap: () {
                    favoriteController.removeFromFavorites(product.id);
                    Get.snackbar(
                      'Removed from Favorites',
                      'Product ${product.name} removed from favorites!',
                      snackPosition: SnackPosition.TOP,
                      duration: Duration(seconds: 2),
                    );
                  },
                  child: Icon(
                    Icons.delete,
                    color: Colors.red,
                  ),
                ),
              ),
            );
          },
        );
      }),
    );
  }

  Widget _buildProductImage(String imageLink) {
    return CachedNetworkImage(
      imageUrl: imageLink,
      placeholder: (context, url) => CircularProgressIndicator(),
      errorWidget: (context, url, error) => Icon(Icons.error),
    );
  }
}
