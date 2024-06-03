extension StatusExtension on Status {
  bool get isInitial => this == Status.initial;
  bool get isLoading => this == Status.loading;
  bool get isSuccess => this == Status.success;
  bool get isFailed => this == Status.failed;
  bool get isRefresh => this == Status.refresh;
}

enum Status {
  initial,
  loading,
  success,
  failed,
  refresh,
}
