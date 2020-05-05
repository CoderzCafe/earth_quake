
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

Map _data;
List _features;
void main() async {

  _data = await getQuakes();
  _features = _data['features'];

//  print("Features properties: \n ${_data["features"][0]["properties"]}");
//  print("Features geometry: \n ${_data["features"][0]["geometry"]}");
//  print(_data["type"]);

  runApp(new MaterialApp(
    title: "Earth Quake",
    home: new Quakes(),
  ));
}

class Quakes extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Quakes"),
        centerTitle: true,
        backgroundColor: Colors.red,
      ),

      body: new Center(
        child: new ListView.builder(
            itemCount: _features.length,
            padding: const EdgeInsets.all(15.6),
            itemBuilder: (BuildContext context, int position){
              /**  creating the rows for our list view  **/

              //  creating a divider
              if(position.isOdd) return new Divider();
              final index = position ~/ 2;

              /** get the date packages
                * https://pub.dev/packages/intl#-installing-tab- **/
//              var format = new DateFormat("yMd");
              var format = new DateFormat.yMMMd("en_US").add_jms();
              var date = format.format(new DateTime.fromMicrosecondsSinceEpoch(_features[index]['properties']['time']*1000, isUtc: true));

              return new ListTile(
                title: new Text("At: ${date}",
                style: new TextStyle(color: Colors.orange,
                  fontSize: 17.5, fontWeight: FontWeight.w500),),

                subtitle: new Text("${_features[index]['properties']['place']}",
                style: new TextStyle(color: Colors.blueGrey, fontSize: 14.5,
                fontWeight: FontWeight.normal, fontStyle: FontStyle.italic),),

                leading: new CircleAvatar(
                  backgroundColor: Colors.green,

                  child: new Text("${_features[index]['properties']['mag']}",
                    style: new TextStyle(color: Colors.white,
                    fontSize: 16.5, fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic),
                  ),
                ),

                onTap: () {_showAlertMessage(context, "${_features[index]['properties']['title']}");},
              );
            }),
      ),
    );
  }

  void _showAlertMessage(BuildContext context, String msg) {
    var alert = new AlertDialog(
      title: new Text("Quakes"),
      content: new Text(msg),
      actions: <Widget>[
        new FlatButton(onPressed: (){Navigator.pop(context);}, child: new Text("Ok")),
      ],
    );

    showDialog(context: context, child: alert);
  }

}

Future<Map> getQuakes() async {
  String apiUrl = "https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/all_day.geojson";

  http.Response response = await http.get(apiUrl);

  return jsonDecode(response.body);
}