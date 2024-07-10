import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:getx/controllers/assets_controller.dart';
import 'package:getx/models/tracked_asset.dart';
import 'package:getx/pages/details_page.dart';
import 'package:getx/utils.dart';
import 'package:getx/widgets/add_asset_dialog.dart';

class HomePage extends StatelessWidget {
  AssetsController assetsController = Get.find();
  HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: _appBar(context),
      body: _buildUI(context),
    );
  }

  PreferredSizeWidget _appBar(BuildContext context) {
    return AppBar(
      title: const CircleAvatar(
        backgroundImage: NetworkImage("https://i.pravatar.cc/150?img=3"),
      ),
      actions: [
        IconButton(
          onPressed: () {
            Get.dialog(
              AddAssetDialog(),
            );
          },
          icon: const Icon(
            Icons.add,
            size: 28,
          ),
        ),
      ],
    );
  }

  Widget _buildUI(BuildContext context) {
    return SafeArea(
      child: Obx(
        () => Column(
          children: [
            _portfolioValue(context),
            _trackedAssetsList(context),
          ],
        ),
      ),
    );
  }

  Widget _portfolioValue(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: Container(
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.symmetric(
          vertical: MediaQuery.of(context).size.height * 0.03,
        ),
        child: Center(
          child: Text.rich(
            textAlign: TextAlign.center,
            TextSpan(
              children: [
                const TextSpan(
                  text: '\$',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                TextSpan(
                  text:
                      "${assetsController.getPortfolioValue().toStringAsFixed(2)}\n",
                  style: const TextStyle(
                    fontSize: 45,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const TextSpan(text: 'Portfolio Value'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _trackedAssetsList(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width * 0.03,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 14),
          SizedBox(
            height: height * 0.05,
            child: const Text(
              'Portfolio',
              style: TextStyle(
                fontSize: 13,
                color: Colors.black38,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          SizedBox(
            height: height * 0.6,
            width: width,
            child: ListView.builder(
              itemCount: assetsController.trackedAsset.length,
              itemBuilder: (context, index) {
                TrackedAsset trackedAsset =
                    assetsController.trackedAsset[index];
                return ListTile(
                  leading: Image.network(
                    getCryptoImageURL(trackedAsset.name!),
                    height: 42,
                    width: 42,
                  ),
                  title: Text(trackedAsset.name!),
                  subtitle: Text(
                    "USD: ${assetsController.getAssetPrice(trackedAsset.name!).toStringAsFixed(2)}",
                  ),
                  trailing: Text(
                    trackedAsset.amount!.toString(),
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onTap: () {
                    Get.to(
                      () {
                        return DetailsPage(
                          coinData:
                              assetsController.getCoinData(trackedAsset.name!)!,
                        );
                      },
                    );
                  },
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
