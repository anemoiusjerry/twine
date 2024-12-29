import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:twine/screens/setup/connect_page.dart';
import 'package:twine/screens/setup/setup_page.dart';

class SetupNavigator extends StatefulWidget {
  const SetupNavigator({super.key, this.connectCode});

  final String? connectCode;
  @override
  State<SetupNavigator> createState() => _SetupNavigatorState();
}

class _SetupNavigatorState extends State<SetupNavigator> {
  final _pageController = PageController();
  String partnerConnectCode = "";


  void setPartnerConnectCode(String value) {
    setState(() {
      partnerConnectCode = value;
    });
  }

  void navToPage(int index) {
    _pageController.animateToPage(
      index, 
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.primary,
        leading: IconButton(
          iconSize: 45,
          onPressed: () async {
            await FirebaseAuth.instance.signOut();
          }, 
          icon: const Icon(Icons.logout, color: Colors.white,)
        ),
      ),
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: <Widget> [
          ConnectPage(
            connectCode: widget.connectCode,
            partnerConnectCode: partnerConnectCode,
            setPartnerConnectCode: setPartnerConnectCode,
            onSubmit: () => navToPage(1)
          ),
          SetupPage(connectCode: partnerConnectCode,),
        ],
      ),
    );
  }
}