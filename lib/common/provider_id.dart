const String EmailAuthProviderID = "password";
const String PhoneAuthProviderID = "phone";
const String GoogleAuthProviderID = "google.com";
const String FacebookAuthProviderID = "facebook.com";
const String TwitterAuthProviderID = "twitter.com";
const String GitHubAuthProviderID = "github.com";
const String AppleAuthProviderID = "apple.com";
const String YahooAuthProviderID = "yahoo.com";
const String MicrosoftAuthProviderID = "hotmail.com";

enum AuthProviderID {
  email,
  phone,
  google,
  facebook,
  twitter,
  github,
  apple,
  yahoo,
  microsoft,
}

extension auth on AuthProviderID {
  String get name {
    switch (this) {
      case AuthProviderID.email:
        return EmailAuthProviderID;
        break;
      case AuthProviderID.phone:
        return PhoneAuthProviderID;
        break;
      case AuthProviderID.google:
        return GoogleAuthProviderID;
        break;
      case AuthProviderID.facebook:
        return FacebookAuthProviderID;
        break;
      case AuthProviderID.twitter:
        return TwitterAuthProviderID;
        break;
      case AuthProviderID.github:
        return GitHubAuthProviderID;
        break;
      case AuthProviderID.apple:
        return AppleAuthProviderID;
        break;
      case AuthProviderID.yahoo:
        return YahooAuthProviderID;
        break;
      case AuthProviderID.microsoft:
        return MicrosoftAuthProviderID;
        break;
      default:
        return '';
    }
  }
}
