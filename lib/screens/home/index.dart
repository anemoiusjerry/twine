import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:twine/models/home_data_model.dart';
import 'package:twine/repositories/couple_interface.dart';
import 'package:twine/repositories/partner_setting_interface.dart';
import 'package:twine/repositories/user_interface.dart';
import 'package:twine/screens/home/audio_log.dart';
import 'package:twine/screens/home/home_screen.dart';
import 'package:twine/screens/settings/profile_screen.dart';
import 'package:twine/screens/setup/index.dart';

class HomeNavigator extends StatefulWidget {
  const HomeNavigator({super.key});
  @override
  State<HomeNavigator> createState() => _HomeNavigatorState();
}

class _HomeNavigatorState extends State<HomeNavigator> {
  int screenIndex = 2;
  late Future<HomeDataModel?> homeData;

  @override
  void initState() {
    super.initState();
    homeData = getUserData();

    // update last activity
    // final userRepo = UserRepository(FirebaseFirestore.instance);
    // userRepo.update(FirebaseAuth.instance.currentUser?.uid ?? "", {
    //   "lastActivity": Timestamp.now()
    // });
  }

  // query partnerSetting, which also indicate setup status
  Future<HomeDataModel?> getUserData() async {
    try {
      // final userId = FirebaseAuth.instance.currentUser?.uid ?? "";
      // final userRepo = UserRepository(FirebaseFirestore.instance);
      // final coupleRepo = CoupleRepository(FirebaseFirestore.instance);
      // final partnerRepo = PartnerSettingRepository(FirebaseFirestore.instance);

      // final partnerSettings = await partnerRepo.get(userId);
      // if (partnerSettings == null) {
      //   return null;
      // }
      // final user = await userRepo.get(userId);
      // final storagePath = "${user?.coupleId}/$userId/profile.jpeg";
      // final imageUrl = await FirebaseStorage.instance.ref(storagePath).getDownloadURL();
      // // get couple info
      // final coupleEntry = await coupleRepo.get(user?.coupleId ?? "");
      // // generate image download link
      // return HomeDataModel(coupleEntry, partnerSettings, imageUrl, storagePath, user!.coupleId!);
    } catch(e) {
      print(e);
    }
  return null;
  }


  void reloadPartnerSettings() {
    setState(() {
      homeData = getUserData();
    });
  }

  void _updateScreenIndex(int newIndex) {
    // setSet informs flutter of change causing the "build" method below to rerun.
    setState(() { screenIndex = newIndex; });
  }

  void _navToSettings(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => const ProfileScreen()));
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return SafeArea(
      child: FutureBuilder(
        future: homeData, 
        builder: (ctx, snapshot) {
          // check if async task has resolved
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              return DefaultTabController(
                length: 2, 
                child: Scaffold(
                  appBar: AppBar(
                    actions: [
                      IconButton(
                        iconSize: 45,
                        onPressed: () => _navToSettings(context),
                        icon: const Icon(Icons.person_outline_rounded)
                      ),
                    ],
                    bottom: screenIndex != 1 ? const TabBar(
                      tabs: [
                        Tab(text: "Inbox"),
                        Tab(text: "Outbox"),
                      ],
                    ) : null,
                  ),
                  bottomNavigationBar: BottomNavigationBar(
                    currentIndex: screenIndex,
                    onTap: _updateScreenIndex,
                    showSelectedLabels: false,
                    showUnselectedLabels: false,
                    iconSize: 45,
                    items: const <BottomNavigationBarItem>[
                      BottomNavigationBarItem(
                        icon: Icon(Icons.photo_library), 
                        label: "Cards",
                      ),          
                      BottomNavigationBarItem(
                        icon: Icon(Icons.favorite), 
                        label: 'Home',
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.album), 
                        label: 'Memos',
                      ),
                    ]
                  ),

                  // Actual screens for the tabs
                  body: <Widget>[
                    Card(
                      shadowColor: Colors.transparent,
                      margin: const EdgeInsets.all(8.0),
                      child: SizedBox.expand(
                        child: Center(
                          child: Text(
                            'home',
                            style: theme.textTheme.titleLarge,
                          ),
                        ),
                      ),
                    ),
                    HomeScreen(data: snapshot.data!),
                    AudioLogScreen(
                      partnerName: snapshot.data!.partnerSettings?.nickName ?? "",
                      group: snapshot.data!.coupleInfo?.users ?? [],
                      coupleId: snapshot.data!.coupleId,
                    ),
                  ][screenIndex],
                )
              );
            } else {
              return SetupNavigator(reload: reloadPartnerSettings,);
            }
          }
          // default return: loader
          return Container(
            color: theme.colorScheme.primary,
            child: const Center(
              child: CircularProgressIndicator(color: Colors.white,)
            ),
          );
        }
      )
    );
  }
}
