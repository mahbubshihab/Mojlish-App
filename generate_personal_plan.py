import os

def create_file(path, content):
    os.makedirs(os.path.dirname(path), exist_ok=True)
    with open(path, 'w') as f:
        f.write(content)

base_path = "/Users/mahbubshihab/Development/Mojlish app/lib/features/student_majlis/personal_plan"

# Entity
entity = """class PersonalPlanEntity {
  final String id;
  final String name;
  final String branch;
  final String responsibility;
  final String month;
  final String year;

  // Study
  final String quranAyatCount;
  final String quranSuraPara;
  final String quranDarasCount;
  final String quranDarasTopic;
  final String quranMemorizeAyat;

  final String hadithCount;
  final String hadithBookTopic;
  final String hadithDarasCount;
  final String hadithDarasTopic;
  final String hadithMemorizeCount;
  final String hadithMemorizeTopic;

  final String islamicLiteraturePages;
  final String islamicLiteratureBookName;
  final String islamicLiteratureBookNotesPage;

  final String textbookClassAvgHours;
  final String textbookClassTime;

  // Worship
  final String jamatNamazWaqt;
  final String selfEvaluationDays;
  final String nafalIbadat;

  // Dawah
  final String friendTargetContactCount;
  final String friendTargetContactName;
  final String primaryMemberIncreaseContactCount;
  final String primaryMemberIncreaseContactName;
  final String bookIntroStickerDistributionCount;
  final String studentReviewDistributionCount;
  final String wellWisherIncreaseContactCount;
  final String wellWisherIncreaseContactName;
  final String cardGiftSmsEmailLetterMagazineCount;
  final String groupDawahCount;
  final String otherDawahMaterialsDistribution;

  // Organizational
  final String workerStandardUpgradeCount;
  final String workerStandardUpgradeName;
  final String meetingAttendanceCount;
  final String orgDawahTimeAvgHours;
  final String baytulmalAmount;
  final String workerContactCount;
  final String workerNames;

  // Misc
  final String dailyOtherNewspaperAvgHours;
  final String physicalExerciseDays;
  final String techLanguageStudyAvgHours;
  final String familySocialWorkAvgHours;
  final String others;

  // For Concerned Persons
  final String memberLevelUpgradeTargetCount;
  final String memberLevelUpgradeTargetName;
  final String associateMemberLevelUpgradeTargetCount;
  final String associateMemberLevelUpgradeTargetName;

  PersonalPlanEntity({
    this.id = '',
    this.name = '',
    this.branch = '',
    this.responsibility = '',
    this.month = '',
    this.year = '',
    this.quranAyatCount = '',
    this.quranSuraPara = '',
    this.quranDarasCount = '',
    this.quranDarasTopic = '',
    this.quranMemorizeAyat = '',
    this.hadithCount = '',
    this.hadithBookTopic = '',
    this.hadithDarasCount = '',
    this.hadithDarasTopic = '',
    this.hadithMemorizeCount = '',
    this.hadithMemorizeTopic = '',
    this.islamicLiteraturePages = '',
    this.islamicLiteratureBookName = '',
    this.islamicLiteratureBookNotesPage = '',
    this.textbookClassAvgHours = '',
    this.textbookClassTime = '',
    this.jamatNamazWaqt = '',
    this.selfEvaluationDays = '',
    this.nafalIbadat = '',
    this.friendTargetContactCount = '',
    this.friendTargetContactName = '',
    this.primaryMemberIncreaseContactCount = '',
    this.primaryMemberIncreaseContactName = '',
    this.bookIntroStickerDistributionCount = '',
    this.studentReviewDistributionCount = '',
    this.wellWisherIncreaseContactCount = '',
    this.wellWisherIncreaseContactName = '',
    this.cardGiftSmsEmailLetterMagazineCount = '',
    this.groupDawahCount = '',
    this.otherDawahMaterialsDistribution = '',
    this.workerStandardUpgradeCount = '',
    this.workerStandardUpgradeName = '',
    this.meetingAttendanceCount = '',
    this.orgDawahTimeAvgHours = '',
    this.baytulmalAmount = '',
    this.workerContactCount = '',
    this.workerNames = '',
    this.dailyOtherNewspaperAvgHours = '',
    this.physicalExerciseDays = '',
    this.techLanguageStudyAvgHours = '',
    this.familySocialWorkAvgHours = '',
    this.others = '',
    this.memberLevelUpgradeTargetCount = '',
    this.memberLevelUpgradeTargetName = '',
    this.associateMemberLevelUpgradeTargetCount = '',
    this.associateMemberLevelUpgradeTargetName = '',
  });
}
"""

