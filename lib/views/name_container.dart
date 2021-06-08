import 'package:flutter/material.dart';
//import 'package:get/get.dart';

Container nameContainer(TextEditingController name, String text) => Container(
      width: 100,
      height: 20,
      margin: EdgeInsets.symmetric(horizontal: 8),
      child: TextField(
        controller: name,
        decoration: InputDecoration(hintText: text),
      ),
    );
