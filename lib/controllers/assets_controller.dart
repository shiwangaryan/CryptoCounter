import 'package:get/get.dart';
import 'package:getx/models/api_response.dart';
import 'package:getx/models/coin_data.dart';
import 'package:getx/models/tracked_asset.dart';
import 'package:getx/services/http_service.dart';

class AssetsController extends GetxController {
  RxList<CoinData> coinData = <CoinData>[].obs;
  RxBool loading = false.obs;
  RxList<TrackedAsset> trackedAsset = <TrackedAsset>[].obs;

  @override
  void onInit() {
    super.onInit();
    _getAssetsValue();
  }

  void addAsset(String name, double value) {
    trackedAsset.add(
      TrackedAsset(
        name: name,
        amount: value,
      ),
    );
  }

  Future<void> _getAssetsValue() async {
    loading.value = true;
    HTTPService httpService = Get.find();
    var responseData = await httpService.get("currencies");
    CurrenciesListAPIResponse currenciesListAPIResponse =
        CurrenciesListAPIResponse.fromJson(
      responseData,
    );
    coinData.value = currenciesListAPIResponse.data ?? [];
    loading.value = false;
  }

  double getPortfolioValue() {
    if (coinData.isEmpty) {
      return 0;
    }
    if (trackedAsset.isEmpty) {
      return 0.0;
    }
    double total = 0.0;
    trackedAsset.forEach(
      (asset) {
        total += asset.amount! * getAssetPrice(asset.name!);
      },
    );
    return total;
  }

  double getAssetPrice(String name) {
    CoinData? data = getCoinData(name);
    return data?.values?.uSD?.price?.toDouble() ?? 0;
  }

  CoinData? getCoinData(String name) {
    return coinData.firstWhereOrNull((e) => e.name == name);
  }
}
