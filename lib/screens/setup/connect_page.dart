import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ConnectPage extends StatefulWidget {
  const ConnectPage({
    super.key,
    required this.connectCode,
    required this.partnerConnectCode,
    required this.setPartnerConnectCode, 
    required this.onSubmit
  });
  
  final String? connectCode;
  final String? partnerConnectCode;
  final Function(String) setPartnerConnectCode;
  final VoidCallback onSubmit;
  @override
  State<ConnectPage> createState() => _ConnectPageState();
}

class _ConnectPageState extends State<ConnectPage> {
  final GlobalKey<TooltipState> tooltipkey = GlobalKey<TooltipState>();
  bool _submitting = false;

  // Do not allow further setup if no user is linked to the connect code
  void _findPartner(BuildContext context) async {
    setState(() {
      _submitting = true;
    });
    var result = await FirebaseFunctions.instance.httpsCallable("userExists").call({
      "connectCode": widget.partnerConnectCode
    });
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
                  await Clipboard.setData(ClipboardData(text: widget.connectCode ?? ""));
                  tooltipkey.currentState?.ensureTooltipVisible();
                },
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.white,),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5))
                ), 
                child: Text(
                  widget.connectCode ?? "NO CODE",
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
              textCapitalization: TextCapitalization.characters,
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
                onPressed: () => _findPartner(context), 
                child: const Text("Connect", style: TextStyle(color: Colors.white))
              )
          ],
        ),
      ),
    );
  }
}