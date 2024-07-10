import 'package:flutter/material.dart';
import 'package:getx/models/coin_data.dart';
import 'package:getx/utils.dart';

class DetailsPage extends StatelessWidget {
  final CoinData coinData;
  const DetailsPage({super.key, required this.coinData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(context),
      body: _buildUI(context),
    );
  }

  PreferredSizeWidget _appBar(BuildContext context) {
    return AppBar(
      centerTitle: true,
      title: Text(coinData.name!),
    );
  }

  Widget _buildUI(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: width * 0.02),
        child: Column(
          children: [
            _assetPrice(context),
            _assetInfo(context),
          ],
        ),
      ),
    );
  }

  Widget _assetPrice(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return SizedBox(
      height: height * 0.1,
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Image.network(getCryptoImageURL(coinData.name!)),
          ),
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text:
                      "\$ ${coinData.values!.uSD!.price!.toStringAsFixed(2)}\n",
                  style: const TextStyle(
                    fontSize: 25,
                  ),
                ),
                TextSpan(
                  text:
                      "${coinData.values!.uSD!.percentChange24h!.toStringAsFixed(2)}%",
                  style: TextStyle(
                    fontSize: 14,
                    color: coinData.values!.uSD!.percentChange24h! > 0
                        ? Colors.green
                        : Colors.red,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _assetInfo(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8),
        child: GridView(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.9,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          children: [
            _inforCard(
              "Circulating Supply",
              coinData.circulatingSupply.toString(),
            ),
            _inforCard(
              "Maximum Supply",
              coinData.maxSupply.toString(),
            ),
            _inforCard(
              "Total Supply",
              coinData.totalSupply.toString(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _inforCard(String title, String subtitle) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFE7E6E6),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text.rich(
            textAlign: TextAlign.center,
            TextSpan(children: [
              TextSpan(
                text: "$title\n",
                style: const TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.w700,
                ),
              ),
              TextSpan(
                text: "\n$subtitle",
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ]),
          ),
        ],
      ),
    );
  }
}
