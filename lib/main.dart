import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' show json;
import 'package:covid19tracker/CovidData.dart';

void main() => runApp(MaterialApp(
      home: new HomePage(),
    ));

class HomePage extends StatefulWidget {
  @override
  HomePageState createState() => new HomePageState();
}

class HomePageState extends State<HomePage> {

  @override
  Widget build(BuildContext context) {

    var futureBuilder = new FutureBuilder(
      future: _getData(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
            return new Text('loading...');
          default:
            if (snapshot.hasError)
              return new Text('Error: ${snapshot.error}');
            else {
              print("updated");
              return createListView(context, snapshot);
            }
        }
      },
    );

    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Covid19 Tracker"),
      ),
      body: futureBuilder,
      floatingActionButton: FloatingActionButton(
        onPressed: () => setState((){ futureBuilder;})
        ,
        child: new Icon(Icons.refresh),
      ),
    );
  }

  Future<CovidData> _getData() async {
    http.Response response = await http.get(
        Uri.encodeFull("https://api.rootnet.in/covid19-in/stats/latest"),
        headers: {"Accept": "application/json"});
    CovidData dat = CovidData.fromJson(json.decode(response.body));

    await new Future.delayed(new Duration(seconds: 5));

    return dat;
  }

  Widget createListView(BuildContext context, AsyncSnapshot snapshot) {
    CovidData dat = snapshot.data;
    List<RegionalData> rdList = dat.data.regionalData;
    Comparator<RegionalData> regionalComparator =
        (a, b) => a.totalConfirmed.compareTo(b.totalConfirmed);
    rdList.sort(regionalComparator);
    rdList = rdList.reversed.toList();
    return SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: DataTable(
          columns: [
            DataColumn(
                label: Text(
              'State',
              style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
              softWrap: true,
            )),
            DataColumn(
                label: Text(
              'Confirmed',
              style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue),
              softWrap: true,
            )),
            DataColumn(
                label: Text(
              'Deaths',
              style: TextStyle(
                  fontSize: 10, fontWeight: FontWeight.bold, color: Colors.red),
              softWrap: true,
            ))
          ],
          rows:
              rdList // Loops through dataColumnText, each iteration assigning the value to element
                  .map(
                    ((element) => DataRow(
                          cells: <DataCell>[
                            DataCell(Container(
                                width: 100, //SET width
                                child: Text(element.loc))),
                            DataCell(Container(
                                width: 50, //SET width
                                child: Text(element.totalConfirmed.toString(),
                                    style: TextStyle(color: Colors.blue)))),
                            DataCell(Container(
                                width: 50, //SET width
                                child: Text(element.deaths.toString(),
                                    style: TextStyle(color: Colors.red))))
                          ],
                        )),
                  )
                  .toList(),
        ));
  }
}
