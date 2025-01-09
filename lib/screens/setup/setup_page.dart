import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:twine/helper.dart';
import 'package:twine/widgets/profile_picture.dart';

class SetupPage extends StatefulWidget {
  const SetupPage({super.key, required this.reload, required this.storagePath});

  final VoidCallback reload;
  final String storagePath;
  @override
  State<SetupPage> createState() => _SetupPageState();
}

class _SetupPageState extends State<SetupPage> {
  final TextEditingController _timezoneController = TextEditingController();
  String nickName = "";
  String timezone = "";
  bool _submitting = false;

  @override
  void dispose() {
    _timezoneController.dispose();
    super.dispose();
  }

  void _setTimezone(String selectedTimezone) {
    setState(() {
      timezone = selectedTimezone;
    });
    _timezoneController.text = selectedTimezone;
  }

  void _linkAccount(BuildContext context) async {
    setState(() {
      _submitting = true;
    });
    try {
      // call API to set up partner settings
      await FirebaseFunctions.instance.httpsCallable("createPartnerSetting").call({
        "nickName": nickName,
        "timezone": timezone,
      });
      setState(() {
        _submitting = false;
      });
      widget.reload();
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
    final theme = Theme.of(context);

    return Container(
      color: theme.colorScheme.primary, 
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          children: <Widget>[
            ProfilePicture(
              radius: 200,
              storagePath: widget.storagePath,
            ),
            const SizedBox(height: 20,),

            TextField(
              onChanged: (text) {
                setState(() {
                  nickName = text;
                });
              },
              textAlign: TextAlign.center,
              decoration: const InputDecoration(hintText: "Your partner's nickname"),
            ),
            const SizedBox(height: 10,),
            GestureDetector(
              onTap: () => showTimezones(context, _setTimezone),
              child: AbsorbPointer(
                child: TextField(
                  controller: _timezoneController,
                  textAlign: TextAlign.center,
                  decoration: const InputDecoration(hintText: "Your partner's timezone"),
                ),
              ),
            ),
           
        
            const SizedBox(height: 20,),
            OutlinedButton(
              onPressed: () => _linkAccount(context), 
              child: _submitting ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(color: Colors.white)
              ) : Text(
                "Submit", 
                style: theme.textTheme.displayMedium,
              )
            )
          ],
        )
      )
    );
  }
}