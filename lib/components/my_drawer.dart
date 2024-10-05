import 'package:flutter/material.dart';
import 'package:untitled2/services/auth/auth_services.dart';
import 'package:untitled2/pages/setting_page.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  void logout() {
    // get auth service
    final auth = AuthServices();
    auth.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.surface,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              //logo
              const DrawerHeader(
                child: Center(
                  child: Icon(
                    Icons.message,
                    size: 50,
                  ),
                ),
              ),

              //home

              Padding(
                padding: const EdgeInsets.only(left: 15.0),
                child: ListTile(
                  title: const Text('H O M E'),
                  leading: const Icon(Icons.home),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              ),

              //setting

              Padding(
                padding: const EdgeInsets.only(left: 15.0),
                child: ListTile(
                  title: const Text('S E T T I N G'),
                  leading: const Icon(Icons.settings),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SettingPage(),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),

          //logout

          Padding(
            padding: const EdgeInsets.only(
              left: 15.0,
              bottom: 25,
            ),
            child: ListTile(
              title: const Text('L O G O U T'),
              leading: const Icon(Icons.logout),
              onTap: logout,
            ),
          ),
        ],
      ),
    );
  }
}
