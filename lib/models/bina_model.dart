class BinaModel {
  final int id;
  final String ad;
  final String bolge;
  final String? not;
  final String? kubel;
  final String? kontrolTarihi;
  final String? durum;
  final String? adres;

  BinaModel({
    required this.id,
    required this.ad,
    required this.bolge,
    this.not,
    this.kubel,
    this.kontrolTarihi,
    this.durum,
    this.adres,
  });

  factory BinaModel.fromJson(Map<String, dynamic> json) {
    return BinaModel(
      id: json["id"],
      ad: json["bina_adi"],
      bolge: json["bina_bolgesi"] ?? "-",
      not: json["bina_notu"],
      kubel: json["kulubel"],
      kontrolTarihi: json["sonraki_kontrol_tarihi"],
      durum: json["durum"],
      adres: json["bina_adresi"],
    );
  }
}
