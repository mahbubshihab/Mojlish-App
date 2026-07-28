import 'package:dartz/dartz.dart';
import 'package:mojlish_app/core/error/failures.dart';
import '../../domain/entities/executive_rule.dart';
import '../../domain/repositories/executive_rule_repository.dart';
import '../datasources/executive_rule_datasource.dart';

class ExecutiveRuleRepositoryImpl implements ExecutiveRuleRepository {
  final ExecutiveRuleDataSource dataSource;

  ExecutiveRuleRepositoryImpl({required this.dataSource});

  @override
  Future<Either<Failure, List<ExecutiveRule>>> getExecutiveRules() async {
    try {
      final remoteRules = await dataSource.getExecutiveRules();
      return Right(remoteRules);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
