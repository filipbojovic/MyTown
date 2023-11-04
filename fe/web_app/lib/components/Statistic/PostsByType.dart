import 'package:flutter/material.dart';
import 'package:random_color/random_color.dart';
import 'package:web_app/models/Statistic/TypeStats.dart';

import 'package:charts_flutter/flutter.dart' as charts;

class TypePie {
  TypeStats typeStats;
  double typeValue;
  Color color;

  TypePie(this.typeStats, this.typeValue, this.color);
}

class PostsByType extends StatelessWidget {
  final List<TypeStats> types;
  final int numberOfPosts;

  PostsByType(this.types, this.numberOfPosts);

  @override
  Widget build(BuildContext context) {
    List<charts.Series<TypePie, String>> _seriesPieData =List<charts.Series<TypePie, String>>();
    List<TypePie> typesData = new List<TypePie>();

    double sum = numberOfPosts.toDouble();
    for (var item in types) {
      RandomColor _randomColor = RandomColor();

      Color _color = _randomColor.randomColor(
          colorHue:  ColorHue.multiple( colorHues: [ColorHue.green, ColorHue.pink],),
          colorSaturation: ColorSaturation.mediumSaturation,
          colorBrightness: ColorBrightness.dark);
      double itemValue = (item.numOfPosts.toDouble() / sum) * 100;
      itemValue = num.parse(itemValue.toStringAsFixed(2));

      typesData.add(new TypePie(item, itemValue, _color));
    }

    _seriesPieData.add(
      charts.Series(
        domainFn: (TypePie userRs, _) => userRs.typeStats.name,
        measureFn: (TypePie userRs, _) => userRs.typeValue,
        colorFn: (TypePie userRs, _) =>
            charts.ColorUtil.fromDartColor(userRs.color),
        id: 'Users via gender',
        data: typesData,
        labelAccessorFn: (TypePie row, _) => '${row.typeValue}%',
      ),
    );

    return Card(
      elevation: 10.0,
      margin: EdgeInsets.all(MediaQuery.of(context).size.width * 0.0170),
      color: Colors.grey[150],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      child: Padding(
        padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.010),
        child: Container(
          height: MediaQuery.of(context).size.height * 0.390,
          width: MediaQuery.of(context).size.width * 0.200,
            child: Center(
              child: Column(
                children: <Widget>[
                  Text(
                    'Procenat objava po vrsti',
                    style: TextStyle(
                        fontSize: MediaQuery.of(context).size.height * 0.025,
                        fontWeight: FontWeight.bold),
                  ),
                 SizedBox(
                    height:MediaQuery.of(context).size.height * 0.010,
                  ),
                  Expanded(
                    child: charts.PieChart(_seriesPieData,
                      animate: false,
                      behaviors: [
                        new charts.DatumLegend(
                          outsideJustification:charts.OutsideJustification.endDrawArea,
                          horizontalFirst: false,
                          desiredMaxRows: 4,
                          cellPadding:new EdgeInsets.only(right: 4.0, bottom: 4.0),
                          entryTextStyle: charts.TextStyleSpec(
                            color:charts.MaterialPalette.purple.shadeDefault,
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
