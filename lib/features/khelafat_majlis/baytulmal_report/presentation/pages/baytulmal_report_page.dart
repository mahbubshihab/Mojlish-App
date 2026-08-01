import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../common/widgets/custom_labeled_input_field.dart';
import '../bloc/baytulmal_report_bloc.dart';
import '../bloc/baytulmal_report_event.dart';
import '../bloc/baytulmal_report_state.dart';
import '../../domain/entities/baytulmal_report_entity.dart';

class BaytulmalReportPage extends StatefulWidget {
  const BaytulmalReportPage({super.key});

  @override
  State<BaytulmalReportPage> createState() => _BaytulmalReportPageState();
}

class _BaytulmalReportPageState extends State<BaytulmalReportPage> {
  final _formKey = GlobalKey<FormState>();

  final _branchController = TextEditingController();
  final _monthController = TextEditingController();
  final _yearController = TextEditingController();

  final _nirbahiSodossoIyanatController = TextEditingController();
  final _nirbahiSodossoSonkkhaController = TextEditingController();
  final _odhostonShakhaIyanatController = TextEditingController();
  final _shakhaSonkkhaController = TextEditingController();
  final _shudhiIyanatController = TextEditingController();
  final _shudhiSonkkhaController = TextEditingController();
  final _soforAayController = TextEditingController();
  final _prokashonaAayController = TextEditingController();
  final _ekkalinAayController = TextEditingController();
  final _motAayController = TextEditingController();
  final _bigotoMashUdbrittoController = TextEditingController();
  final _sorbomotAayController = TextEditingController();
  final _kothayAayController = TextEditingController();

  final _urdhotonIyanatPorishodhController = TextEditingController();
  final _mashikDharjokritoController = TextEditingController();
  final _officeVaraOBillController = TextEditingController();
  final _officeKhorochController = TextEditingController();
  final _soforBbayController = TextEditingController();
  final _jatayatController = TextEditingController();
  final _jogajogController = TextEditingController();
  final _procharController = TextEditingController();
  final _prokashonaBbayController = TextEditingController();
  final _diboshPalonController = TextEditingController();
  final _diboshNamController = TextEditingController();
  final _appayonController = TextEditingController();
  final _shobhaShomabeshController = TextEditingController();
  final _motBbayController = TextEditingController();
  final _udbrittoGhattiController = TextEditingController();
  final _kothayBbayController = TextEditingController();

  final _reportDateController = TextEditingController();
  final _baytulmalSompodokShakkhorController = TextEditingController();
  final _sobhapotiShakkhorController = TextEditingController();

