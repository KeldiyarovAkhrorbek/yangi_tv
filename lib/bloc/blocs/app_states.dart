import 'package:cast/device.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:yangi_tv_new/helpers/auth_state.dart';
import 'package:yangi_tv_new/models/Movie_Short.dart';
import 'package:yangi_tv_new/models/active_tariff.dart';
import 'package:yangi_tv_new/models/banner.dart';
import 'package:yangi_tv_new/models/category.dart';
import 'package:yangi_tv_new/models/collection_model.dart';
import 'package:yangi_tv_new/models/comment.dart';
import 'package:yangi_tv_new/models/db/database_task.dart';
import 'package:yangi_tv_new/models/genre.dart';
import 'package:yangi_tv_new/models/payment_history.dart';
import 'package:yangi_tv_new/models/profile.dart';
import 'package:yangi_tv_new/models/search.dart';
import 'package:yangi_tv_new/models/session.dart';
import 'package:yangi_tv_new/models/single_movie_url.dart';
import 'package:yangi_tv_new/models/story.dart';
import 'package:yangi_tv_new/models/tariff.dart';

import '../../models/movie_full.dart';
import '../../models/order_model.dart';
import '../../models/season.dart';

///login
///login
///login
@immutable
abstract class LoginState extends Equatable {}

class EnterPhoneNumberState extends LoginState {
  final bool isLoading;
  final String? errorText;

  EnterPhoneNumberState({
    required this.isLoading,
    required this.errorText,
  });

  @override
  List<Object?> get props => [
        isLoading,
        errorText,
      ];
}

class VerifyState extends LoginState {
  final bool isLoading;
  final String? errorText;

  VerifyState({
    required this.isLoading,
    required this.errorText,
  });

  @override
  List<Object?> get props => [
        isLoading,
        errorText,
      ];
}

class DeleteSessionState extends LoginState {
  final bool isLoading;
  final List<SessionModel> sessions;

  DeleteSessionState({
    required this.isLoading,
    required this.sessions,
  });

  @override
  List<Object?> get props => [
        isLoading,
        sessions,
      ];
}

class ChangeNameState extends LoginState {
  final bool isLoading;
  final String? errorText;

  ChangeNameState({
    required this.isLoading,
    required this.errorText,
  });

  @override
  List<Object?> get props => [
        isLoading,
        errorText,
      ];
}

class SuccessState extends LoginState {
  final bool shouldOpenCourses;

  SuccessState([this.shouldOpenCourses = false]);

  @override
  List<Object?> get props => [];
}

///testToken
///testToken
///testToken
@immutable
abstract class TestState extends Equatable {}

class TestTokenLoadingState extends TestState {
  @override
  List<Object?> get props => [];
}

class TestTokenDoneState extends TestState {
  final AuthState authState;
  final String? dangerousAppName;

  TestTokenDoneState({required this.authState, this.dangerousAppName});

  @override
  List<Object?> get props => [authState];
}

///banner and category ///main
///banner and category ///main
///banner and category ///main
@immutable
abstract class MainState extends Equatable {}

class MainLoadingState extends MainState {
  @override
  List<Object?> get props => [];
}

class MainSuccessState extends MainState {
  final List<BannerModel> banners;
  final List<Category> categories;
  final List<Story> stories;
  final List<Genre> genres;

  MainSuccessState({
    required this.banners,
    required this.categories,
    required this.stories,
    required this.genres,
  });

  @override
  List<Object?> get props => [
        banners,
        categories,
        stories,
      ];
}

class MainErrorState extends MainState {
  @override
  List<Object?> get props => [];
}

///genre
///genre
///genre
@immutable
abstract class GenreState extends Equatable {}

class GenreLoadingState extends GenreState {
  @override
  List<Object?> get props => [];
}

class GenreSuccessState extends GenreState {
  final List<Genre> genres;

  GenreSuccessState({
    required this.genres,
  });

  @override
  List<Object?> get props => [
        genres,
      ];
}

class GenreErrorState extends GenreState {
  @override
  List<Object?> get props => [];
}

///genre-detail
///genre-detail
///genre-detail
@immutable
abstract class GenreDetailState extends Equatable {}

