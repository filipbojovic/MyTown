import 'package:flutter/material.dart';
import 'package:web_app/models/Statistic/UserStats.dart';

import 'package:charts_flutter/flutter.dart' as charts;

class AgePie {
  String userAge;
  double userValue;
  Color color;

  AgePie(this.userAge, this.userValue, this.color);
}

class AgeStatsChart extends StatelessWidget {
  final List<UserStats> users;

  AgeStatsChart(this.users);

  @override
  Widget build(BuildContext context) {
    double numberOfUsers = users.length.toDouble();

    List<charts.Series<AgePie, String>> _seriesPieData =
        List<charts.Series<AgePie, String>>();

    List<AgePie> categoriesData = new List<AgePie>();

    AgePie age10to20 = new AgePie('10-20', 0.0, Colors.blue);
    AgePie age20to30 = new AgePie('20-30', 0.0, Colors.red);
    AgePie age30to40 = new AgePie('30-40', 0.0, Colors.yellow);
    AgePie age40to50 = new AgePie('40-50', 0.0, Colors.green);
    AgePie age50 = new AgePie('50+', 0.0, Colors.purple);
    for (var item in users) {
      if (getAge(item.birthDate) < 21)
        age10to20.userValue++;
      else if (getAge(item.birthDate) < 31)
        age20to30.userValue++;
      else if (getAge(item.birthDate) < 41)
        age30to40.userValue++;
      else if (getAge(item.birthDate) < 51)
        age40to50.userValue++;
      else
        age50.userValue++;
    }

    age10to20.userValue = (age10to20.userValue / numberOfUsers) * 100;
    age20to30.userValue = (age20to30.userValue / numberOfUsers) * 100;
    age30to40.userValue = (age30to40.userValue / numberOfUsers) * 100;
    age40to50.userValue = (age40to50.userValue / numberOfUsers) * 100;
    age50.userValue = (age50.userValue / numberOfUsers) * 100;

    categoriesData.add(age10to20);
    categoriesData.add(age20to30);
    categoriesData.add(age30to40);
    categoriesData.add(age40to50);
    categoriesData.add(age50);

    _seriesPieData.add(charts.Series<AgePie, String>(
      id: 'Age range',
      domainFn: (AgePie sales, _) => sales.userAge,
      measureFn: (AgePie sales, _) => sales.userValue,
      data: categoriesData,
    ));

    return Card(
      elevation: 10.0,
      margin: EdgeInsets.all(MediaQuery.of(context).size.width * 0.0250),
      color: Colors.grey[150],
      shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      child: Padding(
        padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.010),
        child: Container(
          height: MediaQuery.of(context).size.height * 0.390,
          width: MediaQuery.of(context).size.width * 0.350,
          child: Center(
            child: Column(
              children: <Widget>[
                Text(
                  'Procenat korisnika po starosnoj strukturi',
                  style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width * 0.014,
                      fontWeight: FontWeight.w600),
                  textAlign: TextAlign.center,
                ),
                Expanded(
                  child: new charts.BarChart(
                    _seriesPieData,
                    animate: false,
                    barGroupingType: charts.BarGroupingType.grouped,
                    vertical: false,
                    primaryMeasureAxis: new charts.NumericAxisSpec(tickProviderSpec:new charts.BasicNumericTickProviderSpec(desiredTickCount: 3)),
                    secondaryMeasureAxis: new charts.NumericAxisSpec(tickProviderSpec:new charts.BasicNumericTickProviderSpec(desiredTickCount: 3)),
                  )
                ),
              ],
            ),
          ),
        ),
      )
    );
  }

  int getAge(DateTime birthDate) {
    DateTime currentDate = DateTime.now();
    int age = currentDate.year - birthDate.year;
    int month1 = currentDate.month;
    int month2 = birthDate.month;
    if (month2 > month1) {
      age--;
    } else if (month1 == month2) {
      int day1 = currentDate.day;
      int day2 = birthDate.day;
      if (day2 > day1) {
        age--;
      }
    }
    return age;
  }
}
