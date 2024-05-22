import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:uangku_pencatat_keuangan/model/record.dart';
import 'package:uangku_pencatat_keuangan/page/login.dart';

import 'package:uangku_pencatat_keuangan/util/util.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text("Setting",
            style: TextStyle(
                fontSize: 20, fontFamily: "Inter", color: Colors.black)),
        backgroundColor: Colors.transparent,
        leading: InkWell(
          onTap: () {
            Navigator.pop(context, false);
          },
          child: Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
        ),
      ),
      body: Container(
        margin: EdgeInsets.all(20),
        child: Column(
          children: [
            Text(
              "Akun",
              style: TextStyle(
                  fontSize: 20, fontFamily: "Inter", color: Colors.black),
            ),
            SizedBox(height: 5),
            Card(
                color: Colors.yellow,
                child: InkWell(
                  borderRadius: BorderRadius.circular(10),
                  onTap: () async {
                    await _logout();

                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => login_page()));
                  },
                  child: Container(
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.all(10),
                    width: MediaQuery.of(context).size.width,
                    child: Text(
                      "Logout",
                      style: TextStyle(
                          fontSize: 20,
                          fontFamily: "Inter",
                          color: Colors.black),
                    ),
                  ),
                )),
            SizedBox(height: 20),
            Text(
              "Catatan",
              style: TextStyle(
                  fontSize: 20, fontFamily: "Inter", color: Colors.black),
            ),
            SizedBox(height: 5),
            Card(
                color: Colors.red,
                child: InkWell(
                  borderRadius: BorderRadius.circular(10),
                  onTap: () => _hapusCatatan(Type.TYPE_PEMASUKAN, context),
                  child: Container(
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.all(10),
                    width: MediaQuery.of(context).size.width,
                    child: Text(
                      "Hapus Semua Catatan Pemasukan",
                      style: TextStyle(
                          fontSize: 20,
                          fontFamily: "Inter",
                          color: Colors.white),
                    ),
                  ),
                )),
            Card(
                color: Colors.red,
                child: InkWell(
                  borderRadius: BorderRadius.circular(10),
                  onTap: () => _hapusCatatan(Type.TYPE_PENGELUARAN, context),
                  child: Container(
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.all(10),
                    width: MediaQuery.of(context).size.width,
                    child: Text(
                      "Hapus Semua Catatan Pengeluaran",
                      style: TextStyle(
                          fontSize: 20,
                          fontFamily: "Inter",
                          color: Colors.white),
                    ),
                  ),
                ))
          ],
        ),
      ),
    );
  }

  _logout() async {
    await FirebaseAuth.instance.signOut().then((value) async {
      saveUserToken("");

      print("LOG: Signout Berhasil!");
      Fluttertoast.showToast(msg: "Signout Berhasil!");
    });
  }

  _hapusCatatan(int type, BuildContext context) async {
    await cleanRecord(type);
    Navigator.pop(context, true);
  }
}
