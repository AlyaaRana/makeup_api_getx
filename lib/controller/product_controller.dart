import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:exercise_satu/model/product_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductController extends GetxController {
  var isLoading = true.obs;
  RxList<Product> productList = <Product>[].obs;
  final String cacheKey = 'cached_products';

  @override
  void onInit() {
    loadCachedProducts();
    fetchProducts();
    super.onInit();
  }

  void loadCachedProducts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey(cacheKey)) {
      String cachedData = prefs.getString(cacheKey) ?? '';
      productList.value = productFromJson(cachedData) ?? [];
    }
  }

  void saveProductsToCache() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(cacheKey, productToJson(productList));
  }

  void fetchProducts() async {
    isLoading(true);

    try {
      final response = await http.get(
        Uri.parse('https://makeup-api.herokuapp.com/api/v1/products.json?brand=maybelline'),
      );
      if (response.statusCode == 200) {
        productList.value = productFromJson(response.body) ?? [];
        saveProductsToCache();
      } else {
        print('Error: ${response.statusCode}');
      }
    } catch (e) {
      print(e);
    } finally {
      isLoading(false);
    }
  }
}
