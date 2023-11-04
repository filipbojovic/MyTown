import 'package:flutter/material.dart';
import 'package:random_color/random_color.dart';
import 'package:web_app/models/Statistic/CategoryStats.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class CategoryPie {
  CategoryStats categoryStats;
  double categoryValue;
  Color color;

  CategoryPie(this.categoryStats, this.categoryValue, this.color);
}

class ChallengesByCategory extends StatelessWidget {
  final List<CategoryStats> categories;
  final int numberOfChallanges;

  ChallengesByCategory(this.categories, this.numberOfChallanges);

  @override
  Widget build(BuildContext context) {
    List<charts.Series<CategoryPie, String>> _seriesPieData =
        List<charts.Series<CategoryPie, String>>();

    List<CategoryPie> categoriesData = new List<CategoryPie>();

    double sum = numberOfChallanges.toDouble();

    for (var item in categories) {
      RandomColor _randomColor = RandomColor();

      Color _color = _randomColor.randomColor(colorHue: ColorHue.multiple( colorHues: [ColorHue.blue, ColorHue.orange],),);
      double itemValue = (item.numOfChallenges.toDouble() / sum) * 100;
      itemValue = num.parse(itemValue.toStringAsFixed(2));

      categoriesData.add(new CategoryPie(item, itemValue, _color));
    }

    _seriesPieData.add(
      charts.Series(
        domainFn: (CategoryPie userRs, _) => userRs.categoryStats.name,
        measureFn: (CategoryPie userRs, _) => userRs.categoryValue,
        colorFn: (CategoryPie userRs, _) =>
            charts.ColorUtil.fromDartColor(userRs.color),
        id: 'Users via gender',
        data: categoriesData,
        labelAccessorFn: (CategoryPie row, _) => '${row.categoryValue}%',
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
                  'Procenat izazova po \n kategorijama',
                  style: TextStyle(
                      fontSize: MediaQuery.of(context).size.height * 0.025,
                      fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                ),
                SizedBox(
                  height:MediaQuery.of(context).size.height * 0.010,
                ),
                Expanded(
                  child: charts.PieChart(_seriesPieData,
                      animate: false,
                      behaviors: [
                        new charts.DatumLegend(outsideJustification: charts.OutsideJustification.endDrawArea,
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
                      arcRendererDecorators: [new charts.ArcLabelDecorator(labelPosition: charts.ArcLabelPosition.inside)]
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