class GenreDetailLoadingState extends GenreDetailState {
  @override
  List<Object?> get props => [];
}

class GenreDetailSuccessState extends GenreDetailState {
  final List<MovieShort> movies;
  final bool isPaginating;

  GenreDetailSuccessState({
    required this.movies,
    required this.isPaginating,
  });

  @override
  List<Object?> get props => [
        movies,
        isPaginating,
      ];
}

class GenreDetailErrorState extends GenreDetailState {
  @override
  List<Object?> get props => [];
}

///category-detail
///category-detail
///category-detail
@immutable
abstract class CategoryDetailState extends Equatable {}

class CategoryDetailLoadingState extends CategoryDetailState {
  @override
  List<Object?> get props => [];
}

class CategoryDetailSuccessState extends CategoryDetailState {
  final List<MovieShort> movies;
  final bool isPaginating;

  CategoryDetailSuccessState({
    required this.movies,
    required this.isPaginating,
  });

  @override
  List<Object?> get props => [
        movies,
        isPaginating,
      ];
}

class CategoryDetailErrorState extends CategoryDetailState {
  String errorText;

  CategoryDetailErrorState(this.errorText);

  @override
  List<Object?> get props => [errorText];
}

///favorites
///favorites
///favorites
@immutable
abstract class FavoritesState extends Equatable {}

class FavoritesLoadingState extends FavoritesState {
  @override
  List<Object?> get props => [];
}

class FavoritesSuccessState extends FavoritesState {
  final List<MovieShort> movies;
  final bool isPaginating;

  FavoritesSuccessState({
    required this.movies,
    required this.isPaginating,
  });

  @override
  List<Object?> get props => [
        movies,
        isPaginating,
      ];
}

class FavoritesErrorState extends FavoritesState {
  @override
  List<Object?> get props => [];
}

///movie_detail
///movie_detail
///movie_detail
@immutable
abstract class MovieDetailState extends Equatable {}

class MovieDetailLoadingState extends MovieDetailState {
  @override
  List<Object?> get props => [];
}

class MovieDetailLoadedState extends MovieDetailState {
  final MovieFull movie;
  final List<MovieShort> relatedMovies;
  final String? errorUrlText;

  final SingleMovieUrl? singleMovieURL;
  final List<Season> seasons;
  final bool isFavorite;
  final bool favoriteLoading;
  final bool isUrlWatchLoaded;
  final bool isUrlDownloadLoaded;
  final bool isUrlWatchLoading;
  final bool isUrlDownloadLoading;
  final String? reactionType;
  final int likeCount;
  final int dislikeCount;

  MovieDetailLoadedState({
    required this.movie,
    required this.relatedMovies,
    required this.errorUrlText,
    required this.isUrlWatchLoaded,
    required this.isUrlWatchLoading,
    required this.singleMovieURL,
    required this.seasons,
    required this.isFavorite,
    required this.isUrlDownloadLoaded,
    required this.isUrlDownloadLoading,
    required this.favoriteLoading,
    required this.reactionType,
    required this.likeCount,
    required this.dislikeCount,
  });

  @override
  List<Object?> get props => [
        movie,
        relatedMovies,
        errorUrlText,
        isUrlWatchLoaded,
        isUrlWatchLoading,
        singleMovieURL,
        seasons,
        isFavorite,
        favoriteLoading,
        isUrlDownloadLoading,
        reactionType,
        isUrlDownloadLoaded,
        likeCount,
        dislikeCount,
      ];
}

class MovieDetailErrorState extends MovieDetailState {
  final String error;

  MovieDetailErrorState(this.error);

  @override
  List<Object?> get props => [error];
}

///person-detail
///person-detail
///person-detail
@immutable
abstract class PersonDetailState extends Equatable {}

class PersonDetailLoadingState extends PersonDetailState {
  @override
  List<Object?> get props => [];
}

class PersonDetailSuccessState extends PersonDetailState {
  final List<MovieShort> movies;
  final bool isPaginating;

  PersonDetailSuccessState({
    required this.movies,
    required this.isPaginating,
  });

  @override
  List<Object?> get props => [
        movies,
        isPaginating,
      ];
}

