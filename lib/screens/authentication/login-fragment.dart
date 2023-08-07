import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../api_connection/api.connection.dart';
// imort http package
import 'package:http/http.dart' as http;

import '../users/main_fragment.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // form key declaration
  var formKey = GlobalKey<FormState>();
  //text field controllers
  var phoneController = TextEditingController();
  var passwordController = TextEditingController();
  var isObsecure = true.obs;

  loginMethod() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var phoneTxt = phoneController.text;
    var passwordTxt = passwordController.text;

    try {
      var url = Uri.parse(API.signIn);
      var response = await http.post(url, body: {
        "phone": phoneTxt,
        "password": passwordTxt,
      });

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        var success = data['status'];
        var message = data['message'];
        if (success == "success" && message == "Login Successful") {
          var id = data['id'];
          var fname = data['fname'];
          var lname = data['lname'];
          var email = data['email'];
          var phoneNumber = data['phoneNumber'];
          var password = data['password'];
          var addedBy = data['AddedBy'];
          var addedOn = data['addedOn'];
          var activeStatus = data['ActiveStatus'];

          // save data to shared preferences
          preferences.setString("id", id);
          preferences.setString("fname", fname);
          preferences.setString("lname", lname);
          preferences.setString("email", email);
          preferences.setString("phoneNumber", phoneNumber);
          preferences.setString("password", password);
          preferences.setString("addedBy", addedBy);
          preferences.setString("addedOn", addedOn);
          preferences.setString("activeStatus", activeStatus);

          // close loading dialog
          Get.back();
          // navigate to home screen
          Get.offAll(() => MainFragment());
        } else if (success == "error" && message == "Password is incorrect") {
          Get.back();
          Get.snackbar("Error", "Password is incorrect");
        } else {
          Get.back();
          Get.snackbar("Error", "Phone number does not exist");
        }
      } else {
        Get.snackbar("Error", "Invalid credentials");
        print("error response code: ${response.statusCode} $url");
      }
    } catch (e) {
      print("Error2: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const Center(
                  child: SizedBox(
                    height: 100,
                    width: 200,
                    child: Image(
                      image: AssetImage(
                        "images/parking1.png",
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 60,
                ),
                Form(
                    key: formKey,
                    child: Column(
                      children: [
                        // phone
                        // TextFormField here
                        TextFormField(
                          controller: phoneController,
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                            labelText: "Phone Number",
                            hintText: "Enter your phone number",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            prefixIcon: Icon(Icons.phone),
                            suffixIcon: Icon(Icons.close),
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Phone number is required";
                            }
                            // else if (!value.contains("@")) {
                            //   return "Invalid email";
                            // }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        // password
                        // TextFormField here
                        Obx(() {
                          return TextFormField(
                            controller: passwordController,
                            obscureText: isObsecure.value,
                            decoration: InputDecoration(
                              labelText: "Password",
                              hintText: "Enter your password",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              prefixIcon: Icon(Icons.lock),
                              suffixIcon: IconButton(
                                onPressed: () {
                                  isObsecure.value = !isObsecure.value;
                                },
                                icon: Icon(Icons.remove_red_eye),
                              ),
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Password is required";
                              } else if (value.length < 3) {
                                return "Password must be atleast 6 characters";
                              }
                              return null;
                            },
                          );
                        }),
                        SizedBox(
                          height: 20,
                        ),
                        // login button
                        // ElevatedButton here
                        ElevatedButton(
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              print("Validated");
                              Get.defaultDialog(
                                title: "Loading...",
                                content: const CircularProgressIndicator(),
                                barrierDismissible: false,
                              );
                              loginMethod();
                            }
                          },
                          child: Text("Login"),
                          style: ElevatedButton.styleFrom(
                            minimumSize: Size(double.infinity, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        // register text
                        // Row here
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextButton(
                              onPressed: () {},
                              child: Text(
                                "New User? Register here",
                                style: TextStyle(
                                  color: Color.fromARGB(255, 43, 44, 143),
                                ),
                              ),
                            ),
                            // forgot password text
                            // TextButton here

                            TextButton(
                              onPressed: () {},
                              child: Text("Forgot Password?"),
                            ),
                          ],
                        ),
                      ],
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
