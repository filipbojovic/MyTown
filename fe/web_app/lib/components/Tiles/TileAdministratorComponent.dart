import 'package:flutter/material.dart';
import 'package:web_app/components/Other/DeleteAlertDialog.dart';
import 'package:web_app/components/Other/LoadingDialog.dart';
import 'package:web_app/config/config.dart';
import 'package:web_app/models/DbModels/Administrator.dart';
import 'package:web_app/services/api/administrator.api.dart';

import '../../config/config.dart';

class TileAdministratorComponent extends StatefulWidget {
  final Administrator admin;
  final Function deleteAdministrator;
  final BuildContext ctx;
  final Key key;
  TileAdministratorComponent(this.admin, this.deleteAdministrator, this.ctx, this.key);

  @override
  _TileAdministratorComponentState createState() => _TileAdministratorComponentState();
}

class _TileAdministratorComponentState extends State<TileAdministratorComponent> {
  @override
  Widget build(BuildContext context) {
    return createBody(context);
  }

  Widget createBody(BuildContext _context) {
    return Container(
      padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.003),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(7.0),
        color: themeColor,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.min,
        children: [
          makeUserInfo(widget.admin),
          (!widget.admin.head && loggedAdministrator.head) ? makeDeleteButton(_context) :Icon(
              Icons.person,
              size:MediaQuery.of(context).size.width * 0.02
            )
        ],
      ),
    );
  }

  IconButton makeDeleteButton(BuildContext _context) {
    return IconButton(
      icon: Icon(
        Icons.delete_outline,
        size: MediaQuery.of(context).size.width * 0.02
      ),
      onPressed: () async {
        var res = await showDialog(
          context: context,
          builder: (context){
            return DeleteAlertDialog("Da li ste sigurni da želite da obrišete ovog administratora?");
          }
        );

        if(res)
        {
          showDialog(
            context: widget.ctx,
            builder: (context){
              return LoadingDialog("Brisanje administratora u toku...");
            }
          );
          await AdministratorAPIServices.deleteAdministrator(widget.admin.id);
          Navigator.pop(widget.ctx);
          widget.deleteAdministrator(widget.admin);
        }
      }
    );
  }

  Container makeUserInfo(Administrator user) {
    return Container(
      // height: MediaQuery.of(context).size.height,
      // width: MediaQuery.of(context).size.width * 0.12,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          makeUserNamelabel(user),
          makeEmailLabel(),
          makeMemberSinceLabel(),
        ]
      )
    );
  }

  Widget makeEmailLabel()
  {
    return Container(
      child: Text(
        widget.admin.email,
        style: TextStyle(
          color: Colors.black,
          fontSize: widget.admin.email.length < 17 ? MediaQuery.of(context).size.width * 0.010 :MediaQuery.of(context).size.width * 0.007 
        ),
      )
    );
  }

  Text makeMemberSinceLabel() {
    int day = widget.admin.joinDate.day;
    String month = createDate(widget.admin.joinDate.month);
    int year = widget.admin.joinDate.year;

    return Text(
      "Administrator od: $day. $month $year." ,
      style: TextStyle(
        color: Colors.black,
        fontSize: MediaQuery.of(context).size.width * 0.007
      ),
    );
  }

  Text makeUserNamelabel(Administrator user) {
    return Text(
      user.username,
      style: TextStyle(
        fontSize: MediaQuery.of(context).size.width * 0.013,
        fontWeight: FontWeight.w400,
      ),
      textAlign: TextAlign.center,
    );
  }

  String createDate(int month) {
    switch (month) {
      case 1:
        return 'januar';

      case 2:
        return 'februar';

      case 3:
        return 'mart';

      case 4:
        return 'april';

      case 5:
        return 'maj';

      case 6:
        return 'jun';

      case 7:
        return 'jul';

      case 8:
        return 'avgust';

      case 9:
        return 'septembar';

      case 10:
        return 'oktobar';

      case 11:
        return 'novembar';
      case 12:
        return 'decembar';
        break;
      default:
        return ""; break;
    }
  }
}
