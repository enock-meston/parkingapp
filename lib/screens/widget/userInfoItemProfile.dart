 
  
  import 'package:flutter/material.dart';

Widget userInfoItemProfile(IconData iconData, String userData){
    
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.grey,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
      child: Row(
        children: [
          Icon(
            iconData,
          size:30 ,
          color: Colors.black,
          ),
          const SizedBox(width: 16,),
          
          Text(
              userData,
            style: const TextStyle(
              fontSize: 15,
            ),
          )
        ],
      ),
    );
  }