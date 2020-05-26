import 'dart:async';
import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: new MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  String notif = '';
  final usernamecontroller = TextEditingController();
  final passwordcontroller = TextEditingController();

  String username = '';
  String password = '';
  
  void login() {
    if(username == '' || password == ''){
      setState(() {
        notif = 'Username or Password Cannot Be Empty!';
    });
    }else{
    //   setState(() {
    //     notif = 'Username: $username, Password: $password';
    // });
      authentication();
    }
  }

  Future<String> authentication() async{
    http.Response response = await http.get(
      Uri.encodeFull("http://10.0.2.2:3000/getuser?username=" + username),
      headers: {
        "Accept" : "application/json"
      }
    );
    if (response.statusCode == 200) {
        print('Username ' + username + ' Not Found');
        setState(() {
        notif = 'Username not Found';
    });
    } else {
      var pass = utf8.encode(password);
      var md5pass = md5.convert(pass);
      print("MD5 Pass: ${md5pass}");
      http.Response res = await http.get(
      Uri.encodeFull("http://10.0.2.2:3000/login?username="+username+"&password=${md5pass}"),
      headers: {
        "Accept" : "application/json"
      });
      if (res.statusCode == 200){
        setState((){
        notif = 'Login Success!';});
      }
      else{
        setState((){
        notif = 'Wrong Username or Password!';});
      }
    }
  }

  void getHttp() async {
  try {
    Response response = await Dio().get("http://10.0.2.2:3000/getuser?username=admin");
    print(response);
  } catch (e) {
    print(e);
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text('Flutter'),
      ),

      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[

            Container(
              padding: EdgeInsets.fromLTRB(0, 50, 0, 0 ),
              child: Image(
                image: AssetImage('assets/logo.png'),
                width: 200,
              ),
            ),


            Container(
              padding: EdgeInsets.fromLTRB(0, 20, 0, 0 ),
              child:  Text(
              'LOGIN PAGE',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            ),


            Container(
              padding: EdgeInsets.only(left: 50, right: 50, top: 35 ),
              child:  Column(
                children: <Widget>[
                  TextField(
                    controller: usernamecontroller,
                    decoration: InputDecoration(
                      labelText: 'Username',
                      labelStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[600]
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black)
                      )
                    ),
                  ),
                  TextField(
                    controller: passwordcontroller,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      labelStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[600]
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black)
                      )
                    ),
                    obscureText: true,
                  )
                ],
            ),
            ),


            Container(
              padding: EdgeInsets.only(left: 50, right: 50, top: 35  ),
              height: 80,
              child: GestureDetector(
                  onTap: () {
                    setState(() {
                      password = passwordcontroller.text;
                      username = usernamecontroller.text;
                    });
                    login();
                    },
                  child: Material(
                      borderRadius: BorderRadius.circular(30),
                      shadowColor: Colors.black54,
                      color: Colors.blue,
                      elevation: 5,
                        child: Center(
                          child: Text(
                            'LOGIN',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold
                            ),
                            ),
                          ),
                    )
              ),
            ),

            Container(
              padding: EdgeInsets.fromLTRB(0, 20, 0, 0 ),
              child:  Text(
              '$notif',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            ),
          ],),
      )
    );
  }
}
