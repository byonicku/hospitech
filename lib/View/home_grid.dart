import 'package:flutter/material.dart';
import 'package:tugas_besar_hospital_pbp/main.dart';
import 'package:tugas_besar_hospital_pbp/component/grid_component.dart';
import 'package:tugas_besar_hospital_pbp/component/grid_component_expanded.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

var itemCount = getListOfGridContent().length;
const topLeftIconRadius = 20.0;

class HomeGrid extends StatefulWidget {
  @override
  _HomeGridState createState() => _HomeGridState();
}

class _HomeGridState extends State<HomeGrid> {
  List<bool> expandableState = List.generate(itemCount, (index) => false);
  bool isDark = darkNotifier.value;

  Widget bloc(double width, int index) {
    bool isExpanded = expandableState[index];

    return GestureDetector(
      onTap: () {
        setState(() {
          expandableState[index] = !isExpanded;
        });
      },
      child: AnimatedContainer(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.0),
          color: isDark ? Colors.indigo[500] : Colors.blue,
        ),
        curve: Curves.easeInOut,
        duration: const Duration(milliseconds: 300),
        margin: EdgeInsets.only(left: 2.h, right: 2.h, bottom: 2.5.w),
        width: !isExpanded ? width * 0.30.w : width * 0.30.w,
        height: !isExpanded ? width * 0.10.w : width * 0.15.w,
        child: !isExpanded
            ? getListOfGridContent()[index]
            : getListOfExpandedGrid()[index],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SafeArea(
        child: Align(
          child: SingleChildScrollView(
            child: Wrap(
              children: List.generate(itemCount, (index) {
                return bloc(width, index);
              }),
            ),
          ),
        ),
      ),
    );
  }
}
