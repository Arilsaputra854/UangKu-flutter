import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uangku_pencatat_keuangan/model/account.dart';
import 'package:uangku_pencatat_keuangan/model/record.dart';
import 'package:uangku_pencatat_keuangan/page/login.dart';
import 'package:uangku_pencatat_keuangan/util/util.dart';

import 'form_money.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  @override
  State<HomeScreen> createState() => _HomeState();
}

class _HomeState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  TabController? _tabcontroller;

  FirebaseFirestore? firestore;

  @override
  void initState() {
    _tabcontroller = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _tabcontroller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    firestore = FirebaseFirestore.instance;

    return Scaffold(
        body: Container(
            constraints: BoxConstraints(maxWidth: 500),
            child: ListView(
              children: [
                Container(
                  child: Stack(
                    children: [
                      Container(
                        width: 500,
                        height: 230,
                        child: SvgPicture.asset(
                          "assets/img/bg.svg",
                          fit: BoxFit.fill,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 130),
                        alignment: Alignment.center,
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Saldo Anda",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: "Inter",
                                    fontSize: 20),
                              ),
                              FutureBuilder(
                                  future: getJumlahTotal(),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      return Text(
                                        snapshot.data ?? "0",
                                        style: TextStyle(
                                            color: const Color.fromARGB(
                                                255, 25, 13, 13),
                                            fontFamily: "Inter",
                                            fontSize: 40),
                                      );
                                    } else if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return CircularProgressIndicator();
                                    } else {
                                      return Text("Terjadi Kesalahan");
                                    }
                                  })
                            ]),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 5, left: 10, right: 10),
                        width: 500,
                        height: 60,
                        color: Colors.transparent,
                        child: Row(
                          children: [
                            Container(
                                margin: EdgeInsets.all(5),
                                child: Text(
                                  FirebaseAuth.instance.currentUser?.email ??
                                      "No Signin",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: "Inter",
                                      fontSize: 15),
                                )),
                            Spacer(),
                            IconButton(
                                onPressed: () {},
                                icon: Icon(
                                  Icons.bar_chart,
                                  color: Colors.black,
                                )),
                            IconButton(
                                onPressed: () {
                                  FirebaseAuth.instance
                                      .signOut()
                                      .then((value) async {
                                    saveUserToken("");

                                    print("LOG: Signout Berhasil!");
                                  });
                                },
                                icon: Icon(
                                  Icons.settings,
                                  color: Colors.black,
                                )),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                buttonHeader(),
                Container(
                    margin: EdgeInsets.all(12),
                    height: 40,
                    child: TabBar(
                        overlayColor:
                            MaterialStateProperty.all(Colors.transparent),
                        indicatorColor: Colors.transparent,
                        indicatorPadding: EdgeInsets.only(left: 10, right: 10),
                        indicatorSize: TabBarIndicatorSize.tab,
                        indicator: BoxDecoration(
                            color: Colors.yellow,
                            borderRadius: BorderRadius.circular(20)),
                        unselectedLabelColor: Colors.grey,
                        controller: _tabcontroller,
                        tabs: [Text("Pemasukan"), Text("Pengeluaran")])),
                Container(
                    height: 250,
                    width: 500,
                    margin: EdgeInsets.only(left: 10, right: 10),
                    child: TabBarView(
                        controller: _tabcontroller,
                        children: [_tabPemasukan(), _tabPengeluaran()]))
              ],
            )));
  }

  Widget buttonHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        InkWell(
            hoverColor: Colors.transparent,
            onTap: () async {
              bool result = false;
              result = await Navigator.push(context,
                  MaterialPageRoute(builder: (context) {
                return FormMoneyScreen(Type.TYPE_PEMASUKAN);
              }));
              try {
                if (result) {
                  setState(() {});
                }
              } catch (e) {
                print("Canceled");
              }
            },
            child: Container(
              margin: EdgeInsets.all(10),
              width: 80,
              height: 80,
              child: Image.asset("assets/img/icon_money_in.png"),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.yellow),
            )),
        InkWell(
            hoverColor: Colors.transparent,
            onTap: () async {
              try {
                bool result = false;
                result = await Navigator.push(context,
                    MaterialPageRoute(builder: (context) {
                  return FormMoneyScreen(Type.TYPE_PENGELUARAN);
                }));
                if (result) {
                  setState(() {});
                }
              } catch (e) {
                print("Canceled");
              }
            },
            child: Container(
              margin: EdgeInsets.all(10),
              width: 80,
              height: 80,
              child: Image.asset("assets/img/icon_money_out.png"),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.yellow),
            )),
        InkWell(
            hoverColor: Colors.transparent,
            onTap: () async {},
            child: Container(
              margin: EdgeInsets.all(10),
              width: 80,
              height: 80,
              child: Image.asset("assets/img/icon_graphic.png"),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.yellow),
            )),
      ],
    );
  }

  _tabPengeluaran() {
    return FirebaseAuth.instance.currentUser != null
        ? FutureBuilder(
            future: getRecordFromDatabase(Type.TYPE_PENGELUARAN),
            builder:
                ((BuildContext context, AsyncSnapshot<List<Record>> snapshot) {
              //createRecord();
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: SizedBox(
                    height: 50,
                    width: 50,
                    child: CircularProgressIndicator(),
                  ),
                );
              } else if (snapshot.hasError) {
                return Text(snapshot.error.toString());
              } else if (snapshot.hasData) {
                if (!snapshot.data!.isEmpty) {
                  return ListView.builder(
                    itemCount: snapshot.data?.length,
                    itemBuilder: ((context, index) {
                      return Container(
                        margin: EdgeInsets.only(
                            left: 5, right: 5, top: 10, bottom: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  konversiKeIDR(snapshot.data![index].jumlah),
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Spacer(),
                                Text(konversiTimestamp(
                                    snapshot.data![index].tanggal.toString()))
                              ],
                            ),
                            Text(snapshot.data![index].kategori),
                            Text(snapshot.data![index].catatan)
                          ],
                        ),
                      );
                    }),
                  );
                } else {
                  return Center(child: Text("Tidak ada data"));
                }
              } else {
                return Center(child: Text("Tidak ada data"));
              }
            }))
        : Center(child: Text("Gagal mengambil data. silakan login!"));
  }

  _tabPemasukan() {
    return FirebaseAuth.instance.currentUser != null
        ? FutureBuilder(
            future: getRecordFromDatabase(Type.TYPE_PEMASUKAN),
            builder:
                ((BuildContext context, AsyncSnapshot<List<Record>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: SizedBox(
                    height: 50,
                    width: 50,
                    child: CircularProgressIndicator(),
                  ),
                );
              } else if (snapshot.hasError) {
                return Text(snapshot.error.toString());
              } else if (snapshot.hasData) {
                if (!snapshot.data!.isEmpty) {
                  //loading data
                  return ListView.builder(
                    itemCount: snapshot.data?.length,
                    itemBuilder: ((context, index) {
                      return Container(
                        margin: EdgeInsets.only(
                            left: 5, right: 5, top: 10, bottom: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  konversiKeIDR(snapshot.data![index].jumlah),
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Spacer(),
                                Text(konversiTimestamp(
                                    snapshot.data![index].tanggal.toString()))
                              ],
                            ),
                            Text(snapshot.data![index].kategori),
                            Text(snapshot.data![index].catatan)
                          ],
                        ),
                      );
                    }),
                  );
                } else {
                  return Center(child: Text("Tidak ada data"));
                }
              } else {
                return Center(child: Text("Tidak ada data"));
              }
            }))
        : Center(child: Text("Gagal mengambil data. silakan login!"));
  }
}

Future<String> getJumlahTotal() async {
  int total = 0;
  int totalPemasukan = 0;
  int totalPengeluaran = 0;
  List<Record> pemasukanRecords =
      await getRecordFromDatabase(Type.TYPE_PEMASUKAN);
  List<Record> pengeluaranRecords =
      await getRecordFromDatabase(Type.TYPE_PENGELUARAN);

  for (Record record in pemasukanRecords) {
    totalPemasukan = totalPemasukan + int.parse(record.jumlah);
  }

  for (Record record in pengeluaranRecords) {
    totalPengeluaran = totalPengeluaran + int.parse(record.jumlah);
  }

  total = totalPemasukan - totalPengeluaran;

  return konversiKeIDR(total.toString());
}
