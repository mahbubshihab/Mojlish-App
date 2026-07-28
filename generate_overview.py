import os

base_dir = "lib/features/youth_majlis/overview"

dirs = [
    "data/datasources",
    "data/models",
    "data/repositories",
    "domain/entities",
    "domain/repositories",
    "presentation/bloc",
    "presentation/pages",
]

for d in dirs:
    os.makedirs(os.path.join(base_dir, d), exist_ok=True)

# 1. domain/entities/overview_entity.dart
with open(f"{base_dir}/domain/entities/overview_entity.dart", "w") as f:
    f.write("""import 'package:equatable/equatable.dart';

class OverviewEntity extends Equatable {
  final String title;
  final String content;

  const OverviewEntity({
    required this.title,
    required this.content,
  });

  @override
  List<Object?> get props => [title, content];
}
""")

# 2. domain/repositories/overview_repository.dart
with open(f"{base_dir}/domain/repositories/overview_repository.dart", "w") as f:
    f.write("""import 'package:dartz/dartz.dart';
import '../../../../../core/error/failures.dart';
import '../entities/overview_entity.dart';

abstract class OverviewRepository {
  Future<Either<Failure, OverviewEntity>> getOverview();
}
""")

# 3. data/models/overview_model.dart
with open(f"{base_dir}/data/models/overview_model.dart", "w") as f:
    f.write("""import '../../domain/entities/overview_entity.dart';

class OverviewModel extends OverviewEntity {
  const OverviewModel({
    required String title,
    required String content,
  }) : super(title: title, content: content);

  factory OverviewModel.fromJson(Map<String, dynamic> json) {
    return OverviewModel(
      title: json['title'] ?? '',
      content: json['content'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'content': content,
    };
  }
}
""")

# 4. data/datasources/overview_remote_datasource.dart
with open(f"{base_dir}/data/datasources/overview_remote_datasource.dart", "w") as f:
    f.write("""import '../models/overview_model.dart';

abstract class OverviewRemoteDataSource {
  Future<OverviewModel> getOverview();
}

class OverviewRemoteDataSourceImpl implements OverviewRemoteDataSource {
  @override
  Future<OverviewModel> getOverview() async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));
    return const OverviewModel(
      title: 'ইসলামী যুব মজলিস পরিচিতি',
      content: 'আল্লাহ তাআলার সন্তুষ্টি অর্জনের লক্ষ্যে যুবকদের আত্মিক মানোন্নয়ন, মেধার বিকাশ ও দক্ষতা বৃদ্ধি এবং রাজনৈতিক সচেতনতা সৃষ্টির মাধ্যমে যুবসমাজকে ঐক্যবদ্ধ করে কল্যাণমুখী সমাজব্যবস্থা গড়ে তোলা।',
    );
  }
}
""")

# 5. data/repositories/overview_repository_impl.dart
with open(f"{base_dir}/data/repositories/overview_repository_impl.dart", "w") as f:
    f.write("""import 'package:dartz/dartz.dart';
import '../../../../../core/error/failures.dart';
import '../../domain/entities/overview_entity.dart';
import '../../domain/repositories/overview_repository.dart';
import '../datasources/overview_remote_datasource.dart';

class OverviewRepositoryImpl implements OverviewRepository {
  final OverviewRemoteDataSource remoteDataSource;

  OverviewRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, OverviewEntity>> getOverview() async {
    try {
      final remoteOverview = await remoteDataSource.getOverview();
      return Right(remoteOverview);
    } catch (e) {
      return Left(ServerFailure());
    }
  }
}
""")

# 6. presentation/bloc/overview_event.dart
with open(f"{base_dir}/presentation/bloc/overview_event.dart", "w") as f:
    f.write("""import 'package:equatable/equatable.dart';

abstract class OverviewEvent extends Equatable {
  const OverviewEvent();

  @override
  List<Object> get props => [];
}

class LoadOverviewEvent extends OverviewEvent {}
""")

