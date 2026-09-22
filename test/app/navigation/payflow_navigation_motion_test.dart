import 'package:flutter_test/flutter_test.dart';
import 'package:pay_flow_ui/app/navigation/payflow_navigation_motion.dart';

void main() {
  test('waits for the downward activation distance', () {
    final motion = PayflowNavigationMotion(
      activationDistance: 36,
      transitionDistance: 150,
    );

    var progress = motion.consume(progress: 0, delta: 20);
    expect(progress, 0);

    progress = motion.consume(progress: progress, delta: 16);
    expect(progress, 0);

    progress = motion.consume(progress: progress, delta: 15);
    expect(progress, closeTo(.1, .0001));
  });

  test('applies the same delay while scrolling upward', () {
    final motion = PayflowNavigationMotion(
      activationDistance: 36,
      transitionDistance: 150,
    );

    var progress = motion.consume(progress: 1, delta: -30);
    expect(progress, 1);

    progress = motion.consume(progress: progress, delta: -21);
    expect(progress, closeTo(.9, .0001));
  });

  test('direction reversal starts a fresh activation distance', () {
    final motion = PayflowNavigationMotion(
      activationDistance: 36,
      transitionDistance: 150,
    );

    var progress = motion.consume(progress: 0, delta: 40);
    expect(progress, closeTo(4 / 150, .0001));

    progress = motion.consume(progress: progress, delta: -20);
    expect(progress, closeTo(4 / 150, .0001));

    progress = motion.consume(progress: progress, delta: -20);
    expect(progress, 0);
  });

  test('ending a gesture restores the delay', () {
    final motion = PayflowNavigationMotion(
      activationDistance: 36,
      transitionDistance: 150,
    );

    var progress = motion.consume(progress: 0, delta: 50);
    expect(progress, greaterThan(0));

    motion.resetGesture();
    final unchanged = motion.consume(progress: progress, delta: 20);
    expect(unchanged, progress);
  });
}
