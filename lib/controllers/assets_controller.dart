import 'dart:convert';

import 'package:get/get.dart';
import 'package:getx/models/api_response.dart';
import 'package:getx/models/coin_data.dart';
import 'package:getx/models/tracked_asset.dart';
import 'package:getx/services/http_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AssetsController extends GetxController {
  RxList<CoinData> coinData = <CoinData>[].obs;
  RxBool loading = false.obs;
  RxList<TrackedAsset> trackedAsset = <TrackedAsset>[].obs;

  @override
  void onInit() {
    super.onInit();
    _getAssetsValue();
    _localTrackedAssetFromStorage();
  }

  void addAsset(String name, double value) async {
    trackedAsset.add(
      TrackedAsset(
        name: name,
        amount: value,
      ),
    );
    List<String> data = trackedAsset.map((asset) => jsonEncode(asset)).toList();
    print(data);
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setStringList("tracked_asset", data);
  }

  void _localTrackedAssetFromStorage() async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    List<String>? data = preferences.getStringList("tracked_asset");
    if (data != null) {
      trackedAsset.value = data
          .map(
            (e) => TrackedAsset.fromJson(jsonDecode(e)),
          )
          .toList();
    }
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
