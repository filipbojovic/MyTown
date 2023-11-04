import 'package:flutter/material.dart';
import 'package:web_app/models/Statistic/UserStats.dart';

import 'package:charts_flutter/flutter.dart' as charts;

class GenderUser {
  final int genderID;
  final String genderName;
  double genderValue;
  final Color color;

  GenderUser(this.genderID, this.genderName, this.genderValue, this.color);
}

class GenderPieChart extends StatelessWidget {
final List<UserStats> users;

GenderPieChart(this.users);

  @override
Widget build(BuildContext context) {
  List<charts.Series<GenderUser, String>> _seriesPieData = List<charts.Series<GenderUser, String>>();
  List<GenderUser> dataForPieChart = List<GenderUser>();

  double numFemails =users.where((element) => element.genderID == 1).length.toDouble();
  double numMales =users.where((element) => element.genderID == 2).length.toDouble();
  double numberOfUsers = users.length.toDouble();

  GenderUser males = new GenderUser(1, 'Muško', (numMales / numberOfUsers) * 100, Colors.blue[300]);
  males.genderValue = num.parse(males.genderValue.toStringAsFixed(2));
  GenderUser femails = new GenderUser(2, 'Žensko', (numFemails / numberOfUsers) * 100, Colors.pink[300]);
  femails.genderValue = num.parse(femails.genderValue.toStringAsFixed(2));

  dataForPieChart.add(males);
  dataForPieChart.add(femails);

  _seriesPieData.add(
    charts.Series(
      domainFn: (GenderUser userRs, _) => userRs.genderName,
      measureFn: (GenderUser userRs, _) => userRs.genderValue,
      colorFn: (GenderUser userRs, _) =>
          charts.ColorUtil.fromDartColor(userRs.color),
      id: 'Users via gender',
      data: dataForPieChart,
      labelAccessorFn: (GenderUser row, _) => '${row.genderValue}%',
    ),
  );
  return Card(
    elevation: 10.0,
      margin: EdgeInsets.all(MediaQuery.of(context).size.width * 0.0250),
      color: Colors.grey[150],
      shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      child: Padding(
        padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.010),
        child: Container(
          height: MediaQuery.of(context).size.height * 0.390,
          width: MediaQuery.of(context).size.width * 0.350,
          child: Center(
            child: Column(
              children: <Widget>[
                Text(
                  'Procenat korisnika prema polu',
                  style: TextStyle(
                  fontSize: MediaQuery.of(context).size.width * 0.014,
                  fontWeight: FontWeight.w600),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.010,
                ),
                Expanded(
                  child: charts.PieChart(_seriesPieData,
                    animate: false,
                    behaviors: [
                      new charts.DatumLegend(
                        outsideJustification:charts.OutsideJustification.endDrawArea,
                        horizontalFirst: false,
                        desiredMaxRows: 1,
                        cellPadding:new EdgeInsets.only(right: 4.0, bottom: 4.0),
                        entryTextStyle: charts.TextStyleSpec(color:charts.MaterialPalette.purple.shadeDefault,
                        fontFamily: 'Georgia',
                        fontSize: 11),
                      )
                    ],
                    defaultRenderer: new charts.ArcRendererConfig(
                      arcWidth: 200,
                      arcRendererDecorators: [
                        new charts.ArcLabelDecorator(labelPosition: charts.ArcLabelPosition.inside)
                      ]
                    )
                  ),
                ),
              ],
            ),
          ),
        ),
      )
    );
  }
}
