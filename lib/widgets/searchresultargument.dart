import 'package:mmovies/Models/Result.dart';

class searchresultargument {
  List<Result> data;
  String query;
  searchresultargument({
    required this.data,
    required this.query,
  });

  List<Result> getresult() {
    return data;
  }

  String getquery() {
    return query;
  }
}
