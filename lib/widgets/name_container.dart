import 'package:flutter/material.dart';
//import 'package:get/get.dart';

Container nameContainer(
  TextEditingController name,
  String text,
) =>
    Container(
      margin: EdgeInsets.symmetric(horizontal: 3),
      child: TextField(
        controller: name,
        decoration: InputDecoration(
          labelText: text,
          icon: Icon(Icons.perm_identity),
        ),
      ),
    );
