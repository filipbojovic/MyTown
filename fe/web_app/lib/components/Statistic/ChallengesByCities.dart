import 'package:flutter/material.dart';
import 'package:web_app/models/Statistic/CityStats.dart';

import '../../models/Statistic/CityStats.dart';

class ChallengdesByCities extends StatelessWidget {
  final List<CityStats> cities;
  final int numberOfChallenges;

  ChallengdesByCities(this.cities, this.numberOfChallenges);

  @override
  Widget build(BuildContext context) {
    double sumOfAllPosts = numberOfChallenges.toDouble();

    return Card(
      elevation: 10.0,
      margin: EdgeInsets.all(MediaQuery.of(context).size.width * 0.0170),
      color: Colors.grey[150],
      shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      child: Padding(
        padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.010),
        child: Container(
          height: MediaQuery.of(context).size.height * 0.390,
          width: MediaQuery.of(context).size.width * 0.350,
          child: Column(
            children: [
              Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.005),
                child: Text(
                  'Procenat izazova po gradovima',
                  textAlign: TextAlign.start,
                  style: TextStyle(
                      fontSize:
                      MediaQuery.of(context).size.width * 0.014,
                      fontWeight: FontWeight.w600)
                  )
              ),
              Expanded(
                child: Container(
                color: Colors.grey[300],
                    padding: EdgeInsets.all(
                        MediaQuery.of(context).size.width * 0.005),
                    child: ListView.builder(
                      //itemExtent: MediaQuery.of(context).size.width * 0.20,
                      shrinkWrap: true,
                      itemCount: cities.length,
                      itemBuilder: (BuildContext context, int index) {
                        return createCard(index, cities[index],sumOfAllPosts);
                    },
                  ),
                )
              )
            ]
          )
        )
      )
    );
  }

  Widget createCard(int index,CityStats city, double sumOfAllPosts){
    double procentOfChallenges =(cities[index].numberOfChallenges.toDouble() /sumOfAllPosts) *100;
    procentOfChallenges =num.parse(procentOfChallenges.toStringAsFixed(2));
    return Card(
      child: ListTile(
        leading: Text('${index + 1}', textAlign: TextAlign.center),
        title: Text(cities[index].name),
        subtitle: Text('Broj izazova: ${cities[index].numberOfChallenges}'),
        trailing: Text('$procentOfChallenges%'),
      )
    );
  }
}
