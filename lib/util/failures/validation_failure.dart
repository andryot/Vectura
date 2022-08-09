import 'failure.dart';

abstract class ValidationFailure extends Failure {
  const ValidationFailure();
}

class WrongEmailOrPassword extends ValidationFailure {
  const WrongEmailOrPassword();
}

class EmailValidationFailure extends ValidationFailure {
  const EmailValidationFailure();
}

class PasswordValidationFailure extends ValidationFailure {
  const PasswordValidationFailure();
}

class PasswordRepeatValidationFailure extends ValidationFailure {
  const PasswordRepeatValidationFailure();
}

class NameValidationFailure extends ValidationFailure {
  const NameValidationFailure();
}

class PhoneValidationFailure extends ValidationFailure {
  const PhoneValidationFailure();
}

class NoEmailOrPassword extends ValidationFailure {
  const NoEmailOrPassword();
}

class UsernameValidationFailure extends ValidationFailure {
  const UsernameValidationFailure();
}

class MissingRequiredField extends ValidationFailure {
  const MissingRequiredField();
}

class EmailAlreadyTaken extends ValidationFailure {
  const EmailAlreadyTaken();
}

class IntegerParsingFailure extends ValidationFailure {
  const IntegerParsingFailure();
}

class AddressValidationFailure extends ValidationFailure {
  const AddressValidationFailure();
}

class DateValidationFailure extends ValidationFailure {
  const DateValidationFailure();
}

class PriceValidationFailure extends ValidationFailure {
  const PriceValidationFailure();
}

class BrandValidationFailure extends ValidationFailure {
  const BrandValidationFailure();
}

class ModelValidationFailure extends ValidationFailure {
  const ModelValidationFailure();
}

class ColorValidationFailure extends ValidationFailure {
  const ColorValidationFailure();
}

class LicensePlateValidationFailure extends ValidationFailure {
  const LicensePlateValidationFailure();
}
