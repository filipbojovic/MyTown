import 'package:flutter/material.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:web_app/components/Statistic/AgeStatsChart.dart';
import 'package:web_app/components/Statistic/ChallengesByCategory.dart';
import 'package:web_app/components/Statistic/ChallengesByCities.dart';
import 'package:web_app/components/Statistic/GenderPieChart.dart';
import 'package:web_app/components/Statistic/PostsByType.dart';
import 'package:web_app/components/Statistic/Top10Users.dart';
import 'package:web_app/components/Statistic/UsersIn6Months.dart';
import 'package:web_app/functions/BOTFunction.dart';
import 'package:web_app/models/Statistic/AdministratorStats.dart';
import 'package:web_app/services/api/administrator.api.dart';

class StatisticScreen extends StatefulWidget {
  @override
  _StatisticScreenState createState() => _StatisticScreenState();
}

class _StatisticScreenState extends State<StatisticScreen> {
  Future dataFuture;

  _getData() async {
    return await AdministratorAPIServices.getDashboardStatistic();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dataFuture = _getData();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: loadData(),
    );
  }

  Widget loadData() {
    return FutureBuilder(
      future: dataFuture,
      builder: (context, snapshots) {
        if (!snapshots.hasData)
          return BOTFunction.loadingIndicator();
        else 
          return createStatisticPage(snapshots.data);
      },
    );
  }

  Widget createStatisticPage(AdministratorStats data) {
    return Container(
      color: Colors.white,
      child: SingleChildScrollView(
        child: Column(
          children: [
            createCounterCards(data),
            SizedBox(height: MediaQuery.of(context).size.height * 0.03),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ChallengesByCategory(data.categories, data.numberOfChallenges),
                PostsByType(data.types, data.numberOfPosts),
                Expanded(
                  child: ChallengdesByCities(data.cities, data.numberOfChallenges)
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                UsersInSixMonths(data.users),
                Expanded(child: Top10Users(data.users))
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                AgeStatsChart(data.users),
                Expanded(
                  child: GenderPieChart(data.users),
                ),
              ],
            ),
          ],
        ),
      )
    );
  }

  Widget createCounterCards(AdministratorStats data) {
    int numberOfUsersRegisterToday = 0;

    for (var item in data.users)
      if (checkDate(item.joinDate)) 
        numberOfUsersRegisterToday++;

    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.15,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          createCounterData(1, data.numberOfUsers),
          createCounterData(2, numberOfUsersRegisterToday),
          createCounterData(3, data.numberOfChallenges)
        ],
      )
    );
  }

  bool checkDate(DateTime date) {
    DateTime today = DateTime.now();
    int date1 = date.day + date.month * 12 + date.year * 365;
    int date2 = today.day + today.month * 12 + today.year * 365;
    return date1 == date2;
  }

  Widget createCounterData(int ind, int number) {
    IconData icon;
    String text;

    if (ind == 1) {
      icon = Icons.people_outline;
      text = 'Ukupan broj korisnika';
    } else if (ind == 2) {
      icon = Icons.calendar_today;
      text = 'Novi korisnici';
    } else {
      icon = OMIcons.permMedia;
      text = 'Ukupan broj izazova';
    }

    return Card(
      elevation: 10.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      child: Container(
        decoration: new BoxDecoration(
          borderRadius: new BorderRadius.all(new Radius.circular(10.0)),
          gradient: new LinearGradient(
            colors: ind == 1 ? 
            [Colors.blue[700], Colors.lightBlueAccent] : 
            ind == 2 ? 
            [Colors.green[700], Colors.greenAccent] : 
            [Colors.red[400], Colors.redAccent[100]],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            tileMode: TileMode.clamp
          )
        ),
        padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.012),
        width: MediaQuery.of(context).size.width * 0.15,
        //height: MediaQuery.of(context).size.height / 6.5,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.grey,
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 4.0),
                      child: Text(
                        text,
                        style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width * 0.013,
                          color: Colors.black,
                        ),
                      ),
                    )
                  ],
                )),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Icon(
                  icon,
                  size: MediaQuery.of(context).size.width * 0.015,
                  color: Colors.black,
                ),
                Text(
                  '$number',
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width * 0.019,
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
      )
    );
  }
}
