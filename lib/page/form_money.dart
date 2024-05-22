import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:table_calendar/table_calendar.dart';
import 'package:uangku_pencatat_keuangan/model/kategori.dart';
import 'package:uangku_pencatat_keuangan/model/record.dart';
import 'package:uangku_pencatat_keuangan/page/select_category.dart';
import 'package:uangku_pencatat_keuangan/util/util.dart';
import 'package:uuid/uuid.dart';

class FormMoneyScreen extends StatefulWidget {
  FormMoneyScreen(this.type, [this._record]);
  int type;
  Record? _record;

  @override
  State<FormMoneyScreen> createState() => _FormMoneyScreenState();
}

class _FormMoneyScreenState extends State<FormMoneyScreen> {
  late TextEditingController jumlahController, catatanController;
  String kalendarInput = "";
  String kategoriController = "Pilih";
  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    jumlahController = new TextEditingController();
    catatanController = new TextEditingController();

    if (widget._record != null) {
      kategoriController = widget._record!.kategori;
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget._record != null) {
      jumlahController.text = widget._record!.jumlah;
      catatanController.text = widget._record!.catatan;
      kalendarInput = widget._record!.tanggal;
    }
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
              constraints: BoxConstraints(maxWidth: 500),
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
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Kategori",
                              style:
                                  TextStyle(fontSize: 20, fontFamily: "Inter")),
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
                              openCategoryPage();
                            },
                            child: Container(
                                padding: EdgeInsets.all(5),
                                child: Text(
                                  kategoriController,
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
    if (widget._record != null) {
      if (jumlahController.text.isNotEmpty) {
        Record record = widget._record!;

        Record newRecord = Record(
            id: record.getId,
            catatan: record.getCatatan,
            jumlah: jumlahController.text.isEmpty
                ? record.getJumlah
                : jumlahController.text,
            kategori: kategoriController.isEmpty
                ? record.getKategori
                : kategoriController,
            tanggal: record.getTanggal);

        bool result = await updateRecord(type, newRecord);
        if (result) {
          Fluttertoast.showToast(msg: "Catatan berhasil diupdate");
          Navigator.pop(context, result);
        } else {
          Fluttertoast.showToast(msg: "Gagal mengupdate data");
        }
      } else {
        Fluttertoast.showToast(msg: "Jumlah tidak boleh kosong!");
      }
    } else {
      if (kategoriController != "Pilih" && jumlahController.text.isNotEmpty) {
        Record record = Record(
            catatan: catatanController.text.isNotEmpty
                ? catatanController.text
                : "-",
            jumlah: jumlahController.text,
            kategori: kategoriController,
            tanggal: kalendarInput.isNotEmpty
                ? kalendarInput
                : DateTime.now().millisecondsSinceEpoch.toString());
        bool result = await saveRecordToDatabase(type, record);
        if (result) {
          Fluttertoast.showToast(msg: "Catatan berhasil upload");
          Navigator.pop(context, result);
        } else {
          Fluttertoast.showToast(msg: "Gagal menyimpan data");
        }
      } else if (jumlahController.text.isEmpty) {
        Fluttertoast.showToast(msg: "Jumlah tidak boleh kosong!");
      } else if (kategoriController == "Pilih") {
        Fluttertoast.showToast(msg: "Pilih kategori terlebidahulu!");
      }
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

  openCategoryPage() async {
    String choosedKategori = await Navigator.push(context,
        MaterialPageRoute(builder: ((context) => SelectCategory(widget.type))));

    if (kategoriController != null || kategoriController != "") {
      kategoriController = choosedKategori;
      setState(() {});
    } else {
      kategoriController = "Pilih";
    }
  }
}
