import 'models.dart';
import 'package:flutter/foundation.dart';

/// Clackety Typewriter controller
class ClacketyController extends ChangeNotifier {
  ClacketySequence _sequence;
  String _value;
  String get value =>
      _value +
      (switch (state) {
        ClacketyState.typing => '_',
        _ => '',
      });

  String get valueWhenComplete => _sequence.items.last.value;

  bool _isDisposed = false;
  bool _isTyping = false;
  bool get isTyping => _isTyping;

  ClacketyState get state => _sequence.items.first.state;

  final onComplete = ChangeNotifier();
  final onTyping = ChangeNotifier();

  ClacketyController({
    String initialValue = '',
    required String value,
  })  : _sequence = ClacketySequence.fromStrings(initialValue, value),
        _value = initialValue {
    _doTyping();
  }

  @override
  void dispose() {
    _isDisposed = true;
    onComplete.dispose();
    onTyping.dispose();
    super.dispose();
  }

  void fastForwardSequence() {
    if (!_isDisposed) {
      _sequence = _sequence.copyWith(fastForward: true);
      notifyListeners();
    }
  }

  void type(String text, {Function()? onComplete}) {
    if (valueWhenComplete == text) {
      onComplete?.call();
      return;
    }
    _sequence =
        ClacketySequence.fromStrings(_value, text, onComplete: onComplete);

    if (!_isTyping && !_isDisposed) {
      _doTyping();
    }
  }

  /// Start clackety typing
  Future _doTyping() async {
    _isTyping = true;
    // type...
    final currentSequence = _sequence.items.first;

    // Have we reached the target?
    if (_value == currentSequence.value) {
      // Progress to next one...
      if (_sequence.items.length > 1) {
        _sequence = _sequence.copyWith(items: _sequence.items.sublist(1));
      } else {
        // Trigger onComplete
        final callback = _sequence.onComplete;
        // set state to idle
        _sequence = ClacketySequence(
            items: [(value: _value, state: ClacketyState.idle)]);

        _isTyping = false;
        onComplete.notifyListeners();
        onTyping.notifyListeners();

        callback?.call();
        return;
      }
    } else {
      // Update value
      _value = switch (currentSequence.state) {
        ClacketyState.typing => _value + currentSequence.value[_value.length],
        ClacketyState.deleting => _value.substring(0, _value.length - 1),
        ClacketyState.idle => currentSequence.value,
      };
      onTyping.notifyListeners();
    }
    // pause...
    await Future.delayed(switch (_sequence.fastForward) {
      true => const Duration(milliseconds: 5),
      false => currentSequence.state.pause,
    });

    if (!_isDisposed) _doTyping();
  }
}
