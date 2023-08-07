import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:parkingapp/api_connection/api.connection.dart';
import 'package:parkingapp/models/car_model.dart';
import 'package:parkingapp/screens/users/viewcar_fragment.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../contrals/parking_controler.dart';
import '../../models/parking_model.dart';
import '../widget/appbar.dart';
import 'package:http/http.dart' as http;

class AddNewCarFragment extends StatelessWidget {
  String? lName;
  String? fName;
  // select button
  String? selectedParkingValue;
  AddNewCarFragment({super.key, this.selectedParkingValue});
// form key declaration
  var formKey = GlobalKey<FormState>();
  // TextEditingControllers
  var carPlateController = TextEditingController();
  var carOwnerNamesController = TextEditingController();
  var carOwnerPhoneController = TextEditingController();

  List parkingLIst = ["parking 1", "parking 2", "parking 3"];
  ParkingController parkingController = Get.put(ParkingController());
  // add car function

  void addCar() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var agentId = prefs.getString("id");
    CarModel carModel = CarModel(
      carId: "",
      carPlate: carPlateController.text,
      carOnwerNames: carOwnerNamesController.text,
      parkingPlace: selectedParkingValue,
      phoneNumber: carOwnerPhoneController.text,
      activeStatus: "",
      timeIn: "",
      timeOut: "",
      agentsID: agentId,
    );
    try {
      var url = Uri.parse(API.addCar);
      print(url);
      var response = await http.post(url, body: carModel.toJson());

      if (response.statusCode == 200) {
        print(response.body);
        var data = jsonDecode(response.body);
        var message = data['message'];
        var status = data['status'];
        if (status == "success" && message == "Car added successfully") {
          Get.back();
          // show dialog
          Get.defaultDialog(
              title: "Success",
              middleText: "Car added successfully !",
              actions: [
                TextButton(
                  onPressed: () {
                    // clear all text fields
                    carPlateController.clear();
                    carOwnerNamesController.clear();
                    carOwnerPhoneController.clear();
                    // close dialog

                    Get.back();
                    Get.to(() => ViewCarFragment());
                  },
                  child: Text("Ok"),
                )
              ]);
        } else if (status == "error" && message == "Car already exists") {
          Get.snackbar(
            "Error",
            "Car Plate already exists",
            snackPosition: SnackPosition.BOTTOM,
          );
        } else {
          Get.snackbar(
            "Error",
            "Failed to add car",
            snackPosition: SnackPosition.BOTTOM,
          );
        }
      } else {
        print(response.body);
        Get.snackbar(
          "Error",
          "Failed to add car",
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      print("Error: $e");
    }
  }

 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "Add New Car"
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(20),
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    SizedBox(height: 20),
                    TextFormField(
                      controller: carPlateController,
                      decoration: InputDecoration(
                        labelText: "Car Plate",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      controller: carOwnerNamesController,
                      decoration: InputDecoration(
                        labelText: "Car Owner Names",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      controller: carOwnerPhoneController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: "Car Owner Phone",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 20),
                    // select Parking
                    // select Parking
                    Obx(() {
                      final parkingList = parkingController.parkingList;
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          padding:
                              const EdgeInsets.only(left: 10.0, right: 10.0),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: DropdownButton(
                            hint: const Text("Select Parking"),
                            isExpanded: true,
                            value:
                                selectedParkingValue, // Set the selected value here
                            items: parkingList.map((parking) {
                              return DropdownMenuItem(
                                value: parking.pId,
                                child: Text(parking.title! +
                                    " - " +
                                    parking.price! +
                                    " RWF"),
                              );
                            }).toList(),
                            onChanged: (newValue) {
                              // Update the selectedParkingValue when an item is selected
                              // This will also trigger the DropdownButton to refresh
                              selectedParkingValue = newValue.toString();
                            },
                          ),
                        ),
                      );
                    }),

                    SizedBox(height: 20),

                    // button
                    ElevatedButton(
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          // check if TextEditingControllers are empty
                          if (carPlateController.text.isEmpty ||
                              carOwnerNamesController.text.isEmpty ||
                              carOwnerPhoneController.text.isEmpty) {
                            // show error message
                            Get.snackbar(
                              "Error",
                              "Please fill all fields",
                              snackPosition: SnackPosition.BOTTOM,
                            );
                          } else {
                            Get.defaultDialog(
                              title: "Loading...",
                              content: LinearProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.blue), // Set your desired color here
                                backgroundColor: Colors.grey[200],
                              ),
                              barrierDismissible: false,
                            );
                            // add car

                            addCar();
                          }
                        }
                      },
                      child: Text("Add Car"),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
