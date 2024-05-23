import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:uangku_pencatat_keuangan/page/home.dart';

class EmailVerificationScreen extends StatefulWidget {
  const EmailVerificationScreen({Key? key}) : super(key: key);

  @override
  State<EmailVerificationScreen> createState() =>
      _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  bool isVerifiedEmail = false;
  late Timer _timer;
  int _countdown = 0;
  bool _isCountingDown = false;

  @override
  void initState() {
    super.initState();

    _checkEmailVerified();
  }

  @override
  dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            ),
          ),
        ),
        body: Stack(
          children: [
            Align(
              child: SvgPicture.asset(
                "assets/img/Ellipse.svg",
                height: 200,
                width: 200,
              ),
              alignment: Alignment.topRight,
            ),
            Container(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 150,
                    ),
                    Container(
                        margin: EdgeInsets.only(left: 20, bottom: 10),
                        child: Image.asset(
                          "assets/img/uangku_logo.png",
                          scale: 11,
                        )),
                    Container(
                      margin: EdgeInsets.only(left: 20, bottom: 30),
                      child: Text("Verifikasi",
                          style: TextStyle(fontSize: 40, fontFamily: "Inter")),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 20, bottom: 30, right: 20),
                      child: Text(
                          "Silakan cek Email inbox anda.\nJika tidak ada kemungkinan ada di Spam.",
                          style: TextStyle(fontSize: 15, fontFamily: "Inter")),
                    ),
                    Center(
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.yellow,
                            ),
                            onPressed: () {
                              _isCountingDown
                                  ? null
                                  : resendEmailVerification();
                            },
                            child: _isCountingDown
                                ? Text("$_countdown",
                                    style: TextStyle(
                                        fontFamily: "Inter",
                                        color: Colors.black))
                                : Text("Kirim Ulang",
                                    style: TextStyle(
                                        fontFamily: "Inter",
                                        color: Colors.black)))),
                    SizedBox(
                      height: 20,
                    ),
                    Center(
                        child: InkWell(
                      onTap: () => _checkEmailVerified(),
                      child: Text("Cek verifikasi",
                          style: TextStyle(
                              fontFamily: "Inter", color: Colors.black)),
                    ))
                  ],
                ),
              ),
            )
          ],
        ));
  }

  _checkEmailVerified() async {
    await FirebaseAuth.instance.currentUser?.reload();

    setState(() {
      isVerifiedEmail = FirebaseAuth.instance.currentUser!.emailVerified;
      print("STATUS VERIFIED: $isVerifiedEmail");
    });

    if (isVerifiedEmail) {
      Fluttertoast.showToast(msg: "Email berhasil terverifikasi. ");
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: ((context) => HomeScreen())));
    } else {
      Fluttertoast.showToast(msg: "Email belum terverifikasi. ");
    }
  }

  void startCountdown() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        setState(() {
          if (_countdown < 1) {
            _isCountingDown = false;
            timer.cancel();
          } else {
            _countdown--;
          }
        });
      },
    );
  }

  resendEmailVerification() {
    try {
      FirebaseAuth.instance.currentUser!.sendEmailVerification();

      setState(() {
        _countdown = 60;
        _isCountingDown = true;
      });
      startCountdown();
    } on FirebaseAuthException catch (e) {
      Fluttertoast.showToast(msg: "Terlalu banyak request, coba lagi nanti.");
    }
  }
}
