part of './data_repository.dart';

enum ImageChangeKey { userLikedUpdate, likeCountUpdate }

extension ImageDataRepo on DataRepository {
  //Below function is only being used for uploading all images to an album - this is the old version, should delete
  Future<List<CapturedImage>> addImagesToAlbum(
      List<CapturedImage> imagesToUpload) async {
    List<CapturedImage> failedUploads = [];

    for (int i = 0; i < imagesToUpload.length; i++) {
      CapturedImage image = imagesToUpload[i];

      if (image.albumID == null) {
        failedUploads.add(image);
        continue;
      }

      if (albumMap[image.albumID!] == null) {
        failedUploads.add(image);
        continue;
      }

      String albumID = image.albumID!;

      Photo? uploadedImage;
      (uploadedImage, _) =
          await ImageService.postCapturedImageData(user.token, image);
      if (uploadedImage == null) {
        failedUploads.add(image);
        continue;
      }

      imagesToUpload.removeAt(i);

      Map<String, Photo> albumImages = albumMap[albumID]!.imageMap;
      albumImages[uploadedImage.imageId] = uploadedImage;

      ImageChange change = ImageChange(
        albumID: albumID,
        imageID: uploadedImage.imageId,
        image: uploadedImage,
      );

      _imageController.add(change);

      i--;
    }
    return failedUploads;
  }

  Future<(bool, String?)> addOneImageToAlbum(CapturedImage image) async {
    if (image.albumID == null) {
      return (false, "Image not associated to album");
    }

    if (albumMap[image.albumID!] == null) {
      return (false, "Album does not exist");
    }

    String albumID = image.albumID!;
    bool success = false;
    String? error;

    (success, error) = await ImageService.uploadPhoto(
      user.token,
      image.imageXFile.path,
      image.uuid,
      image.uploadStatusController,
    );

    if (!success) return (success, error);

    Photo? uploadedImage;
    (uploadedImage, _) = await ImageService.postCapturedImageData(
      user.token,
      image,
    );
    if (uploadedImage == null) {
      return (false, "Image data failed");
    }

    Map<String, Photo> albumImages = albumMap[albumID]!.imageMap;
    albumImages[uploadedImage.imageId] = uploadedImage;

    ImageChange change = ImageChange(
      albumID: albumID,
      imageID: uploadedImage.imageId,
      image: uploadedImage,
    );

    _albumController.add((StreamOperation.update, albumMap[albumID]!));
    _imageController.add(change);
    return (true, null);
  }

  Future<(bool, String?)> uploadFailedImage(CapturedImage image) async {
    if (image.albumID == null) {
      return (false, "Image not associated to album");
    }

    if (albumMap[image.albumID!] == null) {
      return (false, "Album does not exist");
    }

    String albumID = image.albumID!;
    //bool success = false;
    //String? error;

    Photo? uploadedImage;
    (uploadedImage, _) = await ImageService.postCapturedImageData(
      user.token,
      image,
    );
    if (uploadedImage == null) {
      return (false, "Image data failed");
    }

    Map<String, Photo> albumImages = albumMap[albumID]!.imageMap;
    albumImages[uploadedImage.imageId] = uploadedImage;

    ImageChange change = ImageChange(
      albumID: albumID,
      imageID: uploadedImage.imageId,
      image: uploadedImage,
    );

    _imageController.add(change);
    return (true, null);
  }

  Future<(bool, String?)> moveImageToAlbum(
      String imageID, String newAlbum, String oldAlbum) async {
    if (albumMap[oldAlbum] == null || albumMap[newAlbum] == null) {
      return (false, "Could not find albums");
    }

    bool success;
    String? error;

    (success, error) =
        await ImageService.moveImageToAlbum(user.token, imageID, newAlbum);

    if (success) {
      Photo foundImage = albumMap[oldAlbum]!
          .images
          .firstWhere((image) => image.imageId == imageID);

      // Remove Image from Old Album
      albumMap[oldAlbum]!.imageMap.remove(foundImage.imageId);

      // Add Image to New Album
      albumMap[newAlbum]!.imageMap[foundImage.imageId] = foundImage;
      _albumController.add((StreamOperation.update, albumMap[oldAlbum]!));
      _albumController.add((StreamOperation.update, albumMap[newAlbum]!));
      return (true, null);
    } else {
      return (false, error);
    }
  }

