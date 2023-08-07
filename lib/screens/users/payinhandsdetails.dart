import 'package:flutter/material.dart';
import 'package:parkingapp/models/payinhands_model.dart';
import 'package:parkingapp/screens/widget/appbar.dart';

class PayInHandsDetailsScreen extends StatelessWidget {
  final PayInHandsModel payment;
  PayInHandsDetailsScreen({required this.payment});


  @override
  Widget build(BuildContext context) {
   
    return  Scaffold(
      appBar: CustomAppBar(
        title: 'Details ${payment.ownerName ?? ""}',
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SizedBox(
          width: 400,
          height: 280,
          child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Owner Name:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(payment.ownerName ?? "", style: TextStyle(fontSize: 16)),
                  SizedBox(height: 12),
                  Text(
                    'Phone Number:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(payment.phoneNumber ?? "", style: TextStyle(fontSize: 16)),
                  SizedBox(height: 12),
                  Text(
                    'Price:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(payment.price ?? "" , style: TextStyle(fontSize: 16)),
                  SizedBox(height: 12),
                  Text(
                    'Date:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(payment.date ?? "", style: TextStyle(fontSize: 16)),
                  SizedBox(height: 12),
                  
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
