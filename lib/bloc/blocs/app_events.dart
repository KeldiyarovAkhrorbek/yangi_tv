import 'package:background_downloader/background_downloader.dart';
import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';
import 'package:yangi_tv_new/models/db/database_task.dart';
import 'package:yangi_tv_new/models/tariff.dart';

///login
///login
///login
@immutable
abstract class LoginEvent extends Equatable {
  const LoginEvent();
}

//change error
class ChangeErrorEvent extends LoginEvent {
  final String type;

  const ChangeErrorEvent(
    this.type,
  );

  @override
  List<Object?> get props => [];
}

class SendOtpEvent extends LoginEvent {
  final String unmasked;

  const SendOtpEvent(
    this.unmasked,
  );

  @override
  List<Object?> get props => [];
}

class ResendOtpEvent extends LoginEvent {
  @override
  List<Object?> get props => [];
}

class CheckOtpEvent extends LoginEvent {
  final String otp;

  const CheckOtpEvent({
    required this.otp,
  });

  @override
  List<Object?> get props => [];
}

class CheckOtpDeleteSessionEvent extends LoginEvent {
  @override
  List<Object?> get props => [];
}

class RemoveSessionEvent extends LoginEvent {
  final String token;

  const RemoveSessionEvent(
    this.token,
  );

  @override
  List<Object?> get props => [];
}

class ChangeNameEvent extends LoginEvent {
  final String name;

  const ChangeNameEvent(
    this.name,
  );

  @override
  List<Object?> get props => [];
}

///testToken
///testToken
///testToken
@immutable
abstract class TestEvent extends Equatable {
  const TestEvent();
}

class TestTokenEvent extends TestEvent {
  @override
  List<Object?> get props => [];
}

///banner and category ///main
///banner and category ///main
///banner and category ///main
@immutable
abstract class MainEvent extends Equatable {
  const MainEvent();
}

class GetMainEvent extends MainEvent {
  @override
  List<Object?> get props => [];
}

class WatchStoryEvent extends MainEvent {
  final int story_id;

  WatchStoryEvent(this.story_id);

  @override
  List<Object?> get props => [];
}

///genre
///genre
///genre
@immutable
abstract class GenreEvent extends Equatable {
  const GenreEvent();
}

class GetGenresEvent extends GenreEvent {
  @override
  List<Object?> get props => [];
}

///genre-detail
///genre-detail
///genre-detail
@immutable
abstract class GenreDetailEvent extends Equatable {
  const GenreDetailEvent();
}

class GetGenreDetailEvent extends GenreDetailEvent {
  final int genre_id;

  GetGenreDetailEvent({
    required this.genre_id,
  });

  @override
  List<Object?> get props => [];
}

class PaginateGenreDetailEvent extends GenreDetailEvent {
  @override
  List<Object?> get props => [];
}

///category-detail
///category-detail
///category-detail
@immutable
abstract class CategoryDetailEvent extends Equatable {
  const CategoryDetailEvent();
}

class GetCategoryDetailEvent extends CategoryDetailEvent {
  final int category_id;

  GetCategoryDetailEvent({
    required this.category_id,
  });

  @override
  List<Object?> get props => [];
}

class PaginateCategoryDetailEvent extends CategoryDetailEvent {
  @override
  List<Object?> get props => [];
}

///favorites
///favorites
///favorites
@immutable
abstract class FavoritesEvent extends Equatable {
  const FavoritesEvent();
}

class GetFavoritesEvent extends FavoritesEvent {
  @override
  List<Object?> get props => [];
}

class PaginateFavoritesEvent extends FavoritesEvent {
  @override
  List<Object?> get props => [];
}

///movie_detail
///movie_detail
///movie_detail
@immutable
abstract class MovieDetailEvent extends Equatable {
  const MovieDetailEvent();
}

class LoadMovieDetailEvent extends MovieDetailEvent {
  final int content_id;

  LoadMovieDetailEvent(this.content_id);

  @override
  List<Object?> get props => [];
}

class LoadMovieUrlEvent extends MovieDetailEvent {
  final String downloadType;

  LoadMovieUrlEvent(this.downloadType);

  @override
  List<Object?> get props => [];
}

class AddToFavoriteEvent extends MovieDetailEvent {
  AddToFavoriteEvent();