create_file(f"{base_path}/domain/entities/personal_plan_entity.dart", entity)

model = """import '../entities/personal_plan_entity.dart';

class PersonalPlanModel extends PersonalPlanEntity {
  PersonalPlanModel({
    super.id,
    super.name,
    super.branch,
    super.responsibility,
    super.month,
    super.year,
    super.quranAyatCount,
    super.quranSuraPara,
    super.quranDarasCount,
    super.quranDarasTopic,
    super.quranMemorizeAyat,
    super.hadithCount,
    super.hadithBookTopic,
    super.hadithDarasCount,
    super.hadithDarasTopic,
    super.hadithMemorizeCount,
    super.hadithMemorizeTopic,
    super.islamicLiteraturePages,
    super.islamicLiteratureBookName,
    super.islamicLiteratureBookNotesPage,
    super.textbookClassAvgHours,
    super.textbookClassTime,
    super.jamatNamazWaqt,
    super.selfEvaluationDays,
    super.nafalIbadat,
    super.friendTargetContactCount,
    super.friendTargetContactName,
    super.primaryMemberIncreaseContactCount,
    super.primaryMemberIncreaseContactName,
    super.bookIntroStickerDistributionCount,
    super.studentReviewDistributionCount,
    super.wellWisherIncreaseContactCount,
    super.wellWisherIncreaseContactName,
    super.cardGiftSmsEmailLetterMagazineCount,
    super.groupDawahCount,
    super.otherDawahMaterialsDistribution,
    super.workerStandardUpgradeCount,
    super.workerStandardUpgradeName,
    super.meetingAttendanceCount,
    super.orgDawahTimeAvgHours,
    super.baytulmalAmount,
    super.workerContactCount,
    super.workerNames,
    super.dailyOtherNewspaperAvgHours,
    super.physicalExerciseDays,
    super.techLanguageStudyAvgHours,
    super.familySocialWorkAvgHours,
    super.others,
    super.memberLevelUpgradeTargetCount,
    super.memberLevelUpgradeTargetName,
    super.associateMemberLevelUpgradeTargetCount,
    super.associateMemberLevelUpgradeTargetName,
  });

  factory PersonalPlanModel.fromJson(Map<String, dynamic> json) {
    return PersonalPlanModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      branch: json['branch'] ?? '',
      responsibility: json['responsibility'] ?? '',
      month: json['month'] ?? '',
      year: json['year'] ?? '',
      quranAyatCount: json['quranAyatCount'] ?? '',
      quranSuraPara: json['quranSuraPara'] ?? '',
      quranDarasCount: json['quranDarasCount'] ?? '',
      quranDarasTopic: json['quranDarasTopic'] ?? '',
      quranMemorizeAyat: json['quranMemorizeAyat'] ?? '',
      hadithCount: json['hadithCount'] ?? '',
      hadithBookTopic: json['hadithBookTopic'] ?? '',
      hadithDarasCount: json['hadithDarasCount'] ?? '',
      hadithDarasTopic: json['hadithDarasTopic'] ?? '',
      hadithMemorizeCount: json['hadithMemorizeCount'] ?? '',
      hadithMemorizeTopic: json['hadithMemorizeTopic'] ?? '',
      islamicLiteraturePages: json['islamicLiteraturePages'] ?? '',
      islamicLiteratureBookName: json['islamicLiteratureBookName'] ?? '',
      islamicLiteratureBookNotesPage: json['islamicLiteratureBookNotesPage'] ?? '',
      textbookClassAvgHours: json['textbookClassAvgHours'] ?? '',
      textbookClassTime: json['textbookClassTime'] ?? '',
      jamatNamazWaqt: json['jamatNamazWaqt'] ?? '',
      selfEvaluationDays: json['selfEvaluationDays'] ?? '',
      nafalIbadat: json['nafalIbadat'] ?? '',
      friendTargetContactCount: json['friendTargetContactCount'] ?? '',
      friendTargetContactName: json['friendTargetContactName'] ?? '',
      primaryMemberIncreaseContactCount: json['primaryMemberIncreaseContactCount'] ?? '',
      primaryMemberIncreaseContactName: json['primaryMemberIncreaseContactName'] ?? '',
      bookIntroStickerDistributionCount: json['bookIntroStickerDistributionCount'] ?? '',
      studentReviewDistributionCount: json['studentReviewDistributionCount'] ?? '',
      wellWisherIncreaseContactCount: json['wellWisherIncreaseContactCount'] ?? '',
      wellWisherIncreaseContactName: json['wellWisherIncreaseContactName'] ?? '',
      cardGiftSmsEmailLetterMagazineCount: json['cardGiftSmsEmailLetterMagazineCount'] ?? '',
      groupDawahCount: json['groupDawahCount'] ?? '',
      otherDawahMaterialsDistribution: json['otherDawahMaterialsDistribution'] ?? '',
      workerStandardUpgradeCount: json['workerStandardUpgradeCount'] ?? '',
      workerStandardUpgradeName: json['workerStandardUpgradeName'] ?? '',
      meetingAttendanceCount: json['meetingAttendanceCount'] ?? '',
      orgDawahTimeAvgHours: json['orgDawahTimeAvgHours'] ?? '',
      baytulmalAmount: json['baytulmalAmount'] ?? '',
      workerContactCount: json['workerContactCount'] ?? '',
      workerNames: json['workerNames'] ?? '',
      dailyOtherNewspaperAvgHours: json['dailyOtherNewspaperAvgHours'] ?? '',
      physicalExerciseDays: json['physicalExerciseDays'] ?? '',
      techLanguageStudyAvgHours: json['techLanguageStudyAvgHours'] ?? '',
      familySocialWorkAvgHours: json['familySocialWorkAvgHours'] ?? '',
      others: json['others'] ?? '',
      memberLevelUpgradeTargetCount: json['memberLevelUpgradeTargetCount'] ?? '',
      memberLevelUpgradeTargetName: json['memberLevelUpgradeTargetName'] ?? '',
      associateMemberLevelUpgradeTargetCount: json['associateMemberLevelUpgradeTargetCount'] ?? '',
      associateMemberLevelUpgradeTargetName: json['associateMemberLevelUpgradeTargetName'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'branch': branch,
      'responsibility': responsibility,
      'month': month,
      'year': year,
      'quranAyatCount': quranAyatCount,
      'quranSuraPara': quranSuraPara,
      'quranDarasCount': quranDarasCount,
      'quranDarasTopic': quranDarasTopic,
      'quranMemorizeAyat': quranMemorizeAyat,
      'hadithCount': hadithCount,
      'hadithBookTopic': hadithBookTopic,
      'hadithDarasCount': hadithDarasCount,
      'hadithDarasTopic': hadithDarasTopic,
      'hadithMemorizeCount': hadithMemorizeCount,
      'hadithMemorizeTopic': hadithMemorizeTopic,
      'islamicLiteraturePages': islamicLiteraturePages,
      'islamicLiteratureBookName': islamicLiteratureBookName,
      'islamicLiteratureBookNotesPage': islamicLiteratureBookNotesPage,
      'textbookClassAvgHours': textbookClassAvgHours,
      'textbookClassTime': textbookClassTime,
      'jamatNamazWaqt': jamatNamazWaqt,
      'selfEvaluationDays': selfEvaluationDays,
      'nafalIbadat': nafalIbadat,
      'friendTargetContactCount': friendTargetContactCount,
      'friendTargetContactName': friendTargetContactName,
      'primaryMemberIncreaseContactCount': primaryMemberIncreaseContactCount,
      'primaryMemberIncreaseContactName': primaryMemberIncreaseContactName,
      'bookIntroStickerDistributionCount': bookIntroStickerDistributionCount,
      'studentReviewDistributionCount': studentReviewDistributionCount,
      'wellWisherIncreaseContactCount': wellWisherIncreaseContactCount,
      'wellWisherIncreaseContactName': wellWisherIncreaseContactName,
      'cardGiftSmsEmailLetterMagazineCount': cardGiftSmsEmailLetterMagazineCount,
      'groupDawahCount': groupDawahCount,
      'otherDawahMaterialsDistribution': otherDawahMaterialsDistribution,
      'workerStandardUpgradeCount': workerStandardUpgradeCount,
      'workerStandardUpgradeName': workerStandardUpgradeName,
      'meetingAttendanceCount': meetingAttendanceCount,
      'orgDawahTimeAvgHours': orgDawahTimeAvgHours,
      'baytulmalAmount': baytulmalAmount,
      'workerContactCount': workerContactCount,
      'workerNames': workerNames,
      'dailyOtherNewspaperAvgHours': dailyOtherNewspaperAvgHours,
      'physicalExerciseDays': physicalExerciseDays,
      'techLanguageStudyAvgHours': techLanguageStudyAvgHours,
      'familySocialWorkAvgHours': familySocialWorkAvgHours,
      'others': others,
      'memberLevelUpgradeTargetCount': memberLevelUpgradeTargetCount,
      'memberLevelUpgradeTargetName': memberLevelUpgradeTargetName,
      'associateMemberLevelUpgradeTargetCount': associateMemberLevelUpgradeTargetCount,
      'associateMemberLevelUpgradeTargetName': associateMemberLevelUpgradeTargetName,
    };
  }
}
"""
create_file(f"{base_path}/data/models/personal_plan_model.dart", model)

