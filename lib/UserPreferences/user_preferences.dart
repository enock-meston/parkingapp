import 'dart:convert';


import 'package:shared_preferences/shared_preferences.dart';

import '../models/agents_model.dart';



class RememberUserPrefs{
  //save-remember user-info

  static Future<void> storeUserInfo(AgentsModel userInfo) async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String userJsonData = jsonEncode(userInfo.toJson());
    print("my data from sharedPref: $userJsonData");
    await sharedPreferences.setString("currentUser", userJsonData);
  }

//  get-read User-info
static Future<AgentsModel?> readUserInfo() async{
    AgentsModel? currentUserInfo;
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? userInfo = sharedPreferences.getString("currentUser");
    print("user info: $userInfo");

    if(userInfo != null){
      Map<String,dynamic> userDataMap = jsonDecode(userInfo);
     currentUserInfo = AgentsModel.fromJson(userDataMap);
     
    }
    return currentUserInfo;
}
  //remove user_info
  static Future<void> removeUserInfo() async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.remove("currentUser");
  }

}