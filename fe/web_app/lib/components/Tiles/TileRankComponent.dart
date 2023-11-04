import 'package:flutter/material.dart';
import 'package:web_app/config/config.dart';
import 'package:web_app/models/DbModels/Rank.dart';

class RankTileComponent extends StatefulWidget {
  final Rank rank;
  final int index;
  RankTileComponent(this.rank, this.index, {Key key}) : super(key: key);
  @override
  RankTileComponentState createState() => RankTileComponentState();
}

class RankTileComponentState extends State<RankTileComponent> {
  @override
  Widget build(BuildContext context) {
    return buildRank(widget.rank, widget.index);
  }

  Widget buildRank(Rank rank, int index) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width * 0.03
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          makeIndexLabel(index, context),
          makeRankLogoAndName(context, rank),
          makePointsLabel(rank, context),
        ],
      ),
    );
  }

  Text makeIndexLabel(int index, BuildContext context) {
    return Text(
      index.toString() +".",
      style: TextStyle(
        fontSize: MediaQuery.of(context).size.width * 0.013,
      ),
    );
  }

  Text makePointsLabel(Rank rank, BuildContext context) {
    return Text(
      rank.startPoints.toString() + (rank.endPoints != null ? " - " + rank.endPoints.toString() : "+") + " poena",
      style: TextStyle(
        fontSize: MediaQuery.of(context).size.width * 0.011,
        letterSpacing: 1
      )
    );
  }

  Widget makeRankLogoAndName(BuildContext context, Rank rank) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.12,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            width: MediaQuery.of(context).size.width * 0.035,
            height: MediaQuery.of(context).size.width * 0.035,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: NetworkImage(defaultServerURL + rank.path + rank.fileName),
                fit: BoxFit.fill,
              ),
            ),
          ),
          Text(
            rank.name,
            style: TextStyle(
              fontSize: MediaQuery.of(context).size.width * 0.013,
            ),
          )
        ],
      ),
    );
  }
}