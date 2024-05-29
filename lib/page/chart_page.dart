import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:uangku_pencatat_keuangan/model/record.dart';
import 'package:uangku_pencatat_keuangan/page/form_money.dart';
import 'package:uangku_pencatat_keuangan/util/util.dart';

class ChartPage extends StatefulWidget {
  const ChartPage({super.key});

  @override
  State<ChartPage> createState() => _ChartPageState();
}

class _ChartPageState extends State<ChartPage> {
  Map<String, double> dataMapPemasukan = {};
  Map<String, double> dataMapPengeluaran = {};

  @override
  void initState() {
    chart(Type.TYPE_PEMASUKAN);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: Text("Grafik Keuangan",
              style: TextStyle(
                  fontSize: 20, fontFamily: "Inter", color: Colors.black)),
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
        body: CarouselSlider(
          items: [
            Column(
              children: [
                Container(
                    width: MediaQuery.of(context).size.width * 0.7,
                    child: FutureBuilder(
                        future: chart(Type.TYPE_PEMASUKAN),
                        builder: ((context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Dialog(
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    CircularProgressIndicator(
                                      valueColor:
                                          AlwaysStoppedAnimation(Colors.black),
                                    ),
                                    SizedBox(width: 20.0),
                                    Text("Memproses"),
                                  ],
                                ),
                              ),
                            );
                          } else {
                            if (snapshot.data != null) {
                              return PieChart(
                                chartValuesOptions: ChartValuesOptions(
                                    showChartValuesInPercentage: true),
                                dataMap: dataMapPemasukan,
                                colorList: [
                                  Colors.greenAccent,
                                  Colors.yellow,
                                  Color.fromARGB(255, 59, 186, 255),
                                ],
                                legendOptions: LegendOptions(
                                    showLegends: false,
                                    legendPosition: LegendPosition.bottom),
                              );
                            } else {
                              return Center(
                                child: Text(
                                  "Tidak ada catatan",
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontFamily: "Inter",
                                      color: Colors.black),
                                ),
                              );
                            }
                          }
                        }))),
                Text(
                  "Catatan",
                  style: TextStyle(
                      fontSize: 15, fontFamily: "Inter", color: Colors.black),
                ),
                _tabPemasukan()
              ],
            ),
            Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Container(
                    width: MediaQuery.of(context).size.width * 0.7,
                    child: FutureBuilder(
                        future: chart(Type.TYPE_PENGELUARAN),
                        builder: ((context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Dialog(
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    CircularProgressIndicator(
                                      valueColor:
                                          AlwaysStoppedAnimation(Colors.black),
                                    ),
                                    SizedBox(width: 20.0),
                                    Text("Memproses"),
                                  ],
                                ),
                              ),
                            );
                          } else {
                            if (snapshot.data != null) {
                              return PieChart(
                                chartValuesOptions: ChartValuesOptions(
                                    showChartValuesInPercentage: true),
                                dataMap: dataMapPengeluaran,
                                colorList: [
                                  Colors.greenAccent,
                                  Colors.yellow,
                                  Color.fromARGB(255, 59, 186, 255),
                                ],
                                legendOptions: LegendOptions(
                                    showLegends: false,
                                    legendPosition: LegendPosition.bottom),
                              );
                            } else {
                              return Center(
                                child: Text(
                                  "Tidak ada catatan",
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontFamily: "Inter",
                                      color: Colors.black),
                                ),
                              );
                            }
                          }
                        }))),
                Text(
                  "Catatan",
                  style: TextStyle(
                      fontSize: 15, fontFamily: "Inter", color: Colors.black),
                ),
                _tabPengeluaran()
              ],
            )
          ],
          options: CarouselOptions(
              onPageChanged: (index, reason) {
                setState(() {});
              },
              autoPlay: false,
              viewportFraction: 1.0,
              enlargeCenterPage: false,
              height: MediaQuery.of(context).size.height),
        ));
  }

  _tabPengeluaran() {
    return FirebaseAuth.instance.currentUser != null
        ? Expanded(
            child: FutureBuilder(
                future: getRecordFromDatabase(Type.TYPE_PENGELUARAN),
                builder: ((BuildContext context,
                    AsyncSnapshot<List<Record>> snapshot) {
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
                          return Card(
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
                          ));
                        }),
                      );
                    } else {
                      return Center(
                          child: Text(
                        "Tidak ada data",
                        style: TextStyle(
                            fontSize: 15,
                            fontFamily: "Inter",
                            color: Colors.black),
                      ));
                    }
                  } else {
                    return Center(
                        child: Text(
                      "Tidak ada data",
                      style: TextStyle(
                          fontSize: 15,
                          fontFamily: "Inter",
                          color: Colors.black),
                    ));
                  }
                })))
        : Center(
            child: Text(
            "Gagal mengambil data. silakan login!",
            style: TextStyle(
                fontSize: 15, fontFamily: "Inter", color: Colors.black),
          ));
  }

  _tabPemasukan() {
    return FirebaseAuth.instance.currentUser != null
        ? Expanded(
            child: FutureBuilder(
                future: getRecordFromDatabase(Type.TYPE_PEMASUKAN),
                builder: ((BuildContext context,
                    AsyncSnapshot<List<Record>> snapshot) {
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
                          return Card(
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
                          );
                        }),
                      );
                    } else {
                      return Center(
                          child: Text(
                        "Tidak ada data",
                        style: TextStyle(
                            fontSize: 15,
                            fontFamily: "Inter",
                            color: Colors.black),
                      ));
                    }
                  } else {
                    return Center(
                        child: Text(
                      "Tidak ada data",
                      style: TextStyle(
                          fontSize: 15,
                          fontFamily: "Inter",
                          color: Colors.black),
                    ));
                  }
                })))
        : Center(
            child: Text(
            "Gagal mengambil data. silakan login!",
            style: TextStyle(
                fontSize: 15, fontFamily: "Inter", color: Colors.black),
          ));
  }

  chart(int type) async {
    List<Record> records = await getRecordFromDatabase(type);

    if (type == Type.TYPE_PEMASUKAN) {
      for (var element in records) {
        if (!dataMapPemasukan.containsKey(element.getKategori)) {
          dataMapPemasukan[element.getKategori] = 0;
        }
        dataMapPemasukan[element.getKategori] =
            dataMapPemasukan[element.getKategori]! +
                double.parse(element.getJumlah);
      }
    } else {
      for (var element in records) {
        if (!dataMapPengeluaran.containsKey(element.getKategori)) {
          dataMapPengeluaran[element.getKategori] = 0;
        }
        dataMapPengeluaran[element.getKategori] =
            dataMapPengeluaran[element.getKategori]! +
                double.parse(element.getJumlah);
      }
    }
    return true;
  }
}
