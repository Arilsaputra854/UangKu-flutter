import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:uangku_pencatat_keuangan/model/kategori.dart';
import 'package:uangku_pencatat_keuangan/model/record.dart';
import 'package:uangku_pencatat_keuangan/page/chart_page.dart';
import 'package:uangku_pencatat_keuangan/page/login.dart';
import 'package:uangku_pencatat_keuangan/page/setting.dart';
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

  FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      new FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    _tabcontroller = TabController(length: 2, vsync: this);

    UangkuNotification.showTextNotification(
        title: "Halo ${FirebaseAuth.instance.currentUser?.email ?? ""}",
        body: "Jangan lupa isi catatan kamu ya!!",
        fln: _flutterLocalNotificationsPlugin);
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
            child: ListView(
      children: [
        Container(
          child: Stack(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.width * 0.6,
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
                            fontSize: MediaQuery.of(context).size.width * 0.05),
                      ),
                      FutureBuilder(
                          future: getJumlahTotal(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return Text(
                                snapshot.data ?? "0",
                                style: TextStyle(
                                  color: const Color.fromARGB(255, 25, 13, 13),
                                  fontFamily: "Inter",
                                  fontSize:
                                      MediaQuery.of(context).size.width * 0.1,
                                ),
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
                        onPressed: () async {
                          try {
                            bool delete = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SettingPage()));
                            if (delete) {
                              setState(() {});

                              Fluttertoast.showToast(msg: "Catatan dihapus!");
                            }
                          } catch (e) {
                            print(e);
                            setState(() {
                              Fluttertoast.showToast(msg: "Terjadi Kesalahan.");
                            });
                          }
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
                dividerColor: Colors.transparent,
                overlayColor: MaterialStateProperty.all(Colors.transparent),
                indicatorColor: Colors.transparent,
                indicatorPadding: EdgeInsets.only(left: 10, right: 10),
                indicatorSize: TabBarIndicatorSize.tab,
                indicator: BoxDecoration(
                    color: Colors.yellow,
                    borderRadius: BorderRadius.circular(20)),
                unselectedLabelColor: Colors.grey,
                controller: _tabcontroller,
                tabs: [
                  Text(
                    "Pemasukan",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: MediaQuery.of(context).size.width * 0.03),
                  ),
                  Text(
                    "Pengeluaran",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: MediaQuery.of(context).size.width * 0.03),
                  )
                ])),
        Container(
            height: MediaQuery.of(context).size.height * 0.43,
            width: MediaQuery.of(context).size.width,
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
            onTap: () async {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ChartPage()));
            },
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
                      return InkWell(
                          onLongPress: () {
                            _deleteRecord(
                                Type.TYPE_PEMASUKAN, snapshot.data![index]);
                          },
                          onTap: () async {
                            if (snapshot.data != null &&
                                snapshot.data?[index] != null) {
                              try {
                                bool result = false;
                                result = await Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return FormMoneyScreen(Type.TYPE_PEMASUKAN,
                                      snapshot.data?[index]);
                                }));
                                if (result) {
                                  setState(() {});
                                }
                              } catch (e) {
                                print("Canceled");
                              }
                            } else {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return FormMoneyScreen(Type.TYPE_PEMASUKAN);
                              }));
                            }
                          },
                          child: Card(
                            child: Container(
                              padding: EdgeInsets.all(10),
                              margin: EdgeInsets.only(
                                  left: 5, right: 5, top: 10, bottom: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        konversiKeIDR(
                                            snapshot.data![index].jumlah),
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.03),
                                      ),
                                      Spacer(),
                                      Text(
                                        konversiTimestamp(snapshot
                                            .data![index].tanggal
                                            .toString()),
                                        style: TextStyle(
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.03),
                                      )
                                    ],
                                  ),
                                  Text(
                                    snapshot.data![index].kategori,
                                    style: TextStyle(
                                        fontSize:
                                            MediaQuery.of(context).size.width *
                                                0.03),
                                  ),
                                  Text(
                                    snapshot.data![index].catatan,
                                    style: TextStyle(
                                        fontSize:
                                            MediaQuery.of(context).size.width *
                                                0.03),
                                  )
                                ],
                              ),
                            ),
                          ));
                    }),
                  );
                } else {
                  return Center(
                      child: Text(
                    "Tidak ada data",
                    style: TextStyle(
                        fontSize: 15, fontFamily: "Inter", color: Colors.black),
                  ));
                }
              } else {
                return Center(
                    child: Text(
                  "Tidak ada data",
                  style: TextStyle(
                      fontSize: 15, fontFamily: "Inter", color: Colors.black),
                ));
              }
            }))
        : Center(
            child: Text(
            "Gagal mengambil data. silakan login!",
            style: TextStyle(
                fontSize: 15, fontFamily: "Inter", color: Colors.black),
          ));
  }

  _tabPengeluaran() {
    return FirebaseAuth.instance.currentUser != null
        ? FutureBuilder(
            future: getRecordFromDatabase(Type.TYPE_PENGELUARAN),
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
                      return InkWell(
                          onLongPress: () {
                            _deleteRecord(
                                Type.TYPE_PENGELUARAN, snapshot.data![index]);
                          },
                          onTap: () async {
                            if (snapshot.data != null &&
                                snapshot.data?[index] != null) {
                              try {
                                bool result = false;
                                result = await Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return FormMoneyScreen(Type.TYPE_PENGELUARAN,
                                      snapshot.data?[index]);
                                }));
                                if (result) {
                                  setState(() {});
                                }
                              } catch (e) {
                                print("Canceled");
                              }
                            } else {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return FormMoneyScreen(Type.TYPE_PENGELUARAN);
                              }));
                            }
                          },
                          child: Card(
                              child: Container(
                            padding: EdgeInsets.all(10),
                            margin: EdgeInsets.symmetric(
                                horizontal: 5, vertical: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      konversiKeIDR(
                                          snapshot.data![index].jumlah),
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.03),
                                    ),
                                    Spacer(),
                                    Text(
                                      konversiTimestamp(snapshot
                                          .data![index].tanggal
                                          .toString()),
                                      style: TextStyle(
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.03),
                                    )
                                  ],
                                ),
                                Text(
                                  snapshot.data![index].kategori,
                                  style: TextStyle(
                                      fontSize:
                                          MediaQuery.of(context).size.width *
                                              0.03),
                                ),
                                Text(
                                  snapshot.data![index].catatan,
                                  style: TextStyle(
                                      fontSize:
                                          MediaQuery.of(context).size.width *
                                              0.03),
                                )
                              ],
                            ),
                          )));
                    }),
                  );
                } else {
                  return Center(
                      child: Text(
                    "Tidak ada data",
                    style: TextStyle(
                        fontSize: 15, fontFamily: "Inter", color: Colors.black),
                  ));
                }
              } else {
                return Center(
                    child: Text(
                  "Tidak ada data",
                  style: TextStyle(
                      fontSize: 15, fontFamily: "Inter", color: Colors.black),
                ));
              }
            }))
        : Center(
            child: Text(
            "Gagal mengambil data. silakan login!",
            style: TextStyle(
                fontSize: 15, fontFamily: "Inter", color: Colors.black),
          ));
  }

  _deleteRecord(int type, Record data) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            actionsAlignment: MainAxisAlignment.spaceBetween,
            content: Text(
              "Hapus Catatan?",
              style: TextStyle(
                  fontSize: 15, fontFamily: "Inter", color: Colors.black),
            ),
            actions: [
              ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  onPressed: () {
                    Navigator.pop(
                      context,
                    );
                  },
                  child: Text(
                    "Batal",
                    style: TextStyle(
                        fontSize: 15, fontFamily: "Inter", color: Colors.white),
                  )),
              ElevatedButton(
                  onPressed: () async {
                    deleteRecordFromDatabase(
                        type == Type.TYPE_PEMASUKAN
                            ? Type.TYPE_PEMASUKAN
                            : Type.TYPE_PENGELUARAN,
                        data.getId);
                    Navigator.pop(context);
                    setState(() {});
                  },
                  style:
                      ElevatedButton.styleFrom(backgroundColor: Colors.yellow),
                  child: Text(
                    "Hapus",
                    style: TextStyle(
                        fontSize: 15, fontFamily: "Inter", color: Colors.black),
                  )),
            ],
          );
        });
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
