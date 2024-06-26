import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../database/database_helper.dart';
import 'editar_agendamentos.dart';

class TelaAgendar extends StatefulWidget {
  @override
  _TelaAgendarState createState() => _TelaAgendarState();
}

class _TelaAgendarState extends State<TelaAgendar> {
  bool showFields = false;
  String? selectedCity;
  String? selectedPlace;
  String? selectedDay;
  String? selectedTime;
  String? selectedService;

  final List<String> cities = ['Vitorino', 'Pato Branco', 'São Lorenço'];
  final List<String> places = ['Ferrari', 'Estação', 'MotorBeleza'];
  final List<String> days = ['Segunda', 'Terça', 'Quarta', 'Quinta', 'Sexta'];
  final List<String> times = ['09:00', '11:00', '14:00', '16:00', '18:00'];
  final List<String> services = ['Corte', 'Corte e Barba', 'Coloração'];

  List<Map<String, dynamic>> agendamentos = [];

  get showMarcados => null;

  @override
  void initState() {
    super.initState();
    loadAgendamentos();
  }

  Future<void> loadAgendamentos() async {
    try {
      agendamentos = await DatabaseHelper().getAgendamentos();
      setState(() {});
    } catch (e) {
      print('Erro ao carregar agendamentos: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao carregar agendamentos')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Agendar"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: <Widget>[
            if (!showFields)
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    showFields = true;
                  });
                },
                child: Text('Marcar'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                ),
              ),
            SizedBox(height: 10),
            if (!showFields)
              ElevatedButton(
                onPressed: showMarcados,
                child: Text('Marcados'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                ),
              ),
            if (showFields) ...[
              buildDropdown("Cidade", selectedCity, cities, (val) => setState(() => selectedCity = val)),
              buildDropdown("Lugar", selectedPlace, places, (val) => setState(() => selectedPlace = val)),
              buildDropdown("Dia", selectedDay, days, (val) => setState(() => selectedDay = val)),
              buildDropdown("Horário", selectedTime, times, (val) => setState(() => selectedTime = val)),
              buildDropdown("Serviço", selectedService, services, (val) => setState(() => selectedService = val)),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: saveAgendamento,
                child: Text('Salvar Agendamento'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                ),
              ),
            ]
          ],
        ),
      ),
    );
  }

  void saveAgendamento() async {
    if (selectedCity == null ||
        selectedPlace == null ||
        selectedDay == null ||
        selectedTime == null ||
        selectedService == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Por favor, preencha todos os campos')),
      );
      return;
    }

    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    final agendamento = {
      'cidade': selectedCity,
      'lugar': selectedPlace,
      'dia': selectedDay,
      'horario': selectedTime,
      'servico': selectedService,
      'latitude': position.latitude.toString(),
      'longitude': position.longitude.toString()
    };

    try {
      await DatabaseHelper().insertAgendamento(agendamento);
      agendamentos = await DatabaseHelper().getAgendamentos();
      setState(() {
        showFields = false;
        selectedCity = null;
        selectedPlace = null;
        selectedDay = null;
        selectedTime = null;
        selectedService = null;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Agendamento salvo com sucesso')),
      );
    } catch (e) {
      print('Erro ao salvar o agendamento: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao salvar o agendamento')),
      );
    }
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
