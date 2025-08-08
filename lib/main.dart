import 'package:twitter_application/application.dart';
import 'package:twitter_application/bootstrap.dart';

void main() async {
  await bootstrap(builder: () => const Application());
}
