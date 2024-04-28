class Record {
  final String catatan;
  final int jumlah;
  final String kategori;
  final String tanggal;

  Record({
    required this.catatan,
    required this.jumlah,
    required this.kategori,
    required this.tanggal,
  });

  int get getJumlah => jumlah;

  String get getKategori => kategori;

  String get getCatatan => catatan;

  String get getTanggal => tanggal;

  factory Record.fromJson(Map<String, dynamic> json) => Record(
        catatan: json['catatan'] as String,
        jumlah: json['jumlah'] as int,
        kategori: json['kategori'] as String,
        tanggal: json['tanggal'] as String,
      );
}
