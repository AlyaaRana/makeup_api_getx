
import 'package:exercise_satu/controller/product_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/favourite_controller.dart';
import 'favourite_view.dart';

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
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      GestureDetector(
                        onTap: () {
                          favoriteController.toggleFavorite(product.id);
                        },
                        child: Obx(() {
                          return Icon(
                            Icons.favorite,
                            color: product.isFavorite(favoriteController)
                                ? Colors.red
                                : Colors.grey,
                            // You can set a border here if needed
                            // border: Border.all(color: Colors.black, width: 2.0),
                          );
                        }),
                      ),
                      SizedBox(width: 8),
                      PopupMenuButton(
                        icon: Icon(Icons.more_vert),
                        itemBuilder: (context) => [
                          PopupMenuItem(
                            child: Text('Edit'),
                          ),
                          PopupMenuItem(
                            child: GestureDetector(
                              onTap: () {
                                productController.productList.remove(product);
                              },
                              child: Text('Delete'),
                            ),
                          ),
                        ],
                      ),
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
        child: Icon(Icons.favorite, color: Colors.red), // Set the color of the icon
        backgroundColor: Colors.white,
      ),
    );
  }
}
