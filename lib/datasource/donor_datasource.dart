import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fpdart/fpdart.dart';
import 'package:seva_meal/core/failure.dart';
import 'package:seva_meal/core/utils/utility_functions.dart';
import 'package:seva_meal/models/post_model.dart';

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

  Future<Either<Failure, List<PostModel>>> getPosts() async {
    final db = FirebaseFirestore.instance;
    try {
      final docs = await db.collection("posts").get();
      List<PostModel> posts = docs.docs.map((e) => PostModel.fromJson(e.data())).toList();
      return right(posts);
    } catch (e) {
      print(e);
      return left(Failure("Failed to get posts"));
    }
  }
}
