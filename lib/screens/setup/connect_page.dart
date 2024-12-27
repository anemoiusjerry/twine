import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:twine/repositories/user_interface.dart';

class ConnectPage extends StatefulWidget {
  const ConnectPage({super.key, required this.setPartnerConnectCode, required this.onSubmit});
  
  final Function(String) setPartnerConnectCode;
  final VoidCallback onSubmit;
  @override
  State<ConnectPage> createState() => _ConnectPageState();
}

class _ConnectPageState extends State<ConnectPage> {
  final userRepo = UserRepository(FirebaseFirestore.instance);
  String? connectCode;
  String partnerConnectCode = "";
  bool _fetchingCode = true;
  bool _submitting = false;

  @override
  initState() {
    super.initState();
    // fetch twine User and get the generated connect code
    final userTable = UserRepository(FirebaseFirestore.instance);
    userTable.get(FirebaseAuth.instance.currentUser?.uid ?? "").then((user) => {
      setState(() {
        connectCode = user?.connectCode;
        _fetchingCode = false;
      })
    });
  }

  // Do not allow further setup if no user is linked to the connect code
  void _linkPartner(BuildContext context) async {
    setState(() {
      _submitting = true;
    });
    var result = await FirebaseFunctions.instance.httpsCallable("userExists").call(
      {
        "connectCode": partnerConnectCode
      }
    );
    bool userExists = result.data;

    setState(() {
      _submitting = false;
    });
    if (userExists) {
      // go to be setup
      widget.onSubmit();
    } else {
      if (context.mounted) {
      // no partner found show error
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("No user found with that invitation code."),
          duration: Duration(seconds: 3),
        ),
      );}
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    final GlobalKey<TooltipState> tooltipkey = GlobalKey<TooltipState>();

    return Container(
      color: theme.primary,
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Tooltip(
              key: tooltipkey,
              triggerMode: TooltipTriggerMode.tap,
              showDuration: const Duration(seconds: 2),
              preferBelow: false,
              message: "Invitation code copied!",
              child: OutlinedButton(
                onPressed: () async {
                  await Clipboard.setData(ClipboardData(text: connectCode ?? ""));
                  tooltipkey.currentState?.ensureTooltipVisible();
                },
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.white,),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5))
                ), 
                child: _fetchingCode ? const CircularProgressIndicator(color: Colors.white,) : 
                Text(
                  connectCode ?? "NO CODE",
                  style: const TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
            ),
            const SizedBox(height: 20,),
            const Text(
              "Link your account", 
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            TextField(
              textAlign: TextAlign.center,
              decoration: const InputDecoration(
                hintText: "Partner's invite code"
              ),
              onChanged: widget.setPartnerConnectCode,
            ),
            const SizedBox(height: 20,),
            if (_submitting)
              const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(color: Colors.white)
              )
            else 
              OutlinedButton(
                onPressed: () => _linkPartner(context), 
                child: const Text("Connect", style: TextStyle(color: Colors.white))
              )
          ],
        ),
      ),
    );
  }
}