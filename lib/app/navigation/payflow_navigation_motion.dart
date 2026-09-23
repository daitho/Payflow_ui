enum PayflowScrollBoundary { none, top, bottom }

class PayflowNavigationMotion {
  final double activationDistance;
  final double transitionDistance;

  double _pendingDistance = 0;
  int _direction = 0;
  bool _activated = false;

  PayflowNavigationMotion({
    this.activationDistance = 36,
    this.transitionDistance = 150,
  }) : assert(activationDistance >= 0),
       assert(transitionDistance > 0);

  double consume({
    required double progress,
    required double delta,
    PayflowScrollBoundary boundary = PayflowScrollBoundary.none,
  }) {
    if (boundary == PayflowScrollBoundary.top) {
      resetGesture();
      return 0;
    }

    if (boundary == PayflowScrollBoundary.bottom) {
      resetGesture();
      return 1;
    }

    if (delta == 0) {
      return _bounded(progress);
    }

    final direction = delta > 0 ? 1 : -1;
    if (direction != _direction) {
      _direction = direction;
      _pendingDistance = 0;
      _activated = false;
    }

    var effectiveDelta = delta;
    if (!_activated) {
      _pendingDistance += delta.abs();
      if (_pendingDistance <= activationDistance) {
        return _bounded(progress);
      }

      _activated = true;
      effectiveDelta =
          direction * (_pendingDistance - activationDistance);
    }

    return _bounded(
      progress + effectiveDelta / transitionDistance,
    );
  }

  void resetGesture() {
    _pendingDistance = 0;
    _direction = 0;
    _activated = false;
  }

  double _bounded(double value) =>
      value.clamp(0.0, 1.0).toDouble();
}
