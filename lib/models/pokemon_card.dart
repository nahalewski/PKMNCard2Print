class PokemonCard {
  final String id;
  final String name;
  final String supertype;
  final List<String>? subtypes;
  final String? hp;
  final List<String>? types;
  final String? number;
  final String? artist;
  final String? rarity;
  final SetInfo? set;
  final CardImages? images;
  final String? flavorText;

  PokemonCard({
    required this.id,
    required this.name,
    required this.supertype,
    this.subtypes,
    this.hp,
    this.types,
    this.number,
    this.artist,
    this.rarity,
    this.set,
    this.images,
    this.flavorText,
  });

  factory PokemonCard.fromJson(Map<String, dynamic> json) {
    return PokemonCard(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      supertype: json['supertype'] ?? '',
      subtypes: json['subtypes'] != null ? List<String>.from(json['subtypes']) : null,
      hp: json['hp'],
      types: json['types'] != null ? List<String>.from(json['types']) : null,
      number: json['number'],
      artist: json['artist'],
      rarity: json['rarity'],
      set: json['set'] != null ? SetInfo.fromJson(json['set']) : null,
      images: json['images'] != null ? CardImages.fromJson(json['images']) : null,
      flavorText: json['flavorText'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'supertype': supertype,
      'subtypes': subtypes,
      'hp': hp,
      'types': types,
      'number': number,
      'artist': artist,
      'rarity': rarity,
      'set': set?.toJson(),
      'images': images?.toJson(),
      'flavorText': flavorText,
    };
  }
}

class SetInfo {
  final String id;
  final String name;
  final String series;
  final int? printedTotal;
  final int? total;
  final String? ptcgoCode;
  final String? releaseDate;
  final SetImages? images;

  SetInfo({
    required this.id,
    required this.name,
    required this.series,
    this.printedTotal,
    this.total,
    this.ptcgoCode,
    this.releaseDate,
    this.images,
  });

  factory SetInfo.fromJson(Map<String, dynamic> json) {
    return SetInfo(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      series: json['series'] ?? '',
      printedTotal: json['printedTotal'],
      total: json['total'],
      ptcgoCode: json['ptcgoCode'],
      releaseDate: json['releaseDate'],
      images: json['images'] != null ? SetImages.fromJson(json['images']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'series': series,
      'printedTotal': printedTotal,
      'total': total,
      'ptcgoCode': ptcgoCode,
      'releaseDate': releaseDate,
      'images': images?.toJson(),
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

class CardImages {
  final String? small;
  final String? large;
  final String? symbol;
  final String? logo;

  CardImages({
    this.small,
    this.large,
    this.symbol,
    this.logo,
  });

  factory CardImages.fromJson(Map<String, dynamic> json) {
    return CardImages(
      small: json['small'],
      large: json['large'],
      symbol: json['symbol'],
      logo: json['logo'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'small': small,
      'large': large,
      'symbol': symbol,
      'logo': logo,
    };
  }
}

