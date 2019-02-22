import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'dart:math';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

/// Sample linear data type.
class EnergyReading {
  final DateTime dateTime;
  final int watts;

  EnergyReading(this.dateTime, this.watts);
}

class _MyHomePageState extends State<MyHomePage> {
  static int _month = 1;
  static int _day = 1;
  int _counter = 0;
// rebuild the widget.
  void _incrementDate() {
    _counter++;
    setState(() {
      _month = _month > 12 ? 1 : _month;
      // roughly to accomodate all months for this simple test.
      if (_day > 26) {
        _month++;
        _day = 1;
      } else {
        _day++;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Random random = Random();
    var data = [
      EnergyReading(DateTime(2019, _month, _day), random.nextInt(100)),
      EnergyReading(DateTime(2019, _month, _day + 1), random.nextInt(100)),
      EnergyReading(DateTime(2019, _month, _day + 2), random.nextInt(100)),
    ];

    var series = [
      new charts.Series(
        id: 'Energy',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (EnergyReading reading, _) => reading.dateTime,
        measureFn: (EnergyReading readings, _) => readings.watts,
        measureUpperBoundFn: (EnergyReading readings, _) => 100,
        measureLowerBoundFn: (EnergyReading readings, _) => 0,
        data: data,
      ),
    ];
    var chart = charts.TimeSeriesChart(
      series,
      animate: true,
    );

    var chartWidget = new Padding(
      padding: new EdgeInsets.all(32.0),
      child: new SizedBox(
        height: 200.0,
        child: chart,
      ),
    );

    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
      ),
      body: new Center(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Text(
              'You have pushed the button this many times:',
            ),
            new Text(
              '$_counter',
              style: Theme.of(context).textTheme.display1,
            ),
            chartWidget,
          ],
        ),
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: _incrementDate,
        tooltip: 'Increment',
        child: new Icon(Icons.add),
      ),
    );
  }
}
