enum ClacketyState {
  idle(Duration(milliseconds: 250)),
  typing(Duration(milliseconds: 25)),
  deleting(Duration(milliseconds: 15)),
  ;

  final Duration pause;
  const ClacketyState(this.pause);
}

typedef ClacketySequenceItem = ({String value, ClacketyState state});

class ClacketySequence {
  final List<ClacketySequenceItem> items;
  final bool fastForward;
  final Function()? onComplete;

  const ClacketySequence({
    required this.items,
    this.fastForward = false,
    this.onComplete,
  });

  /// Creates a typing sequence from two strings.
  factory ClacketySequence.fromStrings(String start, String target,
      {Function()? onComplete}) {
    start = start.trim();
    target = target.trim();

    if (start == target) {
      return ClacketySequence(
          onComplete: onComplete,
          items: [(value: target, state: ClacketyState.idle)]);
    }

    // Find the cursor position we are correct to
    var correctTo = 0;
    for (var i = 0; i < start.length; i++) {
      if (target.length >= i &&
          start.substring(0, i) == target.substring(0, i)) {
        correctTo = i;
      } else {
        break;
      }
    }

    // Return the sequence we need to arrive at target
    return ClacketySequence(onComplete: onComplete, items: [
      (value: start, state: ClacketyState.idle),
      if (correctTo <= target.length)
        (value: target.substring(0, correctTo), state: ClacketyState.deleting),
      (value: target, state: ClacketyState.typing),
    ]);
  }

  ClacketySequence copyWith({
    List<ClacketySequenceItem>? items,
    bool? fastForward,
  }) {
    return ClacketySequence(
      items: items ?? this.items,
      fastForward: fastForward ?? this.fastForward,
      onComplete: onComplete,
    );
  }
}
