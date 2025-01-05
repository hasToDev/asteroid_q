import 'package:amplify_flutter/amplify_flutter.dart';

class AuthService {
  Future<bool> signOut() async {
    try {
      SignOutResult _ = await Amplify.Auth.signOut();
      return true;
    } on AuthException catch (e) {
      safePrint('Sign out failed: ${e.message}');
      return false;
    } catch (e, s) {
      safePrint('AuthService signOut $e\n$s');
      return false;
    }
  }

  Future<String> getUserName() async {
    try {
      List<AuthUserAttribute> attributes = await Amplify.Auth.fetchUserAttributes();
      AuthUserAttribute nicknameAttribute =
          attributes.firstWhere((attribute) => attribute.userAttributeKey.key == 'nickname');
      AuthUserAttribute emailAttribute =
          attributes.firstWhere((attribute) => attribute.userAttributeKey.key == 'email');

      if (nicknameAttribute.value.isNotEmpty) return nicknameAttribute.value;
      if (emailAttribute.value.isNotEmpty) return _removeDomain(emailAttribute.value);
      return 'Guest';
    } on AuthException catch (e) {
      safePrint('Get user name failed: ${e.message}');
      return 'Guest';
    } catch (e, s) {
      safePrint('AuthService getUserName $e\n$s');
      return 'Guest';
    }
  }

  String _removeDomain(String email) {
    if (!email.contains('@')) return 'Guest';
    return email.substring(0, email.indexOf('@'));
  }
}
