import 'package:flutter/material.dart';
import 'package:tugas_besar_hospital_pbp/component/GridComponent.dart';
import 'package:tugas_besar_hospital_pbp/component/GridComponentExpanded.dart';

var itemCount = getListOfGridContent().length;
const topLeftIconRadius = 20.0;

class HomeGrid extends StatefulWidget {
  @override
  _HomeGridState createState() => _HomeGridState();
}

class _HomeGridState extends State<HomeGrid> {
  List<bool> expandableState = List.generate(itemCount, (index) => false);

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
          color: Colors.blue,
        ),
        curve: Curves.easeInOut,
        duration: const Duration(milliseconds: 300),
        margin: const EdgeInsets.all(5.0),
        width: !isExpanded ? width * 0.45 : width * 0.92,
        height: !isExpanded ? width * 0.45 : width * 0.92,
        child: !isExpanded ? getListOfGridContent()[index] : getListOfExpandedGrid()[index],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Align(
        child: SingleChildScrollView(
          child: Wrap(
            children: List.generate(itemCount, (index) {
              return bloc(width, index);
            }),
          ),
        ),
      ),
    );
  }
}
