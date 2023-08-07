import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../contrals/car_controller.dart';
import '../../models/view_car_model.dart';
import '../widget/appbar.dart';
import 'car_details_fragments.dart';

class ViewCarFragment extends StatelessWidget {
  ViewCarFragment({super.key});

  final TextEditingController searchController = TextEditingController();
  CarController carController = Get.put(CarController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "Car List",
      ),
      body: FutureBuilder<void>(
        future: carController.getCarMethod(),
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
            return SingleChildScrollView(
              child: Column(
                children: [
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: carController.carDataList.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          // Navigate to detail screen with carController.carDataList[index]
                          // You can pass the selected car data to the detail screen
                          // using Get.to or Navigator.push method.
                          Get.to(() => CarDetailScreen(
                                car: carController.carDataList[index],
                              ));
                        },
                        child: Card(
                          child: ListTile(
                            title: Text(
                              "Plate: ${carController.carDataList[index].carPlate}",
                            ),
                            subtitle: Text(
                              "Owner Name: ${carController.carDataList[index].carOnwerNames}",
                            ),
                            trailing: Text(
                              "Parking Place: ${carController.carDataList[index].title}",
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
}
