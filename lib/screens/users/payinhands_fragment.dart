import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:get/get.dart';
import 'package:parkingapp/screens/users/payinhandsdetails.dart';

import '../../contrals/payinhands_controller.dart';
import '../widget/appbar.dart';

class PayInHandsFragment extends StatelessWidget {
  PayInHandsFragment({super.key});

  PayInHandsController payInHandsController = Get.put(PayInHandsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Pay In Hands',
      ),
      body: FutureBuilder<void>(
        future: payInHandsController.getPayInHandsMethod(),
        builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            // Display your data here
            return Obx(() {
              if (payInHandsController.isLoading.value) {
                return Center(child: CircularProgressIndicator());
              } else {
                return ListView.builder(
                  itemCount: payInHandsController.payinhandList.length,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder:
                      (BuildContext context, int index) {
                        return GestureDetector(
                          onTap: () {
                            Get.to(() => PayInHandsDetailsScreen(
                                  payment: payInHandsController.payinhandList[index],
                                ));
                          },
                          child: Card(
                            child: ListTile(
                              
                              title: Text(
                                payInHandsController.payinhandList[index].ownerName??"",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Text(
                                payInHandsController.payinhandList[index].phoneNumber??"",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              trailing: Text(
                                payInHandsController.payinhandList[index].price??"",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        );
                      },

                );
              }
            });
          }
        },
      ),
    );
  }
}
