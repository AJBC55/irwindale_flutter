import 'package:shared_preferences/shared_preferences.dart';

Future<bool> hasAcceptedTerms() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getBool('accepted_terms') ?? false;
}

Future<void> setAcceptedTerms() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setBool('accepted_terms', true);
}

