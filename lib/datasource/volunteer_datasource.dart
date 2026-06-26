import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fpdart/fpdart.dart';
import 'package:seva_meal/core/failure.dart';
import 'package:seva_meal/core/utils/user_session.dart';
import 'package:seva_meal/models/post_model.dart';
import 'package:seva_meal/models/user_model.dart';

class VolunteerDatasource {
  final db = FirebaseFirestore.instance;
  Future<Either<Failure, List<PostModel>>> getActivePostsByRegion() async {
    try {
      UserModel? user = await UserSession().user;
      if (user == null) return left(Failure("User is null"));

      final docs = await db
          .collection("posts")
          .where("region", isEqualTo: user.region)
          .where('isActive', isEqualTo: true)
          .get();
      List<PostModel> posts = docs.docs.map((e) => PostModel.fromJson(e.data())).toList();
      return right(posts);
    } catch (e) {
      print(e);
      return left(Failure("Failed to get posts"));
    }
  }
}
