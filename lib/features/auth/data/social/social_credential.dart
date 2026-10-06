class SocialCredential {
  final String token;
  final String? expectedNonce;

  const SocialCredential(this.token, {this.expectedNonce});
}
