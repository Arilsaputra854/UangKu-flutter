import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:uangku_pencatat_keuangan/model/kategori.dart';
import 'package:uangku_pencatat_keuangan/util/util.dart';

class CategoryPage extends StatefulWidget {
  int type;
  CategoryPage(this.type);

  @override
  State<CategoryPage> createState() => _SelectCategoryState();
}

class _SelectCategoryState extends State<CategoryPage> {
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
              return Dialog(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation(Colors.black),
                      ),
                      SizedBox(width: 20.0),
                      Text("Memproses"),
                    ],
                  ),
                ),
              );
              ;
            } else if (snapshot.hasData && snapshot.data?.length != 0) {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: ((context, index) {
                  return InkWell(
                      onLongPress: () {
                        return _deleteKategori(snapshot.data![index]);
                      },
                      onTap: () =>
                          Navigator.pop(context, snapshot.data![index].nama),
                      child: Card(
                          child: Container(
                        padding: EdgeInsets.all(10),
                        child: Text(
                          snapshot.data![index].nama,
                          style: TextStyle(
                              fontSize: 20,
                              fontFamily: "Inter",
                              color: Colors.black),
                        ),
                      )));
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
      floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.yellow,
          child: Icon(
            Icons.add,
            color: Colors.black,
          ),
          onPressed: () async {
            String kategori = await _showDialogKategori(context);
            if (kategori != "") {
              setState(() {});
              Fluttertoast.showToast(msg: "Berhasil menambahkan ${kategori}.");
            } else {
              Fluttertoast.showToast(msg: "Terjadi kesalahan.");
            }
          }),
    );
  }

  _deleteKategori(Kategori kategori) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            actionsAlignment: MainAxisAlignment.spaceBetween,
            content: Container(
              margin: EdgeInsets.only(top: 10),
              child: Text("Hapus kategori ${kategori.nama}?",
                  style: TextStyle(
                      fontSize: 20, fontFamily: "Inter", color: Colors.black)),
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
                    bool sucess = await removeKategoriFromDatabase(
                        widget.type, Kategori(nama: kategori.nama));

                    if (sucess) {
                      Fluttertoast.showToast(
                          msg: "Berhasil menghapus kategori ${kategori.nama}");
                    } else {
                      Fluttertoast.showToast(msg: "Terjadi kesalahan");
                    }
                    Navigator.pop(context);
                    setState(() {});
                  },
                  style:
                      ElevatedButton.styleFrom(backgroundColor: Colors.yellow),
                  child: Text(
                    "Hapus",
                    style: TextStyle(
                        fontSize: 15, fontFamily: "Inter", color: Colors.black),
                  ))
            ],
          );
        });
  }

  _showDialogKategori(BuildContext context) async {
    TextEditingController kategoryController = new TextEditingController();
    String _newKategori = "";

    return showDialog<String>(
        context: context,
        builder: (context) {
          return AlertDialog(
            actionsAlignment: MainAxisAlignment.spaceBetween,
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
                    if (_newKategori.trim().isEmpty) {
                      Fluttertoast.showToast(
                          msg: "Kategori baru tidak boleh kosong!");
                    } else {
                      Kategori kategori = Kategori(nama: _newKategori);
                      await saveKategoriToDatabase(widget.type, kategori);
                      Navigator.pop(context, _newKategori);
                    }
                  },
                  style:
                      ElevatedButton.styleFrom(backgroundColor: Colors.yellow),
                  child: Text(
                    "Simpan",
                    style: TextStyle(
                        fontSize: 15, fontFamily: "Inter", color: Colors.black),
                  ))
            ],
            content: Container(
                child: Column(mainAxisSize: MainAxisSize.min, children: [
              Text("Kategori",
                  style: TextStyle(
                      fontSize: 20, fontFamily: "Inter", color: Colors.black)),
              TextField(
                style: TextStyle(
                    fontSize: 20, fontFamily: "Inter", color: Colors.black),
                onChanged: (value) {
                  _newKategori = value.toString();
                },
                controller: kategoryController,
              ),
            ])),
          );
        });
  }
}
