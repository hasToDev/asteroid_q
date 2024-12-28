import 'dart:convert';
import 'dart:typed_data';
import 'package:asteroid_q/assets/assets.dart';

class AssetByteService {
  final Uint8List? imageFIGHTERJET;
  final Uint8List? imageASTEROID;
  final Uint8List? imageFUELPOD;
  final Uint8List? imageMISSILE;
  final Uint8List? imageSCORE;
  final Uint8List? imageLIFE;
  final Uint8List? animationBLAST;
  final Uint8List? animationWARP;
  final Uint8List? soundEXPLOSION;
  final Uint8List? soundLASER;
  final Uint8List? soundLIFEREDUCED;
  final Uint8List? soundREFUEL;
  final Uint8List? soundWHOOSH;

  AssetByteService({
    this.imageFIGHTERJET,
    this.imageASTEROID,
    this.imageFUELPOD,
    this.imageMISSILE,
    this.imageSCORE,
    this.imageLIFE,
    this.animationBLAST,
    this.animationWARP,
    this.soundEXPLOSION,
    this.soundLASER,
    this.soundLIFEREDUCED,
    this.soundREFUEL,
    this.soundWHOOSH,
  });

  Future<AssetByteService> initialize() async {
    return AssetByteService(
      imageFIGHTERJET: base64.decode(fighterJetBASE64),
      imageASTEROID: base64.decode(asteroidBASE64),
      imageFUELPOD: base64.decode(fuelBASE64),
      imageMISSILE: base64.decode(missileBASE64),
      imageSCORE: base64.decode(scoreBASE64),
      imageLIFE: base64.decode(lifeBASE64),
      animationBLAST: base64.decode(blastBASE64),
      animationWARP: base64.decode(warpBASE64),
      soundEXPLOSION: base64.decode(explosionBASE64),
      soundLASER: base64.decode(laserBASE64),
      soundLIFEREDUCED: base64.decode(lifeReducedBASE64),
      soundREFUEL: base64.decode(refuelBASE64),
      soundWHOOSH: base64.decode(whooshMoveBASE64),
    );
  }
}
