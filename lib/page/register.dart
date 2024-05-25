import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:uangku_pencatat_keuangan/page/login.dart';
import 'package:uangku_pencatat_keuangan/util/util.dart';

import 'email_ver.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController EmailController = new TextEditingController();
  TextEditingController PasswordController = new TextEditingController();
  TextEditingController ConfirmPasswordController = new TextEditingController();
  String _Email = "", _password = "";
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    EmailController.dispose();
    PasswordController.dispose();
    ConfirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
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
                        height: 100,
                      ),
                      Container(
                          margin: EdgeInsets.only(left: 20, bottom: 10),
                          child: Image.asset(
                            "assets/img/uangku_logo.png",
                            scale: 11,
                          )),
                      Container(
                        margin: EdgeInsets.only(left: 20, bottom: 30),
                        child: Text(
                          "Create Account",
                          style: TextStyle(fontSize: 40, fontFamily: "Inter"),
                        ),
                      ),
                      Form(
                          key: _formKey,
                          child: Container(
                              margin: EdgeInsets.only(left: 20, right: 20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Email",
                                      style: TextStyle(
                                          fontSize: 20, fontFamily: "Inter")),
                                  Container(
                                    color: Colors.white,
                                    margin:
                                        EdgeInsets.only(bottom: 10, top: 10),
                                    child: TextFormField(
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontFamily: "Inter",
                                            color: Colors.black),
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return "Please enter Email.";
                                          }
                                        },
                                        controller: EmailController,
                                        decoration: InputDecoration(
                                          focusedBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10)),
                                              borderSide: BorderSide(
                                                  color: Colors.black)),
                                          border: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10))),
                                        )),
                                  ),
                                  Text("Password",
                                      style: TextStyle(
                                          fontSize: 20, fontFamily: "Inter")),
                                  Container(
                                    margin:
                                        EdgeInsets.only(top: 10, bottom: 10),
                                    child: TextFormField(
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontFamily: "Inter",
                                            color: Colors.black),
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return "Please enter your new Password.";
                                          }

                                          return null;
                                        },
                                        obscureText: true,
                                        controller: PasswordController,
                                        decoration: InputDecoration(
                                          focusedBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10)),
                                              borderSide: BorderSide(
                                                  color: Colors.black)),
                                          border: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10))),
                                        )),
                                  ),
                                  Text("Confirm Password",
                                      style: TextStyle(
                                          fontSize: 20, fontFamily: "Inter")),
                                  Container(
                                    margin:
                                        EdgeInsets.only(top: 10, bottom: 30),
                                    child: TextFormField(
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontFamily: "Inter",
                                            color: Colors.black),
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            Navigator.pop(context);
                                            return "Please enter your confirm password.";
                                          }
                                          if (value !=
                                              PasswordController.text) {
                                            Navigator.pop(context);
                                            return "Your password not same as before.";
                                          }

                                          return null;
                                        },
                                        obscureText: true,
                                        controller: ConfirmPasswordController,
                                        decoration: InputDecoration(
                                          focusedBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10)),
                                              borderSide: BorderSide(
                                                  color: Colors.black)),
                                          border: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10))),
                                        )),
                                  ),
                                  Center(
                                      child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.yellow,
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(15)))),
                                    onPressed: () {
                                      registerAccount();
                                    },
                                    child: Container(
                                        width: 250,
                                        padding: EdgeInsets.all(10),
                                        child: Center(
                                          child: Text(
                                            "Register Now",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontSize: 25,
                                                fontFamily: "Inter",
                                                color: Colors.black),
                                          ),
                                        )),
                                  ))
                                ],
                              )))
                    ],
                  ),
                ))
              ],
            )));
  }

  void registerAccount() async {
    loadingUangku(context);

    if (_formKey.currentState!.validate()) {
      _Email = EmailController.text;
      _password = PasswordController.text;

      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: _Email, password: _password);

        Navigator.pop(context); // Menutup dialog loading
        FirebaseFirestore firestore = FirebaseFirestore.instance;
        await firestore
            .collection("financial_records")
            .doc(userCredential.user!.uid)
            .collection("kategori")
            .doc("pemasukan")
            .set({"nama": FieldValue.arrayUnion([])});

        await firestore
            .collection("financial_records")
            .doc(userCredential.user!.uid)
            .collection("kategori")
            .doc("pengeluaran")
            .set({"nama": FieldValue.arrayUnion([])});

        Navigator.pop(
            context, MaterialPageRoute(builder: (context) => login_page()));
        Fluttertoast.showToast(msg: "Akun berhasil dibuat");
      } on FirebaseAuthException catch (e) {
        Navigator.pop(context); // Menutup dialog loading

        if (e.code == 'weak-password') {
          Fluttertoast.showToast(msg: "Error: Password minimal 8 huruf.");
        } else if (e.code == 'email-already-in-use') {
          Fluttertoast.showToast(msg: "Error: Email telah digunakan.");
        } else if (e.code == 'invalid-email') {
          Fluttertoast.showToast(msg: 'Error: Email tidak valid.');
        }
      }
    }
  }
}
