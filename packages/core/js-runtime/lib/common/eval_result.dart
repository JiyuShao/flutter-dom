class EvalResult {
  final String stringResult;
  final bool isPromise;
  final bool isError;

  EvalResult(
    this.stringResult, {
    this.isError = false,
    this.isPromise = false,
  });

  @override
  toString() => stringResult;
}
