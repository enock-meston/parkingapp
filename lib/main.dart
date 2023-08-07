import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:parkingapp/contrals/user_profile_controller.dart';
import 'package:parkingapp/models/agents_model.dart';
import 'package:parkingapp/screens/users/main_fragment.dart';

import 'UserPreferences/user_preferences.dart';
import 'screens/authentication/login-fragment.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final UserProfileControler _userProfileControler =
      Get.put(UserProfileControler());

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // remove debug banner

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Parking App',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: FutureBuilder(
  future: RememberUserPrefs.readUserInfo(),
  builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      // Future is still loading
      return CircularProgressIndicator(); // or any other loading indicator
    } else if (snapshot.hasError) {
      // Future threw an error
      return Text('Error: ${snapshot.error}');
    } else {
      // Future completed successfully, now check if it has data or not
      if (snapshot.hasData) {
        // Data is available (user is logged in)
        return MainFragment();
      } else {
        // Data is null (user is not logged in)
        return LoginScreen();
      }
    }
  },
),
    );
  }
}
