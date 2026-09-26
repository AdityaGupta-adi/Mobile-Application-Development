import 'dart:io';

void main() {
  stdout.write("Enter first value: ");
  int a = int.parse(stdin.readLineSync()!);

  stdout.write("Enter second value: ");
  int b = int.parse(stdin.readLineSync()!);

  print("Before swapping: a = $a, b = $b");

  int temp = a;
  a = b;
  b = temp;

  print("After swapping: a = $a, b = $b");
}
