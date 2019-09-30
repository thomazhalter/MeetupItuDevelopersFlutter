import 'package:flutter_web/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'First WebApplication With Flutter', // title da página
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: Container(
          child: Center(
            child: CounterWidget(),
          ),
        ));
  }
}

class CounterWidget extends StatefulWidget {
  @override
  _CounterWidgetState createState() => _CounterWidgetState();
}

class _CounterWidgetState extends State<CounterWidget> {
  int _counter = 10;

  Future<void> _fimAlert(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Alerta'),
          content: const Text('O contador será reiniciado'),
          actions: <Widget>[
            FlatButton(
              child: Text('Ok'),
              onPressed: () {
                setState(() {
                  _counter = 10;
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            "$_counter",
            style: TextStyle(color: Colors.grey, fontSize: 40.0),
          ),
          FlatButton(
            child: Text('Decrementar'),
            color: Colors.amber,
            onPressed: () {
              setState(() {
                _counter--;
                if (_counter == 0) _fimAlert(context);
              });
            },
          )
        ],
      ),
    );
  }
}
