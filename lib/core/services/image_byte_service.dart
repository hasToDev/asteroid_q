import 'dart:convert';
import 'dart:typed_data';
import 'package:asteroid_q/assets/assets.dart';

class ImageByteService {
  final Uint8List? fighterJet;
  final Uint8List? asteroid;
  final Uint8List? fuelPod;
  final Uint8List? missile;

  ImageByteService({
    this.fighterJet,
    this.asteroid,
    this.fuelPod,
    this.missile,
  });

  Future<ImageByteService> initialize() async {
    return ImageByteService(
      fighterJet: base64.decode(fighterJetBASE64),
      asteroid: base64.decode(asteroidBASE64),
      fuelPod: base64.decode(fuelBASE64),
      missile: base64.decode(missileBASE64),
    );
  }
}