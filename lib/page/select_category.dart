import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:uangku_pencatat_keuangan/model/kategori.dart';
import 'package:uangku_pencatat_keuangan/util/util.dart';

class SelectCategory extends StatefulWidget {
  int type;
  SelectCategory(this.type);

  @override
  State<SelectCategory> createState() => _SelectCategoryState();
}

class _SelectCategoryState extends State<SelectCategory> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: widget.type == Type.TYPE_PEMASUKAN
            ? Text("Pemasukan",
                style: TextStyle(
                    fontSize: 20, fontFamily: "Inter", color: Colors.black))
            : Text("Pengeluaran",
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
      body: Container(
        constraints: BoxConstraints(maxWidth: 500),
        margin: EdgeInsets.only(left: 20, right: 20),
        child: FutureBuilder(
          future: getKategoriFromDatabase(widget.type),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: Container(
                    width: 200,
                    height: 200,
                    child: CircularProgressIndicator()),
              );
            } else if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: ((context, index) {
                  return InkWell(
                      onTap: () =>
                          Navigator.pop(context, snapshot.data![index].nama),
                      child: Text(
                        snapshot.data![index].nama,
                        style: TextStyle(
                            fontSize: 20,
                            fontFamily: "Inter",
                            color: Colors.black),
                      ));
                }),
              );
            } else {
              return Center(
                child: Text("Tidak ada kategori"),
              );
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(onPressed: () async {
        String kategori = await _showDialogKategori(context);
        print(kategori);
        if (kategori != "") {
          setState(() {});
          Fluttertoast.showToast(msg: "Berhasil menambahkan ${kategori}.");
        } else {
          Fluttertoast.showToast(msg: "Terjadi kesalahan.");
        }
      }),
    );
  }
}

_showDialogKategori(BuildContext context) async {
  TextEditingController kategoryController = new TextEditingController();
  String _newKategori = "";

  return showDialog<String>(
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
              controller: kategoryController,
            ),
            SizedBox(
              height: 20,
            ),
            TextButton(
              style: TextButton.styleFrom(
                  backgroundColor: Colors.yellow,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15)))),
              onPressed: () async {
                if (_newKategori.trim().isEmpty) {
                  Fluttertoast.showToast(
                      msg: "Kategori baru tidak boleh kosong!");
                } else {
                  Kategori kategori = Kategori(nama: _newKategori);
                  await saveKategoriToDatabase(kategori);
                  Navigator.pop(context, _newKategori);
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
