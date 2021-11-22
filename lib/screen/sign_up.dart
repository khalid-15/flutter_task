import 'dart:convert';

import 'package:flutter/material.dart';
import './home.dart';
import './login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_task/network_utils/api.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController phoneController = TextEditingController();

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
                              controller: phoneController,
                              cursorColor: Color(0xFF9b9b9b),
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                prefixIcon: Icon(
                                  Icons.mobile_screen_share,
                                  color: Colors.grey,
                                ),
                                hintText: "phone_num",
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
                                      _isLoading ? 'Sending...' : 'Send code',
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
      'phone_num': phoneController.text,
    };

    // print(jsonEncode(data));
    var res = await Network().postData(data, '/user/validate');
    print(res);
    print(res.data['success']);
    // var body = json.decode(res);
    // print(body);
    if (res.data['success']) {
      SharedPreferences localStorage = await SharedPreferences.getInstance();
      var user = res.data['user'];
      var userDecode = json.encode(user);
      // print(userDecode);
      localStorage.setString('user', userDecode);
      localStorage.setString('code', res.data['code_session'].toString());

      var userJson = localStorage.getString('user');
      var user2 = json.decode(userJson!);
      print(user2['id']);
      Navigator.push(
          context, new MaterialPageRoute(builder: (context) => Login()));
    }

    setState(() {
      _isLoading = false;
    });
  }
}
