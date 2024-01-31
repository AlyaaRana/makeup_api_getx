import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/favourite_controller.dart';
import '../controller/product_controller.dart';

class FavoritePage extends StatelessWidget {
  final favoriteController = Get.find<FavoriteController>();

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
            final product = Get.find<ProductController>()
                .productList
                .firstWhere((p) => p.id == productId);
            return Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              padding: EdgeInsets.all(8),
              child: ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Image.network(product.imageLink),
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
              ),
            );

          },
        );
      }),
    );
  }
}
