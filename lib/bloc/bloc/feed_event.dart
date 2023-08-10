// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'feed_bloc.dart';

abstract class FeedEvent extends Equatable {
  const FeedEvent();

  @override
  List<Object> get props => [];
}

class FeedDataRequested extends FeedEvent {
  final int index;
  const FeedDataRequested({
    required this.index,
  });
}

class FeedDataFetched extends FeedEvent {}

class FeedDataFailed extends FeedEvent {}
