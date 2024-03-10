class AppUser {
  const AppUser({
    required this.email,
    required this.uid,
  });

  final String email;
  final String uid;

  @override
  bool operator ==(covariant AppUser other) {
    if (identical(this, other)) return true;

    return other.email == email && other.uid == uid;
  }

  @override
  int get hashCode => email.hashCode ^ uid.hashCode;

  @override
  String toString() => 'AppUser(email: $email, uid: $uid)';
}
