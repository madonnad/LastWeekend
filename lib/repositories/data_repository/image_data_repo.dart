part of './data_repository.dart';

enum ImageChangeKey { userLikedUpdate, likeCountUpdate }

extension ImageDataRepo on DataRepository {
  // Initalize and Coordinate Storage of Comments
  Future<Map<String, Comment>> initalizeCommentsAndStore(
      String albumID, String imageID) async {
    Map<String, Comment> commentMap = {};

    if (albumMap.containsKey(albumID) &&
        albumMap[albumID]!.imageMap.containsKey(imageID)) {
      if (albumMap[albumID]!.imageMap[imageID]!.commentMap.isEmpty) {
        // Fetch List from Service
        List<Comment> imageComments =
            await EngagementService.getImageComments(user.token, imageID);

        // Transform List to Map
        commentMap = {
          for (Comment comment in imageComments) comment.id: comment,
        };

        albumMap[albumID]!.imageMap[imageID]!.commentMap = commentMap;

        return commentMap;
      } else {
        return albumMap[albumID]!.imageMap[imageID]!.commentMap;
      }
    }
    return commentMap;
  }

  Future<(bool, int)> toggleImageLike(
      String albumID, String imageID, bool currentStatus) async {
    late bool userLiked;
    late int newCount;

    if (albumMap[albumID]?.imageMap[imageID] != null) {
      Image image;
      if (currentStatus) {
        newCount = await EngagementService.unlikePhoto(user.token, imageID);
        userLiked = false;
      } else {
        newCount = await EngagementService.likePhoto(user.token, imageID);
        userLiked = true;
      }

      // Update Repo Store
      image = albumMap[albumID]!.imageMap[imageID]!;

      image.userLiked = userLiked;
      image.likes = newCount;
      albumMap[albumID]!.imageMap[imageID] = image;

      ImageChange imageChange =
          ImageChange(albumID: albumID, imageID: imageID, image: image);
      _imageController.add(imageChange);
      return (userLiked, newCount);
    }

    //Return to Image Cubit
    newCount = 0;
    userLiked = false;
    return (userLiked, newCount);
  }

  Future<(bool, int)> toggleImageUpvote(
      String albumID, String imageID, bool currentStatus) async {
    late bool userUpvoted;
    late int newCount;

    if (albumMap[albumID]?.imageMap[imageID] != null) {
      Image image;
      if (currentStatus) {
        newCount =
            await EngagementService.removeUpvoteFromPhoto(user.token, imageID);
        userUpvoted = false;
      } else {
        newCount = await EngagementService.upvotePhoto(user.token, imageID);
        userUpvoted = true;
      }

      // Update Repo Store
      image = albumMap[albumID]!.imageMap[imageID]!;

      image.userUpvoted = userUpvoted;
      image.upvotes = newCount;
      albumMap[albumID]!.imageMap[imageID] = image;

      ImageChange imageChange =
          ImageChange(albumID: albumID, imageID: imageID, image: image);
      _imageController.add(imageChange);
      return (userUpvoted, newCount);
    }

    //Return to Image Cubit
    newCount = 0;
    userUpvoted = false;
    return (userUpvoted, newCount);
  }

  void _handleImageEngagement(EngagementNotification notification) {
    print("hello");
    switch (notification.notificationType) {
      case EngageType.liked:
        // TODO: Handle this case.
        return;
      case EngageType.upvoted:
        String imageID = notification.notificationMediaID;
        String albumID = notification.albumID;
        EngageOperation operation = notification.operation;

        if (albumMap[albumID]?.imageMap[imageID] == null) return;

        Image image = albumMap[albumID]!.imageMap[imageID]!;

        switch (operation) {
          case EngageOperation.add:
            // Add the upvote to the upvote count
            image.upvotes++;

            // Check if the person who upvote is in the list - if not then add
            if (image.upvotesUID
                .any((element) => element.uid != notification.notifierID)) {
              String uid = notification.notifierID;
              String firstName = notification.notifierFirst;
              String lastName = notification.notifierLast;
              Engager engager =
                  Engager(uid: uid, firstName: firstName, lastName: lastName);

              image.upvotesUID.add(engager);
            }

            // Add the image back to the global cache
            albumMap[albumID]?.imageMap[imageID] = image;

            // Preapre the ImageChange class for the image stream to update
            ImageChange imageChange =
                ImageChange(albumID: albumID, imageID: imageID, image: image);
            _imageController.add(imageChange);

            return;
          case EngageOperation.remove:
          // TODO: Handle this case.
        }
    }
  }
}
