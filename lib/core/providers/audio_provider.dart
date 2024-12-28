import 'package:asteroid_q/core/core.dart';
import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';

class AudioProvider extends ChangeNotifier {
  late AudioPlayer explosionSound;
  late AudioPlayer laserSound;
  late AudioPlayer lifeReducedSound;
  late AudioPlayer refuelSound;
  late AudioPlayer whooshSound;

  double effectVolume = 0.35;

  bool playerHaveTapScreen = false;

  void playerTapScreen() {
    if (playerHaveTapScreen) return;
    playerHaveTapScreen = true;
  }

  Future<void> initializeAudio({double effectVol = 0.35}) async {
    if (!kIsWeb) return;

    effectVolume = effectVol;

    explosionSound = AudioPlayer();
    laserSound = AudioPlayer();
    lifeReducedSound = AudioPlayer();
    refuelSound = AudioPlayer();
    whooshSound = AudioPlayer();

    await explosionSound.setAudioSource(ByteAudioSource(getIt<AssetByteService>().soundEXPLOSION!));
    await explosionSound.setVolume(effectVolume);
    explosionSound.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed) explosionSound.stop();
    });

    await laserSound.setAudioSource(ByteAudioSource(getIt<AssetByteService>().soundLASER!));
    await laserSound.setVolume(effectVolume);
    laserSound.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed) laserSound.stop();
    });

    await lifeReducedSound.setAudioSource(ByteAudioSource(getIt<AssetByteService>().soundLIFEREDUCED!));
    await lifeReducedSound.setVolume(effectVolume);
    lifeReducedSound.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed) lifeReducedSound.stop();
    });

    await refuelSound.setAudioSource(ByteAudioSource(getIt<AssetByteService>().soundREFUEL!));
    await refuelSound.setVolume(effectVolume);
    refuelSound.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed) refuelSound.stop();
    });

    await whooshSound.setAudioSource(ByteAudioSource(getIt<AssetByteService>().soundWHOOSH!));
    await whooshSound.setVolume(effectVolume);
    whooshSound.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed) whooshSound.stop();
    });
  }

  Future<void> sound(GameSound type) async {
    if (!kIsWeb || !playerHaveTapScreen || effectVolume == 0.0) return;

    switch (type) {
      case GameSound.explosion:
        await explosionSound.seek(Duration.zero);
        explosionSound.play();
        break;
      case GameSound.laser:
        await laserSound.seek(Duration.zero);
        laserSound.play();
        break;
      case GameSound.lifeReduced:
        await lifeReducedSound.seek(Duration.zero);
        lifeReducedSound.play();
        break;
      case GameSound.refuel:
        await refuelSound.seek(Duration.zero);
        refuelSound.play();
        break;
      case GameSound.move:
        await whooshSound.seek(Duration.zero);
        whooshSound.play();
        break;
    }
  }
}

class ByteAudioSource extends StreamAudioSource {
  final List<int> bytes;

  ByteAudioSource(this.bytes);

  @override
  Future<StreamAudioResponse> request([int? start, int? end]) async {
    start ??= 0;
    end ??= bytes.length;
    return StreamAudioResponse(
      sourceLength: bytes.length,
      contentLength: end - start,
      offset: start,
      stream: Stream.value(bytes.sublist(start, end)),
      contentType: 'audio/mpeg',
    );
  }
}
