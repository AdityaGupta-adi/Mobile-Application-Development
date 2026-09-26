import 'dart:io';

void main() {
  stdout.write("Enter first number: ");
  double num1 = double.parse(stdin.readLineSync()!);

  stdout.write("Enter second number: ");
  double num2 = double.parse(stdin.readLineSync()!);

  print("Sum: ${num1 + num2}");
  print("Difference: ${num1 - num2}");
  print("Product: ${num1 * num2}");

  if (num2 != 0) {
    print("Quotient: ${num1 / num2}");
  } else {
    print("Quotient: Cannot divide by zero");
  }
}
