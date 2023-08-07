import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../UserPreferences/current_user.dart';
import '../../UserPreferences/user_preferences.dart';
import '../../api_connection/api.connection.dart';
import '../../contrals/user_profile_controller.dart';
import '../../models/agents_model.dart';
import '../authentication/login-fragment.dart';
import '../widget/appbar.dart';
import '../widget/userInfoItemProfile.dart';
import 'package:http/http.dart' as http;

class ProfileFragment extends StatelessWidget {
  final CurrentUser _currentUser = Get.put(CurrentUser());
  final UserProfileControler _userProfileControler =
      Get.put(UserProfileControler());

  ProfileFragment({super.key});

  signOurUser() async {
    var resultResponse = await Get.dialog(AlertDialog(
      backgroundColor: Colors.grey,
      title: const Text(
        "Logout",
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      content: const Text("Are you sure? \n "),
      actions: [
        TextButton(
            onPressed: () {
              Get.back();
            },
            child: const Text(
              "No",
              style: TextStyle(
                color: Colors.black,
              ),
            )),
        TextButton(
            onPressed: () {
              Get.back(result: "loggedOut");
            },
            child: const Text(
              "Yes",
              style: TextStyle(
                color: Colors.black,
              ),
            )),
      ],
    ));

    if (resultResponse == "loggedOut") {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.remove("id");
     
      //remove the user sharedPreference
      // delete user from phone storage
      RememberUserPrefs.removeUserInfo().then((value) {
        Get.off(LoginScreen());
      });
    }
  }

  
  @override
  Widget build(BuildContext context) {
    _userProfileControler.getUserProfileData();

    return Scaffold(
      appBar: CustomAppBar(
        title: _userProfileControler.agentsModel.fname ?? "",
        actions: [
          IconButton(
            onPressed: () {
              Get.defaultDialog(
                title: "Help",
                content: const Center(
                  child: Text(
                    "You can call us on \n0783 982 872 or email us on ndagijimanaenock11@gmail.com",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                    ),
                    
                  ),
                  
                ),
                actions: [
                  TextButton(
                      onPressed: () {
                        Get.back();
                      },
                      child: const Text(
                        "Ok",
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      )),
                ],
              );
            },
            icon: const Icon(Icons.help, color: Colors.black,),
          ),
          IconButton(
            onPressed: () {
            },
            icon: const Icon(Icons.edit, color: Colors.black,),
          ),
        ],


      ),
      body: FutureBuilder<AgentsModel>(
        future: _userProfileControler.getUserProfileData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else {
            return ListView(
              padding: const EdgeInsets.all(32),
              children: [
                Center(
                  child: Image.asset(
                    "images/profile.png",
                    width: 80,
                  ),
                ),
                const SizedBox(height: 20),
                userInfoItemProfile(Icons.person, snapshot.data?.fname ?? ""),
                const SizedBox(height: 20),
                userInfoItemProfile(Icons.email, snapshot.data?.lname ?? ""),
                const SizedBox(height: 20),
                userInfoItemProfile(
                    Icons.phone, snapshot.data?.phoneNumber ?? ""),
                const SizedBox(height: 20),
                userInfoItemProfile(Icons.email, snapshot.data?.email ?? ""),
                const SizedBox(height: 20),
                Center(
                  child: Material(
                    color: Colors.redAccent,
                    borderRadius: BorderRadius.circular(8),
                    child: InkWell(
                      onTap: () {
                        signOurUser();
                      },
                      borderRadius: BorderRadius.circular(32),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 30,
                          vertical: 12,
                        ),
                        child: Text(
                          "Sign Out",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