  Future<(bool, String?)> deleteImageFromAlbum(
      String imageID, String albumID) async {
    if (albumMap[albumID] == null) {
      return (false, "Could not find album");
    }

    if (!albumMap[albumID]!.imageMap.containsKey(imageID)) {
      albumMap[albumID]!.imageMap.remove(imageID);
      _albumController.add((StreamOperation.update, albumMap[albumID]!));
      return (true, null);
    }

    bool success;
    String? error;

    (success, error) = await ImageService.deletePhoto(user.token, imageID);
    if (success) {
      albumMap[albumID]!.imageMap.remove(imageID);
      _albumController.add((StreamOperation.update, albumMap[albumID]!));
      return (true, null);
    } else {
      return (false, error);
    }
  }

  // Initalize and Coordinate Storage of Comments
  Future<(Map<String, Comment>, String?)> initalizeCommentsAndStore(
      String albumID, String imageID) async {
    Map<String, Comment> commentMap = {};
    String? error;

    if (albumMap[albumID]?.imageMap[imageID] != null) {
      if (albumMap[albumID]!.imageMap[imageID]!.commentMap.isEmpty) {
        // Fetch List from Service
        List<Comment> imageComments = [];

        (imageComments, error) =
            await EngagementService.getImageComments(user.token, imageID);

        // Transform List to Map
        commentMap = {
          for (Comment comment in imageComments) comment.id: comment,
        };

        albumMap[albumID]!.imageMap[imageID]!.commentMap = commentMap;

        return (commentMap, error);
      } else {
        return (albumMap[albumID]!.imageMap[imageID]!.commentMap, error);
      }
    }
    return (commentMap, error);
  }

  Future<(Comment?, String?)> addCommentToImage(
      String albumID, String imageID, String comment) async {
    Comment? postedComment;
    String? error;

    (postedComment, error) =
        await EngagementService.postNewComment(user.token, imageID, comment);

    if (postedComment == null) return (postedComment, error);

    if (albumMap[albumID]?.imageMap[imageID] != null) {
      Photo image = albumMap[albumID]!.imageMap[imageID]!;

      image.commentMap[postedComment.id] = postedComment;
    }

    return (postedComment, error);
  }

  Future<(bool, int, String?)> toggleImageLike(
      String albumID, String imageID, bool currentStatus) async {
    late bool userLiked;
    late int newCount;
    String? error;

    if (albumMap[albumID]?.imageMap[imageID] != null) {
      Photo image;
      if (currentStatus) {
        (newCount, error) =
            await EngagementService.unlikePhoto(user.token, imageID);
        userLiked = false;
      } else {
        (newCount, error) =
            await EngagementService.likePhoto(user.token, imageID);
        userLiked = true;
      }

      if (error != null) {
        return (false, 0, error);
      }

      // Update Repo Store
      image = albumMap[albumID]!.imageMap[imageID]!;

      image.userLiked = userLiked;
      image.likes = newCount;
      albumMap[albumID]!.imageMap[imageID] = image;

      ImageChange imageChange =
          ImageChange(albumID: albumID, imageID: imageID, image: image);
      _imageController.add(imageChange);
      return (userLiked, newCount, error);
    }

    //Return to Image Cubit
    newCount = 0;
    userLiked = false;
    return (userLiked, newCount, error);
  }

