import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:parkingapp/contrals/car_controller.dart';
import 'package:parkingapp/screens/users/payinhands_fragment.dart';
import 'package:parkingapp/screens/users/payment_fragment.dart';
import 'package:parkingapp/screens/users/place_fragment.dart';
import 'package:parkingapp/screens/users/profile_fragment.dart';
import 'package:parkingapp/screens/users/viewcar_fragment.dart';

import '../../contrals/parking_controler.dart';
import '../../contrals/user_profile_controller.dart';
import 'addnewcar_fragment.dart';

class MainFragment extends StatefulWidget {
  UserProfileControler userProfileControler = Get.put(UserProfileControler());
  ParkingController parkingController = Get.put(ParkingController()); 
  CarController carController = Get.put(CarController());

  MainFragment({Key? key}) : super(key: key);

  @override
  State<MainFragment> createState() => _MainFragmentState();
}

class _MainFragmentState extends State<MainFragment> {
  final PageController _pageController = PageController();
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        children: [
          AddNewCarFragment(),
          PlaceFragment(),
          ViewCarFragment(),
          TransactionListView(),
          PayInHandsFragment(),
          ProfileFragment(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.green,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.white,
        iconSize: 30,
        onTap: (index) {
          setState(() {
            currentIndex = index;
            _pageController.animateToPage(
              index,
              duration: Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.car_rental),
            label: "New Car",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_parking),
            label: "Parking",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: "Cars",
            backgroundColor: Colors.amber,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.update),
            label: "Payments",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.clean_hands),
            label: "In Hands",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: "Settings",
          )
        ],
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: MainFragment(),
  ));
}
