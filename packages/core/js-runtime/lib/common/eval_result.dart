class EvalResult {
  final dynamic result;
  final bool isPromise;

  EvalResult(
    this.result, {
    this.isPromise = false,
  });

  @override
  toString() => result.toString();
}
