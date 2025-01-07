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
  final Uint8List? imageGAMEOVER;
  final Uint8List? imageEXIT;
  final Uint8List? imageSIGNOUT;
  final Uint8List? imageRANK;
  final Uint8List? imageCONTINUE;
  final Uint8List? animationBLAST;
  final Uint8List? animationWARP;
  final Uint8List? animationWINNER;
  final Uint8List? soundEXPLOSION;
  final Uint8List? soundLASER;
  final Uint8List? soundLIFEREDUCED;
  final Uint8List? soundREFUEL;
  final Uint8List? soundWHOOSH;
  final Uint8List? soundWON;
  final Uint8List? soundLOSE;
  final Uint8List? countDistance;
  final Uint8List? countGalaxy;
  final Uint8List? countRefuel;
  final Uint8List? countRotation;
  final Uint8List? legendEnter;
  final Uint8List? legendR;
  final Uint8List? legendSpace;
  final Uint8List? legendArrowDown;
  final Uint8List? legendArrowUp;
  final Uint8List? legendArrowLeft;
  final Uint8List? legendArrowRight;
  final Uint8List? legendMouseLeft;
  final Uint8List? legendMouseRight;
  final Uint8List? legendMouseMiddle;
  final Uint8List? controlDown;
  final Uint8List? controlUp;
  final Uint8List? controlLeft;
  final Uint8List? controlRight;
  final Uint8List? appLogo;

  AssetByteService({
    this.imageFIGHTERJET,
    this.imageASTEROID,
    this.imageFUELPOD,
    this.imageMISSILE,
    this.imageSCORE,
    this.imageLIFE,
    this.imageGAMEOVER,
    this.imageEXIT,
    this.imageSIGNOUT,
    this.imageRANK,
    this.imageCONTINUE,
    this.animationBLAST,
    this.animationWARP,
    this.animationWINNER,
    this.soundEXPLOSION,
    this.soundLASER,
    this.soundLIFEREDUCED,
    this.soundREFUEL,
    this.soundWHOOSH,
    this.soundWON,
    this.soundLOSE,
    this.countDistance,
    this.countGalaxy,
    this.countRefuel,
    this.countRotation,
    this.legendEnter,
    this.legendR,
    this.legendSpace,
    this.legendArrowDown,
    this.legendArrowUp,
    this.legendArrowLeft,
    this.legendArrowRight,
    this.legendMouseLeft,
    this.legendMouseRight,
    this.legendMouseMiddle,
    this.controlDown,
    this.controlUp,
    this.controlLeft,
    this.controlRight,
    this.appLogo,
  });

  Future<AssetByteService> initialize() async {
    return AssetByteService(
      imageFIGHTERJET: base64.decode(fighterJetBASE64),
      imageASTEROID: base64.decode(asteroidBASE64),
      imageFUELPOD: base64.decode(fuelBASE64),
      imageMISSILE: base64.decode(missileBASE64),
      imageSCORE: base64.decode(scoreBASE64),
      imageLIFE: base64.decode(lifeBASE64),
      imageGAMEOVER: base64.decode(gameOverBASE64),
      imageEXIT: base64.decode(exitBASE64),
      imageSIGNOUT: base64.decode(signOutBASE64),
      imageRANK: base64.decode(rankBASE64),
      imageCONTINUE: base64.decode(continueBASE64),
      animationBLAST: base64.decode(blastBASE64),
      animationWARP: base64.decode(warpBASE64),
      animationWINNER: base64.decode(winnerBASE64),
      soundEXPLOSION: base64.decode(explosionBASE64),
      soundLASER: base64.decode(laserBASE64),
      soundLIFEREDUCED: base64.decode(lifeReducedBASE64),
      soundREFUEL: base64.decode(refuelBASE64),
      soundWHOOSH: base64.decode(whooshMoveBASE64),
      soundWON: base64.decode(wonBASE64),
      soundLOSE: base64.decode(loseBASE64),
      countDistance: base64.decode(distanceCountBASE64),
      countGalaxy: base64.decode(galaxyCountBASE64),
      countRefuel: base64.decode(refuelCountBASE64),
      countRotation: base64.decode(rotationCountBASE64),
      legendEnter: base64.decode(enterKeyBASE64),
      legendR: base64.decode(rKeyBASE64),
      legendSpace: base64.decode(spaceKeyBASE64),
      legendArrowDown: base64.decode(arrowDownBASE64),
      legendArrowUp: base64.decode(arrowUpBASE64),
      legendArrowLeft: base64.decode(arrowLeftBASE64),
      legendArrowRight: base64.decode(arrowRightBASE64),
      legendMouseLeft: base64.decode(mouseLeftBASE64),
      legendMouseRight: base64.decode(mouseRightBASE64),
      legendMouseMiddle: base64.decode(mouseMiddleBASE64),
      controlDown: base64.decode(moveDownBASE64),
      controlUp: base64.decode(moveUpBASE64),
      controlLeft: base64.decode(moveLeftBASE64),
      controlRight: base64.decode(moveRightBASE64),
      appLogo: base64.decode(logoBASE64),
    );
  }
}
