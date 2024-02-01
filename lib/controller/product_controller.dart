import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:exercise_satu/model/product_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity/connectivity.dart';

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
    String? cachedData = prefs.getString(cacheKey);
    if (cachedData != null) {
      productList.assignAll(productFromJson(cachedData) ?? []);
    }
  }

  void saveProductsToCache() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(cacheKey, productToJson(productList));
  }

  Future<void> fetchProducts() async {
    isLoading(true);

    try {
      bool internetAvailable = await hasInternetConnection();

      if (internetAvailable) {
        final response = await http.get(
          Uri.parse('https://makeup-api.herokuapp.com/api/v1/products.json?brand=maybelline'),
        );
        if (response.statusCode == 200) {
          productList.assignAll(productFromJson(response.body) ?? []);
          saveProductsToCache();
        } else {
          print('Error: ${response.statusCode}');
        }
      } else {
        print('No internet connection. Loading data from cache.');
        loadCachedProducts();
      }
    } catch (e) {
      print(e);
    } finally {
      isLoading(false);
    }
  }

  Future<bool> hasInternetConnection() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }
}