repo_abs = """import '../entities/personal_plan_entity.dart';

abstract class PersonalPlanRepository {
  Future<void> submitPersonalPlan(PersonalPlanEntity plan);
  Future<PersonalPlanEntity?> getPersonalPlan(String id);
}
"""
create_file(f"{base_path}/domain/repositories/personal_plan_repository.dart", repo_abs)

repo_impl = """import '../../domain/entities/personal_plan_entity.dart';
import '../../domain/repositories/personal_plan_repository.dart';
import '../datasources/personal_plan_remote_data_source.dart';
import '../models/personal_plan_model.dart';

class PersonalPlanRepositoryImpl implements PersonalPlanRepository {
  final PersonalPlanRemoteDataSource remoteDataSource;

  PersonalPlanRepositoryImpl(this.remoteDataSource);

  @override
  Future<void> submitPersonalPlan(PersonalPlanEntity plan) async {
    final model = PersonalPlanModel(
      id: plan.id,
      name: plan.name,
      branch: plan.branch,
      responsibility: plan.responsibility,
      month: plan.month,
      year: plan.year,
      quranAyatCount: plan.quranAyatCount,
      quranSuraPara: plan.quranSuraPara,
      quranDarasCount: plan.quranDarasCount,
      quranDarasTopic: plan.quranDarasTopic,
      quranMemorizeAyat: plan.quranMemorizeAyat,
      hadithCount: plan.hadithCount,
      hadithBookTopic: plan.hadithBookTopic,
      hadithDarasCount: plan.hadithDarasCount,
      hadithDarasTopic: plan.hadithDarasTopic,
      hadithMemorizeCount: plan.hadithMemorizeCount,
      hadithMemorizeTopic: plan.hadithMemorizeTopic,
      islamicLiteraturePages: plan.islamicLiteraturePages,
      islamicLiteratureBookName: plan.islamicLiteratureBookName,
      islamicLiteratureBookNotesPage: plan.islamicLiteratureBookNotesPage,
      textbookClassAvgHours: plan.textbookClassAvgHours,
      textbookClassTime: plan.textbookClassTime,
      jamatNamazWaqt: plan.jamatNamazWaqt,
      selfEvaluationDays: plan.selfEvaluationDays,
      nafalIbadat: plan.nafalIbadat,
      friendTargetContactCount: plan.friendTargetContactCount,
      friendTargetContactName: plan.friendTargetContactName,
      primaryMemberIncreaseContactCount: plan.primaryMemberIncreaseContactCount,
      primaryMemberIncreaseContactName: plan.primaryMemberIncreaseContactName,
      bookIntroStickerDistributionCount: plan.bookIntroStickerDistributionCount,
      studentReviewDistributionCount: plan.studentReviewDistributionCount,
      wellWisherIncreaseContactCount: plan.wellWisherIncreaseContactCount,
      wellWisherIncreaseContactName: plan.wellWisherIncreaseContactName,
      cardGiftSmsEmailLetterMagazineCount: plan.cardGiftSmsEmailLetterMagazineCount,
      groupDawahCount: plan.groupDawahCount,
      otherDawahMaterialsDistribution: plan.otherDawahMaterialsDistribution,
      workerStandardUpgradeCount: plan.workerStandardUpgradeCount,
      workerStandardUpgradeName: plan.workerStandardUpgradeName,
      meetingAttendanceCount: plan.meetingAttendanceCount,
      orgDawahTimeAvgHours: plan.orgDawahTimeAvgHours,
      baytulmalAmount: plan.baytulmalAmount,
      workerContactCount: plan.workerContactCount,
      workerNames: plan.workerNames,
      dailyOtherNewspaperAvgHours: plan.dailyOtherNewspaperAvgHours,
      physicalExerciseDays: plan.physicalExerciseDays,
      techLanguageStudyAvgHours: plan.techLanguageStudyAvgHours,
      familySocialWorkAvgHours: plan.familySocialWorkAvgHours,
      others: plan.others,
      memberLevelUpgradeTargetCount: plan.memberLevelUpgradeTargetCount,
      memberLevelUpgradeTargetName: plan.memberLevelUpgradeTargetName,
      associateMemberLevelUpgradeTargetCount: plan.associateMemberLevelUpgradeTargetCount,
      associateMemberLevelUpgradeTargetName: plan.associateMemberLevelUpgradeTargetName,
    );
    return await remoteDataSource.submitPersonalPlan(model);
  }

  @override
  Future<PersonalPlanEntity?> getPersonalPlan(String id) async {
    return await remoteDataSource.getPersonalPlan(id);
  }
}
"""
create_file(f"{base_path}/data/repositories/personal_plan_repository_impl.dart", repo_impl)