class PersonDetailErrorState extends PersonDetailState {
  @override
  List<Object?> get props => [];
}

///search
///search
///search
@immutable
abstract class SearchState extends Equatable {}

class SearchLoadingState extends SearchState {
  @override
  List<Object?> get props => [];
}

class SearchSuccessState extends SearchState {
  final List<Search> movies;
  final bool isPaginating;

  SearchSuccessState({
    required this.movies,
    required this.isPaginating,
  });

  @override
  List<Object?> get props => [
        movies,
        isPaginating,
      ];
}

class SearchInitialState extends SearchState {
  @override
  List<Object?> get props => [];
}

class SearchErrorInsufficientState extends SearchState {
  @override
  List<Object?> get props => [];
}

class SearchErrorState extends SearchState {
  @override
  List<Object?> get props => [];
}

///profile
///profile
///profile
@immutable
abstract class ProfileState extends Equatable {}

class ProfileLoadingState extends ProfileState {
  @override
  List<Object?> get props => [];
}

class ProfileSuccessState extends ProfileState {
  final Profile profile;

  ProfileSuccessState({
    required this.profile,
  });

  @override
  List<Object?> get props => [
        profile,
      ];
}

class ProfileErrorState extends ProfileState {
  @override
  List<Object?> get props => [];
}

///session
///session
///session
@immutable
abstract class SessionState extends Equatable {}

class SessionLoadingState extends SessionState {
  @override
  List<Object?> get props => [];
}

class SessionSuccessState extends SessionState {
  final SessionModel current;
  final List<SessionModel> sessions;

  SessionSuccessState({
    required this.current,
    required this.sessions,
  });

  @override
  List<Object?> get props => [
        current,
        sessions,
      ];
}

class SessionErrorState extends SessionState {
  @override
  List<Object?> get props => [];
}

///payment
///payment
///payment
@immutable
abstract class PaymentState extends Equatable {}

class PaymentInitialState extends PaymentState {
  @override
  List<Object?> get props => [];
}

class PaymentSuccessState extends PaymentState {
  final String link;

  PaymentSuccessState({
    required this.link,
  });

  @override
  List<Object?> get props => [
        link,
      ];
}

class PaymentErrorState extends PaymentState {
  final String errorText;

  PaymentErrorState(this.errorText);

  @override
  List<Object?> get props => [];
}

///tariff
///tariff
///tariff
@immutable
abstract class TariffState extends Equatable {}

class TariffLoadingState extends TariffState {
  @override
  List<Object?> get props => [];
}

class TariffSuccessState extends TariffState {
  final List<Tariff> tariffs;
  final Profile profile;
  final bool isBuyingTariff;
  final String? errorText;
  final bool boughtTariff;

  TariffSuccessState({
    required this.tariffs,
    required this.profile,
    required this.isBuyingTariff,
    required this.errorText,
    required this.boughtTariff,
  });

  @override
  List<Object?> get props => [
        tariffs,
        profile,
        isBuyingTariff,
        errorText,
        boughtTariff,
      ];
}

class TariffErrorState extends TariffState {
  final String errorText;

  TariffErrorState(this.errorText);

  @override
  List<Object?> get props => [];
}

///active_tariff
///active_tariff
///active_tariff
@immutable
abstract class ActiveTariffState extends Equatable {}

class ActiveTariffLoadingState extends ActiveTariffState {
  @override
  List<Object?> get props => [];
}

class ActiveTariffSuccessState extends ActiveTariffState {
  final List<ActiveTariff> active_tariffs;

  ActiveTariffSuccessState({
    required this.active_tariffs,
  });

  @override
  List<Object?> get props => [
        active_tariffs,
      ];
}

class ActiveTariffErrorState extends ActiveTariffState {
  @override
  List<Object?> get props => [];
}

///promocode
///promocode
///promocode
@immutable
abstract class PromocodeState extends Equatable {}

class PromocodeInitialState extends PromocodeState {
  @override
  List<Object?> get props => [];
}

class PromocodeSuccessState extends PromocodeState {
  @override
  List<Object?> get props => [];
}

class PromocodeLoadingState extends PromocodeState {
  @override
  List<Object?> get props => [];
}

class PromocodeErrorState extends PromocodeState {
  String error;

