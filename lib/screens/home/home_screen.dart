import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:twine/models/home_data_model.dart';
import 'package:twine/repositories/partner_setting_interface.dart';
import 'package:twine/widgets/countdown_donut.dart';
import 'package:twine/widgets/profile_picture.dart';
import 'package:twine/widgets/timezone_clock.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.data});

  final HomeDataModel data;
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final padding = const EdgeInsets.only(left: 20, right: 20, bottom: 20);
  final partnerRepo = PartnerSettingRepository(FirebaseFirestore.instance);
  final _textController = TextEditingController();

  late DateTime anniversaryDate;
  late DateTime reunionDate;
  late DateTime separationDate;
  late String? nickName;

  @override
  void initState() {
    super.initState();
    nickName = widget.data.partnerSettings?.nickName;
    _textController.text = nickName ?? "";
    anniversaryDate = widget.data.coupleInfo?.anniversaryDate?.toDate() ?? DateTime.now();
    reunionDate = widget.data.coupleInfo?.reunionDate?.toDate() ?? DateTime.now();
    separationDate = widget.data.coupleInfo?.separationDate?.toDate() ?? DateTime.now();
  }
  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _setNickName(String newName) {
    setState(() {
      nickName = newName;
    });
  }
  void _saveNewNickName() {
    partnerRepo.update(FirebaseAuth.instance.currentUser!.uid, {
      'nickName': nickName
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final nameWidth = (MediaQuery.of(context).size.width - padding.horizontal) * 0.5;

    return SafeArea(
      child: Padding(
        padding: padding,
        child:  Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ProfilePicture(
                radius: 170,
                borderColour: theme.colorScheme.secondary,
                imageUrl: widget.data.imageUrl,
                storagePath: widget.data.storagePath,
              ),
              const Spacer(),
              SizedBox(
                width: nameWidth,
                child: GestureDetector(
                  onLongPress: () {
                    showDialog<void>(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          contentPadding: const EdgeInsets.only(left: 20, right: 20, top: 20),
                          actionsPadding: const EdgeInsets.all(5),
                          actionsAlignment: MainAxisAlignment.spaceAround,
                          content: TextField(
                            controller: _textController,
                            onChanged: (value) => _setNickName(value),
                          ),
                          actions: <Widget>[
                            TextButton(
                              style: TextButton.styleFrom(
                                foregroundColor: Colors.red,
                                textStyle: const TextStyle(fontSize: 15, color: Colors.red),
                              ),
                              child: const Text('Cancel'),
                              onPressed: () => Navigator.of(context).pop(),
                            ),
                            TextButton(
                              style: TextButton.styleFrom(
                                textStyle: Theme.of(context).textTheme.labelMedium,
                              ),
                              child: const Text('Save'),
                              onPressed: () {
                                _saveNewNickName();
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      }
                    );
                  },
                  child: Text(nickName ?? "Set a nickname!", style: const TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 20)
                  ),
                )
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly, 
            children: [
              CountdownDonut(
                reunionDate: reunionDate,
                separationDate: separationDate
              ),
              SizedBox(
                width: 140, 
                child: TimezoneClock(tzString: widget.data.partnerSettings?.timezone,)
              )
            ],
          ),
          // for time spent together
          //CountdownDonut(anniversaryDate: DateTime(2023, 11, 4),)
        ],
      ),
      )
    );
  }
}