datasource = """import '../models/personal_plan_model.dart';

abstract class PersonalPlanRemoteDataSource {
  Future<void> submitPersonalPlan(PersonalPlanModel plan);
  Future<PersonalPlanModel?> getPersonalPlan(String id);
}

class PersonalPlanRemoteDataSourceImpl implements PersonalPlanRemoteDataSource {
  @override
  Future<void> submitPersonalPlan(PersonalPlanModel plan) async {
    // Implement API call
    await Future.delayed(const Duration(seconds: 1));
  }

  @override
  Future<PersonalPlanModel?> getPersonalPlan(String id) async {
    // Implement API call
    await Future.delayed(const Duration(seconds: 1));
    return null;
  }
}
"""
create_file(f"{base_path}/data/datasources/personal_plan_remote_data_source.dart", datasource)

bloc_event = """import 'package:equatable/equatable.dart';
import '../../domain/entities/personal_plan_entity.dart';

abstract class PersonalPlanEvent extends Equatable {
  const PersonalPlanEvent();

  @override
  List<Object?> get props => [];
}

class SubmitPersonalPlanEvent extends PersonalPlanEvent {
  final PersonalPlanEntity plan;

  const SubmitPersonalPlanEvent(this.plan);

  @override
  List<Object?> get props => [plan];
}
"""
create_file(f"{base_path}/presentation/bloc/personal_plan_event.dart", bloc_event)

