import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutterthirdtask/model.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:http/http.dart' as Http;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fetch and Display Data from API',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blueGrey,
      ),
      home: MyHomePage(title: 'Fetch and Display Data from API'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<StatefulWidget> createState() {
    return _MyPageState();
  }

}
class _MyPageState extends State<MyHomePage> {

  List<User> _users = [];
  ProgressDialog pr;

  void _getUsersData( ) async {
    try {
      pr.show();
      String url = "https://jsonplaceholder.typicode.com/users";
      var response = await Http.get(url);

      if(response.statusCode == 200){
        var data = jsonDecode(response.body);
        setState(() {
          for (Map u in data){
            _users.add(User.fromJson(u));
          }
        });
        
      }

      pr.hide();
    } catch (e) {
      pr.hide();
    }
  }



  @override
  Widget build(BuildContext context) {
    pr = new ProgressDialog(context);
    pr.style(
      message: 'Please Wait...',
      borderRadius: 10.0,
      backgroundColor: Colors.white,
      progressWidget: CircularProgressIndicator(),
      elevation: 10.0,
      insetAnimCurve: Curves.easeInOut,
      progress: 0.0,
      maxProgress: 100.0,
      progressTextStyle: TextStyle(
        color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w400),
      messageTextStyle: TextStyle(
        color: Colors.black, fontSize: 19.0, fontWeight: FontWeight.w600)
    );
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text ('Widget, Text'),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text("Results: ( ${_users.length} )", style: Theme.of(context).textTheme.display1,),
              ],
            ),
            Container(
                height: 300.0,
                width: 340.0,
                child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: <Widget>[
                    ..._users.map( (user) { 
                      return UserSearchResult(user);
                    }),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _getUsersData,
        tooltip: 'Increment',
        child: Icon(Icons.cloud_download),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

}

class UserSearchResult extends StatelessWidget {
  final User user;
  const UserSearchResult(@required this.user, {Key key, }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.of(context).push(MaterialPageRoute(builder: (context){
          return UserInfoPage(user);
        }));
      },
          child: Container(
        width: 300.0,
        child: Card(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        CircleAvatar(radius: 30.0,
                        backgroundImage: NetworkImage("https://api.adorable.io/avatars/58/${user.email}"),
                        ),
                        Text(user.name),
                        Text(user.email)
                      ],
                    ),
                  ),
      ),
    );
  }
}

class UserInfoPage extends StatelessWidget {
  final User user;

  const UserInfoPage(this.user, {Key key, }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(actions: <Widget>[],title: Text("About: ${user.name}"),),
      
      body: Center(
        child: Container(
          height: 390,
          width: 500,
          child: Padding(
            padding: EdgeInsets.all(18.0),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.only(top:18.0, left: 10, right: 10, bottom: 18.0),
                child: Column(
                  children: <Widget>[
                    CircleAvatar(
                      radius: 40.0,
                      backgroundImage: NetworkImage("https://api.adorable.io/avatars/58/${user.email}"),
                    ),
                    InfoDetail(title:"Name: ", value: user.name),
                    InfoDetail(title:"Email: ", value: user.email),
                    InfoDetail(title:"Phone: ", value: user.phone),
                    InfoDetail(title:"Address: ", value: user.address.toString()),
                  ],
                ),
              ),
            ) ,),
        ),
      ),
    );
  }
}

class InfoDetail extends StatelessWidget {
  final String title;
  final String value;

  const InfoDetail({Key key, this.title, this.value}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top:8.0, bottom: 8.0),
      child: Container(
        child: Row(
          children: <Widget>[
            Text(title, style:TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold
            ),),
            Expanded(child: Text(value, style: TextStyle(
              fontSize: 20,
              color: Colors.black54
            ),))
          ],
        ),
      ),
    );
  }
}