
import 'package:get/get.dart';
import 'package:parkingapp/UserPreferences/user_preferences.dart';

import '../models/agents_model.dart';


class CurrentUser extends GetxController{
  final Rx<AgentsModel> _currentUser = AgentsModel().obs;

  AgentsModel get user => _currentUser.value;


  getUserInfo() async{
    AgentsModel? getUserInfoFromLocalStorage = await RememberUserPrefs.readUserInfo();
    _currentUser.value = getUserInfoFromLocalStorage!;
    print("object1: ${_currentUser.value}");
  }
}