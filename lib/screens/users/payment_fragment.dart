import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:parkingapp/screens/users/paymentFrag_details.dart';

import '../../contrals/transaction_controller.dart';

// Assuming you already have the TransactionModel class defined

class TransactionListView extends StatelessWidget {
  final TransactionController _transactionController =
      Get.put(TransactionController());
      Future<void> _refreshTransactions() async {
    await _transactionController.getTransactionMethod();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Transactions')),
      body: Center(
        child: RefreshIndicator(
          onRefresh: _refreshTransactions,
          child: FutureBuilder<void>(
            future: _transactionController.getTransactionMethod(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                return Obx(() {
                  return ListView.builder(
                    itemCount: _transactionController.transactionsList.length,
                    itemBuilder: (context, index) {
                      var transaction = _transactionController.transactionsList[index];
                      return GestureDetector(
                        onTap: () {
                          Get.to(() => TransactionDetailPage(transaction: transaction));
                        },
                        child: ListTile(
                          leading: Icon(Icons.money),
                          title: Text('Car Name: ${transaction.ownerName}'),
                          subtitle: Text('Phone: ${transaction.phone}'),
                          trailing: Text('Amount: ${transaction.amount}'),
                        ),
                      );
                    },
                  );
                });
              }
            },
          ),
        ),
      ),
    );
  }
}
