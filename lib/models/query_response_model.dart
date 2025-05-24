class QueryResponseModel {
  QueryResponseModel({
    required this.status,
    this.msg,
    this.data,
  });
  final String status;
  final String? msg;
  final List<Map<String, dynamic>>? data;
}
