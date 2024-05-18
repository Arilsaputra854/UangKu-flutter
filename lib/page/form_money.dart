import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:uangku_pencatat_keuangan/Model/record.dart';
import 'package:uangku_pencatat_keuangan/util/util.dart';

class FormMoneyScreen extends StatefulWidget {
  FormMoneyScreen(this.type);
  int type;

  @override
  State<FormMoneyScreen> createState() => _FormMoneyScreenState();
}

class _FormMoneyScreenState extends State<FormMoneyScreen> {
  late TextEditingController jumlahController, catatanController;
  String kalendarInput = "";
  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    jumlahController = new TextEditingController();
    catatanController = new TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
            appBar: AppBar(
              elevation: 0,
              title: widget.type == Type.TYPE_PEMASUKAN
                  ? Text("Pemasukan",
                      style: TextStyle(
                          fontSize: 20,
                          fontFamily: "Inter",
                          color: Colors.black))
                  : Text("Pengeluaran",
                      style: TextStyle(
                          fontSize: 20,
                          fontFamily: "Inter",
                          color: Colors.black)),
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
            body: Container(
              margin: EdgeInsets.only(left: 20, right: 20, top: 30),
              child: SingleChildScrollView(
                child: Column(children: [
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Jumlah",
                            style:
                                TextStyle(fontSize: 20, fontFamily: "Inter")),
                        SizedBox(
                          height: 5,
                        ),
                        Container(
                          child: TextFormField(
                              key: _formKey,
                              keyboardType: TextInputType.number,
                              style:
                                  TextStyle(fontSize: 25, fontFamily: "Inter"),
                              controller: jumlahController,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.yellow,
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.yellow, width: 1),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.yellow, width: 1),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                              )),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Column(children: [
                      Text("Kategori",
                          style: TextStyle(fontSize: 20, fontFamily: "Inter")),
                      SizedBox(
                        height: 5,
                      ),
                      TextButton(
                        style: TextButton.styleFrom(
                            backgroundColor: Colors.yellow,
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15)))),
                        onPressed: () {
                          _showDialogKategori(context);
                        },
                        child: Container(
                            padding: EdgeInsets.all(5),
                            child: Text(
                              "Pilih",
                              style: TextStyle(
                                  fontSize: 20,
                                  fontFamily: "Inter",
                                  color: Colors.black),
                            )),
                      ),
                    ]),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      Container(
                        alignment: Alignment.centerLeft,
                        child: Column(children: [
                          Text("Tanggal",
                              style:
                                  TextStyle(fontSize: 20, fontFamily: "Inter")),
                          SizedBox(
                            height: 5,
                          ),
                          TextButton(
                            child: Icon(
                              Icons.calendar_month,
                              size: 45,
                              color: Colors.black,
                            ),
                            style: TextButton.styleFrom(
                                backgroundColor: Colors.yellow,
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(15)))),
                            onPressed: () async {
                              kalendarInput = await openCalendar();
                              setState(() {});
                            },
                          ),
                        ]),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        konversiTimestamp(kalendarInput.isNotEmpty
                            ? kalendarInput
                            : DateTime.now().millisecondsSinceEpoch.toString()),
                        style: TextStyle(fontSize: 20, fontFamily: "Inter"),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Catatan",
                            style:
                                TextStyle(fontSize: 20, fontFamily: "Inter")),
                        SizedBox(
                          height: 5,
                        ),
                        Container(
                          child: TextFormField(
                              style:
                                  TextStyle(fontSize: 20, fontFamily: "Inter"),
                              controller: catatanController,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.yellow,
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.yellow, width: 1),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.yellow, width: 1),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                              )),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.yellow,
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(15)))),
                    onPressed: () {
                      if ((widget.type == Type.TYPE_PEMASUKAN)) {
                        simpanData(Type.TYPE_PEMASUKAN);
                      } else if ((widget.type == Type.TYPE_PENGELUARAN)) {
                        simpanData(Type.TYPE_PENGELUARAN);
                      } else {
                        Fluttertoast.showToast(msg: "Terjadi Kesalahan");
                      }
                    },
                    child: Container(
                        width: 200,
                        padding: EdgeInsets.all(10),
                        child: Center(
                          child: Text(
                            "Simpan",
                            style: TextStyle(
                                fontSize: 25,
                                fontFamily: "Inter",
                                color: Colors.black),
                          ),
                        )),
                  )
                ]),
              ),
            )));
  }

  simpanData(int type) async {
    if (jumlahController.text.isNotEmpty) {
      Record record = Record(
          catatan:
              catatanController.text.isNotEmpty ? catatanController.text : "-",
          jumlah: jumlahController.text,
          kategori: "kategori test",
          tanggal: kalendarInput.isNotEmpty
              ? kalendarInput
              : DateTime.now().millisecondsSinceEpoch.toString());
      bool result = await saveRecordToDatabase(type, record);
      if (result) {
        Fluttertoast.showToast(msg: "Catatan berhasil ditambahkan");
        Navigator.pop(context, result);
      } else {
        Fluttertoast.showToast(msg: "Gagal menyimpan data");
      }
    } else {
      Fluttertoast.showToast(msg: "Jumlah tidak boleh kosong!");
    }
  }

  Future<String> openCalendar() async {
    DateTime _selectedDay = DateTime.now();
    DateTime _focusedDay = DateTime.now();

    return await showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                  actions: [
                    ElevatedButton(
                        onPressed: () {
                          DateTime now = DateTime.now();
                          int hour = now.hour;
                          int minute = now.minute;
                          int second = now.second;

                          DateTime formatedDate = DateTime(
                              _selectedDay.year,
                              _selectedDay.month,
                              _selectedDay.day,
                              hour,
                              minute,
                              second);

                          String timestamp =
                              formatedDate.millisecondsSinceEpoch.toString();
                          Navigator.pop(context, timestamp);
                          ;
                        },
                        child: Text("Oke"))
                  ],
                  content: Container(
                      width: MediaQuery.of(context).size.width * 0.8,
                      height: MediaQuery.of(context).size.height * 0.8,
                      child: TableCalendar(
                          onPageChanged: (focusedDay) {
                            setState(() {
                              _focusedDay = focusedDay;
                            });
                          },
                          selectedDayPredicate: (day) {
                            return isSameDay(day, _selectedDay);
                          },
                          onDaySelected: (selectedDay, focusedDay) {
                            setState(() {
                              _selectedDay = selectedDay;
                              _focusedDay = focusedDay;
                            });
                          },
                          calendarFormat: CalendarFormat.month,
                          availableCalendarFormats: {
                            CalendarFormat.month: "month"
                          },
                          focusedDay: _focusedDay,
                          firstDay: DateTime.utc(2010),
                          lastDay: DateTime.utc(2099))));
            },
          );
        });
  }
}

_showDialogKategori(BuildContext context) async {
  TextEditingController _addKategori = new TextEditingController();
  String _newKategori = "";

  await showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Container(
              child: Column(mainAxisSize: MainAxisSize.min, children: [
            Text("Kategori",
                style: TextStyle(
                    fontSize: 20, fontFamily: "Inter", color: Colors.black)),
            TextField(
              onChanged: (value) {
                _newKategori = value.toString();
              },
              controller: _addKategori,
            ),
            SizedBox(
              height: 20,
            ),
            TextButton(
              style: TextButton.styleFrom(
                  backgroundColor: Colors.yellow,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15)))),
              onPressed: () {
                if (_newKategori.trim().isEmpty) {
                  Fluttertoast.showToast(
                      msg: "Kategori baru tidak boleh kosong!");
                } else {
                  Fluttertoast.showToast(
                      msg: "Kategori ${_newKategori} ditambahkan.");
                  Navigator.pop(context);
                }
              },
              child: Container(
                  padding: EdgeInsets.all(5),
                  child: Text(
                    "Simpan",
                    style: TextStyle(
                        fontSize: 20, fontFamily: "Inter", color: Colors.black),
                  )),
            ),
          ])),
        );
      });
}
