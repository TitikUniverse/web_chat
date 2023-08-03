import 'package:get/get.dart';

import 'repositories/messenger_repository.dart';

void initDependencies() {
  // repositories
  Get.lazyPut(() => MessengerRepository());

  // controllers
  // Get.lazyPut(() => RestaurantController(restaurantRepo: Get.find()), fenix: true);
  // Get.lazyPut(() => CartController(cartRepo: Get.find()), fenix: true);
}