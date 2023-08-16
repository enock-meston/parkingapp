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
import 'package:dropdown_button2/dropdown_button2.dart';

class AddNewCarFragment extends StatefulWidget {
  String? selectedParkingValue;
  AddNewCarFragment({super.key, this.selectedParkingValue});

  @override
  State<AddNewCarFragment> createState() => _AddNewCarFragmentState();
}

class _AddNewCarFragmentState extends State<AddNewCarFragment> {
  String? lName;

  String? fName;
  String dropdownvalue = 'Item 1';
  String? gender;
  String? selectedValue;
  bool valuefirst = false;

// form key declaration
  var formKey = GlobalKey<FormState>();

  // TextEditingControllers
  var carPlateController = TextEditingController();

  var carOwnerNamesController = TextEditingController();

  var carOwnerPhoneController = TextEditingController();

  var parkingLIst = ["parking 1", "parking 2", "parking 3"];

  // ===
  var items = [
    "Asset Details",
    "Purchase Details",
    "Financial Details",
    "Additional Details",
    "Asset Images"
  ];

  // ====
  ParkingController parkingController = Get.put(ParkingController());

// =====
  @override
  void initState() {
    super.initState();
    // Call the method to fetch the parking list from the API
    parkingController.fetchParkingList();
  }

// =====
  // add car function
  void addCar() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var agentId = prefs.getString("id");
    CarModel carModel = CarModel(
      carId: "",
      carPlate: carPlateController.text,
      carOnwerNames: carOwnerNamesController.text,
      parkingPlace: selectedValue,
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
      appBar: CustomAppBar(title: "Add New Car"),
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
                    Container(
                      width: double.infinity,
                      height: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(04),
                        color: Colors.white,
                        border: Border.all(
                          color: Colors.black,
                          width: 1,
                        ),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: Obx(() {
                          var parkingList = parkingController.parkingList;
                          return DropdownButton2<String>(
                            isExpanded: true,
                            items: parkingList.map((ParkingModel item) {
                              return DropdownMenuItem<String>(
                                value: item
                                    .pId, // Use the title property from the model
                                child: Text(
                                  item.title!, // Use the title property from the model
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.grey[600],
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              );
                            }).toList(),
                            value: selectedValue,
                            onChanged: (String? value) {
                              setState(() {
                                selectedValue = value;
                                // print("selected value $selectedValue");
                              });
                            },
                            buttonStyleData: ButtonStyleData(
                              width: 120,
                              padding: EdgeInsets.only(left: 14, right: 14),
                              elevation: 2,
                            ),
                            iconStyleData: IconStyleData(
                              icon: Icon(Icons.arrow_drop_down),
                              iconSize: 14,
                              iconEnabledColor: Colors.black,
                              iconDisabledColor: Colors.black,
                            ),
                            dropdownStyleData: DropdownStyleData(
                              maxHeight: 300,
                              width: double.infinity,
                              padding: EdgeInsets.only(left: 20, right: 20),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(14),
                                color: Colors.white,
                              ),
                              offset: const Offset(-20, 0),
                              scrollbarTheme: ScrollbarThemeData(
                                radius: const Radius.circular(40),
                                thickness: MaterialStateProperty.all<double>(6),
                                thumbVisibility:
                                    MaterialStateProperty.all<bool>(true),
                              ),
                            ),
                            menuItemStyleData: const MenuItemStyleData(
                              height: 40,
                              padding: EdgeInsets.only(left: 14, right: 14),
                            ),
                          );
                        }),
                      ),
                    ),

                    SizedBox(height: 20),

                    // button
                    ElevatedButton(
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          // check if TextEditingControllers are empty
                          // if (carPlateController.text.isEmpty ||
                          //     carOwnerPhoneController.text.isEmpty) {
                          //   // show error message
                          //   Get.snackbar(
                          //     "Error",
                          //     "Please fill all fields",
                          //     snackPosition: SnackPosition.BOTTOM,
                          //   );
                          // } else {
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
                          // }
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