bloc_state = """import 'package:equatable/equatable.dart';

abstract class PersonalPlanState extends Equatable {
  const PersonalPlanState();

  @override
  List<Object?> get props => [];
}

class PersonalPlanInitial extends PersonalPlanState {}

class PersonalPlanLoading extends PersonalPlanState {}

class PersonalPlanSuccess extends PersonalPlanState {}

class PersonalPlanError extends PersonalPlanState {
  final String message;

  const PersonalPlanError(this.message);

  @override
  List<Object?> get props => [message];
}
"""
create_file(f"{base_path}/presentation/bloc/personal_plan_state.dart", bloc_state)

bloc = """import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/personal_plan_repository.dart';
import 'personal_plan_event.dart';
import 'personal_plan_state.dart';

class PersonalPlanBloc extends Bloc<PersonalPlanEvent, PersonalPlanState> {
  final PersonalPlanRepository repository;

  PersonalPlanBloc({required this.repository}) : super(PersonalPlanInitial()) {
    on<SubmitPersonalPlanEvent>(_onSubmitPersonalPlan);
  }

  Future<void> _onSubmitPersonalPlan(
    SubmitPersonalPlanEvent event,
    Emitter<PersonalPlanState> emit,
  ) async {
    emit(PersonalPlanLoading());
    try {
      await repository.submitPersonalPlan(event.plan);
      emit(PersonalPlanSuccess());
    } catch (e) {
      emit(PersonalPlanError(e.toString()));
    }
  }
}
"""
create_file(f"{base_path}/presentation/bloc/personal_plan_bloc.dart", bloc)

