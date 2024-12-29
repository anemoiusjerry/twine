import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:twine/widgets/datepicker_card.dart';

SnackBar generateSnackBar(String text) {
  return SnackBar(content: Text(text), duration: const Duration(seconds: 3),);
}

void showDatePickerDialog(
  BuildContext context, 
  DateTime initialDate, 
  Function(DateTime) setSelectedDate,
  {DateTime? firstDate,
  DateTime? lastDate,}
) {
  showDialog(
    context: context, 
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: DatepickerCard(
            initialDate: initialDate,
            firstDate: firstDate ?? DateTime(DateTime.now().year - 5),
            lastDate: lastDate ?? DateTime(DateTime.now().year + 5),
            handleDateSelect: setSelectedDate
          ),
        )
      );
    }
  );
}

Future<String> uploadToFirebase(File image, String fileName, String firebasePath) async {
  final storageRef = FirebaseStorage.instance.ref();
  // create firebase ref to where file is saved
  final imageRef = storageRef.child("$firebasePath/$fileName");
  TaskSnapshot uploadTask = await imageRef.putFile(image);
  String blobUrl = await uploadTask.ref.getDownloadURL();
  return blobUrl;
}