import 'package:flutter/material.dart';
import 'screens/home/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:custom_splash/custom_splash.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  var title, app_logo, site_desc;

  Function duringSplash = () {
    //  print('Something background process');
    int a = 123 + 23;

    if (a > 100) {
      return 1;
    } else {
      return 2;
    }
  };

  Map<int, Widget> op = {1: const HomeScreen(), 2: const HomeScreen()};

  bool isLogin = false;
  void cheackLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.get('token') != null) {
      setState(() {
        isLogin = true;
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const HomeScreen(),
          ),
        );
      });
    }
  }

  @override
  void initState() {
    super.initState();
    // cheackLogin();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black12,
      body: Stack(
        children: [
          Center(
            child: SizedBox(
              height: MediaQuery.of(context).size.height / 2,
              child: CustomSplash(
                imagePath: 'assets/logosplash.png',
                backGroundColor: Colors.transparent,
                animationEffect: 'zoom-in',
                logoSize: MediaQuery.of(context).size.height / 1.5,
                home: const HomeScreen(),
                customFunction: duringSplash,
                duration: 2000,
                type: CustomSplashType.BackgroundProcess,
                outputAndHome: op,
              ),
            ),
          ), /*
          Container(
            margin: EdgeInsets.only(top: 25, right: 10, left: 10),
            alignment: Alignment.centerRight,
            child: Image.asset(
              'assets/icon/icon.png',
              height: 110,
              width: 110,
            ),
          ),*/
        ],
      ),
      // body: Stack(
      //   children: <Widget>[
      //     InkWell(
      //       onTap: () {
      //         Navigator.of(context).pushReplacementNamed('home');
      //       },
      //       child: Container(
      //         width: double.infinity,
      //         height: double.infinity,
      //         decoration: BoxDecoration(
      //           gradient: LinearGradient(
      //             begin: Alignment.topLeft,
      //             end: Alignment.bottomRight,
      //             stops: [0.1, 0.5, 0.7, 0.9],
      //             colors: [
      //               Colors.grey[100],
      //               Colors.grey[200],
      //               Colors.grey[300],
      //               Colors.grey[400],
      //             ],
      //           ),
      //         ),
      //         child: Stack(
      //           children: <Widget>[
      //             Padding(
      //               padding:
      //                   const EdgeInsets.only(left: 10, right: 10, top: 40),
      //               child: InkWell(
      //                 onTap: () {
      //                   setLang();
      //                 },
      //                 child: CircleAvatar(
      //                   maxRadius: 20,
      //                   minRadius: 20,
      //                   backgroundColor:
      //                       Theme.of(context).colorScheme.secondary.withOpacity(0.7),
      //                   child: Text(
      //                     'ar' == 'en'
      //                         ? 'AR'
      //                         : 'EN',
      //                     style: TextStyle(
      //                         color: Colors.black87,
      //                         fontSize: 18,
      //                         fontWeight: FontWeight.bold),
      //                   ),
      //                 ),
      //               ),
      //             ),
      //             // Opacity(
      //             //   opacity: 0.07,
      //             //   child: Container(
      //             //     alignment: Alignment.bottomCenter,
      //             //     margin: EdgeInsets.only(top: 100),
      //             //     child: Hero(child: app_logo != null ? Image.network( app_logo , fit: BoxFit.cover,height: double.infinity,): Image.asset('assets/splash.png',fit: BoxFit.cover,height: double.infinity,colorBlendMode: BlendMode.saturation,),tag: 'splash',),
      //             //   ),
      //             // ),

      //             Container(
      //               alignment: Alignment.center,
      //               child: Image.asset('assets/logosplash.png'),
      //             ),

      //             Padding(
      //               padding: const EdgeInsets.only(bottom: 30),
      //               child: Align(
      //                 alignment: FractionalOffset.bottomCenter,
      //                 child: Row(
      //                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      //                   children: <Widget>[
      //                     Container(
      //                       height: 50,
      //                       width: MediaQuery.of(context).size.width / 2.5,
      //                       child: RaisedButton(
      //                         elevation: 1,
      //                         child: Hero(
      //                             tag: 'signup',
      //                             child: Text(
      //                               AppLocalizations.of(context)."التسجيل",
      //                               style: TextStyle(
      //                                   color: Colors.white, fontSize: 20),
      //                             )),
      //                         color: Theme.of(context).primaryColor,
      //                         onPressed: () {
      //                           Navigator.pushNamed(context, 'signup');
      //                         },
      //                         shape: RoundedRectangleBorder(
      //                           borderRadius: BorderRadius.circular(5.0),
      //                         ),
      //                       ),
      //                     ),
      //                     Container(
      //                       height: 50,
      //                       width: MediaQuery.of(context).size.width / 2.5,
      //                       child: RaisedButton(
      //                         elevation: 0.5,
      //                         // padding: EdgeInsets.only(top: 15,bottom: 15,right: 60,left: 60),
      //                         child: Hero(
      //                             tag: 'login',
      //                             child: Text(
      //                               AppLocalizations.of(context).tr('login'),
      //                               style: TextStyle(
      //                                   color: Colors.white, fontSize: 20),
      //                             )),
      //                         color: Theme.of(context).colorScheme.secondary,
      //                         onPressed: () {
      //                           Navigator.pushNamed(context, 'login');
      //                         },
      //                         shape: RoundedRectangleBorder(
      //                           borderRadius: BorderRadius.circular(5.0),
      //                         ),
      //                       ),
      //                     ),
      //                   ],
      //                 ),
      //               ),
      //             ),
      //           ],
      //         ),
      //       ),
      //     ),
      //   ],
      // ),
    );
  }
}
