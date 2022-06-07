import 'package:get/get.dart';
import 'package:projectx/models/user.dart';

class UserController extends GetxController {
  Rx<User> _userModel = User().obs;

  User get user => _userModel.value;

  set user(User value) => this._userModel.value = value;

  void clear() {
    _userModel.value = User();
  }
}
