import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:app_settings/app_settings.dart';  // Esta linha já estava incluída

class TelaLocalizacao extends StatefulWidget {
  @override
  _TelaLocalizacaoState createState() => _TelaLocalizacaoState();
}

class _TelaLocalizacaoState extends State<TelaLocalizacao> {
  String _locationMessage = "Localização não definida";

  @override
  void initState() {
    super.initState();
    _checkPermissionAndLocation();
  }

  void _checkPermissionAndLocation() async {
    var serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() {
        _locationMessage = "Os serviços de localização estão desativados.";
      });
      return;
    }

    var permission = await Permission.locationWhenInUse.status;
    switch (permission) {
      case PermissionStatus.granted:
        _getCurrentLocation();  // Se já concedida, obtenha a localização imediatamente
        break;
      case PermissionStatus.denied:
        permission = await Permission.locationWhenInUse.request();
        if (permission == PermissionStatus.granted) {
          _getCurrentLocation();
        } else {
          setState(() {
            _locationMessage = "Permissão de localização negada.";
          });
        }
        break;
      case PermissionStatus.permanentlyDenied:
        _showSettingsDialog();
        break;
      default:
        setState(() {
          _locationMessage = "Erro desconhecido ao obter permissão.";
        });
    }
  }

  void _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      setState(() {
        _locationMessage = "Latitude: ${position.latitude}, Longitude: ${position.longitude}";
      });
    } catch (e) {
      setState(() {
        _locationMessage = "Erro ao obter localização: ${e.toString()}";
      });
    }
  }

  void _showSettingsDialog() {
    setState(() {
      _locationMessage = "Permissão de localização negada permanentemente. Ajuste nas configurações do seu dispositivo.";
    });
    // Opção para abrir as configurações do app
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Permissão necessária"),
            content: Text("Esta aplicação precisa de permissão de localização para funcionar corretamente. Por favor, habilite a localização nas configurações do app."),
            actions: <Widget>[
              TextButton(
                child: Text("Abrir Configurações"),
                onPressed: () {
                  Navigator.of(context).pop();
                  AppSettings.openAppSettings();  // Abrir configurações do app
                },
              ),
              TextButton(
                child: Text("Cancelar"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Localização'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_locationMessage),
            ElevatedButton(
              onPressed: _checkPermissionAndLocation,
              child: Text('Verificar Localização Novamente'),
            ),
          ],
        ),
      ),
    );
  }
}