page = """import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/personal_plan_bloc.dart';
import '../bloc/personal_plan_event.dart';
import '../bloc/personal_plan_state.dart';
import '../../domain/entities/personal_plan_entity.dart';

class PersonalPlanPage extends StatefulWidget {
  const PersonalPlanPage({super.key});

  @override
  State<PersonalPlanPage> createState() => _PersonalPlanPageState();
}

class _PersonalPlanPageState extends State<PersonalPlanPage> {
  final _formKey = GlobalKey<FormState>();

  // Use controllers or a Map to hold form values.
  // For brevity, using a few controllers as example.
  final nameController = TextEditingController();
  final branchController = TextEditingController();
  final monthController = TextEditingController();
  final yearController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ব্যক্তিগত মাসিক পরিকল্পনা')),
      body: BlocConsumer<PersonalPlanBloc, PersonalPlanState>(
        listener: (context, state) {
          if (state is PersonalPlanSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Plan submitted successfully')),
            );
          } else if (state is PersonalPlanError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          if (state is PersonalPlanLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    controller: nameController,
                    decoration: const InputDecoration(labelText: 'নাম'),
                  ),
                  TextFormField(
                    controller: branchController,
                    decoration: const InputDecoration(labelText: 'শাখা'),
                  ),
                  TextFormField(
                    controller: monthController,
                    decoration: const InputDecoration(labelText: 'মাস'),
                  ),
                  TextFormField(
                    controller: yearController,
                    decoration: const InputDecoration(labelText: 'সন'),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        final plan = PersonalPlanEntity(
                          name: nameController.text,
                          branch: branchController.text,
                          month: monthController.text,
                          year: yearController.text,
                          // ... set other fields
                        );
                        context.read<PersonalPlanBloc>().add(SubmitPersonalPlanEvent(plan));
                      }
                    },
                    child: const Text('জমা দিন'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
"""
create_file(f"{base_path}/presentation/pages/personal_plan_page.dart", page)

print("Files generated.")
