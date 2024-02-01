import 'package:get/get.dart';
import 'package:exercise_satu/product_db_helper.dart';

class FavoriteController extends GetxController {
  RxList<int> favoriteProductIds = <int>[].obs;
  final ProductDBHelper dbHelper = ProductDBHelper();

  @override
  void onInit() {
    loadFavoriteProducts();
    super.onInit();
  }

  void loadFavoriteProducts() async {
    final favoriteProducts = await dbHelper.getFavoriteProducts();
    favoriteProductIds.value = favoriteProducts.map<int>((product) => product['id'] as int).toList();
  }

  void removeFromFavorites(int productId) async {
    favoriteProductIds.remove(productId);
    await dbHelper.deleteProduct(productId);
  }

  void toggleFavorite(int productId) async {
    if (favoriteProductIds.contains(productId)) {
      favoriteProductIds.remove(productId);
      await dbHelper.deleteProduct(productId);
    } else {
      favoriteProductIds.add(productId);
      await dbHelper.insertProduct({'id': productId});
    }
  }
}
