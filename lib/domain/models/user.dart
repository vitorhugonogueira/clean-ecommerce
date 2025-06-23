import 'package:clean_ecommerce/domain/models/role.dart';

class User {
  final String id;
  final String name;
  final String email;
  final String address;
  final List<Role> roles;

  const User({
    required this.id,
    required this.name,
    required this.email,
    required this.address,
    this.roles = const [Role.customer],
  });

  bool hasRole(Role role) => roles.contains(role);
}
