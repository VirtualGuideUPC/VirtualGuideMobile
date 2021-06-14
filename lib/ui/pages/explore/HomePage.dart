import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tour_guide/ui/widgets/MapScreenWidget.dart';
import 'package:tour_guide/ui/widgets/SearchBarWidget.dart';

class HomePage extends StatefulWidget {
  Stream<int> streamExplorerTabIndex;
  HomePage(this.streamExplorerTabIndex);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin<HomePage> {
  String _searchString = '';
  bool _isBottomSheetOpen = false;
  @override
  void initState() {
    super.initState();

    widget.streamExplorerTabIndex.listen((number) {
      Future.delayed(Duration.zero, () {
        _closeBottomSheet(context);
      });
    });
  }

  @override
  bool get wantKeepAlive => true;
  @override
  Widget build(context) {
    super.build(context);
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
              ),
              child: SearchBarWidget(
                onchangeValue: (val) {
                  _searchString = val;
                },
                onEditingComplete: () {
                  print(_searchString);
                },
              ),
            ),
            Expanded(
              child: Stack(
                fit: StackFit.loose,
                children: [
                  Flexible(
                      child: Container(
                    child: MapScreen(),
                  )),
                  Positioned(
                    height: 60,
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: GestureDetector(
                      child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20.0),
                              topRight: Radius.circular(20.0),
                            ),
                            color: Color.fromRGBO(79, 77, 140, 1),
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 10.0),
                          height: 56.0,
                          child:
                              Stack(children: [
                            Container(
                              width: double.infinity,
                              height: 20,
                              child: Center(
                                child: Container(
                                  width: 100,
                                  height: 3,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            Expanded(
                                child: Container(
                                    child: Center(
                              child: Text("15 experiencias encontradas",style: TextStyle(color: Colors.white),),
                            )))
                          ])),
                      onTap: () {
                        _showBottomSheet(context);
                      },
                    ),
                  )
                ],
              ),
            )
          ],
        ));
  }

  void _showBottomSheet(context) {
    Scaffold.of(context)
        .showBottomSheet((context) {
          _isBottomSheetOpen = true;
          return Container(
            //  decoration: BoxDecoration(
            //   borderRadius: BorderRadius.only(
            //     topLeft: Radius.circular(16.0),
            //     topRight: Radius.circular(16.0),
            //   ),
            color: Color.fromRGBO(79, 77, 140, 1),
            height: MediaQuery.of(context).size.height - 100.0,
            child:Stack(
              children: [
                                            Container(
                              width: double.infinity,
                              height: 20,
                              child: Center(
                                child: Container(
                                  width: 100,
                                  height: 3,
                                  color: Colors.black,
                                ),
                              ),
                            ),
              ],
            )
          );
        })
        .closed
        .whenComplete(() {
          _isBottomSheetOpen = false;
        });
  }

  void _closeBottomSheet(context) {
    if (_isBottomSheetOpen) {
      Navigator.pop(context);
    }
  }
}
