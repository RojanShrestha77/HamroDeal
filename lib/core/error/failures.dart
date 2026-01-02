class Failure {
  final String message;

  Failure([this.message = 'An unexpected error occurred']);

  @override
  String toString() => message;
}

// Specific failure for local database (Hive) errors
class LocalDatabaseFailure extends Failure {
  LocalDatabaseFailure({String message = 'Local database error'})
    : super(message);
}
