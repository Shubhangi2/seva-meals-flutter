import 'package:flutter/widgets.dart';
import 'package:fpdart/fpdart.dart';
import 'package:seva_meal/core/failure.dart';
import 'package:seva_meal/datasource/donor_datasource.dart';
import 'package:seva_meal/models/post_model.dart';

class DonorProvider extends ChangeNotifier {
  final DonorDatasource datasource;

  DonorProvider({required this.datasource});
  Future<Either<Failure, String>> createPost(PostModel postModel) async {
    return await datasource.createPost(postModel);
  }
}
