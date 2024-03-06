import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:harajsedirah/api/api.dart';
import 'package:harajsedirah/helper/helper.dart';
import 'package:harajsedirah/provider/profile_provider.dart';
import 'package:harajsedirah/ui/screens/profile/edit_phone_screen.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  static const routeName = "profile";
  const ProfileScreen({Key key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    context.read<ProfileProvider>().readUserProfile();

    super.initState();
  }

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final profileProvider = context.watch<ProfileProvider>();
    print(
        "************************************* ******************** ********");
    print(profileProvider.id);
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: profileProvider.isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 50),
                      CircleAvatar(
                        maxRadius: 50,
                        minRadius: 50,
                        backgroundImage: profileProvider.image != null &&
                                profileProvider.image != 'null'
                            ? NetworkImage(apiUrlImage(profileProvider.image))
                            : const AssetImage('assets/user2.png'),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        profileProvider.username,
                        style:
                            const TextStyle(color: Colors.white, fontSize: 18),
                      ),
                      Text(
                        profileProvider.email != "null"
                            ? profileProvider.email
                            : '',
                        style:
                            const TextStyle(color: Colors.white, fontSize: 18),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '${profileProvider.stateKey} ${profileProvider.phone}',
                            style: const TextStyle(
                                color: Colors.white, fontSize: 18),
                            textDirection: TextDirection.ltr,
                          ),
                          TextButton(
                            onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ChangeNotifierProvider<
                                    ProfileProvider>.value(
                                  value: profileProvider,
                                  child: const EditPhoneScreen(),
                                ),
                              ),
                            ),
                            child: const Text(
                              'تعديل الرقم',
                              style: TextStyle(
                                  color: Colors.greenAccent, fontSize: 18),
                              textDirection: TextDirection.ltr,
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      ListTile(
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                    content: const Text(
                                        "!سوف يتم حذف الحساب نهائيا"),
                                    actions: [
                                      _isLoading
                                          ? const Center(
                                              child:
                                                  CircularProgressIndicator())
                                          : ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                  primary: Colors.red),
                                              onPressed: _deleteAccount,
                                              child: const Text("حزف")),
                                      ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              primary: Theme.of(context)
                                                  .primaryColor,
                                              onPrimary: Colors.white),
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: const Text("إلغاء"))
                                    ],
                                  ));
                        },
                        textColor: Colors.white,
                        iconColor: Colors.white,
                        style: ListTileStyle.list,
                        tileColor: Colors.red,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16)),
                        title: const Text("حذف الحساب"),
                        trailing: const Icon(Icons.delete),
                      ),
                      const SizedBox(
                        height: 50,
                      )
                    ]),
              ),
            ),
    );
  }

  void _deleteAccount() async {
    setState(() {
      _isLoading = true;
    });

    Response res = await Api().postAuthData({}, "/haraj1_deleteAccount");
    log(res.statusCode.toString());
    log(res.body.toString());
    final int statusCode = res.statusCode;

    if (statusCode < 200 || statusCode > 400 || json == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            "هناك خطأ ما جاري أصلاحة",
            style: TextStyle(fontSize: 20, fontFamily: 'Cocan'),
          ),
          duration: const Duration(seconds: 3),
          backgroundColor: Theme.of(context).colorScheme.secondary,
        ),
      );

      setState(() {
        _isLoading = false;
      });
    }

    var body = json.decode(res.body);

    if (body['status'] == false) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            body['msg'],
            style: const TextStyle(fontSize: 20, fontFamily: 'Cocan'),
          ),
          duration: const Duration(seconds: 3),
          backgroundColor: Theme.of(context).colorScheme.secondary,
        ),
      );
      setState(() {
        _isLoading = false;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            "تم حذف الحساب",
            style: TextStyle(fontSize: 20, fontFamily: 'Cocan'),
          ),
          duration: const Duration(seconds: 3),
          backgroundColor: Theme.of(context).colorScheme.secondary,
        ),
      );
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.clear();
      Navigator.of(context).pushReplacementNamed("login");
    }

    //    If all data are not valid then start auto validation.
  }
}
