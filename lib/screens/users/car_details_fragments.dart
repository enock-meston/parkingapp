import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../api_connection/api.connection.dart';
import '../../models/car_model.dart';
import 'package:http/http.dart' as http;

import '../../models/view_car_model.dart';

// import random
import 'dart:math';

class CarDetailScreen extends StatelessWidget {
  final ViewCarModel car;

  CarDetailScreen({required this.car});

  // payment method
  paymentMethod(
      String carId, String phoneNumber, String price, String ownerName) async {
    var timeOut = DateTime.now().second.toString();
    // random number from 10000 to 99999
    var randomNumber = (10000 + Random().nextInt(99999 - 10000)).toString();

    String transactionID =
        "ffe037792vcdmx51e8l5h4603qf0064aj9$timeOut$randomNumber";
    print("seconds $timeOut phone : $phoneNumber amount : $price");
    var headers = {'Content-Type': 'application/json'};
    var request = http.Request(
        'POST', Uri.parse('https://opay-api.oltranz.com/opay/paymentrequest'));
    request.body = json.encode({
      "telephoneNumber": "25$phoneNumber",
      "amount": price,
      "organizationId": "dd9f8b81-f584-487c-9aa3-515c2e01d6fa",
      "description": "Payment for Printing services",
      "callbackUrl": "https://parking.nigoote.com/android/callback.php",
      // "callbackUrl": "https://webhook.site/#!/1d06db09-0248-48eb-a1de-b570a724ce49",
      // "callbackUrl": "http://myonlineprints.com/payments/callback",
      "transactionId": "$transactionID"
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      // print(await response.stream.bytesToString());
      var data = await response.stream.bytesToString();
      var jsonData = json.decode(data);
      print("=====================");
      print(data);
      print("========$jsonData=============");

      String code = jsonData['code'];
      String description = jsonData['description'];
      String status = jsonData['status'];

      if (code == "401") {
        Get.defaultDialog(
          title: "Message",
          middleText:
              "THE PAYER DOES NOT HAVE SUFFICIENT FUNDS ON HIS/HER ACCOUNT",
          confirm: ElevatedButton(
            onPressed: () {
              Get.back();
            },
            child: Text("OK"),
          ),
        );
      }
      // Access values inside the 'body' object
      // String transactionID = jsonData['body']['transactionId'];

      // Print the values
      // print('Code: $code');
      // print('Description: $description');
      // print('Status: $status');
      // print('Transaction ID: $transactionId');
      print("=====================");
      //  ===================================
      // save to database using api
      String url = API.saveTransaction;
      var responseTransaction = await http.post(Uri.parse(url), body: {
        "carId": carId,
        "ownerName": ownerName,
        "phone": phoneNumber,
        "amount": price,
        "status": status,
        "transactionId": transactionID,
      });

      if (responseTransaction.statusCode == 200) {
        var dataTransaction = jsonDecode(responseTransaction.body);
        print("turebe $dataTransaction");
        // print("transaction: ${dataTransaction}");
        var message = dataTransaction['message'];
        var status1 = dataTransaction['status'];
        if (status1 == "success" &&
            message == "transaction added successfully") {
              Get.back();
          // Show dialog
          Get.defaultDialog(
              title: "Message",
              middleText: "Transaction added successfully",
              confirm: ElevatedButton(
                onPressed: () {
                  Get.back();
                },
                child: Text("OK"),
              ));
              // Get.back();
        } else {
          print("error");
        }
      } else {
        print("error");
      }

      // ====================================
    } else {
      print(response.reasonPhrase);
    }
  }
  // end payment method

  // send message
  sendMessage(
      String phoneNumber, String price, String ownerName, String plate) async {
    // send sms to phone
    // ==========
    String message =
        "Mukiriya Mwiza $ownerName  Tubashimiye Ko mwatugiriye Icyizere mukadusigira Imodoka yanyu ifite purake(Plate) No: $plate, Mwaciwe amafaranga angana na $price, Murakoze Twishimiye kuzongera gukorana namwe!";
    var data = {
      "sender": 'Nigoote ltd',
      "recipients": "$phoneNumber",
      "message": "$message",
    };

    var url = Uri.parse("https://www.intouchsms.co.rw/api/sendsms/.json");
    var username = "enock-meston";
    var password = "Enock@123";

    var response = await http.post(url,
        headers: <String, String>{
          'Authorization':
              'Basic ' + base64Encode(utf8.encode('$username:$password')),
        },
        body: data);

    if (response.statusCode == 200) {
      // SMS sent successfully
      var result = response.body;
      print(result);
      Get.snackbar(
        "Success",
        "Message sent successfully",
        snackPosition: SnackPosition.BOTTOM,
      );
    } else {
      // Error sending SMS
      print('Failed to send SMS. Error code: ${response.statusCode}');
    }

    // update data method in order to change the status of the data

// Call the function to send the SMS

    //==========
  }
  // end send message

// =========save cash by hands==========
  saveCashByHands(String carId, String phoneNumber, String price,
      String ownerName, String plate) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String userId = prefs.getString('id')!;
      String url = API.payInHands;
      var response1 = await http.post(Uri.parse(url), body: {
        "carId": carId,
        "ownerName": ownerName,
        "phone": phoneNumber,
        "amount": price,
        "status": "success",
        "transactionId": "0",
        "userId": userId,
      });
      if (response1.statusCode == 200) {
        var data = jsonDecode(response1.body);
        print("data: $data");
        var message = data['message'];
        var status = data['status'];
        if (status == "error" && message == "Car already Paid") {
          // dialog
          Get.defaultDialog(
            title: "Message",
            middleText: "Car already Paid",
            confirm: ElevatedButton(
              onPressed: () {
                Get.back();
              },
              child: Text("OK"),
            ),
          );
        } else if (status == "success" &&
            message == "transaction added successfully") {
          // dialog
          Get.defaultDialog(
            title: "Message",
            middleText: "Car Paid successfully",
            confirm: ElevatedButton(
              onPressed: () {
                Get.back();
              },
              child: Text("OK"),
            ),
          );
          sendMessage(phoneNumber, price, ownerName, plate);
        } else {
          // snackbar
          Get.snackbar(
            "Error",
            "Error in paying car / Query",
            snackPosition: SnackPosition.BOTTOM,
          );
          print("error in payin hands");
        }
      } else {
        print("error in payin hands ${response1.statusCode}");
      }
    } catch (e) {
      print("error in payinhands Catch: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Car Details'),
      ),
      body: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card(
            child: SizedBox(
              height: 240,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Plate: ${car.carPlate}',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Owner Name: ${car.carOnwerNames}',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Phone: ${car.phoneNumber}',
                      style: TextStyle(fontSize: 16),
                    ),
                    Text(
                      'Parking Place: ${car.title}',
                      style: TextStyle(fontSize: 16),
                    ),
                    Text(
                      'Price: ${car.price} Rwf',
                      style: TextStyle(fontSize: 16),
                    ),
                    Text(
                      'Time In: ${car.timeIn}',
                      style: TextStyle(fontSize: 16),
                    ),
                    Text(
                      'Time Out: ${car.timeOut}',
                      style: TextStyle(fontSize: 16),
                    ),
                    Text(
                      'Agent ID: ${car.agentsID}',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    // devider
                    Divider(
                      color: Colors.grey,
                      height: 10,
                      thickness: 1,
                      indent: 10,
                      endIndent: 0,
                    ),
                    // add button
                    SingleChildScrollView(
                      scrollDirection: Axis
                          .horizontal, // Scroll horizontally (left-to-right)
                      child: Row(
                        children: [
                          ElevatedButton.icon(
                            onPressed: () {
                              Get.defaultDialog(
                                title: "Loading...",
                                content: LinearProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors
                                          .blue), // Set your desired color here
                                  backgroundColor: Colors.grey[200],
                                ),
                                barrierDismissible: false,
                              );
                              String carId = car.carId ?? "";
                              String phoneNumber = car.phoneNumber ?? "";
                              String price = car.price ?? "";
                              String OwnerName = car.carOnwerNames ?? "";
                              // print("phone : $phoneNumber amount : $price");
                              // Show the loading dialog with LinearProgressIndicator

                              paymentMethod(
                                  carId, phoneNumber, price, OwnerName);
                            },
                            icon: const Icon(Icons.payment),
                            label: const Text('MoMo'),
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                  Color.fromARGB(255, 177, 159, 1)),
                            ),
                          ),
                          SizedBox(width: 10),
                          // edit button
                          ElevatedButton.icon(
                              onPressed: () {
                                String carId = car.carId ?? "";
                                String plate = car.carPlate ?? "";
                                String phoneNumber = car.phoneNumber ?? "";
                                String price = car.price ?? "";
                                String ownerName = car.carOnwerNames ?? "";
                                //
                                saveCashByHands(carId, phoneNumber, price,
                                    ownerName, plate);
                              },
                              icon: Icon(Icons.money),
                              label: const Text(
                                'Cash in Hands',
                                style: TextStyle(fontSize: 16),
                              ),
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all(Colors.green),
                              )),
                          SizedBox(width: 10),
                          // send message
                          ElevatedButton.icon(
                            onPressed: () {
                              String plate = car.carPlate ?? "";
                              String phoneNumber = car.phoneNumber ?? "";
                              String price = car.price ?? "";
                              String ownerName = car.carOnwerNames ?? "";
                              sendMessage(phoneNumber, price, ownerName, plate);
                            },
                            icon: Icon(Icons.message),
                            label: const Text('SMS'),
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.blue),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
