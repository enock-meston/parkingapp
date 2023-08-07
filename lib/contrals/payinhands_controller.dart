import 'dart:convert';

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../api_connection/api.connection.dart';
import '../models/payinhands_model.dart';
import 'package:http/http.dart' as http;

class PayInHandsController extends GetxController {
  var isLoading = true.obs;
  var payinhandList = <PayInHandsModel>[].obs;

  @override
  void onInit() {
    getPayInHandsMethod();
    super.onInit();
  }

  Future<void> getPayInHandsMethod() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String userId = prefs.getString('id')!;

      var response = await http.get(Uri.parse("${API.selectParkingById}?userId=$userId"));
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        if (data.containsKey('data') && data['data'] is List) {
          var data1 = data['data'];
          print("kwishyura mu ntoki : $data1");
          
          // Clear the list before adding new data
          payinhandList.clear();

          for (var i in data1) {
            PayInHandsModel _payInHandsModel = PayInHandsModel.fromJson(i);
            payinhandList.add(_payInHandsModel);
          }
          isLoading(false);
        } else {
          print("No car data found");
        }
      } else {
        throw Exception('Failed to load PayInHands details');
      }
    } catch (e) {
      print("error in getPayInHandsMethod : $e");
    }
  }
}
