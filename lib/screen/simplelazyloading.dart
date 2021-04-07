import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SimpleLazyloading extends StatefulWidget {
  @override
  _SimpleLazyloadingState createState() => _SimpleLazyloadingState();
}

class _SimpleLazyloadingState extends State<SimpleLazyloading> {
  List myList;
  bool isMore = false;
  ScrollController _scrollController = new ScrollController();
  int _currentMax = 10;

  @override
  void initState() {
    super.initState();
    myList =
        List.generate(10, (index) => "Item Number: " + (index + 1).toString());
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _getMoreData();
      }
    });
  }

  _getMoreData() async {
    print("Get More Data");
    if (_currentMax == 30) {
      setState(() {});
      return;
    }
    for (int i = _currentMax; i < _currentMax + 10; i++) {
      myList.add("Item Number: " + (i + 1).toString());
      isMore = true;
    }
    await Future.delayed(const Duration(milliseconds: 1000), () {});
    _currentMax = _currentMax + 10;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("LazyLoading"),
      ),
      body: ListView.builder(
          controller: _scrollController,
          itemExtent: 80,
          itemCount: myList.length + 1,
          itemBuilder: (ctx, index) {
            if (index == myList.length) {
              if (isMore != false) {
                return CupertinoActivityIndicator();
              }
              return Container();
            }
            return ListTile(
              title: Text(myList[index]),
            );
          }),
    );
  }
}
