enum HomeTransferStatus {
  created,
  pending,
  processing,
  completed,
  failed,
  cancelled,
  refunded,
  unknown;

  factory HomeTransferStatus.fromApi(
      String value,
      ) {
    switch (value) {
      case 'CREATED':
        return HomeTransferStatus.created;

      case 'PENDING':
        return HomeTransferStatus.pending;

      case 'PROCESSING':
        return HomeTransferStatus.processing;

      case 'COMPLETED':
        return HomeTransferStatus.completed;

      case 'FAILED':
        return HomeTransferStatus.failed;

      case 'CANCELLED':
        return HomeTransferStatus.cancelled;

      case 'REFUNDED':
        return HomeTransferStatus.refunded;

      default:
        return HomeTransferStatus.unknown;
    }
  }
}
