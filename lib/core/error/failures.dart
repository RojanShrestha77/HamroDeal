class Failure {
  final String message;

  Failure([this.message = 'An unexpected error occurred']);

  @override
  String toString() => message;
}

//failure for the local database
class LocalDatabaseFailure extends Failure {
  LocalDatabaseFailure({String message = 'Local database error'})
    : super(message);
}
