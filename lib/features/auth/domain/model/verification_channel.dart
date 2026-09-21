enum VerificationChannel {
  email,
  phone;

  String get apiValue => name.toUpperCase();

  VerificationChannel get alternative =>
      this == VerificationChannel.email
      ? VerificationChannel.phone
      : VerificationChannel.email;
}
