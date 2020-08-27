import 'package:beauty_textfield/beauty_textfield.dart';
import 'package:flutter/material.dart';
import 'package:argon_buttons_flutter/argon_buttons_flutter.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'dart:async';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: Color.fromRGBO(31, 45, 68, 1),
        ),
        padding: EdgeInsets.all(20),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(bottom: 32),
                  child: Image.asset(
                    'images/iatec_logo.png',
                    width: 200,
                    height: 150,
                  ),
                ),
                Text(
                  'Patrimonio ANP',
                  style: TextStyle(color: Colors.white, fontSize: 25),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 25),
                ),
                BeautyTextfield(
                  maxLines: 1,
                  width: double.maxFinite,
                  height: 50,
                  duration: Duration(milliseconds: 300),
                  inputType: TextInputType.emailAddress,
                  prefixIcon: Icon(Icons.email),
                  placeholder: "Email",
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 8),
                ),
                BeautyTextfield(
                  maxLines: 1,
                  obscureText: true,
                  width: double.maxFinite,
                  height: 50,
                  duration: Duration(milliseconds: 300),
                  inputType: TextInputType.text,
                  prefixIcon: Icon(Icons.lock),
                  placeholder: "Password",
                ),
                Padding(
                  padding: EdgeInsets.only(top: 16, bottom: 10),
                  child: ArgonButton(
                    height: 50,
                    roundLoadingShape: true,
                    width: MediaQuery.of(context).size.width * 0.45,
                    onTap: (startLoading, stopLoading, btnState) async {
                      if (btnState == ButtonState.Idle) {
                        startLoading();
                        await new Future.delayed(const Duration(seconds: 1));
                        Navigator.pushNamedAndRemoveUntil(
                            context, '/home', (route) => false);
                      }
                    },
                    child: Text(
                      "Login",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w700),
                    ),
                    loader: Container(
                      padding: EdgeInsets.all(10),
                      child: SpinKitRing(
                        color: Colors.white,
                        // size: loaderWidth ,
                      ),
                    ),
                    borderRadius: 5.0,
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
