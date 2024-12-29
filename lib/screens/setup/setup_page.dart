import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:twine/helper.dart';
import 'package:twine/widgets/circular_picture.dart';
import 'package:mime/mime.dart';

class SetupPage extends StatefulWidget {
  const SetupPage({super.key, required this.connectCode});

  // partner connect code
  final String connectCode;
  @override
  State<SetupPage> createState() => _SetupPageState();
}

class _SetupPageState extends State<SetupPage> {
  final _picker = ImagePicker();
  final _anniversaryController = TextEditingController();
  final _reunionController = TextEditingController();
  
  File? image;
  String nickName = "";
  DateTime anniversaryDate = DateTime.now();
  bool longDistance = false;
  DateTime reunionDate = DateTime.now();
  bool _submitting = false;

  @override
  initState() {
    super.initState();
    _anniversaryController.text = DateFormat('d MMM yyyy').format(anniversaryDate);
    _reunionController.text = DateFormat('d MMM yyyy').format(reunionDate);
  }

  Future<void> _pickImage(BuildContext context, ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(source: source);
      if (pickedFile != null) {
        setState(() {
          image = File(pickedFile.path);
        });
      }
    } catch (e) {
      print('Error picking image: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          generateSnackBar("Error, please select another image."));
      }
    }
  }

  void setAnniversaryDate(DateTime selected) {
    setState(() {
      anniversaryDate = selected;
    });
    _anniversaryController.text = DateFormat('d MMM yyyy').format(selected);
  }
  void setReunionDate(DateTime selected) {
    setState(() {
      reunionDate = selected;
    });
    _reunionController.text = DateFormat('d MMM yyyy').format(selected);
  }

  void _linkAccount() async {
    setState(() {
      _submitting = true;
    });
    // read file as base64 string
    String dataString = image != null ? base64Encode(image!.readAsBytesSync()) : "";
    try {
      // call API to set up partner settings
      await FirebaseFunctions.instance.httpsCallable("setupAccount").call({
        "connectCode": widget.connectCode,
        "anniversaryDate": anniversaryDate.toIso8601String(),
        "reunionDate": reunionDate.toIso8601String(),
        "imageData": dataString,
        "mimeType": lookupMimeType(image?.path ?? ""),
        "nickName": nickName,
      });
      setState(() {
        _submitting = false;
      });
    } catch(e) {
      print(e);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          generateSnackBar("Error occurred please fill out all fields."));
      }
      setState(() {
        _submitting = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;

    return Container(
      color: theme.primary, 
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          children: <Widget>[
            CircularContainer(
              radius: 200,
              child: GestureDetector(
                onTap: () => _pickImage(context, ImageSource.gallery),
                child: image == null ? 
                  Icon(Icons.person, size: 150, color: theme.primary,):
                  Image.file(image!, width: 200, height: 200, fit: BoxFit.cover,)
              )
            ),
            const SizedBox(height: 20,),

            TextFormField(
              onChanged: (text) {
                setState(() {
                  nickName = text;
                });
              },
              textAlign: TextAlign.center,
              decoration: const InputDecoration(hintText: "Your partner's nickname"),
            ),
            const SizedBox(height: 10,),

            const Text("Anniversary date", style: TextStyle(color: Colors.white),),
            GestureDetector(
              onTap: () => showDatePickerDialog(
                context, 
                anniversaryDate,
                setAnniversaryDate,
                firstDate: DateTime(DateTime.now().year - 30),
                lastDate: DateTime.now()
              ),
              // need AbsorbPointer to override text input focus
              child: AbsorbPointer(
                child: TextField(
                  controller: _anniversaryController,
                  readOnly: true,
                  textAlign: TextAlign.center,
                ),
              )
            ),
            const SizedBox(height: 10,),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Text("Long distance", style: TextStyle(color: Colors.white),),
                Container(
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.white),
                  child: ToggleButtons(
                    color: Colors.black,
                    fillColor: theme.secondary,
                    selectedColor: Colors.black,
                    borderRadius: BorderRadius.circular(10),
                    isSelected: [longDistance, !longDistance],
                    onPressed: (int index) {
                      setState(() {
                        longDistance = index == 0;
                      });
                    },
                    children: const <Widget> [
                      Text("Yes"),
                      Text("No")
                    ]
                  )
                )
              ],
            ),
            const SizedBox(height: 10,),
            Visibility(
              visible: longDistance,
              child: GestureDetector(
                onTap: () => showDatePickerDialog(
                  context, 
                  reunionDate, 
                  setReunionDate,
                  firstDate: DateTime.now()
                ),
                child: AbsorbPointer(
                  child: TextField(
                    controller: _reunionController,
                    readOnly: true,
                    textAlign: TextAlign.center,
                  )
                )
              )
            ),

            const SizedBox(height: 20,),
            OutlinedButton(
              onPressed: _linkAccount, 
              child: _submitting ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(color: Colors.white)
              ) : const Text(
                "Submit", 
                style: TextStyle(color: Colors.white),
              )
            )
          ],
        )
      )
    );
  }
}