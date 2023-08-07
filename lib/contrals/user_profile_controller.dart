import 'dart:convert';

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:http/http.dart' as http;

import '../api_connection/api.connection.dart';
import '../models/agents_model.dart';


class UserProfileControler extends GetxController {
// get user Profile method

AgentsModel agentsModel = AgentsModel();
var isLoading = true.obs;
var user = AgentsModel().obs;

 @override
  void onInit() {
    super.onInit();
    getUserProfileData();
  }


  
     Future<AgentsModel> getUserProfileData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? userId = sharedPreferences.getString("id");
    print("profileLink: ${API.profile}?userId=$userId}");
    var response = await http.get(Uri.parse("${API.profile}?userId=$userId"));
    // print("response.body: ${response.body}");

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      agentsModel = AgentsModel.fromJson(data);
      isLoading(false);
      return agentsModel;
    } else {
      throw Exception("Failed to load user profile");
    }
  }
  

}
