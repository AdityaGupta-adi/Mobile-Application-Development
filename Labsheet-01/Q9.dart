import 'dart:io';

void main() {
  stdout.write("Enter a number: ");
  double number = double.parse(stdin.readLineSync()!);

  if (number > 0) {
    print("The number is Positive.");
  } else if (number < 0) {
    print("The number is Negative.");
  } else {
    print("The number is Zero.");
  }
}
