class PokemonSet {
  final String id;
  final String name;
  final String series;
  final int printedTotal;
  final int total;
  final String? releaseDate;
  final String? legalities;
  final SetImages? images;
  final String ptcgoCode;

  PokemonSet({
    required this.id,
    required this.name,
    required this.series,
    required this.printedTotal,
    required this.total,
    this.releaseDate,
    this.legalities,
    this.images,
    required this.ptcgoCode,
  });

  factory PokemonSet.fromJson(Map<String, dynamic> json) {
    return PokemonSet(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      series: json['series'] ?? '',
      printedTotal: json['printedTotal'] ?? 0,
      total: json['total'] ?? 0,
      releaseDate: json['releaseDate'],
      legalities: json['legalities']?.toString(),
      images: json['images'] != null ? SetImages.fromJson(json['images']) : null,
      ptcgoCode: json['ptcgoCode'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'series': series,
      'printedTotal': printedTotal,
      'total': total,
      'releaseDate': releaseDate,
      'legalities': legalities,
      'images': images?.toJson(),
      'ptcgoCode': ptcgoCode,
    };
  }
}

class SetImages {
  final String? symbol;
  final String? logo;

  SetImages({
    this.symbol,
    this.logo,
  });

  factory SetImages.fromJson(Map<String, dynamic> json) {
    return SetImages(
      symbol: json['symbol'],
      logo: json['logo'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'symbol': symbol,
      'logo': logo,
    };
  }
}