  @override
  void dispose() {
    _branchController.dispose();
    _monthController.dispose();
    _yearController.dispose();
    _nirbahiSodossoIyanatController.dispose();
    _nirbahiSodossoSonkkhaController.dispose();
    _odhostonShakhaIyanatController.dispose();
    _shakhaSonkkhaController.dispose();
    _shudhiIyanatController.dispose();
    _shudhiSonkkhaController.dispose();
    _soforAayController.dispose();
    _prokashonaAayController.dispose();
    _ekkalinAayController.dispose();
    _motAayController.dispose();
    _bigotoMashUdbrittoController.dispose();
    _sorbomotAayController.dispose();
    _kothayAayController.dispose();
    _urdhotonIyanatPorishodhController.dispose();
    _mashikDharjokritoController.dispose();
    _officeVaraOBillController.dispose();
    _officeKhorochController.dispose();
    _soforBbayController.dispose();
    _jatayatController.dispose();
    _jogajogController.dispose();
    _procharController.dispose();
    _prokashonaBbayController.dispose();
    _diboshPalonController.dispose();
    _diboshNamController.dispose();
    _appayonController.dispose();
    _shobhaShomabeshController.dispose();
    _motBbayController.dispose();
    _udbrittoGhattiController.dispose();
    _kothayBbayController.dispose();
    _reportDateController.dispose();
    _baytulmalSompodokShakkhorController.dispose();
    _sobhapotiShakkhorController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final report = BaytulmalReportEntity(
        branch: _branchController.text,
        month: _monthController.text,
        year: _yearController.text,
        nirbahiSodossoIyanat: double.tryParse(_nirbahiSodossoIyanatController.text) ?? 0.0,
        nirbahiSodossoSonkkha: int.tryParse(_nirbahiSodossoSonkkhaController.text) ?? 0,
        odhostonShakhaIyanat: double.tryParse(_odhostonShakhaIyanatController.text) ?? 0.0,
        shakhaSonkkha: int.tryParse(_shakhaSonkkhaController.text) ?? 0,
        shudhiIyanat: double.tryParse(_shudhiIyanatController.text) ?? 0.0,
        shudhiSonkkha: int.tryParse(_shudhiSonkkhaController.text) ?? 0,
        soforAay: double.tryParse(_soforAayController.text) ?? 0.0,
        prokashonaAay: double.tryParse(_prokashonaAayController.text) ?? 0.0,
        ekkalinAay: double.tryParse(_ekkalinAayController.text) ?? 0.0,
        motAay: double.tryParse(_motAayController.text) ?? 0.0,
        bigotoMashUdbritto: double.tryParse(_bigotoMashUdbrittoController.text) ?? 0.0,
        sorbomotAay: double.tryParse(_sorbomotAayController.text) ?? 0.0,
        kothayAay: _kothayAayController.text,
        urdhotonIyanatPorishodh: double.tryParse(_urdhotonIyanatPorishodhController.text) ?? 0.0,
        mashikDharjokrito: double.tryParse(_mashikDharjokritoController.text) ?? 0.0,
        officeVaraOBill: double.tryParse(_officeVaraOBillController.text) ?? 0.0,
        officeKhoroch: double.tryParse(_officeKhorochController.text) ?? 0.0,
        soforBbay: double.tryParse(_soforBbayController.text) ?? 0.0,
        jatayat: double.tryParse(_jatayatController.text) ?? 0.0,
        jogajog: double.tryParse(_jogajogController.text) ?? 0.0,
        prochar: double.tryParse(_procharController.text) ?? 0.0,
        prokashonaBbay: double.tryParse(_prokashonaBbayController.text) ?? 0.0,
        diboshPalon: double.tryParse(_diboshPalonController.text) ?? 0.0,
        diboshNam: _diboshNamController.text,
        appayon: double.tryParse(_appayonController.text) ?? 0.0,
        shobhaShomabesh: double.tryParse(_shobhaShomabeshController.text) ?? 0.0,
        motBbay: double.tryParse(_motBbayController.text) ?? 0.0,
        udbrittoGhatti: double.tryParse(_udbrittoGhattiController.text) ?? 0.0,
        kothayBbay: _kothayBbayController.text,
        reportDate: _reportDateController.text,
        baytulmalSompodokShakkhor: _baytulmalSompodokShakkhorController.text,
        sobhapotiShakkhor: _sobhapotiShakkhorController.text,
      );

      context.read<BaytulmalReportBloc>().add(SubmitBaytulmalReportEvent(report: report));
    }
  }

  Widget _buildTextField(String label, TextEditingController controller, {bool isNumber = false}) {
    return CustomLabeledInputField(
      label: label,
      controller: controller,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('বায়তুলমাল রিপোর্ট (খেলাফত মজলিস)'),
      ),
      body: BlocConsumer<BaytulmalReportBloc, BaytulmalReportState>(
        listener: (context, state) {
          if (state is BaytulmalReportSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Report submitted successfully')),
            );
          } else if (state is BaytulmalReportFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error: ${state.message}')),
            );
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text('সাধারণ তথ্য', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  _buildTextField('শাখা', _branchController),
                  _buildTextField('মাস', _monthController),
                  _buildTextField('সন', _yearController),

                  const SizedBox(height: 16),
                  const Text('আয়', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  _buildTextField('নির্বাহী সদস্যদের এয়ানত', _nirbahiSodossoIyanatController, isNumber: true),
                  _buildTextField('নির্বাহী সদস্য সংখ্যা', _nirbahiSodossoSonkkhaController, isNumber: true),
                  _buildTextField('অধস্তন শাখা এয়ানত', _odhostonShakhaIyanatController, isNumber: true),
                  _buildTextField('শাখা সংখ্যা', _shakhaSonkkhaController, isNumber: true),
                  _buildTextField('সুধী/শুভাকাঙ্ক্ষী এয়ানত', _shudhiIyanatController, isNumber: true),
                  _buildTextField('শুভাকাঙ্ক্ষী সংখ্যা', _shudhiSonkkhaController, isNumber: true),
                  _buildTextField('সফর আয়', _soforAayController, isNumber: true),
                  _buildTextField('প্রকাশনা আয়', _prokashonaAayController, isNumber: true),
                  _buildTextField('এককালীন আয়', _ekkalinAayController, isNumber: true),
                  _buildTextField('মোট আয়', _motAayController, isNumber: true),
                  _buildTextField('বিগত মাস/সেশনের উদ্বৃত্ত', _bigotoMashUdbrittoController, isNumber: true),
                  _buildTextField('সর্বমোট আয়', _sorbomotAayController, isNumber: true),
                  _buildTextField('কথায় (আয়)', _kothayAayController),

                  const SizedBox(height: 16),
                  const Text('ব্যয়', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  _buildTextField('ঊর্ধ্বতন এয়ানত পরিশোধ', _urdhotonIyanatPorishodhController, isNumber: true),
                  _buildTextField('মাসিক ধার্যকৃত', _mashikDharjokritoController, isNumber: true),
                  _buildTextField('অফিস ভাড়া ও বিল', _officeVaraOBillController, isNumber: true),
                  _buildTextField('অফিস খরচ', _officeKhorochController, isNumber: true),
                  _buildTextField('সফর ব্যয়', _soforBbayController, isNumber: true),
                  _buildTextField('যাতায়াত', _jatayatController, isNumber: true),
                  _buildTextField('যোগাযোগ', _jogajogController, isNumber: true),
                  _buildTextField('প্রচার', _procharController, isNumber: true),
                  _buildTextField('প্রকাশনা ব্যয়', _prokashonaBbayController, isNumber: true),
                  _buildTextField('দিবস পালন', _diboshPalonController, isNumber: true),
                  _buildTextField('দিবসের নাম', _diboshNamController),
                  _buildTextField('আপ্যায়ন', _appayonController, isNumber: true),
                  _buildTextField('সভা/সমাবেশ বাস্তবায়ন', _shobhaShomabeshController, isNumber: true),
                  _buildTextField('মোট ব্যয়', _motBbayController, isNumber: true),
                  _buildTextField('উদ্বৃত্ত/ঘাটতি', _udbrittoGhattiController, isNumber: true),
                  _buildTextField('কথায় (ব্যয়)', _kothayBbayController),

                  const SizedBox(height: 16),
                  const Text('স্বাক্ষর', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  _buildTextField('তারিখ', _reportDateController),
                  _buildTextField('বায়তুলমাল সম্পাদকের স্বাক্ষর', _baytulmalSompodokShakkhorController),
                  _buildTextField('সভাপতির স্বাক্ষর', _sobhapotiShakkhorController),

                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: state is BaytulmalReportLoading ? null : _submit,
                    child: state is BaytulmalReportLoading
                        ? const CircularProgressIndicator()
                        : const Text('জমা দিন'),
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
