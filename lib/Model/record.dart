import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uangku_pencatat_keuangan/util/util.dart';

class Record {
  final String catatan;
  final String jumlah;
  final String kategori;
  final String tanggal;

  Record({
    required this.catatan,
    required this.jumlah,
    required this.kategori,
    required this.tanggal,
  });

  String get getJumlah => jumlah;

  String get getKategori => kategori;

  String get getCatatan => catatan;

  String get getTanggal => tanggal;

  factory Record.fromJson(Map<String, dynamic> json) => Record(
      kategori: json['kategori'],
      catatan: json['catatan'],
      jumlah: (json['jumlah']),
      tanggal: (json['tanggal']));
}

Future<bool> saveRecordToDatabase(int type, Record record) async {
  switch (type) {
    case Type.TYPE_PEMASUKAN:
      try {
        FirebaseFirestore firestore = FirebaseFirestore.instance;
        CollectionReference ref = firestore!
            .collection('financial_records')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .collection("pemasukan");

        Map<String, dynamic> data = {
          "catatan": record.getCatatan,
          "jumlah": record.getJumlah,
          "kategori": record.getKategori,
          "tanggal": record.getTanggal
        };

        await ref.add(data).then((value) {
          print("Data berhasil diupload! ");
        });
        return true;
      } catch (e) {
        print("SAVE RECORD : $e");

        return false;
      }
    case Type.TYPE_PENGELUARAN:
      try {
        FirebaseFirestore firestore = FirebaseFirestore.instance;
        CollectionReference ref = firestore!
            .collection('financial_records')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .collection("pengeluaran");

        Map<String, dynamic> data = {
          "catatan": record.getCatatan,
          "jumlah": record.getJumlah,
          "kategori": record.getKategori,
          "tanggal": record.getTanggal
        };

        await ref.add(data).then((value) {
          print("Data berhasil diupload! ");
        });
        return true;
      } catch (e) {
        print("SAVE RECORD : $e");
        return false;
      }
    default:
      return false;
  }
}

Future<List<Record>> getRecordFromDatabase(int type) async {
  CollectionReference? ref;
  switch (type) {
    case 1:
      ref = FirebaseFirestore.instance
          .collection('financial_records')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection("pemasukan");
      break;

    case 2:
      ref = FirebaseFirestore.instance
          .collection('financial_records')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection("pengeluaran");
      break;
    default:
  }

  try {
    if (ref != null) {
      QuerySnapshot querySnapshot = await ref.get();

      if (querySnapshot.docs.isNotEmpty) {
        List<Record> records = [];
        querySnapshot.docs.forEach((documentSnapshot) {
          Map<String, dynamic> data =
              documentSnapshot.data() as Map<String, dynamic>;
          records.add(Record.fromJson(data));
        });
        return records;
      } else {
        print("Tidak ada data.");
        return [];
      }
    } else {
      print("Ref tidak ditetapkan.");
      return [];
    }
  } catch (e) {
    print("Error: $e");
    return [];
  }
}
