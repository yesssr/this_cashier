import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../constant.dart';

class MyTabBar extends StatelessWidget {
  const MyTabBar({super.key, required this.tabs});
  final List<Tab> tabs;

  @override
  Widget build(BuildContext context) {
    return TabBar(
      tabAlignment: TabAlignment.start,
      isScrollable: true,
      automaticIndicatorColorAdjustment: true,
      tabs: tabs,
      indicatorSize: TabBarIndicatorSize.tab,
      labelStyle: labelMedBold,
      labelColor: secondaryColor,
      unselectedLabelColor: Colors.black,
      indicatorColor: secondaryColor,
      dragStartBehavior: DragStartBehavior.down,
    );
  }
}
