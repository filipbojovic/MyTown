import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:web_app/models/Statistic/UserStats.dart';

class Top10Users extends StatelessWidget {
  final List<UserStats> users;
  Top10Users(this.users);

  @override
  Widget build(BuildContext context) {
    users.sort((b, a) => a.numOfEcoFPoints.compareTo(b.numOfEcoFPoints));
    return Card(
      elevation: 10.0,
      margin: EdgeInsets.all(MediaQuery.of(context).size.width * 0.0170),
      color: Colors.grey[150],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      child: Padding(
        padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.010),
        child: Container(
            height: MediaQuery.of(context).size.height * 0.390,
            width: MediaQuery.of(context).size.width * 0.350,
            child: Column(children: [
              Container(
                  //alignment: Alignment.centerLeft,
                  padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.005),
                  child: Text('Top 10 korisnika sa najviše društvenih poena',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width * 0.014,
                    fontWeight: FontWeight.w600))),
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.005),
                  color: Colors.grey[300],
                  child: ListView.builder(
                    // itemExtent: MediaQuery.of(context).size.width * 0.045,
                    itemCount: users.length > 9 ? 10 : users.length,
                    itemBuilder: (BuildContext context, int index) {
                      return new Card(
                        child: ListTile(
                          leading: Text('${index + 1}',),
                          title: Text(users[index].fullName, style: TextStyle(fontWeight: FontWeight.w500,)),
                          subtitle: Text('Član od : ${DateFormat('yyyy-MM-dd hh:mm').format(users[index].joinDate)}'),
                          trailing: Text('${users[index].numOfEcoFPoints}'),
                        )
                      );
                    },
                  ),
                ),
              )
            ]
          )
        )
      )
    );
  }
}
