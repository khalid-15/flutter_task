import 'dart:convert';

import 'package:flutter/material.dart';
import './home.dart';
import './sign_up.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_task/network_utils/api.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController codeController = TextEditingController();

  var userData;
  var code;

  _showMsg(msg) {
    //
    final snackBar = SnackBar(
      content: Text(msg),
      action: SnackBarAction(
        label: 'Close',
        onPressed: () {
          // Some code to undo the change!
        },
      ),
    );
    Scaffold.of(context).showSnackBar(snackBar);
  }

  @override
  void initState() {
    _getUserInfo();
    super.initState();
  }

  void _getUserInfo() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var userJson = localStorage.getString('user');
    var userJson1 = localStorage.getString('code');
    var user = json.decode(userJson!);

    setState(() {
      userData = user['phone_number'];
      // code = json.decode(userJson1!);
    });
  }

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Stack(
          children: <Widget>[
            /////////////  background/////////////
            new Container(
              decoration: new BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  stops: [0.0, 0.4, 0.9],
                  colors: [
                    Color(0xFFFF835F),
                    Color(0xFFFC663C),
                    Color(0xFFFF3F1A),
                  ],
                ),
              ),
            ),

            Positioned(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Card(
                      elevation: 4.0,
                      color: Colors.white,
                      margin: EdgeInsets.only(left: 20, right: 20),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            TextField(
                              style: TextStyle(color: Color(0xFF000000)),
                              controller: codeController,
                              cursorColor: Color(0xFF9b9b9b),
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                prefixIcon: Icon(
                                  Icons.mobile_screen_share,
                                  color: Colors.grey,
                                ),
                                hintText: "code",
                                hintStyle: TextStyle(
                                    color: Color(0xFF9b9b9b),
                                    fontSize: 15,
                                    fontWeight: FontWeight.normal),
                              ),
                            ),

                            /////////////// SignUp Button ////////////
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: FlatButton(
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        top: 8, bottom: 8, left: 10, right: 10),
                                    child: Text(
                                      _isLoading ? 'Verifying...' : 'Verify',
                                      textDirection: TextDirection.ltr,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 15.0,
                                        decoration: TextDecoration.none,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                  ),
                                  color: Colors.red,
                                  disabledColor: Colors.grey,
                                  shape: new RoundedRectangleBorder(
                                      borderRadius:
                                          new BorderRadius.circular(20.0)),
                                  onPressed: _isLoading ? null : _handleLogin),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void _handleLogin() async {
    setState(() {
      _isLoading = true;
    });

    var data = {
      'code': codeController.text,
      // 'code_sent': code,
      // 'phone_number': userData,
    };

    // print(data);
    var res = await Network().postData(data, '/user/auth');
    print(res);
    // var body = json.decode(res.body);
    // print(res.body);
    if (res.data['success']) {
      SharedPreferences localStorage = await SharedPreferences.getInstance();
      var user = res.data['user'];
      var userDecode = json.encode(user);
      localStorage.setString('user', userDecode);
      localStorage.setString('token', res.data['access_token']);
      // print(user['id']);
      var token = localStorage.getString('token');
      print(token);
      Navigator.push(
          context, new MaterialPageRoute(builder: (context) => Home()));
    } else {
      _showMsg('Code is invalid');
    }

    setState(() {
      _isLoading = false;
    });
  }
}
