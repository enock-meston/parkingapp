import 'dart:convert';
import 'package:get/get.dart';
import 'package:parkingapp/models/view_car_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../api_connection/api.connection.dart';

class CarController extends GetxController {
  var carDataList = <ViewCarModel>[].obs;
  var isLoading = true.obs;

  Future<void> getCarMethod() async {
    try {
      isLoading(true); // Set isLoading to true before making the API call

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String userId = prefs.getString('id')!;
      print("user id1 : $userId");
      var response = await http.get(Uri.parse("${API.selectCar}?userId=$userId"));

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        if (data.containsKey('cars') && data['cars'] is List) {
          var cars = data['cars'];
          carDataList.value = List<ViewCarModel>.from(cars.map((car) => ViewCarModel.fromJson(car)));
        } else {
          carDataList.clear(); // Clear the list if no data found
          // print("No car data found");
        }
      } else {
        carDataList.clear(); // Clear the list on error
        print("Failed to fetch car data");
      }
    } catch (error) {
      carDataList.clear(); // Clear the list on error
      print("Error fetching car data: $error");
    } finally {
      isLoading(false); // Set isLoading to false after completing the API call
    }
  }
}
