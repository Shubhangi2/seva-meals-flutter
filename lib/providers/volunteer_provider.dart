import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';
import 'package:seva_meal/core/failure.dart';
import 'package:seva_meal/datasource/volunteer_datasource.dart';
import 'package:seva_meal/models/post_model.dart';

class VolunteerProvider extends ChangeNotifier {
  final VolunteerDatasource datasource;

  VolunteerProvider({required this.datasource});

  Future<Either<Failure, List<PostModel>>> getActivePostsByRegion() {
    return datasource.getActivePostsByRegion();
  }
}
