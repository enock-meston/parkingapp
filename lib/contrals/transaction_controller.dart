import 'dart:convert';

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../api_connection/api.connection.dart';
import '../models/transaction_model.dart';
import 'package:http/http.dart' as http;

class TransactionController extends GetxController {
  // Observable list to store the transactions
  var transactionsList = <TransactionModel>[].obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    // Fetch the transactions on controller initialization
    getTransactionMethod();
  }

  // Fetch transactions from the API or data source
  Future<void> getTransactionMethod() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userId = prefs.getString('id')!;
    // print("my id: $userId");
    var response =
        await http.get(Uri.parse("${API.transaction}?userId=$userId"));

print("see data: ${API.transaction}?userId=$userId");

    if (response.statusCode == 200) {
      var data =json.decode(response.body);
      // print("data pariking: $data");
      // var status = data['success'];
      // print("status: $status");
      if(data.containsKey('transactions') && data['transactions'] is List){
        var parkings = data['transactions'];
        // print("parking: $parkings");
        for (var i in parkings) {
          TransactionModel _transactionModel = TransactionModel.fromJson(i);
          transactionsList.add(
            TransactionModel(
              transId: _transactionModel.transId,
              carId: _transactionModel.carId,
              ownerName: _transactionModel.ownerName,
              phone: _transactionModel.phone,
              amount: _transactionModel.amount,
              trstatus: _transactionModel.trstatus,
              transactionId: _transactionModel.transactionId,
              transactionIDMoMo: _transactionModel.transactionIDMoMo,
              addedOn: _transactionModel.addedOn,
            )
          );
        }
        isLoading(false);
        update();
      }else{
        print("no data");
      }
      
    } else {
      print("see ${response.statusCode}");
    }
  }
}
