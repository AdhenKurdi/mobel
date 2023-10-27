import 'package:equatable/equatable.dart';
import 'package:task_mobel/app/domain/entity/task.dart';

class TaskModel extends Equatable {
  final int id;
  final String name;
  final String description;
  final int quantity;
  final String latitude;
  final String longitude;
  final String photo;
  final String date;
  final String address;

  const TaskModel(
      {required this.id,
      required this.name,
      required this.description,
      required this.latitude,
      required this.longitude,
      required this.photo,
      required this.date,
      required this.quantity,
      required this.address});

  Task toEntity() => Task(
      id: id,
      name: name,
      description: description,
      quantity: quantity,
      latitude: latitude,
      longitude: longitude,
      photo: photo,
      date: date,
      address: address);

  factory TaskModel.fromEntity(Task task) => TaskModel(
      id: task.id,
      name: task.name,
      description: task.description,
      quantity: task.quantity,
      latitude: task.latitude,
      longitude: task.longitude,
      photo: task.photo,
      date: task.date,
      address: task.address);

  factory TaskModel.fromMap(Map<String, dynamic> map) => TaskModel(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      quantity: map['quantity'],
      latitude: map['latitude'],
      longitude: map['longitude'],
      photo: map['photo'],
      date: map['date'],
      address: map['address']);

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'latitude': latitude,
        'longitude': longitude,
        'photo': photo,
        'date': date,
        'quantity': quantity,
        'address': address,
      };

    Map<String, dynamic> toJsonRemote() => {
        'name': name,
        'description': description,
        'latitude': latitude,
        'longitude': longitude,
        'photo': photo,
        'date': date,
        'quantity': quantity,
        'address': address,
      };  

  @override
  List<Object?> get props =>
      [id, name, description, quantity, latitude, longitude, photo, date,address];
}
