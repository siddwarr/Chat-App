import 'package:flutter/material.dart';

const textInputDecoration = InputDecoration(
  filled: true,
  fillColor: Colors.white,
  enabledBorder: OutlineInputBorder( //when the text field is not focused
    borderSide: BorderSide(
      color: Colors.white,
      width: 2.0,
    ),
  ),
  focusedBorder: OutlineInputBorder( //when the text field is clicked on
    borderSide: BorderSide(
      color: Colors.pink,
      width: 2.0,
    ),
  ),
);
