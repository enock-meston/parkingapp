import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:parkingapp/models/transaction_model.dart';

class TransactionDetailPage extends StatelessWidget {
  final TransactionModel transaction;
   TransactionDetailPage({ required this.transaction});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${transaction.ownerName}'),
      ),
      body: Card(
  color: Color.fromARGB(255, 245, 237, 237),
  elevation: 4.0,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(10.0),
  ),
  child: SizedBox(
    height: 310,
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Car Owner Name: ${transaction.ownerName}',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Phone: ${transaction.phone}',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[800],
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Amount: ${transaction.amount} Rwf',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[800],
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Status: ${transaction.trstatus}',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[800],
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Transaction ID: ${transaction.transactionId}',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[800],
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Transaction ID MoMo: ${transaction.transactionIDMoMo}',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[800],
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Added On: ${transaction.addedOn}',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[800],
            ),
          ),
          SizedBox(height: 16),

          // Divider
          Divider(
            color: Colors.grey,
            height: 10,
            thickness: 1,
            indent: 10,
            endIndent: 0,
          ),

          // Action buttons
          SingleChildScrollView(
            scrollDirection: Axis.horizontal, // Scroll horizontally (left-to-right)
            child: Row(
              children: [
                SizedBox(width: 16),
                ElevatedButton.icon(
                  onPressed: () {
                    // Implement the print functionality here
                    // print the details of the parking

                  },
                  icon: Icon(Icons.print),
                  label: const Text('Print'),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.blue),
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
    );
  }
}