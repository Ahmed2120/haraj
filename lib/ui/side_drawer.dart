import 'package:flutter/material.dart';
import 'package:harajsedirah/ui/screens/profile/profile_screen.dart';
import '../helper/helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SideDrawer extends StatefulWidget {
  final String pagename;
  const SideDrawer({Key key, this.pagename = 'home'}) : super(key: key);
  @override
  _SideDrawerState createState() => _SideDrawerState();
}

class _SideDrawerState extends State<SideDrawer> {
  String pagename = 'الرئيسية';
  _SideDrawerState({this.pagename});

  bool isLogin = false;
  var username = '';
  var email = '';
  var image;
  void cheackLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //  print(prefs.get('id'));
    if (prefs.get('token') != null) {
      setState(() {
        isLogin = true;
        username = prefs.get('username');
        if (prefs.get('email') != null) {
          email = prefs.get('email');
        } else {
          email = '';
        }
        if (prefs.get('img') != null) {
          image = prefs.get('img');
        } else {
          image = '';
        }
      });
    }
  }

  @override
  void initState() {
    super.initState();
    cheackLogin();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 1,
      child: Drawer(
        child: Stack(
          children: <Widget>[
            SizedBox(
              width: double.infinity,
              height: MediaQuery.of(context).size.height,
              child: Image.asset(
                'assets/sections/car2.png',
                fit: BoxFit.fitHeight,
              ),
            ),
            Container(
              color: Theme.of(context).primaryColor.withOpacity(0.9),
              width: double.infinity,
              height: MediaQuery.of(context).size.height,
              child: ListView(
                children: <Widget>[
                  Container(
                    margin: const EdgeInsets.only(
                        top: 20, left: 10, right: 10, bottom: 20),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              CircleAvatar(
                                maxRadius: 25,
                                minRadius: 25,
                                backgroundImage:
                                    image != null && image != 'null'
                                        ? NetworkImage(apiUrlImage(image))
                                        : const AssetImage('assets/user2.png'),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 20, right: 20),
                                child: Column(
                                  children: <Widget>[
                                    Text(
                                      username,
                                      style: const TextStyle(
                                          color: Colors.white, fontSize: 15),
                                    ),
                                    Text(
                                      email != "null" ? email : '',
                                      style: const TextStyle(
                                          color: Colors.white, fontSize: 15),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          InkWell(
                            child: const Icon(
                              Icons.close,
                              size: 25,
                              color: Colors.white,
                            ),
                            onTap: () {
                              Navigator.pop(context, true);
                            },
                          ),
                        ],
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(bottom: 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        InkWell(
                          onTap: () {
                            pagename == 'home'
                                ? Navigator.pop(context, true)
                                : Navigator.pop(context, true);
                            Navigator.pushNamed(context, 'home');
                          },
                          child: Row(
                            children: const [
                              Padding(
                                padding: EdgeInsets.all(10),
                                child: Icon(
                                  Icons.home,
                                  size: 30,
                                  color: Colors.white,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 5),
                                child: Text(
                                  'الرئيسية',
                                  style: TextStyle(
                                      fontSize: 22, color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        ),
                        widget.pagename == 'home'
                            ? Container(
                                color: Theme.of(context).colorScheme.secondary,
                                width: 3,
                                height: 40,
                              )
                            : Container(),
                      ],
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(bottom: 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        InkWell(
                          onTap: () {
                            Navigator.pop(context, true);
                            Navigator.pushNamed(context, 'search');
                          },
                          child: Row(
                            children: const [
                              Padding(
                                padding: EdgeInsets.all(10),
                                child: Icon(
                                  Icons.search,
                                  size: 30,
                                  color: Colors.white,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 5),
                                child: Text(
                                  "أبحث عن سلعة",
                                  style: TextStyle(
                                      fontSize: 22, color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        ),
                        widget.pagename == 'search'
                            ? Container(
                                color: Theme.of(context).colorScheme.secondary,
                                width: 3,
                                height: 40,
                              )
                            : Container(),
                      ],
                    ),
                  ),
                  isLogin
                      ? Padding(
                          padding: const EdgeInsets.only(bottom: 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              InkWell(
                                onTap: () {
                                  Navigator.pop(context, true);
                                  Navigator.pushNamed(context, 'myAdFav');
                                },
                                child: Row(
                                  children: const [
                                    Padding(
                                      padding: EdgeInsets.all(10),
                                      child: Icon(
                                        Icons.favorite,
                                        size: 30,
                                        color: Colors.white,
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(top: 5),
                                      child: Text(
                                        'الأعلانات المفضلة',
                                        style: TextStyle(
                                            fontSize: 22, color: Colors.white),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              widget.pagename == 'myAdFav'
                                  ? Container(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                      width: 3,
                                      height: 40,
                                    )
                                  : Container(),
                            ],
                          ),
                        )
                      : Container(),
                  isLogin
                      ? Padding(
                          padding: const EdgeInsets.only(bottom: 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              InkWell(
                                onTap: () {
                                  Navigator.pop(context, true);
                                  Navigator.pushNamed(context, 'myAds');
                                },
                                child: Row(
                                  children: const [
                                    Padding(
                                      padding: EdgeInsets.all(10),
                                      child: Icon(
                                        Icons.store_mall_directory,
                                        size: 30,
                                        color: Colors.white,
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(top: 5),
                                      child: Text(
                                        'أعلاناتي',
                                        style: TextStyle(
                                            fontSize: 22, color: Colors.white),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              widget.pagename == 'myAds'
                                  ? Container(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                      width: 3,
                                      height: 40,
                                    )
                                  : Container(),
                            ],
                          ),
                        )
                      : Container(),

                  Padding(
                    padding: const EdgeInsets.only(bottom: 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        InkWell(
                          onTap: () {
                            Navigator.pop(context, true);
                            Navigator.pushNamed(context, 'contact');
                          },
                          child: Row(
                            children: const [
                              Padding(
                                padding: EdgeInsets.all(10),
                                child: Icon(
                                  Icons.contacts,
                                  size: 30,
                                  color: Colors.white,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 5),
                                child: Text(
                                  'اتصل بنا',
                                  style: TextStyle(
                                      fontSize: 22, color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        ),
                        widget.pagename == 'contact'
                            ? Container(
                                color: Theme.of(context).colorScheme.secondary,
                                width: 3,
                                height: 40,
                              )
                            : Container(),
                      ],
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(bottom: 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        InkWell(
                          onTap: () {
                            Navigator.pop(context, true);
                            Navigator.pushNamed(context, 'omola');
                          },
                          child: Row(
                            children: const [
                              Padding(
                                padding: EdgeInsets.all(10),
                                child: Icon(
                                  Icons.monetization_on,
                                  size: 30,
                                  color: Colors.white,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 5),
                                child: Text(
                                  'حساب العمولة',
                                  style: TextStyle(
                                      fontSize: 22, color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        ),
                        widget.pagename == 'omola'
                            ? Container(
                                color: Theme.of(context).colorScheme.secondary,
                                width: 3,
                                height: 40,
                              )
                            : Container(),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        InkWell(
                          onTap: () {
                            Navigator.pop(context, true);
                            Navigator.pushNamed(context, 'DiscountSystem');
                          },
                          child: Row(
                            children: const [
                              Padding(
                                padding: EdgeInsets.all(10),
                                child: Icon(
                                  Icons.money_off,
                                  size: 30,
                                  color: Colors.white,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 5),
                                child: Text(
                                  'نظام الخصم',
                                  style: TextStyle(
                                      fontSize: 22, color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        ),
                        widget.pagename == 'DiscountSystem'
                            ? Container(
                                color: Theme.of(context).colorScheme.secondary,
                                width: 3,
                                height: 40,
                              )
                            : Container(),
                      ],
                    ),
                  ),
                  isLogin
                      ? Padding(
                          padding: const EdgeInsets.only(bottom: 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              InkWell(
                                onTap: () {
                                  Navigator.pop(context, true);
                                  Navigator.pushNamed(context, 'Follow');
                                },
                                child: Row(
                                  children: const [
                                    Padding(
                                      padding: EdgeInsets.all(10),
                                      child: Icon(
                                        Icons.rss_feed,
                                        size: 30,
                                        color: Colors.white,
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(top: 5),
                                      child: Text(
                                        'قائمة المتابعة',
                                        style: TextStyle(
                                            fontSize: 22, color: Colors.white),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              widget.pagename == 'Follow'
                                  ? Container(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                      width: 3,
                                      height: 40,
                                    )
                                  : Container(),
                            ],
                          ),
                        )
                      : Container(),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        InkWell(
                          onTap: () {
                            Navigator.pop(context, true);
                            Navigator.pushNamed(context, 'ProhibitedGoods');
                          },
                          child: Row(
                            children: const [
                              Padding(
                                padding: EdgeInsets.all(10),
                                child: Icon(
                                  Icons.report,
                                  size: 30,
                                  color: Colors.white,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 5),
                                child: Text(
                                  'السلع الممنوعة',
                                  style: TextStyle(
                                      fontSize: 22, color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        ),
                        widget.pagename == 'ProhibitedGoods'
                            ? Container(
                                color: Theme.of(context).colorScheme.secondary,
                                width: 3,
                                height: 40,
                              )
                            : Container(),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        InkWell(
                          onTap: () {
                            Navigator.pop(context, true);
                            Navigator.pushNamed(context, 'BlackList');
                          },
                          child: Row(
                            children: const [
                              Padding(
                                padding: EdgeInsets.all(10),
                                child: Icon(
                                  Icons.signal_wifi_4_bar_lock,
                                  size: 30,
                                  color: Colors.white,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 5),
                                child: Text(
                                  'القائمة السوداء',
                                  style: TextStyle(
                                      fontSize: 22, color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        ),
                        widget.pagename == 'BlackList'
                            ? Container(
                                color: Theme.of(context).colorScheme.secondary,
                                width: 3,
                                height: 40,
                              )
                            : Container(),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        InkWell(
                          onTap: () {
                            Navigator.pop(context, true);
                            Navigator.pushNamed(context, 'TreatyOfUse');
                          },
                          child: Row(
                            children: const [
                              Padding(
                                padding: EdgeInsets.all(10),
                                child: Icon(
                                  Icons.theaters,
                                  size: 30,
                                  color: Colors.white,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 5),
                                child: Text(
                                  'معاهدة الأستخدام',
                                  style: TextStyle(
                                      fontSize: 22, color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        ),
                        widget.pagename == 'TreatyOfUse'
                            ? Container(
                                color: Theme.of(context).colorScheme.secondary,
                                width: 3,
                                height: 40,
                              )
                            : Container(),
                      ],
                    ),
                  ),
                  if (isLogin == true)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          InkWell(
                            onTap: () {
                              Navigator.pop(context, true);
                              Navigator.pushNamed(
                                  context, ProfileScreen.routeName);
                            },
                            child: Row(
                              children: const [
                                Padding(
                                  padding: EdgeInsets.all(10),
                                  child: Icon(
                                    Icons.account_circle,
                                    size: 30,
                                    color: Colors.white,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 5),
                                  child: Text(
                                    "الملف الشخصي",
                                    style: TextStyle(
                                        fontSize: 22, color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          widget.pagename == 'signup'
                              ? Container(
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                  width: 3,
                                  height: 40,
                                )
                              : Container(),
                        ],
                      ),
                    ),

                  isLogin == false
                      ? Padding(
                          padding: const EdgeInsets.only(bottom: 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              InkWell(
                                onTap: () {
                                  Navigator.pop(context, true);
                                  Navigator.pushNamed(context, 'signup');
                                },
                                child: Row(
                                  children: const [
                                    Padding(
                                      padding: EdgeInsets.all(10),
                                      child: Icon(
                                        Icons.account_circle,
                                        size: 30,
                                        color: Colors.white,
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(top: 5),
                                      child: Text(
                                        "التسجيل",
                                        style: TextStyle(
                                            fontSize: 22, color: Colors.white),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              widget.pagename == 'signup'
                                  ? Container(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                      width: 3,
                                      height: 40,
                                    )
                                  : Container(),
                            ],
                          ),
                        )
                      : Container(),
                  isLogin == false
                      ? Padding(
                          padding: const EdgeInsets.only(bottom: 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              InkWell(
                                onTap: () => Navigator.pushReplacementNamed(
                                    context, 'login'),
                                child: Row(
                                  children: const [
                                    Padding(
                                      padding: EdgeInsets.all(10),
                                      child: Icon(
                                        Icons.login,
                                        size: 30,
                                        color: Colors.white,
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(top: 5),
                                      child: Text(
                                        'دخول',
                                        style: TextStyle(
                                            fontSize: 22, color: Colors.white),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              widget.pagename == 'login'
                                  ? Container(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                      width: 3,
                                      height: 40,
                                    )
                                  : Container(),
                            ],
                          ),
                        )
                      : Padding(
                          padding: const EdgeInsets.only(bottom: 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              InkWell(
                                onTap: () async {
                                  SharedPreferences prefs =
                                      await SharedPreferences.getInstance();
                                  prefs.clear();
                                  print("555555555555555555555555555555555");

                                  Navigator.pushReplacementNamed(
                                      context, 'login');
                                },
                                child: Row(
                                  children: const [
                                    Padding(
                                      padding: EdgeInsets.all(10),
                                      child: Icon(
                                        Icons.logout,
                                        size: 30,
                                        color: Colors.white,
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(top: 5),
                                      child: Text(
                                        "تسجيل الخروج",
                                        style: TextStyle(
                                            fontSize: 22, color: Colors.white),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              widget.pagename == 'logout'
                                  ? Container(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                      width: 3,
                                      height: 40,
                                    )
                                  : Container(),
                            ],
                          ),
                        ),

                  // Container(
                  //   alignment: Alignment.bottomLeft,
                  //   child: Padding(
                  //     padding: const EdgeInsets.only(left: 10,right: 10),
                  //     child: InkWell(
                  //       onTap: (){
                  //       'ar' == 'en' ?
                  //       data.changeLocale(Locale("ar","DZ")) :
                  //       data.changeLocale(Locale("en","US"));
                  //       Navigator.pushReplacementNamed(context, pagename);
                  //       },
                  //       child: CircleAvatar(
                  //         maxRadius: 20,
                  //         minRadius: 20,
                  //         backgroundColor: Theme.of(context).colorScheme.secondary.withOpacity(0.7),
                  //         child: Text('ar' == 'en' ? 'AR' : 'EN',style: TextStyle(color: Colors.black87,fontSize: 22,fontWeight: FontWeight.bold),),
                  //       ),
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