  PromocodeErrorState(this.error);

  @override
  List<Object?> get props => [];
}

///payment-history
///payment-history
///payment-history
@immutable
abstract class PaymentHistoryState extends Equatable {}

class PaymentHistoryLoadingState extends PaymentHistoryState {
  @override
  List<Object?> get props => [];
}

class PaymentHistorySuccessState extends PaymentHistoryState {
  final List<PaymentHistory> historyList;
  final bool isPaginating;

  PaymentHistorySuccessState({
    required this.historyList,
    required this.isPaginating,
  });

  @override
  List<Object?> get props => [
        historyList,
        isPaginating,
      ];
}

class PaymentHistoryErrorState extends PaymentHistoryState {
  @override
  List<Object?> get props => [];
}

///comment
///comment
///comment
@immutable
abstract class CommentState extends Equatable {}

class CommentLoadingState extends CommentState {
  @override
  List<Object?> get props => [];
}

class CommentSuccessState extends CommentState {
  final List<Comment> comments;
  final bool isPaginating;
  final bool newComment;

  CommentSuccessState({
    required this.comments,
    required this.isPaginating,
    required this.newComment,
  });

  @override
  List<Object?> get props => [
        comments,
        isPaginating,
        newComment,
      ];
}

class CommentErrorState extends CommentState {
  @override
  List<Object?> get props => [];
}

///download
///download
///download
@immutable
abstract class DownloadState extends Equatable {}

class DownloadSuccessState extends DownloadState {
  final List<DatabaseTask> tasks;
  final DateTime time;

  DownloadSuccessState({
    required this.tasks,
    required this.time,
  });

  @override
  List<Object?> get props => [
        tasks,
        time,
      ];
}

///collection
///collection
///collection
@immutable
abstract class CollectionState extends Equatable {}

class CollectionLoadingState extends CollectionState {
  @override
  List<Object?> get props => [];
}

class CollectionSuccessState extends CollectionState {
  final List<CollectionModel> collections;
  final bool isPaginating;

  CollectionSuccessState({
    required this.collections,
    required this.isPaginating,
  });

  @override
  List<Object?> get props => [
        collections,
        isPaginating,
      ];
}

class CollectionErrorState extends CollectionState {
  @override
  List<Object?> get props => [];
}

///collection-detail
///collection-detail
///collection-detail
@immutable
abstract class CollectionDetailState extends Equatable {}

class CollectionDetailLoadingState extends CollectionDetailState {
  @override
  List<Object?> get props => [];
}

class CollectionDetailSuccessState extends CollectionDetailState {
  final List<MovieShort> movies;
  final bool isPaginating;

  CollectionDetailSuccessState({
    required this.movies,
    required this.isPaginating,
  });

  @override
  List<Object?> get props => [
        movies,
        isPaginating,
      ];
}

class CollectionDetailErrorState extends CollectionDetailState {
  @override
  List<Object?> get props => [];
}

///cast
///cast
///cast
@immutable
abstract class CastState extends Equatable {}

class CastLoadingState extends CastState {
  @override
  List<Object?> get props => [];
}

class CastSuccessState extends CastState {
  final List<CastDevice> devices;

  CastSuccessState({
    required this.devices,
  });

  @override
  List<Object?> get props => [
        devices,
      ];
}

class CastErrorState extends CastState {
  @override
  List<Object?> get props => [];
}

// orders
// orders
// orders
@immutable
abstract class OrdersState extends Equatable {}

class OrdersLoadingState extends OrdersState {
  @override
  List<Object?> get props => [];
}

class OrdersLoadedState extends OrdersState {
  final List<OrderModel> orders;
  final bool addingOrder;
  final bool isPaginating;
  final bool orderAdded;
  final String? errorName;
  final String? errorYear;

  OrdersLoadedState({
    required this.orders,
    required this.isPaginating,
    required this.addingOrder,
    required this.orderAdded,
    required this.errorName,
    required this.errorYear,
  });

  @override
  List<Object?> get props =>
      [orders, isPaginating, addingOrder, orderAdded, errorName, errorYear];
}

class OrdersErrorState extends OrdersState {
  @override
  List<Object?> get props => [];
}
