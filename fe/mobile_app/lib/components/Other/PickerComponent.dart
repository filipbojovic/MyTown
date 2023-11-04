import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PickerComponent extends StatefulWidget {
  final DateTime dateTime;
  final Function callBack;
  PickerComponent(this.dateTime, this.callBack);
  @override
  _PickerComponentState createState() => _PickerComponentState();
}

class _PickerComponentState extends State<PickerComponent> {
  
  int _selectedDay = 0;
  int _selectedHour = 0;
  int _selectedMinute = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height / 5,
      color: Colors.white,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: CupertinoPicker(
              looping: true,
                scrollController:
                    new FixedExtentScrollController(
                  initialItem: _selectedDay,
                ),
                itemExtent: MediaQuery.of(context).size.width * 0.08,
                backgroundColor: Colors.white,
                onSelectedItemChanged: (int index) {
                  setState(() {
                    _selectedDay = index;
                  });
                  widget.callBack(widget.dateTime.add(Duration(days: _selectedDay)));
                },
                children: new List<Widget>.generate(31, //num of days
                    (int index) {
                  return new Center(
                    child: new Text((index < 10 ? index.toString().padLeft(2, '0') : '$index') +(_selectedDay == index ? "d" : "")),
                  );
                })),
          ),
          Expanded(
            child: CupertinoPicker(
              looping: true,
                scrollController:
                    new FixedExtentScrollController(
                  initialItem: _selectedHour,
                ),
                itemExtent: MediaQuery.of(context).size.width * 0.08,
                backgroundColor: Colors.white,
                onSelectedItemChanged: (int index) {
                  setState(() {
                    _selectedHour = index;
                  });
                  widget.callBack(widget.dateTime.add(Duration(hours: _selectedHour)));
                },
                children: new List<Widget>.generate(24,
                    (int index) {
                  return new Center(
                    child: new Text((index < 10 ? index.toString().padLeft(2, '0') : '$index') +(_selectedHour == index ? "č" : "")),
                  );
                })),
          ),
          Expanded(
            child: CupertinoPicker(
              looping: true,
                scrollController:
                    new FixedExtentScrollController(
                  initialItem: _selectedMinute,
                ),
                itemExtent: MediaQuery.of(context).size.width * 0.08,
                backgroundColor: Colors.white,
                onSelectedItemChanged: (int index) {
                  setState(() {
                    _selectedMinute = index;
                  });
                  widget.callBack(widget.dateTime.add(Duration(minutes: _selectedMinute)));
                },
                children: new List<Widget>.generate(60,
                    (int index) {
                  return new Center(
                    child: new Text((index < 10 ? index.toString().padLeft(2, '0') : '$index') +(_selectedMinute == index ? "m" : "")),
                  );
                })),
          ),
        ],
      ),
    );
  }
}