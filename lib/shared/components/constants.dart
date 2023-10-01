import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

var alertStyle = AlertStyle(
      animationType: AnimationType.fromTop,
     // isCloseButton: false,
     // isOverlayTapDismiss: false,
      descStyle: const TextStyle(fontWeight: FontWeight.bold),
      descTextAlign: TextAlign.start,
      animationDuration: const Duration(milliseconds: 400),
      alertBorder: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
        side: const BorderSide(
          color: Colors.grey,
        ),
      ),
      titleStyle: const TextStyle(
        color: Colors.green,
      ),
      alertAlignment: Alignment.topCenter,
    );