import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../api_connection/api.connection.dart';
// import http
import 'package:http/http.dart' as http;

class FormDialogController extends GetxController {
  final formKey = GlobalKey<FormState>();
  var title = ''.obs;
  var placeRef = ''.obs;
  var price = ''.obs;

  submitForm() {
    
  }
}