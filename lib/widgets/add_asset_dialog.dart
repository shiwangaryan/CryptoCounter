import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx/controllers/assets_controller.dart';
import 'package:getx/models/api_response.dart';
import 'package:getx/services/http_service.dart';

class AddAssetDialogController extends GetxController {
  RxBool loading = false.obs;
  RxList<String> assets = <String>[].obs;
  RxString selectedAsset = "".obs;
  RxDouble assetValue = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    _getAssets();
  }

  Future<void> _getAssets() async {
    loading.value = true;
    HTTPService httpService = Get.find<HTTPService>();
    var respnseData = await httpService.get("currencies");
    CurrenciesListAPIResponse currenciesListAPIResponse =
        CurrenciesListAPIResponse.fromJson(respnseData);
    currenciesListAPIResponse.data?.forEach((coin) {
      assets.add(coin.name!);
    });
    selectedAsset.value = assets.first;
    loading.value = false;
  }
}

class AddAssetDialog extends StatelessWidget {
  final controller = Get.put(AddAssetDialogController());
  AddAssetDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;

    return Obx(
      () => Center(
        child: Material(
          child: Container(
            height: height * 0.4,
            width: width * 0.8,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Colors.white,
            ),
            child: _buildUI(context),
          ),
        ),
      ),
    );
  }

  Widget _buildUI(BuildContext context) {
    if (controller.loading.isTrue) {
      return const Center(
        child: SizedBox(
          height: 30,
          width: 30,
          child: CircularProgressIndicator(),
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            DropdownButton(
              isExpanded: true,
              value: controller.selectedAsset.value,
              items: controller.assets.map((asset) {
                return DropdownMenuItem(
                  value: asset,
                  child: Text(asset),
                );
              }).toList(),
              onChanged: (value) {
                controller.selectedAsset.value = value!;
              },
            ),
            TextField(
              onChanged: (e) {
                controller.assetValue.value = double.parse(e);
              },
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
            ),
            MaterialButton(
              onPressed: () {
                AssetsController assetsController = Get.find();
                assetsController.addAsset(
                  controller.selectedAsset.value,
                  controller.assetValue.value,
                );
                Get.back(closeOverlays: true);
              },
              color: Theme.of(context).colorScheme.primary,
              child: const Text(
                'Add Asset',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      );
    }
  }
}
