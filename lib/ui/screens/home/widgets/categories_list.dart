import 'package:flutter/material.dart';

import 'package:harajsedirah/helper/helper.dart';
import 'package:harajsedirah/provider/home_provider.dart';

import 'package:harajsedirah/ui/section_sds.dart';
import 'package:provider/provider.dart';

class CategoriesList extends StatefulWidget {
  const CategoriesList({
    Key key,
  }) : super(key: key);

  @override
  State<CategoriesList> createState() => _CategoriesListState();
}

class _CategoriesListState extends State<CategoriesList>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation animation;
  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    );

    animation = ColorTween(
      begin: Colors.transparent,
      end: Colors.red.withOpacity(0.9),
    ).animate(controller);
    controller.forward();
    controller.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final categories = context.read<HomeProvider>().categoreis;
    final isData = context.read<HomeProvider>().isData;
    final _homeController = context.read<HomeProvider>();
    return ListView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: categories.length,
      scrollDirection: Axis.horizontal,
      itemBuilder: (BuildContext context, index) {
        return InkWell(
          onTap: () {
            _homeController.setVisibilty(false);
            isData
                ? Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SectionAds(
                        title: categories[index].sectionName,
                        section_id: categories[index].id,
                      ),
                    ),
                  )
                : null;
          },
          child: Container(
            padding: const EdgeInsets.only(left: 15, right: 15),
            width: 65,
            height: 90,
            margin: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                    color: Theme.of(context).primaryColor.withOpacity(0.1),
                    offset: const Offset(
                      1.0,
                      2.0,
                    ),
                    blurRadius: 5,
                    spreadRadius: 0.1),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  child: isData
                      ? Opacity(
                          opacity: controller.value,
                          child: Image.network(
                            apiUrlImage(
                              categories[index].image,
                            ),
                            width: 55,
                            height: 22,
                          ),
                        )
                      : Opacity(
                          opacity: controller.value,
                          // child : Image.asset(categoreis[index]['image'],width: MediaQuery.of(context).size.width / 1.6,)
                          child: Container(),
                        ),
                ),
                const SizedBox(
                  height: 7,
                ),
                Text(
                  categories[index].sectionName,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 7,
                    height: 1.4,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
