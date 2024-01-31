import 'package:get/get.dart';

class FavoriteController extends GetxController {
  RxList<int> favoriteProductIds = <int>[].obs;

  void toggleFavorite(int productId) {
    if (favoriteProductIds.contains(productId)) {
      favoriteProductIds.remove(productId);
    } else {
      favoriteProductIds.add(productId);
    }
  }
}
