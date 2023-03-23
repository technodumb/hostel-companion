Future<void> abc() async {
  await Future.delayed(const Duration(seconds: 1), () => print('abc'));
  // print('abc');
  // print('abc');
  // print(() => 'abc');
  return;
}

Future<void> main() async {
  print('a');
  await abc();

  print('b');
}
