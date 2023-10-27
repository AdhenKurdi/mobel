import 'package:equatable/equatable.dart';

class Task extends Equatable {
  final int id;
  final String name;
  final String description;
  final int quantity;
  final String latitude;
  final String longitude;
  String photo;
  final String date;
  final String address;

  Task(
      {
      required this.id,
      required this.name,
      required this.description,
      required this.latitude,
      required this.longitude,
      required this.photo,
      required this.date,
      required this.quantity,
      required this.address});

  @override
  List<Object?> get props =>
      [id, name, description, quantity, latitude, longitude, photo, date,address];
}
