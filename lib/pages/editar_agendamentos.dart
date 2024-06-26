import 'package:flutter/material.dart';

class EditarAgendamentoPage extends StatefulWidget {
  final Map<String, dynamic> agendamento;
  final List<String> cities;
  final List<String> places;
  final List<String> days;
  final List<String> times;
  final List<String> services;

  EditarAgendamentoPage({
    required this.agendamento,
    required this.cities,
    required this.places,
    required this.days,
    required this.times,
    required this.services,
  });

  @override
  _EditarAgendamentoPageState createState() => _EditarAgendamentoPageState();
}

class _EditarAgendamentoPageState extends State<EditarAgendamentoPage> {
  String? selectedCity;
  String? selectedPlace;
  String? selectedDay;
  String? selectedTime;
  String? selectedService;

  @override
  void initState() {
    super.initState();
    selectedCity = widget.agendamento['cidade'];
    selectedPlace = widget.agendamento['lugar'];
    selectedDay = widget.agendamento['dia'];
    selectedTime = widget.agendamento['horario'];
    selectedService = widget.agendamento['servico'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Editar Agendamento"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: <Widget>[
            buildDropdown("Cidade", selectedCity, widget.cities, (val) => setState(() => selectedCity = val)),
            buildDropdown("Lugar", selectedPlace, widget.places, (val) => setState(() => selectedPlace = val)),
            buildDropdown("Dia", selectedDay, widget.days, (val) => setState(() => selectedDay = val)),
            buildDropdown("Horário", selectedTime, widget.times, (val) => setState(() => selectedTime = val)),
            buildDropdown("Serviço", selectedService, widget.services, (val) => setState(() => selectedService = val)),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final editedAgendamento = {
                  'cidade': selectedCity,
                  'lugar': selectedPlace,
                  'dia': selectedDay,
                  'horario': selectedTime,
                  'servico': selectedService,
                };
                Navigator.of(context).pop(editedAgendamento);
              },
              child: Text('Salvar'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  DropdownButtonFormField<String> buildDropdown(String label, String? value, List<String> options, ValueChanged<String?> onChanged) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(labelText: label),
      items: options.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }
}
