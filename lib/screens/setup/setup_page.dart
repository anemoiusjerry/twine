import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:twine/widgets/circular_picture.dart';

class SetupPage extends StatefulWidget {
  const SetupPage({super.key, required this.connectCode});

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
  bool longDistance = true;
  DateTime reunionDate = DateTime.now();

  @override
  initState() {
    super.initState();
    _anniversaryController.text = DateFormat('d MMM yyyy').format(anniversaryDate);
    _reunionController.text = DateFormat('d MMM yyyy').format(reunionDate);
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(source: source);

      if (pickedFile != null) {
        setState(() {
          image = File(pickedFile.path);
        });
      }
    } catch (e) {
      print('Error picking image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;

    return Container(
      color: theme.primary, 
      child: Column(
        children: <Widget>[
          CircularContainer(
            radius: 200,
            borderWidth: 0,
            child: image == null ? 
            Icon(Icons.person, size: 150, color: theme.primary,):
            Image.file(image!, width: 200, height: 200,)
          ),
          const SizedBox(height: 20,),
          TextFormField(
            textAlign: TextAlign.center,
            decoration: const InputDecoration(hintText: "Your partner's nickname"),
          ),
          const SizedBox(height: 10,),
          const Text("Anniversary date", style: TextStyle(color: Colors.white),),
          TextField(
            controller: _anniversaryController,
            textAlign: TextAlign.center,
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
            child: TextFormField(
              controller: _reunionController,
              textAlign: TextAlign.center,
            )
          ),
          OutlinedButton(onPressed: (){}, child: const Text("Next"))
        ],
      )
    );
  }
}