  Future<(bool, int, String?)> toggleImageUpvote(
      String albumID, String imageID, bool currentStatus) async {
    late bool userUpvoted;
    late int newCount;
    String? error;

    if (albumMap[albumID]?.imageMap[imageID] != null) {
      Photo image;
      if (currentStatus) {
        (newCount, error) =
            await EngagementService.removeUpvoteFromPhoto(user.token, imageID);
        userUpvoted = false;
      } else {
        (newCount, error) =
            await EngagementService.upvotePhoto(user.token, imageID);
        userUpvoted = true;
      }

      if (error != null) {
        return (false, 0, error);
      }

      // Update Repo Store
      image = albumMap[albumID]!.imageMap[imageID]!;

      image.userUpvoted = userUpvoted;
      image.upvotes = newCount;
      albumMap[albumID]!.imageMap[imageID] = image;

      ImageChange imageChange =
          ImageChange(albumID: albumID, imageID: imageID, image: image);
      _imageController.add(imageChange);
      return (userUpvoted, newCount, error);
    }

    //Return to Image Cubit
    newCount = 0;
    userUpvoted = false;
    return (userUpvoted, newCount, error);
  }

  void _handleImageComment(CommentNotification notification) {
    switch (notification.operation) {
      case EngageOperation.add:
        Comment comment = Comment.fromCommentNotification(notification);

        String albumID = notification.albumID;
        String imageID = notification.notificationMediaID;

        if (albumMap[albumID]?.imageMap[imageID] != null) {
          Photo image = albumMap[albumID]!.imageMap[imageID]!;

          image.commentMap[comment.id] = comment;

          ImageChange imageChange =
              ImageChange(albumID: albumID, imageID: imageID, image: image);
          _imageController.add(imageChange);
        }
        return;
      case EngageOperation.remove:
      // TODO: Handle this case.
      case EngageOperation.update:
      // TODO: Handle this case.
    }
  }

  void _handleImageEngagement(EngagementNotification notification) {
    switch (notification.notificationType) {
      case EngageType.liked:
        String imageID = notification.notificationMediaID;
        String albumID = notification.albumID;
        EngageOperation operation = notification.operation;

        if (albumMap[albumID]?.imageMap[imageID] == null) return;

        Photo image = albumMap[albumID]!.imageMap[imageID]!;

        switch (operation) {
          case EngageOperation.add:
            // Add the upvote to the upvote count
            image.likes = notification.newCount;

            // Check if the person who upvote is in the list - if not then add
            if (image.upvotesUID
                .any((element) => element.uid != notification.notifierID)) {
              String uid = notification.notifierID;
              String firstName = notification.notifierFirst;
              String lastName = notification.notifierLast;
              Engager engager =
                  Engager(uid: uid, firstName: firstName, lastName: lastName);

              image.likesUID.add(engager);
            }

            // Add the image back to the global cache
            albumMap[albumID]?.imageMap[imageID] = image;

            // Preapre the ImageChange class for the image stream to update
            ImageChange imageChange =
                ImageChange(albumID: albumID, imageID: imageID, image: image);
            _imageController.add(imageChange);
            return;
          case EngageOperation.remove:
            image.likes = notification.newCount;
            image.likesUID.removeWhere(
                (element) => element.uid == notification.notifierID);

            // Add the image back to the global cache
            albumMap[albumID]?.imageMap[imageID] = image;

            // Preapre the ImageChange class for the image stream to update
            ImageChange imageChange =
                ImageChange(albumID: albumID, imageID: imageID, image: image);
            _imageController.add(imageChange);
            return;
          case EngageOperation.update:
          // TODO: Handle this case.
        }
      case EngageType.upvoted:
        String imageID = notification.notificationMediaID;
        String albumID = notification.albumID;
        EngageOperation operation = notification.operation;

        if (albumMap[albumID]?.imageMap[imageID] == null) return;

        Photo image = albumMap[albumID]!.imageMap[imageID]!;

        switch (operation) {
          case EngageOperation.add:
            // Add the upvote to the upvote count
            image.upvotes = notification.newCount;

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
            image.upvotes = notification.newCount;
            image.upvotesUID.removeWhere(
                (element) => element.uid == notification.notifierID);

            // Add the image back to the global cache
            albumMap[albumID]?.imageMap[imageID] = image;

            // Preapre the ImageChange class for the image stream to update
            ImageChange imageChange =
                ImageChange(albumID: albumID, imageID: imageID, image: image);
            _imageController.add(imageChange);
            return;
          case EngageOperation.update:
          // TODO: Handle this case.
        }
    }
  }
}