# 7. presentation/bloc/overview_state.dart
with open(f"{base_dir}/presentation/bloc/overview_state.dart", "w") as f:
    f.write("""import 'package:equatable/equatable.dart';
import '../../domain/entities/overview_entity.dart';

abstract class OverviewState extends Equatable {
  const OverviewState();

  @override
  List<Object> get props => [];
}

class OverviewInitial extends OverviewState {}

class OverviewLoading extends OverviewState {}

class OverviewLoaded extends OverviewState {
  final OverviewEntity overview;

  const OverviewLoaded({required this.overview});

  @override
  List<Object> get props => [overview];
}

class OverviewError extends OverviewState {
  final String message;

  const OverviewError({required this.message});

  @override
  List<Object> get props => [message];
}
""")

# 8. presentation/bloc/overview_bloc.dart
with open(f"{base_dir}/presentation/bloc/overview_bloc.dart", "w") as f:
    f.write("""import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/overview_repository.dart';
import 'overview_event.dart';
import 'overview_state.dart';

class OverviewBloc extends Bloc<OverviewEvent, OverviewState> {
  final OverviewRepository repository;

  OverviewBloc({required this.repository}) : super(OverviewInitial()) {
    on<LoadOverviewEvent>((event, emit) async {
      emit(OverviewLoading());
      final result = await repository.getOverview();
      result.fold(
        (failure) => emit(OverviewError(message: 'Failed to load data')),
        (overview) => emit(OverviewLoaded(overview: overview)),
      );
    });
  }
}
""")

# 9. presentation/pages/overview_screen.dart
with open(f"{base_dir}/presentation/pages/overview_screen.dart", "w") as f:
    f.write("""import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/overview_bloc.dart';
import '../bloc/overview_event.dart';
import '../bloc/overview_state.dart';

class OverviewScreen extends StatefulWidget {
  const OverviewScreen({Key? key}) : super(key: key);

  @override
  _OverviewScreenState createState() => _OverviewScreenState();
}

class _OverviewScreenState extends State<OverviewScreen> {
  @override
  void initState() {
    super.initState();
    context.read<OverviewBloc>().add(LoadOverviewEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('পরিচিতি'), // Overview
      ),
      body: BlocBuilder<OverviewBloc, OverviewState>(
        builder: (context, state) {
          if (state is OverviewLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is OverviewLoaded) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    state.overview.title,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    state.overview.content,
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 24),
                  _buildSection('ভূমিকা', 'আল্লাহ রাব্বুল আলামীনের শুকরিয়া...'),
                  const SizedBox(height: 16),
                  _buildSection('প্রেক্ষাপট', 'মনে রাখতে হবে যুবসমাজই একটি জাতির...'),
                  const SizedBox(height: 16),
                  _buildSection('লক্ষ্য ও উদ্দেশ্য', 'আল্লাহ তাআলার সন্তুষ্টি অর্জনের লক্ষ্যে...'),
                  const SizedBox(height: 16),
                  _buildSection('নীতিমালা', '১. যুবকদের শান্তি, ন্যায়বিচার, স্বাধীনতা...'),
                  const SizedBox(height: 16),
                  _buildSection('কর্মসূচি', 'এক. যুব সমাজের ঐক্য...'),
                  const SizedBox(height: 16),
                  _buildSection('সাংগঠনিক স্তর', 'প্রাথমিক সদস্য ও সদস্য...'),
                  const SizedBox(height: 16),
                  _buildSection('সাংগঠনিক কাঠামো', 'কেন্দ্রীয় সংগঠন, জেলা/মহানগরী শাখা...'),
                ],
              ),
            );
          } else if (state is OverviewError) {
            return Center(child: Text(state.message));
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.blue,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          content,
          style: const TextStyle(fontSize: 16),
        ),
      ],
    );
  }
}
""")

print("Overview sub-feature created successfully.")
