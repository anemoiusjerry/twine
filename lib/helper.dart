import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:twine/widgets/datepicker_card.dart';
import 'package:timezone/timezone.dart' as tz;

bool checkValidEmail(String emailAddress) {
  const pattern = r"(?:[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'"
  r'*+/=?^_`{|}~-]+)*|"(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-'
  r'\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])*")@(?:(?:[a-z0-9](?:[a-z0-9-]*'
  r'[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\[(?:(?:(2(5[0-5]|[0-4]'
  r'[0-9])|1[0-9][0-9]|[1-9]?[0-9]))\.){3}(?:(2(5[0-5]|[0-4][0-9])|1[0-9]'
  r'[0-9]|[1-9]?[0-9])|[a-z0-9-]*[a-z0-9]:(?:[\x01-\x08\x0b\x0c\x0e-\x1f\'
  r'x21-\x5a\x53-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])+)\])';
  final regex = RegExp(pattern);
  return emailAddress.isNotEmpty && regex.hasMatch(emailAddress);
}

bool checkValidDate(String date) {
  const pattern = r'^(0[1-9]|[12][0-9]|3[01])/(0[1-9]|1[0-2])/\d{4}$';
  final regex = RegExp(pattern);
  return date.isNotEmpty && regex.hasMatch(date);
}

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

void showTimezones(BuildContext context, void Function(String) onSelect) {
  final timezones = tz.timeZoneDatabase.locations;
  showDialog(
    context: context, 
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text("Select your partner's timezone"),
        content: SizedBox(
          height: 300,
          width: 300,
          child: ListView.builder(
          shrinkWrap: true,
          itemCount: timezones.length,
          itemBuilder: (_, int index) {
            return ListTile(
              title: Text(timezones.keys.elementAt(index)),
              onTap: () {
                onSelect(timezones.keys.elementAt(index));
                Navigator.pop(context);
              },
            );
          },
        )),
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