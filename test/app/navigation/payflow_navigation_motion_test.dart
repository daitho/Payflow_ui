import 'package:flutter_test/flutter_test.dart';
import 'package:pay_flow_ui/app/navigation/payflow_navigation_motion.dart';

void main() {
  test('top boundary always keeps navigation expanded', () {
    final motion = PayflowNavigationMotion();

    final progress = motion.consume(
      progress: .7,
      delta: -80,
      boundary: PayflowScrollBoundary.top,
    );

    expect(progress, 0);
  });

  test('bottom boundary always keeps navigation collapsed', () {
    final motion = PayflowNavigationMotion();

    final progress = motion.consume(
      progress: .2,
      delta: 80,
      boundary: PayflowScrollBoundary.bottom,
    );

    expect(progress, 1);
  });

  test('boundary lock resets the activation distance', () {
    final motion = PayflowNavigationMotion(
      activationDistance: 36,
      transitionDistance: 150,
    );

    motion.consume(progress: .5, delta: 50);
    final atTop = motion.consume(
      progress: .6,
      delta: -20,
      boundary: PayflowScrollBoundary.top,
    );
    final afterLeavingTop = motion.consume(progress: atTop, delta: 20);

    expect(atTop, 0);
    expect(afterLeavingTop, 0);
  });

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
