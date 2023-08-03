class ActionResult<T> {
  T? data;
  int? statusCode;
  String? responseText;

  ActionResult({
    this.data,
    this.statusCode,
    this.responseText
  });
}