  @override
  List<Object?> get props => [];
}

class PutReactionEvent extends MovieDetailEvent {
  final String reaction;

  PutReactionEvent(this.reaction);

  @override
  List<Object?> get props => [];
}

///person-detail
///person-detail
///person-detail
@immutable
abstract class PersonDetailEvent extends Equatable {
  const PersonDetailEvent();
}

class GetPersonDetailEvent extends PersonDetailEvent {
  final int person_id;

  GetPersonDetailEvent({
    required this.person_id,
  });

  @override
  List<Object?> get props => [];
}

class PaginatePersonDetailEvent extends PersonDetailEvent {
  @override
  List<Object?> get props => [];
}

///search
///search
///search
@immutable
abstract class SearchEvent extends Equatable {
  const SearchEvent();
}

class GetSearchEvent extends SearchEvent {
  final String search_text;

  GetSearchEvent({
    required this.search_text,
  });

  @override
  List<Object?> get props => [];
}

class PaginateSearchEvent extends SearchEvent {
  @override
  List<Object?> get props => [];
}

///profile
///profile
///profile
@immutable
abstract class ProfileEvent extends Equatable {
  const ProfileEvent();
}

class GetProfileEvent extends ProfileEvent {
  @override
  List<Object?> get props => [];
}

class LogoutProfileEvent extends ProfileEvent {
  @override
  List<Object?> get props => [];
}

///session
///session
///session
@immutable
abstract class SessionEvent extends Equatable {
  const SessionEvent();
}

class GetSessionEvent extends SessionEvent {
  @override
  List<Object?> get props => [];
}

class LogoutSessionEvent extends SessionEvent {
  final String token;

  LogoutSessionEvent(this.token);

  @override
  List<Object?> get props => [];
}

///payment
///payment
///payment
@immutable
abstract class PaymentEvent extends Equatable {
  const PaymentEvent();
}

class GetUrlEvent extends PaymentEvent {
  final String method;
  final int userID;
  final int? amount;

  GetUrlEvent(this.method, this.userID, this.amount);

  @override
  List<Object?> get props => [];
}

class ChangePaymentErrorEvent extends PaymentEvent {
  @override
  List<Object?> get props => [];
}

///tariff
///tariff
///tariff
@immutable
abstract class TariffsEvent extends Equatable {
  const TariffsEvent();
}

class GetTariffsEvent extends TariffsEvent {
  final String tariffFilter;

  GetTariffsEvent(this.tariffFilter);

  @override
  List<Object?> get props => [];
}

class BuyTariffEvent extends TariffsEvent {
  final Tariff tariff;

  BuyTariffEvent(this.tariff);

  @override
  List<Object?> get props => [];
}

class ChangeDefaultBuyTariffEvent extends TariffsEvent {
  @override
  List<Object?> get props => [];
}

///active_tariff
///active_tariff
///active_tariff
@immutable
abstract class ActiveTariffsEvent extends Equatable {
  const ActiveTariffsEvent();
}

class GetActiveTariffsEvent extends ActiveTariffsEvent {
  @override
  List<Object?> get props => [];
}

///promocode
///promocode
///promocode
@immutable
abstract class PromocodeEvent extends Equatable {
  const PromocodeEvent();
}

class ActivatePromocodeEvent extends PromocodeEvent {
  String promocode;

  ActivatePromocodeEvent(this.promocode);

  @override
  List<Object?> get props => [];
}

class DefaultPromocodeEvent extends PromocodeEvent {
  @override
  List<Object?> get props => [];
}

///payment-history
///payment-history
///payment-history
@immutable
abstract class PaymentHistoryEvent extends Equatable {
  const PaymentHistoryEvent();
}

class GetPaymentHistoryEvent extends PaymentHistoryEvent {
  @override
  List<Object?> get props => [];
}

class PaginatePaymentHistoryEvent extends PaymentHistoryEvent {
  @override
  List<Object?> get props => [];
}

///comment
///comment
///comment
@immutable
abstract class CommentEvent extends Equatable {
  const CommentEvent();
}

class GetCommentEvent extends CommentEvent {
  final int content_id;

  GetCommentEvent(this.content_id);

  @override
  List<Object?> get props => [];
}

class AddCommentEvent extends CommentEvent {
  final int content_id;
  final String text;

