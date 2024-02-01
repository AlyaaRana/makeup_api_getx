import 'package:exercise_satu/controller/product_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/favourite_controller.dart';
import 'favourite_view.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ListMakeup extends StatelessWidget {
  final productController = Get.put(ProductController());
  final favoriteController = Get.put(FavoriteController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("API Makeup"),
      ),
      body: Obx(() {
        if (productController.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        } else if (productController.productList.isEmpty) {
          return Center(child: Text("No internet connection or failed to fetch data"));
        } else {
          return ListView.builder(
            itemCount: productController.productList.length,
            itemBuilder: (context, index) {
              final product = productController.productList[index];
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
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      GestureDetector(
                        onTap: () {
                          favoriteController.toggleFavorite(product.id);
                          Get.snackbar(
                            'Added to Favorites',
                            'Product ${product.name} added to favorites!',
                            snackPosition: SnackPosition.TOP,
                            duration: Duration(seconds: 2),
                          );
                        },
                        child: Obx(() {
                          return Icon(
                            Icons.favorite,
                            color: favoriteController.favoriteProductIds.contains(product.id)
                                ? Colors.red
                                : Colors.grey,
                          );
                        }),
                      ),
                      SizedBox(width: 8),
                    ],
                  ),
                ),
              );
            },
          );
        }
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(() => FavoritePage());
        },
        child: Icon(Icons.favorite, color: Colors.red),
        backgroundColor: Colors.white,
      ),
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