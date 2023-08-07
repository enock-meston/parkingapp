import 'package:get/get.dart';
import 'package:parkingapp/models/parking_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../api_connection/api.connection.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ParkingController extends GetxController {
  var parkingList = <ParkingModel>[].obs;

  Future<List<ParkingModel>> getParkingList() async {
  try {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userId = prefs.getString('id')!;
    parkingList.clear(); // Clear the list before adding new items

    var response = await http.get(Uri.parse("${API.selectParking}?userId=$userId"));

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      
      if (data.containsKey('parking') && data['parking'] is List) {
        var parkings = data['parking'];
        
        for (var i in parkings) {
          ParkingModel _parkingModel = ParkingModel.fromJson(i);
          parkingList.add(
            ParkingModel(
              pId: _parkingModel.pId,
              title: _parkingModel.title,
              refere: _parkingModel.refere,
              price: _parkingModel.price,
              status: _parkingModel.status,
              addedOn: _parkingModel.addedOn,
              postedBy: _parkingModel.postedBy,
            ),
          );
        }
        return parkingList;
      } else {
        return [];
      }
    } else {
      print(response.statusCode);
      return [];
    }
  } catch (e) {
    print("Error fetching parking list: $e");
    return [];
  }
}

}
