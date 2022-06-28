import 'dart:async';


import 'package:flutter_drawer/drawn_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_drawer/sketcher.dart';

class DrawingPage extends StatefulWidget {
  @override
  _DrawingPageState createState() => _DrawingPageState();
}

class _DrawingPageState extends State<DrawingPage> {
  GlobalKey _globalKey = new GlobalKey();
  List<DrawnLine> lines = <DrawnLine>[];
  DrawnLine? line = DrawnLine([],Colors.black,5); 
  Color selectedColor = Colors.black;
  double selectedWidth = 5.0;
  Color selectedBackColor = Colors.white;
 

  Future<void> save() async {
    // TODo
  }

  Future<void> clear() async {
    setState(() {
    lines = [];
    line = null;
  });
  }

GestureDetector buildCurrentPath(BuildContext context) {
    return GestureDetector(
    onPanStart: onPanStart,
    onPanUpdate: onPanUpdate,
    onPanEnd: onPanEnd,
    child: RepaintBoundary(
      child: Container(
        color: Colors.transparent,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: CustomPaint(
          painter: Sketcher(lines: lines),
        ),// CustomPaint widget will go here
      ),
    ),
            );
}

    
    

  void onPanStart(DragStartDetails details) {
   final box = context.findRenderObject() as RenderBox;
  final point = box.globalToLocal(details.globalPosition);
  setState(() {
    line = DrawnLine([point], selectedColor, selectedWidth);
  });
 
  }

  void onPanUpdate(DragUpdateDetails details) {
    final box = context.findRenderObject() as RenderBox;
  final point = box.globalToLocal(details.globalPosition);
  List<Offset> path = List.from(line!.path)..add(point);
  line = DrawnLine(path, selectedColor, selectedWidth);

  setState(() {
    if (lines.length == 0) {
      lines.add(line!);
    } else {
      lines[lines.length - 1] = line!;
    }
  });


  }

  void onPanEnd(DragEndDetails details) {
    setState(() {
    lines.add(line!);
  });
  
  }

  
  Widget? buildAllPaths(BuildContext context) {
  }

  Widget buildStrokeToolbar() {
  return Positioned(
    bottom: 100.0,
    right: 10.0,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        buildStrokeButton(5.0),
        buildStrokeButton(10.0),
        buildStrokeButton(15.0),
      ],
    ),
  );
}

  Widget buildStrokeButton(double strokeWidth) {
    return GestureDetector(
      onTap: () {
        selectedWidth = strokeWidth;
      },
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Container(
          width: strokeWidth * 2,
          height: strokeWidth * 2,
          decoration: BoxDecoration(color: selectedColor, borderRadius: BorderRadius.circular(20.0)),
        ),
      ),
    );
  }

  Widget buildColorToolbar() {
  return Positioned(
    top: 40.0,
    right: 10.0,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        buildClearButton(),
        buildColorButton(Colors.red),
        buildColorButton(Colors.blueAccent),
        buildColorButton(Colors.deepOrange),
        buildColorButton(Colors.green),
        buildColorButton(Colors.lightBlue),
        buildColorButton(Colors.black),
        buildColorButton(Colors.white),
      ],
    ),
  );
}

  Widget buildColorButton(Color color) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: FloatingActionButton(
        mini: true,
        backgroundColor: color,
        child: Container(),
        onPressed: () {
          setState(() {
            selectedColor = color;
          });
        },
      ),
    );
  }

  Widget buildSaveButton() {
    return GestureDetector(
      onTap: save,
      child: CircleAvatar(
        child: Icon(
          Icons.save,
          size: 20.0,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget buildClearButton() {
    return GestureDetector(
      onTap: clear,
      child: CircleAvatar(
        child: Icon(
          Icons.delete_forever_outlined,
          size: 20.0,
          color: Colors.white,
        ),
      ),
    );
  }


Widget buildBackColorToolbar() {
  return 
     Align( 
      alignment: Alignment.bottomCenter,
       child: Row(
        
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
        
          buildBackColorButton(Colors.red),
          buildBackColorButton(Colors.blueAccent),
          buildBackColorButton(Colors.deepOrange),
          buildBackColorButton(Colors.green),
          buildBackColorButton(Colors.lightBlue),
          buildBackColorButton(Colors.black),
          buildBackColorButton(Colors.white),
        ],
         ),
     );
  
}

Widget buildBackColorButton(Color color){
return Padding(
      padding: const EdgeInsets.all(4.0),
      child: FloatingActionButton(
        mini: true,
        backgroundColor: color,
        child: Container(),
        onPressed: () {
          setState(() {
            selectedBackColor = color;
          });
        },
      ),
    );
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: selectedBackColor,
      body: Stack(
        children: [
                buildCurrentPath(context),
                buildColorToolbar(),
                buildStrokeToolbar(),
                buildBackColorToolbar(),
        ],
      ),
    );
  }

}