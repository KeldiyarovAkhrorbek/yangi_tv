class FirstTimeTracker {
  FirstTimeTracker._internal();

  static FirstTimeTracker get instance => _instance;
  static final FirstTimeTracker _instance = FirstTimeTracker._internal();

  bool isFirstTime = false;
}
