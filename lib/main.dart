import 'package:flutter/material.dart';
import 'package:cielo_bin_query/cielo_bin_query.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cielo Bin Query Sample',
      theme: ThemeData.dark(),
      home: MyHomePage(title: 'Cielo Bin Query Sample'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  void _query() async {
    var binquery = CieloBinQuery(
      clientId: "YOUR-CLIENT-ID",
      clientSecret: "YOUR-CLIENT-SECRET",
      merchantId: "YOUR-MERCHANT-ID",
    );

    var result = await binquery.query(cardBinController.text);

    var message = "";

    message += "Status Code: ${result.statusCode}\n\n";

    if (result.binQueryResponse != null) {
      message +=
          "Status: ${result.binQueryResponse.status}\n\n" +
          "Provider: ${result.binQueryResponse.provider}\n\n" +
          "Card Type: ${result.binQueryResponse.cardType}\n\n" +
          "Foreign Card: ${result.binQueryResponse.foreignCard}\n\n" +
          "Corporate Card: ${result.binQueryResponse.corporateCard}\n\n" +
          "Issuer: ${result.binQueryResponse.issuer}\n\n" +
          "Issuer Code: ${result.binQueryResponse.issuerCode}";
    }

    if (result.errorResponse != null) {
      result.errorResponse.forEach((e) {
        message += "Error Code: ${e.code}\n\n";
        message += "Error Message: ${e.message}\n\n";
      });
    }

    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Result"),
          titleTextStyle: TextStyle(fontSize: 32),
          actions: <Widget>[
            FlatButton(
              child: Text("Ok"),
              onPressed: () => Navigator.of(context).pop(),
            )
          ],
          content: Text(message),
        );
      },
    );
  }

  final cardBinController = TextEditingController();

  @override
  void dispose() {
    cardBinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: cardBinController,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _query(),
        tooltip: 'Query',
        child: Icon(Icons.credit_card),
      ),
    );
  }
}
