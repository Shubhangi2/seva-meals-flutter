import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fpdart/fpdart.dart';
import 'package:seva_meal/core/failure.dart';
import 'package:seva_meal/core/utility_functions.dart';
import 'package:seva_meal/models/post_model.dart';
import 'package:seva_meal/providers/donor_provider.dart';

class DonorDatasource {
  Future<Either<Failure, String>> createPost(PostModel postModel) async {
    postModel.postId = UtilityFunctions.generateId("POST");
    final db = FirebaseFirestore.instance;
    try {
      final doc = await db.collection("posts").add(postModel.toJson());
      return right("Post created successfully");
    } catch (e) {
      print(e);
      return left(Failure("Failed to create post"));
    }
  }
}
