import 'package:flutter/material.dart';
import 'package:twine/models/home_data_model.dart';
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
  late DateTime anniversaryDate;
  late DateTime reunionDate;
  late DateTime separationDate;

  @override
  void initState() {
    super.initState();
    anniversaryDate = widget.data.coupleInfo?.anniversaryDate?.toDate() ?? DateTime.now();
    reunionDate = widget.data.coupleInfo?.reunionDate?.toDate() ?? DateTime.now();
    separationDate = widget.data.coupleInfo?.separationDate?.toDate() ?? DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ProfilePicture(
                radius: 170,
                borderColour: theme.colorScheme.primary,
                imageUrl: widget.data.imageUrl,
                storagePath: widget.data.storagePath,
              ),
             
              Flexible(child: Text(
                widget.data.partnerSettings?.nickName ?? "Set a nickname!", 
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20))
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
          //CountdownDonut(anniversaryDate: DateTime(2023, 11, 4),)
        ],
      )
    );
  }
}