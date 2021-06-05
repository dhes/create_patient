import 'package:flutter/material.dart';
import 'package:get/get.dart';

Container nameContainer(TextEditingController name, String text) => Container(
      width: Get.width / 4,
      margin: EdgeInsets.symmetric(horizontal: 8),
      child: TextField(
        controller: name,
        decoration: InputDecoration(hintText: text),
      ),
    );
