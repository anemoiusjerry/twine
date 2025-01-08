import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:twine/helper.dart';
import 'package:twine/models/user_model.dart';
import 'package:twine/repositories/user_interface.dart';
import 'package:twine/styles/colours.dart';
import 'package:twine/styles/styles.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final userRepo = UserRepository(FirebaseFirestore.instance);
  final _emailController = TextEditingController();
  final _nameController = TextEditingController();
  final _bdayController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  late TwineUser userData; 
  bool _editing = false;
  String email = "Not set";
  String name = "Not set";
  String birthday = "Not set";

  // get user data
  @override
  void initState() {
    super.initState();
    _reloadUserSettings();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _nameController.dispose();
    _bdayController.dispose();
    super.dispose();
  }

  void setEditing(bool value) {
    setState(() {
      _editing = value;
    });
  }

  void setEmail(String value) {
    setState(() {
      email = value.trim();
    });
  }

  void setName(String value) {
    setState(() {
      name = value.trim();
    });
  }

  void setBirthday(String value) {
    setState(() {
      birthday = value.trim();
    });
  }

  // set correct values for text controllers and state variables of user settings
  void populateUserSettings(String? email, String? name, DateTime? birthday) {
    final newEmail = email ?? "Not set";
    final newName = name ?? "Not set";
    final newBirthday = birthday != null ? DateFormat("MMM d yyyy").format(birthday) : "Not set";

    _emailController.text = email ?? "";
    _nameController.text = name ?? "";
    _bdayController.text = newBirthday == "Not set" ? "" : newBirthday;

    setState(() {
      this.email = newEmail;
      this.name = newName;
      this.birthday = newBirthday;
    });
  }

  void _reloadUserSettings() async {
    final data = await userRepo.get(FirebaseAuth.instance.currentUser!.uid);
    if (data != null) {
      userData = data;
      populateUserSettings(data.email, data.name, data.birthday?.toDate());
    }
  }

  Future<void> _saveUserSettings() async {
    Map<String, dynamic> updated = {};
    if (_formKey.currentState!.validate()) {
      if (email != userData.email) {
        updated['email'] = email;
      }
      if (name != userData.name) {
        updated['name'] = name;
      }
      final bdayTimestamp = Timestamp.fromDate(DateFormat('dd/MM/yyyy').parseStrict(birthday));
      if (bdayTimestamp != userData.birthday) {
        updated['birthday'] = bdayTimestamp;
      }
      if (updated.isNotEmpty) {
        await userRepo.update(FirebaseAuth.instance.currentUser!.uid, updated);
        _reloadUserSettings();
      }
      setState(() {
        _editing = false;
      });
    }
  }

  // This disconnects the current partner from account
  void _unlinkAccount() {
    // delete couples entry
    // delete partnerSettings associated with current partner
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        // buttons to trigger editing
        actions: [
          Padding(
              padding: const EdgeInsets.only(
                right: 10,
              ),
              child: _editing
                  ? Row(children: [
                    TextButton(
                      onPressed: () {
                        setEditing(false);
                        // revert to original settings
                        populateUserSettings(userData.email, userData.name, userData.birthday?.toDate());
                      },
                      child: Text("Cancel", style: theme.textTheme.labelMedium?.copyWith(
                        color: Colors.red
                      ))),
                    TextButton(
                      onPressed: () async {
                        await _saveUserSettings();
                      },
                      child: Text("Save", style: theme.textTheme.labelMedium))
                  ],)
                  // pencil icon
                  : IconButton(
                      onPressed: () {
                        final bdayString = userData.birthday == null ? "" : DateFormat("dd/MM/yyyy").format(userData.birthday!.toDate());
                        _bdayController.text = bdayString;
                        birthday = bdayString;
                        setEditing(true);
                      },
                      icon: const Icon(Icons.edit),
                      iconSize: 35,
                    ))
        ],
      ),
      body: Padding(
          padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Flexible(
                  child: ListView(
                    padding: const EdgeInsets.all(10),
                    children: [
                      // Editable user settings
                      Container(
                          decoration: const BoxDecoration(
                            color: AppColours.lightGray,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(10)),
                          ),
                          child: ListTile(
                            leading: const Icon(
                              Icons.mail_outline,
                              size: 35,
                            ),
                            trailing: Container(
                                constraints:
                                    const BoxConstraints(maxWidth: 200),
                                child: _editing
                                    ? TextFormField(
                                        controller: _emailController,
                                        textAlign: TextAlign.right,
                                        onChanged: (text) => setEmail(text),
                                        decoration: underlineTextDecoration(),
                                        validator: (value) {
                                          if (value == null || !checkValidEmail(value)) {
                                            return 'Invalid email';
                                          }
                                          return null;
                                        },
                                      )
                                    : Text(
                                        email,
                                        style: theme.textTheme.bodyMedium,
                                        overflow: TextOverflow.ellipsis,
                                      )),
                          )),
                      ListTile(
                        tileColor: AppColours.lightGray,
                        leading: const Icon(
                          Icons.person_outline,
                          size: 35,
                        ),
                        trailing: Container(
                            constraints: const BoxConstraints(maxWidth: 200),
                            child: _editing
                                ? TextField(
                                    controller: _nameController,
                                    textAlign: TextAlign.right,
                                    onChanged: (text) => setName(text),
                                    decoration: underlineTextDecoration(),
                                  )
                                : Text(name,
                                    style: theme.textTheme.bodyMedium,
                                    overflow: TextOverflow.ellipsis)),
                      ),
                      Container(
                          decoration: const BoxDecoration(
                            color: AppColours.lightGray,
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(10),
                                bottomRight: Radius.circular(10)),
                          ),
                          child: ListTile(
                              leading: const Icon(
                                Icons.cake_outlined,
                                size: 35,
                              ),
                              trailing: Container(
                                constraints:
                                    const BoxConstraints(maxWidth: 200),
                                child: _editing
                                    ? TextFormField(
                                        controller: _bdayController,
                                        textAlign: TextAlign.right,
                                        onChanged: (text) => setBirthday(text),
                                        decoration: underlineTextDecoration('dd/mm/yyyy'),
                                        validator: (value) {
                                          if (value == null || !checkValidDate(value)) {
                                            return "Incorrect format: dd/mm/yyyy";
                                          }
                                          return null;
                                        }
                                      )
                                    : Text(birthday, style: theme.textTheme.bodyMedium,overflow: TextOverflow.ellipsis),
                              ))),
                      const SizedBox(
                        height: 20,
                      ),

                      // Informational items
                      Container(
                          decoration: const BoxDecoration(
                            color: AppColours.lightGray,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(10)),
                          ),
                          child: ListTile(
                            leading: const Icon(Icons.info_outline, size: 35),
                            title: Text(
                              "About",
                              style: theme.textTheme.bodyMedium,
                            ),
                          )),
                      Container(
                          decoration: const BoxDecoration(
                            color: AppColours.lightGray,
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(10),
                                bottomRight: Radius.circular(10)),
                          ),
                          child: ListTile(
                            leading: const Icon(
                                Icons.insert_drive_file_outlined,
                                size: 35),
                            title: Text(
                              "Privacy Policy",
                              style: theme.textTheme.bodyMedium,
                            ),
                          )),
                      const SizedBox(
                        height: 20,
                      ),

                      // Account settings
                      Container(
                          decoration: const BoxDecoration(
                            color: AppColours.lightGray,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(10)),
                          ),
                          child: ListTile(
                            title: Text("Unlink account",
                                style: theme.textTheme.bodyMedium),
                          )),
                      ListTile(
                        tileColor: AppColours.lightGray,
                        title: Text("Delete data",
                            style: theme.textTheme.bodyMedium),
                      ),
                      Container(
                          decoration: const BoxDecoration(
                            color: AppColours.lightGray,
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(10),
                                bottomRight: Radius.circular(10)),
                          ),
                          child: ListTile(
                            title: Text(
                              "Log out",
                              style: theme.textTheme.bodyMedium
                                  ?.copyWith(color: Colors.red),
                            ),
                          )),
                    ],
                  ),
                ),
              ],
            ),
          )),
    );
  }
}
