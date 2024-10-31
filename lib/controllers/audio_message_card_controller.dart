import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:todo/core/utils/helper_functions.dart';

final audioMessageCardControllerProvider = AutoDisposeNotifierProvider.family<AudioMessageCardController, bool, String>(() {
  return AudioMessageCardController();
});

class AudioMessageCardController extends AutoDisposeFamilyNotifier<bool, String> {
  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  bool build(arg) {
    ref.onDispose(() {
      _audioPlayer.dispose();
    });
    _audioPlayer.playerStateStream.listen((playerState) {
      if (playerState.processingState == ProcessingState.completed) {
        state = false;
      }
    });
    return false;
  }

  Future<void> onPlayOrPause({required String url}) async {
    if (!state) {
      try {
        state = true;
        _audioPlayer.setUrl(url);
        await _audioPlayer.play();
      } catch (e) {
        state = false;
        HelperFunctions.showErrorSnackBar(message: e.toString());
      }
    } else {
      state = false;
      _audioPlayer.stop();
    }
  }
}
