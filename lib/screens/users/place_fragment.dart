import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:get/get.dart';
import 'package:parkingapp/models/parking_model.dart';
import 'package:parkingapp/screens/users/place_details_fragment.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../api_connection/api.connection.dart';
import '../../contrals/parking_controler.dart';
import '../widget/add_place_widget.dart';
import '../widget/appbar.dart';
import '../../contrals/form_dialog_controller.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PlaceFragment extends StatelessWidget {
  PlaceFragment({super.key});

  ParkingController parkingController = Get.put(ParkingController());

  final FormDialogController _controller = Get.put(FormDialogController());

  TextEditingController titleController = TextEditingController();

  TextEditingController placeRefController = TextEditingController();

  TextEditingController priceController = TextEditingController();

  submitForm() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userId = prefs.getString('id')!;

    var url = Uri.parse(API.addParking);
    ParkingModel parkingModel = ParkingModel(
      pId: "",
      title: titleController.text,
      refere: placeRefController.text,
      price: priceController.text,
      status: "1",
      addedOn: "",
      postedBy: userId,
    );

    try {
      var response = await http.post(url, body: parkingModel.toJson());

      if (response.statusCode == 200) {
        print(response.body);
        var data = jsonDecode(response.body);
        var message = data['message'];
        var status = data['status'];
        if (status == "success" && message == "parking added successfully") {
          // show dialog
          Get.defaultDialog(
              title: "Success",
              middleText: "Parking added successfully !",
              actions: [
                TextButton(
                  onPressed: () {
                    // clear all text fields
                    titleController.clear();
                    placeRefController.clear();
                    priceController.clear();
                    // close dialog
                    Get.back();
                    Get.to(() => PlaceFragment());
                  },
                  child: Text("Ok"),
                )
              ]);
          
        } else if (status == "error" && message == "parking already exists") {
          Get.snackbar(
            "Error",
            "Parking already exists",
            snackPosition: SnackPosition.BOTTOM,
          );
          Get.back();
        } else {
          Get.snackbar("Error", "Error");
        }
      } else {
        Get.snackbar("Error", "Error");
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    // print("parking number: ${parkingController.parkingList.length}");
    return Scaffold(
      appBar: CustomAppBar(
        title: "Parking",
        actions: [
          IconButton(
            onPressed: () {
              Get.dialog(_buildFormDialog());
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: FutureBuilder<List<ParkingModel>>(
  future: parkingController.getParkingList(),
  builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return Center(
        child: CircularProgressIndicator(),
      );
    } else if (snapshot.hasError) {
      return Center(
        child: Text("Error: ${snapshot.error}"),
      );
    } else {
      return SingleChildScrollView( // Add a return statement here
        child: Column(
          children: [
            parkingController.parkingList.isEmpty
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: parkingController.parkingList.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          Get.to(() => PlaceDetailsScreen(
                                parking: parkingController.parkingList[index],
                              ));
                        },
                        child: Card(
                          child: ListTile(
                            title: Text(
                              "Title: ${parkingController.parkingList[index].title}",
                            ),
                            subtitle: Text(
                              "Location: ${parkingController.parkingList[index].refere}",
                            ),
                            trailing: Text(
                              "Price:${parkingController.parkingList[index].price} Rwf",
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ],
        ),
      );
    }
  },
),

    );
  }

  //
  Widget _buildFormDialog() {
    return AlertDialog(
      title: const Text('Add Parking'),
      content: Form(
        key: _controller.formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: titleController,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  )),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a Title';
                }
                return null;
              },
              // onChanged: (value) => _controller.title.value = value,
            ),
            const SizedBox(
              height: 10,
            ),
            TextFormField(
              controller: placeRefController,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                  labelText: 'Reference',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  )),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter an Reference';
                }
                return null;
              },
              // onChanged: (value) => _controller.placeRef.value = value,
            ),
            const SizedBox(
              height: 10,
            ),
            TextFormField(
              controller: priceController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Price',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter an Price';
                }
                return null;
              },
              // onChanged: (value) => _controller.price.value = value,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // _controller.submitForm();

                submitForm();
                Get.back();
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