  AddCommentEvent(this.content_id, this.text);

  @override
  List<Object?> get props => [];
}

class PaginateCommentEvent extends CommentEvent {
  @override
  List<Object?> get props => [];
}

///download
///download
///download
@immutable
abstract class DownloadEvent extends Equatable {
  const DownloadEvent();
}

class SetTasksEvent extends DownloadEvent {
  List<DatabaseTask> tasks;

  SetTasksEvent(this.tasks);

  @override
  List<Object?> get props => [
        tasks,
      ];
}

class DownloadTaskStatusUpdateEvent extends DownloadEvent {
  final TaskStatusUpdate update;

  DownloadTaskStatusUpdateEvent(this.update);

  @override
  List<Object?> get props => [
        update,
      ];
}

class DownloadTaskProgressUpdateEvent extends DownloadEvent {
  final TaskProgressUpdate update;

  DownloadTaskProgressUpdateEvent(this.update);

  @override
  List<Object?> get props => [
    update,
  ];
}

class LoadAllDownloadTasksEvent extends DownloadEvent {
  @override
  List<Object?> get props => [];
}

class UpdateDownloadsEvent extends DownloadEvent {
  @override
  List<Object?> get props => [];
}

class ResumeTaskEvent extends DownloadEvent {
  final String taskId;

  ResumeTaskEvent(this.taskId);

  @override
  List<Object?> get props => [];
}

class PauseTaskEvent extends DownloadEvent {
  final String taskId;

  PauseTaskEvent(this.taskId);

  @override
  List<Object?> get props => [];
}

class DeleteTaskEvent extends DownloadEvent {
  final String taskId;

  DeleteTaskEvent(this.taskId);

  @override
  List<Object?> get props => [];
}

class AddDownloadEvent extends LoadAllDownloadTasksEvent {
  final String movie_name;
  final String name;
  final String displayName;
  final String image;
  final String url;
  final String? seasonName;
  final bool is_multi;
  final String tariff;

  AddDownloadEvent({
    required this.movie_name,
    required this.name,
    required this.displayName,
    required this.image,
    required this.url,
    required this.seasonName,
    required this.is_multi,
    required this.tariff,
  });

  @override
  List<Object?> get props => [];
}

///collection
///collection
///collection
@immutable
abstract class CollectionEvent extends Equatable {
  const CollectionEvent();
}

class GetCollectionsEvent extends CollectionEvent {
  @override
  List<Object?> get props => [];
}

class PaginateCollectionEvent extends CollectionEvent {
  @override
  List<Object?> get props => [];
}

///collection-detail
///collection-detail
///collection-detail
@immutable
abstract class CollectionDetailEvent extends Equatable {
  const CollectionDetailEvent();
}

class GetCollectionDetailEvent extends CollectionDetailEvent {
  final int collection_id;

  GetCollectionDetailEvent({
    required this.collection_id,
  });

  @override
  List<Object?> get props => [];
}

class PaginateCollectionDetailEvent extends CollectionDetailEvent {
  @override
  List<Object?> get props => [];
}

///cast
///cast
///cast
@immutable
abstract class CastEvent extends Equatable {
  const CastEvent();
}

class GetCastDevicesEvent extends CastEvent {
  @override
  List<Object?> get props => [];
}

//Orders
//Orders
//Orders
@immutable
abstract class OrdersEvent extends Equatable {
  const OrdersEvent();
}

class LoadOrdersEvent extends OrdersEvent {
  LoadOrdersEvent();

  @override
  List<Object?> get props => [];
}

class AddOrderEvent extends OrdersEvent {
  final String name;
  final String year;

  AddOrderEvent(this.name, this.year);

  @override
  List<Object?> get props => [];
}

class PaginateOrdersEvent extends OrdersEvent {
  PaginateOrdersEvent();

  @override
  List<Object?> get props => [];
}

class ChangeOrderNameErrorEvent extends OrdersEvent {
  final String? errorName;

  ChangeOrderNameErrorEvent(this.errorName);

  @override
  List<Object?> get props => [];
}

class ChangeOrderYearErrorEvent extends OrdersEvent {
  final String? errorYear;

  ChangeOrderYearErrorEvent(this.errorYear);

  @override
  List<Object?> get props => [];
}
