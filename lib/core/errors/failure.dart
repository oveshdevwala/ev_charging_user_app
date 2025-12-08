/// File: lib/core/errors/failure.dart
/// Purpose: Failure classes for error handling using Either pattern
/// Belongs To: shared
/// Customization Guide:
///    - Add new failure types as needed
///    - Use Either<Failure, T> pattern in repositories
library;

import 'package:equatable/equatable.dart';

/// Base failure class for all errors.
abstract class Failure extends Equatable {
  const Failure({this.message});

  final String? message;

  @override
  List<Object?> get props => [message];
}

/// Network-related failures.
class NetworkFailure extends Failure {
  const NetworkFailure({super.message});

  @override
  String toString() => 'NetworkFailure: ${message ?? 'Network error occurred'}';
}

/// Cache-related failures.
class CacheFailure extends Failure {
  const CacheFailure({super.message});

  @override
  String toString() => 'CacheFailure: ${message ?? 'Cache error occurred'}';
}

/// Permission-related failures.
class PermissionFailure extends Failure {
  const PermissionFailure({super.message});

  @override
  String toString() => 'PermissionFailure: ${message ?? 'Permission denied'}';
}

/// Server-related failures.
class ServerFailure extends Failure {
  const ServerFailure({super.message, this.statusCode});

  final int? statusCode;

  @override
  List<Object?> get props => [message, statusCode];

  @override
  String toString() => 'ServerFailure: ${message ?? 'Server error occurred'}';
}

/// Validation failures.
class ValidationFailure extends Failure {
  const ValidationFailure({super.message});

  @override
  String toString() => 'ValidationFailure: ${message ?? 'Validation error'}';
}

/// Unknown failures.
class UnknownFailure extends Failure {
  const UnknownFailure({super.message});

  @override
  String toString() => 'UnknownFailure: ${message ?? 'Unknown error occurred'}';
}

/// Either type for functional error handling.
/// Left = Failure, Right = Success
sealed class Either<L, R> {
  const Either();

  /// Create a Left (failure) value.
  const factory Either.left(L value) = Left<L, R>;

  /// Create a Right (success) value.
  const factory Either.right(R value) = Right<L, R>;

  /// Check if this is a Left value.
  bool get isLeft => this is Left<L, R>;

  /// Check if this is a Right value.
  bool get isRight => this is Right<L, R>;

  /// Get the Left value, or null if Right.
  L? get left => isLeft ? (this as Left<L, R>).value : null;

  /// Get the Right value, or null if Left.
  R? get right => isRight ? (this as Right<L, R>).value : null;

  /// Fold: apply function based on Left or Right.
  T fold<T>(T Function(L left) onLeft, T Function(R right) onRight) {
    if (isLeft) {
      return onLeft((this as Left<L, R>).value);
    } else {
      return onRight((this as Right<L, R>).value);
    }
  }

  /// Map the Right value.
  Either<L, T> map<T>(T Function(R right) mapper) {
    if (isLeft) {
      return Either.left((this as Left<L, R>).value);
    } else {
      return Either.right(mapper((this as Right<L, R>).value));
    }
  }
}

/// Left (failure) value.
class Left<L, R> extends Either<L, R> {
  const Left(this.value);

  final L value;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Left<L, R> && runtimeType == other.runtimeType && value == other.value;

  @override
  int get hashCode => value.hashCode;
}

/// Right (success) value.
class Right<L, R> extends Either<L, R> {
  const Right(this.value);

  final R value;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Right<L, R> && runtimeType == other.runtimeType && value == other.value;

  @override
  int get hashCode => value.hashCode;
}

