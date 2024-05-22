import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uangku_pencatat_keuangan/util/util.dart';

class Kategori {
  final String nama;

  Kategori({required this.nama});

  getKategori() {
    return this.nama;
  }

  factory Kategori.fromJson(Map<String, dynamic> json) =>
      Kategori(nama: json['nama']);
}

Future<Kategori> saveKategoriToDatabase(int type, Kategori kategori) async {
  try {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference ref = firestore
        .collection("financial_records")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("kategori");

    List<String> newData = [];
    newData.add(kategori.nama);
    if (type == Type.TYPE_PEMASUKAN) {
      await ref
          .doc("pemasukan")
          .update({"nama": FieldValue.arrayUnion(newData)}).then((value) {
        print("Berhasil menambahkan kategori");
      });
    } else {
      await ref
          .doc("pengeluaran")
          .update({"nama": FieldValue.arrayUnion(newData)}).then((value) {
        print("Berhasil menambahkan kategori");
      });
    }
    return Kategori(nama: kategori.nama);
  } catch (e) {
    print("ERROR: $e");
    return Kategori(nama: "");
  }
}

Future<bool> removeKategoriFromDatabase(int type, Kategori kategori) async {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference ref = firestore
      .collection("financial_records")
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection("kategori");
  try {
    type == Type.TYPE_PEMASUKAN
        ? await ref.doc("pemasukan").update({
            "nama": FieldValue.arrayRemove([kategori.getKategori()])
          }).then((value) {
            print("Berhasil menghapus kategori ${kategori.getKategori()} ");
          })
        : await ref.doc("pengeluaran").update({
            "nama": FieldValue.arrayRemove([kategori.getKategori()])
          }).then((value) {
            print("Berhasil menghapus kategori ${kategori.getKategori()} ");
          });
    return true;
  } catch (e) {
    return false;
  }
}
//TODO delete kategori

Future<List<Kategori>> getKategoriFromDatabase(int type) async {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference ref = firestore
      .collection("financial_records")
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection("kategori");

  DocumentSnapshot snapshot = type == Type.TYPE_PEMASUKAN
      ? await ref.doc("pemasukan").get()
      : await ref.doc("pengeluaran").get();

  if (snapshot.exists) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;

    List<dynamic> dataKategori = data["nama"] as List<dynamic>;

    List<Kategori> kategories =
        dataKategori.map((value) => Kategori(nama: value)).toList();

    return kategories;
  } else {
    return [];
  }
}
