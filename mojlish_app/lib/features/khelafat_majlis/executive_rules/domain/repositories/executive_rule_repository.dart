import 'package:dartz/dartz.dart';
import 'package:mojlish_app/core/error/failures.dart';
import '../entities/executive_rule.dart';

abstract class ExecutiveRuleRepository {
  Future<Either<Failure, List<ExecutiveRule>>> getExecutiveRules();
}
