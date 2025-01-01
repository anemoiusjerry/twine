import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:twine/widgets/datepicker_card.dart';
import 'package:timezone/timezone.dart' as tz;

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