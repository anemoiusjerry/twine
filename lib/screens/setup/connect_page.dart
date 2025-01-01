import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:twine/helper.dart';
import 'package:twine/widgets/text_date_field.dart';

class ConnectPage extends StatefulWidget {
  const ConnectPage(
      {super.key, required this.connectCode, required this.onSubmit});

  final String? connectCode;
  final VoidCallback onSubmit;

  @override
  State<ConnectPage> createState() => _ConnectPageState();
}

class _ConnectPageState extends State<ConnectPage> {
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<TooltipState> tooltipkey = GlobalKey<TooltipState>();

  bool _submitting = false;
  String? partnerConnectCode = "";
  bool _partnerFound = false;
  // input state
  DateTime anniversaryDate = DateTime.now();
  bool longDistance = false;
  DateTime reunionDate = DateTime.now();
  DateTime separationDate = DateTime.now();


  // Do not allow further setup if no user is linked to the connect code
  void _findPartner(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _submitting = true;
      });
      // query firestore to see if invite code corresponds to a user
      var result = await FirebaseFunctions.instance
          .httpsCallable("userAvailable")
          .call({"connectCode": partnerConnectCode});
      setState(() {
        _partnerFound = result.data;
        _submitting = false;
      });

      if (!_partnerFound) {
        if (context.mounted) {
          // no partner found show error
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("No user found with that invitation code."),
              duration: Duration(seconds: 3),
            ),
          );
        }
      }
    }
  }

  void _linkAccount(BuildContext context) async {
    setState(() {
      _submitting = true;
    });
    try {
      // call API to set up partner settings
      await FirebaseFunctions.instance.httpsCallable("createCouple").call({
        "connectCode": partnerConnectCode,
        "anniversaryDate": anniversaryDate.toIso8601String(),
        "reunionDate": reunionDate.toIso8601String(),
        "separationDate": separationDate.toIso8601String(),
      });
      setState(() {
        _submitting = false;
      });
      // move to setup page
      widget.onSubmit();
    } catch (e) {
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

  void setAnniversaryDate(DateTime selected) {
    setState(() {
      anniversaryDate = selected;
    });
  }

  void setReunionDate(DateTime selected) {
    setState(() {
      reunionDate = selected;
    });
  }

  void setSeparationDate(DateTime selected) {
    setState(() {
      separationDate = selected;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      color: theme.colorScheme.primary,
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Form(
          key: _formKey,
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
                    await Clipboard.setData(
                        ClipboardData(text: widget.connectCode ?? ""));
                    tooltipkey.currentState?.ensureTooltipVisible();
                  },
                  style: OutlinedButton.styleFrom(
                      side: const BorderSide(
                        color: Colors.white,
                      ),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5))),
                  child: Text(
                    widget.connectCode ?? "NO CODE",
                    style: theme.textTheme.displayMedium,
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                "Link your account",
                style: theme.textTheme.displayMedium,
              ),
              const SizedBox(
                height: 5,
              ),
              TextFormField(
                textAlign: TextAlign.center,
                textCapitalization: TextCapitalization.characters,
                decoration:
                    const InputDecoration(hintText: "Partner's invite code"),
                onChanged: (value) {
                  setState(() {
                    partnerConnectCode = value;
                  });
                },
                validator: (value) => value != widget.connectCode
                    ? null
                    : "Cannot link to yourself!",
              ),
              const SizedBox(
                height: 10,
              ),

              // Allow further setup ONLY if partner is found
              Visibility(
                visible: _partnerFound,
                child: Column(
                  children: [
                    Text(
                      "Anniversary date",
                      style: theme.textTheme.displayMedium,
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    TextDateField(
                      initDate: anniversaryDate,
                      setDate: setAnniversaryDate,
                      firstDate: DateTime(DateTime.now().year - 30),
                      lastDate: DateTime.now(),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          "Long distance",
                          style: theme.textTheme.displayMedium,
                        ),
                        Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.white),
                            child: ToggleButtons(
                                color: Colors.black,
                                fillColor: theme.colorScheme.secondary,
                                selectedColor: Colors.black,
                                borderRadius: BorderRadius.circular(10),
                                isSelected: [longDistance, !longDistance],
                                onPressed: (int index) {
                                  setState(() {
                                    longDistance = index == 0;
                                  });
                                },
                                children: const <Widget>[
                                  Text("Yes"),
                                  Text("No")
                                ]))
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Visibility(
                        visible: longDistance,
                        child: Column(
                          children: [
                            Text(
                              "When did you separate?",
                              style: theme.textTheme.displayMedium,
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            TextDateField(
                              initDate: separationDate,
                              setDate: setSeparationDate,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              "When will you reunite?",
                              style: theme.textTheme.displayMedium,
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            TextDateField(
                              initDate: reunionDate,
                              setDate: setReunionDate,
                              firstDate: DateTime.now(),
                            )
                          ],
                        ))
                  ],
                ),
              ),

              const SizedBox(
                height: 20,
              ),
              if (_submitting)
                const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(color: Colors.white))
              else
                OutlinedButton(
                  onPressed: () => _partnerFound
                      ? _linkAccount(context)
                      : _findPartner(context),
                  child: Text(_partnerFound ? "Connect" : "Next",
                      style: theme.textTheme.displayMedium),
                )
            ],
          ),
        ),
      ),
    );
  }
}
