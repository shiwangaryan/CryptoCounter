import 'package:get/get.dart';
import 'package:getx/controllers/assets_controller.dart';
import 'package:getx/services/http_service.dart';

Future<void> registerService() async {
  // register the HTTPService to use through out the app
  Get.put(HTTPService());
}

Future<void> registerController() async {
  //register controller to use through out the app
  Get.put(AssetsController());
}

String getCryptoImageURL(String name) {
  // return "https://raw.githubusercontentcom/ErikThiart/cryptocurrency-icons/blob/master/128/${name.toLowerCase()}.png";
  // return "https://raw.githubusercontent.com/ErikThiart/cryptocurrency-icons/master/128/${name.toLowerCase()}.png";
  return "https://raw.githubusercontent.com/ErikThiart/cryptocurrency-icons/master/128/${name.toLowerCase()}.png";
}
