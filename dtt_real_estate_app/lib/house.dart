class House {
  final int id;
  final String image;
  final int price;
  final int bedrooms;
  final int bathrooms;
  final int size;
  final String description;
  final String zip;
  final String city;
  final double latitude;
  final double longitude;
  final DateTime createdDate;

  House({
    required this.id,
    required this.image,
    required this.price,
    required this.bedrooms,
    required this.bathrooms,
    required this.size,
    required this.description,
    required this.zip,
    required this.city,
    required this.latitude,
    required this.longitude,
    required this.createdDate,
  });

  // (Factory) constructor to convert a Map (from JSON) into an instance of House
  factory House.fromJson(Map<String, dynamic> json) {
    return House(
        id: json['id'],
        image: json['image'],
        price: json['price'],
        bedrooms: json['bedrooms'] ,
        bathrooms: json['bathrooms'] ,
        size: json['size'],
        description: json['description'] ,
        zip: json['zip'],
        city: json['city'],
        latitude: json['latitude'].toDouble(),
        longitude: json['longitude'].toDouble(),
        createdDate: DateTime.parse(json['createdDate'])
    );
  }
}
