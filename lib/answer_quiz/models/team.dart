import 'package:equatable/equatable.dart';

class Team extends Equatable {
  const Team({required this.id, required this.name});

  final int id;
  final String name;

  Team copyWith({
    int? id,
    String? name,
  }) {
    return Team(
      id: id ?? this.id,
      name: name ?? this.name,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
    };
  }

  factory Team.fromMap(Map<String, dynamic> map) {
    return Team(
      id: map['id']?.toInt() ?? 0,
      name: map['name'] ?? '',
    );
  }

  @override
  List<Object?> get props => [id, name];
}
