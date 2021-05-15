import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  late List<dynamic> data = [];

  // Function to get the JSON data
  void getJSONData() async {
    try {
      //https://unsplash.com/napi/photos/Q14J2k8VE3U/related
      //https://gist.githubusercontent.com/winweb/1117ee33bcd6ad8378a54edf50f45f35/raw/7cc4aad697a5c13e5d5808784662cf13ecb4bb84/sample.json
      final response = await http.get(Uri.https("gist.githubusercontent.com","/winweb/1117ee33bcd6ad8378a54edf50f45f35/raw/7cc4aad697a5c13e5d5808784662cf13ecb4bb84/sample.json"));

      if (response.statusCode == 200) {
        // If the server did return a 200 OK response,
        // then parse the JSON.
        data = json.decode(response.body)['results'];

      } else {
        // If the server did not return a 200 OK response,
        // then throw an exception.
        throw Exception('Failed to load album');
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: _buildListView(),
    );
  }

  Widget _buildListView() {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      // ignore: unnecessary_null_comparison
      itemCount: data == null ? 0 : data.length,
      itemBuilder: (context, index) {
        return _buildImageColumn(data[index]);
        // return _buildRow(data[index]);
      }
    );
  }

  Widget _buildImageColumn(dynamic item) => Container(
      decoration: BoxDecoration(
        color: Colors.white54
      ),
      margin: const EdgeInsets.all(4),
      child: Column(
        children: [
          new CachedNetworkImage(
            imageUrl: item['urls']['small'],
            placeholder: (context, url) => new CircularProgressIndicator(),
            errorWidget: (context, url, error) => new Icon(Icons.error),
            fadeOutDuration: new Duration(seconds: 1),
            fadeInDuration: new Duration(seconds: 3),
          ),
          _buildRow(item)
        ],
      ),
    );

  Widget _buildRow(dynamic item) {
    return ListTile(
      title: Text(
        item['description'] == null ? '': item['description'],
      ),
      subtitle: Text("Likes: " + item['likes'].toString()),
    );
  }

  @override
  void initState() {
    super.initState();
    // Call the getJSONData() method when the app initializes
    this.getJSONData();
  }
}