import 'package:flutter/material.dart';

import 'package:charts_flutter/flutter.dart' as charts;
import 'package:web_app/models/Statistic/UserStats.dart';

class MonthUser {
  int monthID;
  double monthValue;
  String month;
  Color color;

  MonthUser(this.monthID, this.monthValue, this.month, this.color);
}

class UsersInSixMonths extends StatelessWidget {
  final List<UserStats> users;

  UsersInSixMonths(this.users);

  @override
  Widget build(BuildContext context) {
    List<MonthUser> dataForBarUsers = new List<MonthUser>();
    List<charts.Series<MonthUser, String>> _seriesBarData =
        new List<charts.Series<MonthUser, String>>();

    double numberOfUsers = users.length.toDouble();

    int monthNow = new DateTime.now().month;

    double sum = users.length.toDouble();

    var list = [
      'januar',
      'februar',
      'mart',
      'april',
      'maj',
      'jun',
      'jul',
      'avgust',
      'septembar',
      'oktobar',
      'novembar',
      'decembar'
    ];

    var colors = [
      Colors.blue,
      Colors.red,
      Colors.green,
      Colors.yellow,
      Colors.orange,
      Colors.purple
    ];

    for (int i = 6; i > 0; i--) {
      MonthUser pom = new MonthUser(
          monthNow - i < 0 ? 12 + (monthNow - i) : monthNow - i,
          0,
          monthNow - i < 0 ? list[12 + (monthNow - i)] : list[monthNow - i],
          colors[i - 1]);
      dataForBarUsers.add(pom);
    }

    for (var item in users) {
      DateTime joinDate = item.joinDate;
      int joinMonth = joinDate.month - 1;
      for (var m in dataForBarUsers) {
        if (m.monthID == joinMonth) {
          m.monthValue++;
        }
      }
    }

    for (var m in dataForBarUsers) {
      m.monthValue = (m.monthValue / sum) * 100;
    }

    _seriesBarData.add(charts.Series(
        domainFn: (MonthUser user, _) => user.month,
        measureFn: (MonthUser user, _) => user.monthValue,
        colorFn: (MonthUser user, _) =>
            charts.ColorUtil.fromDartColor(user.color),
        id: "Users in BarChart",
        data: dataForBarUsers,
        labelAccessorFn: (MonthUser row, _) => '${row.monthValue}'));

    return Card(
      elevation: 10.0,
      margin: EdgeInsets.all(MediaQuery.of(context).size.width * 0.0250),
      color: Colors.grey[150],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      child: Padding(
        padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.010),
        child: Container(
          height: MediaQuery.of(context).size.height * 0.390,
          width: MediaQuery.of(context).size.width * 0.350,
          child: Center(
            child: Column(
              children: <Widget>[
                Text(
                  'Procenat registrovanih korisnika po mesecima',
                  style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width * 0.014,
                        fontWeight: FontWeight.w600),
                  textAlign: TextAlign.center,
                ),
                Expanded(
                  child: charts.BarChart(
                    _seriesBarData,
                    animate: false,
                    barGroupingType: charts.BarGroupingType.stacked,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
