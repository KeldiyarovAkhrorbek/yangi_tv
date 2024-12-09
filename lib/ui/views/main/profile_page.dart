import 'dart:io';

import 'package:blur/blur.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:yangi_tv_new/bloc/blocs/app_blocs.dart';
import 'package:yangi_tv_new/bloc/blocs/app_states.dart';
import 'package:yangi_tv_new/helpers/color_changer.dart';
import 'package:yangi_tv_new/ui/views/landing/landing_page.dart';
import 'package:yangi_tv_new/ui/views/profile/active_tariffs/active_tariffs_page.dart';
import 'package:yangi_tv_new/ui/views/profile/downloads/downloads_page.dart';
import 'package:yangi_tv_new/ui/views/profile/fill_balance/fill_balance_page.dart';
import 'package:yangi_tv_new/ui/views/profile/orders/orders_page.dart';
import 'package:yangi_tv_new/ui/views/profile/payment_history/payment_history_page.dart';
import 'package:yangi_tv_new/ui/views/profile/session/session_page.dart';
import 'package:yangi_tv_new/ui/views/profile/tariffs_page/tariffs_page.dart';
import 'package:yangi_tv_new/ui/widgets/dialog/tryAgainDialog.dart';

import '../../../bloc/blocs/app_events.dart';
import '../../../bloc/repos/mainrepository.dart';
import '../../../helpers/constants.dart';

class ProfilePage extends StatefulWidget {
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String versionNumber = '1';
  final InAppReview inAppReview = InAppReview.instance;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    getVersion();
  }

  void getVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    versionNumber = packageInfo.version;
  }

  void openLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierColor: Colors.transparent,
      barrierDismissible: true,
      builder: (_) {
        return Scaffold(
          backgroundColor: Colors.transparent,
          body: Container(
            height: double.infinity,
            width: double.infinity,
            padding: EdgeInsets.symmetric(
              horizontal: 10,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(),
                Stack(
                  children: [
                    Blur(
                      blur: 7,
                      blurColor: HexColor('#4D4D4D').withOpacity(1),
                      child: Container(
                        width: double.infinity,
                        child: SizedBox(
                          height: 250,
                        ),
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      height: 250,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                          100,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 20,
                          ),
                          SvgPicture.asset(
                              'assets/icons/profile/ic_logout.svg'),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            "Rostdan ham profildan chiqmoqchimisiz?\n\n Ilovadan foydalanish uchun yana qayta kirishingizga to'g'ri keladi.",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.montserrat(
                              textStyle: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 15,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 50.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                RawMaterialButton(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(10),
                                    ),
                                  ),
                                  fillColor: Colors.white,
                                  onPressed: () {
                                    Navigator.of(context).maybePop();
                                  },
                                  child: Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 20.0),
                                    child: Text(
                                      'Bekor qilish',
                                      style: GoogleFonts.inter(
                                        textStyle: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                RawMaterialButton(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(10),
                                    ),
                                  ),
                                  fillColor: HexColor('#FF4747'),
                                  onPressed: () {
                                    BlocProvider.of<ProfileBloc>(context).add(
                                      LogoutProfileEvent(),
                                    );
                                    Navigator.of(context)
                                        .pushNamedAndRemoveUntil(
                                            LandingPage.routeName,
                                            (route) => false);
                                  },
                                  child: Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 20.0),
                                    child: Text(
                                      'Ha, albatta!',
                                      style: GoogleFonts.inter(
                                        textStyle: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                SizedBox(),
              ],
            ),
          ),
        );
      },
    );
  }

  void openNoTariffOrderDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierColor: Colors.transparent,
      barrierDismissible: true,
      builder: (_) {
        return Scaffold(
          backgroundColor: Colors.transparent,
          body: Container(
            height: double.infinity,
            width: double.infinity,
            padding: EdgeInsets.symmetric(
              horizontal: 10,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(),
                Stack(
                  children: [
                    Blur(
                      blur: 7,
                      blurColor: HexColor('#4D4D4D').withOpacity(1),
                      child: Container(
                        width: double.infinity,
                        child: SizedBox(
                          height: 250,
                        ),
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      height: 250,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                          100,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 20,
                          ),
                          SvgPicture.asset('assets/icons/watch/ic_warning.svg'),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            "Buyurtma qoldirish faqat «Premium»\ntarifini sotib olgan foydalanuvchilar uchun!",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.montserrat(
                              textStyle: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 15,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 50.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                RawMaterialButton(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(10),
                                    ),
                                  ),
                                  fillColor: HexColor('#FF4747'),
                                  onPressed: () {
                                    Navigator.of(context).maybePop();
                                  },
                                  child: Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 20.0),
                                    child: Text(
                                      'Tushundim',
                                      style: GoogleFonts.inter(
                                        textStyle: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                SizedBox(),
              ],
            ),
          ),
        );
      },
    );
  }

  final ScrollController scrollController = ScrollController();
  bool show = false;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          ProfileBloc(RepositoryProvider.of<MainRepository>(context))
            ..add(GetProfileEvent()),
      child: BlocConsumer<ProfileBloc, ProfileState>(
        listener: (context, state) {
          if (state is ProfileErrorState)
            openTryAgainDialog(context, () {
              BlocProvider.of<ProfileBloc>(context)..add(GetProfileEvent());
            });
        },
        builder: (context, state) {
          scrollController.addListener(() {
            if (scrollController.position.pixels > 50) {
              show = true;
            } else
              show = false;
            setState(() {});
          });
          return SafeArea(
            child: RefreshIndicator(
              color: Colors.black,
              onRefresh: () async {
                BlocProvider.of<ProfileBloc>(context)..add(GetProfileEvent());
              },
              child: Scaffold(
                resizeToAvoidBottomInset: true,
                backgroundColor: Colors.black,
                extendBodyBehindAppBar: true,
                appBar: PreferredSize(
                  preferredSize: Size.fromHeight(40),
                  child: AppBar(
                    automaticallyImplyLeading: false,
                    surfaceTintColor: Colors.transparent,
                    backgroundColor: Colors.transparent,
                    centerTitle: true,
                    flexibleSpace: AnimatedContainer(
                      duration: Duration(milliseconds: 500),
                      width: double.infinity,
                      height: double.infinity,
                      color: show ? Colors.black : Colors.transparent,
                    ),
                    title: Text(
                      "Profil bo'limi",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.roboto(
                        textStyle: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w400,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),
                body: Stack(
                  children: [
                    Image.asset(
                      'assets/images/profile_background.png',
                      height: double.infinity,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                    Container(
                      height: double.infinity,
                      width: double.infinity,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black.withOpacity(
                              0.8,
                            ),
                            Colors.black,
                          ],
                        ),
                      ),
                    ),
                    Builder(builder: (_) {
                      if (state is ProfileLoadingState)
                        return Center(
                          child: CircularProgressIndicator(
                            color: Colors.white,
                          ),
                        );
                      if (state is ProfileSuccessState)
                        return SingleChildScrollView(
                          controller: scrollController,
                          physics: BouncingScrollPhysics(),
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 3.0),
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 60,
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(
                                      15,
                                    ),
                                    border: Border.all(
                                      color: Colors.white,
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex: 3,
                                        child: Center(
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                              30,
                                            ),
                                            child: FancyShimmerImage(
                                              imageUrl: state.profile.photo,
                                              width: 100,
                                              height: 100,
                                              boxFit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 7,
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                            left: 1,
                                            right: 10,
                                            top: 20,
                                            bottom: 20,
                                          ),
                                          child: Column(
                                            children: [
                                              Container(
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                    10,
                                                  ),
                                                  color: HexColor('#959595')
                                                      .withOpacity(0.2),
                                                ),
                                                padding: EdgeInsets.symmetric(
                                                  horizontal: 10,
                                                  vertical: 5,
                                                ),
                                                child: Row(
                                                  children: [
                                                    Text(
                                                      'Ismingiz: ',
                                                      style: GoogleFonts.roboto(
                                                        textStyle: TextStyle(
                                                          color: HexColor(
                                                              '#9A9A9A'),
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          fontSize: 13,
                                                        ),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      flex: 1,
                                                      child: Text(
                                                        state.profile.name
                                                            .toString(),
                                                        style:
                                                            GoogleFonts.roboto(
                                                          textStyle: TextStyle(
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            fontSize: 13,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(
                                                height: 7,
                                              ),
                                              Container(
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                    10,
                                                  ),
                                                  color: HexColor('#959595')
                                                      .withOpacity(0.2),
                                                ),
                                                padding: EdgeInsets.symmetric(
                                                  horizontal: 10,
                                                  vertical: 5,
                                                ),
                                                child: Row(
                                                  children: [
                                                    Text(
                                                      'Telefon raqam: ',
                                                      style: GoogleFonts.roboto(
                                                        textStyle: TextStyle(
                                                          color: HexColor(
                                                              '#9A9A9A'),
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          fontSize: 13,
                                                        ),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      flex: 1,
                                                      child: Text(
                                                        state.profile.login,
                                                        style:
                                                            GoogleFonts.roboto(
                                                          textStyle: TextStyle(
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            fontSize: 13,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(
                                                height: 7,
                                              ),
                                              Container(
                                                padding: EdgeInsets.only(
                                                  left: 10,
                                                  right: 6,
                                                  top: 5,
                                                  bottom: 5,
                                                ),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                    10,
                                                  ),
                                                  color: HexColor('#959595')
                                                      .withOpacity(0.2),
                                                ),
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      'Balans: ',
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: GoogleFonts.roboto(
                                                        textStyle: TextStyle(
                                                          color: HexColor(
                                                              '#9A9A9A'),
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          fontSize: 13,
                                                        ),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      flex: 1,
                                                      child: Text(
                                                        "${state.profile.balance.toInt()}\ UZS",
                                                        maxLines: 1,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style:
                                                            GoogleFonts.roboto(
                                                          textStyle: TextStyle(
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            fontSize: 13,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(
                                                height: 7,
                                              ),
                                              GestureDetector(
                                                onTap: () async {
                                                  await Clipboard.setData(
                                                      ClipboardData(
                                                          text: state.profile.id
                                                              .toString()));
                                                  Fluttertoast.showToast(
                                                      msg: "ID nusxalandi!",
                                                      toastLength:
                                                          Toast.LENGTH_SHORT,
                                                      gravity:
                                                          ToastGravity.BOTTOM,
                                                      timeInSecForIosWeb: 1,
                                                      backgroundColor:
                                                          Colors.grey,
                                                      textColor: Colors.white,
                                                      fontSize: 16.0);
                                                },
                                                child: Container(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 10,
                                                      vertical: 5),
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                      10,
                                                    ),
                                                    color: HexColor('#959595')
                                                        .withOpacity(0.2),
                                                  ),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Text(
                                                            'ID: ',
                                                            maxLines: 1,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style: GoogleFonts
                                                                .roboto(
                                                              textStyle:
                                                                  TextStyle(
                                                                color: HexColor(
                                                                    '#9A9A9A'),
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                fontSize: 13,
                                                              ),
                                                            ),
                                                          ),
                                                          Text(
                                                            state.profile.id
                                                                .toString(),
                                                            maxLines: 1,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style: GoogleFonts
                                                                .roboto(
                                                              textStyle:
                                                                  TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                fontSize: 13,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      Icon(
                                                        Icons.copy,
                                                        size: 15,
                                                        color: Colors.white,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),

                                buildAction(
                                  icon: 'assets/icons/profile/ic_wallet.svg',
                                  title: "Balansni to'ldirish",
                                  color: '#FFFFFF',
                                  pressed: () {
                                    fillBalancePressed(
                                        context, state.profile.id);
                                  },
                                ),

                                buildAction(
                                  icon: 'assets/icons/profile/ic_buy.svg',
                                  title: "Tarif sotib olish",
                                  color: '#FFFFFF',
                                  pressed: buyTariffPressed,
                                ),

                                buildAction(
                                  icon: 'assets/icons/profile/ic_bought.svg',
                                  title: "Sotib olingan, faol tariflar",
                                  color: '#FFFFFF',
                                  pressed: activeTariffPressed,
                                ),

                                buildAction(
                                  icon: 'assets/icons/profile/ic_calendar.svg',
                                  title: "To'lovlar tarixi",
                                  color: '#FFFFFF',
                                  pressed: paymentHistoryPressed,
                                ),

                                buildAction(
                                  icon: 'assets/icons/profile/ic_order.svg',
                                  title: "Buyurtmalar stoli",
                                  color: "#22a848",
                                  pressed: () {
                                    orderTablePressed(
                                        state.profile.expireTariff);
                                  },
                                ),

                                buildAction(
                                  icon: 'assets/icons/profile/ic_download.svg',
                                  title: "Yuklangan film va seriallar",
                                  color: '#FFE600',
                                  pressed: downloadsPressed,
                                ),
                                // buildAction(
                                //   icon: 'assets/icons/profile/ic_card.svg',
                                //   title: "Mening kartalarim",
                                //   color: '#FFFFFF',
                                //   pressed: cardsPressed,
                                // ),
                                buildAction(
                                  icon: 'assets/icons/profile/ic_gift.svg',
                                  title: "Promokod kiritish",
                                  color: '#FFFFFF',
                                  pressed: promocodePressed,
                                ),
                                buildAction(
                                  icon: 'assets/icons/profile/ic_device.svg',
                                  title: "Faol qurilmalar",
                                  color: '#FFFFFF',
                                  pressed: activeDevicesPressed,
                                ),
                                buildAction(
                                  icon: 'assets/icons/profile/ic_exit.svg',
                                  title: "Profildan chiqish",
                                  color: '#E82C2A',
                                  pressed: () {
                                    exitProfilePressed(context);
                                  },
                                  drawLine: false,
                                ),
                                Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 8.0),
                                  child: Container(
                                    width: double.infinity,
                                    height: 1,
                                    color: Colors.white,
                                  ),
                                ),
                                // buildAction(
                                //   icon: 'assets/icons/profile/ic_setting.svg',
                                //   title: "Sozlamalar",
                                //   color: '#FFFFFF',
                                //   pressed: settingsPressed,
                                // ),
                                buildAction(
                                  icon: 'assets/icons/profile/ic_enveloper.svg',
                                  title: "Biz bilan bog'lanish",
                                  color: '#FFFFFF',
                                  pressed: contactsPressed,
                                ),
                                buildAction(
                                  icon: 'assets/icons/profile/ic_star.svg',
                                  title: "Ilovani baholash",
                                  color: '#FFFFFF',
                                  pressed: ratePressed,
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      'Ilova versiyasi: ' + versionNumber,
                                      style: GoogleFonts.roboto(
                                        textStyle: TextStyle(
                                          color: HexColor('#525151'),
                                          fontWeight: FontWeight.w400,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                Container(
                                  height: 70,
                                  child: Row(
                                    children: [
                                      buildSocial(
                                        'assets/icons/social/ic_youtube.svg',
                                        ytPressed,
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      buildSocial(
                                        'assets/icons/social/ic_tiktok.svg',
                                        tkPressed,
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      buildSocial(
                                        'assets/icons/social/ic_instagram.svg',
                                        igPressed,
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      buildSocial(
                                        'assets/icons/social/ic_facebook.svg',
                                        fbPressed,
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      buildSocial(
                                        'assets/icons/social/ic_telegram.svg',
                                        tgPressed,
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 150,
                                ),
                              ],
                            ),
                          ),
                        );
                      return Container();
                    })
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget buildAction({
    required String icon,
    required String title,
    required String color,
    required VoidCallback pressed,
    bool drawLine = true,
  }) {
    return Container(
      child: Material(
        type: MaterialType.button,
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            pressed();
          },
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 10,
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            SvgPicture.asset(
                              icon,
                              color: HexColor(color),
                              width: 24,
                              height: 24,
                            ),
                            SizedBox(
                              width: 25,
                            ),
                            Text(
                              title,
                              style: GoogleFonts.roboto(
                                textStyle: TextStyle(
                                  color: HexColor(color),
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14,
                                ),
                              ),
                            )
                          ],
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          color: HexColor(color),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              if (drawLine)
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 0),
                  child: Container(
                    width: double.infinity,
                    height: 1,
                    color: Colors.white.withOpacity(0.3),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildSocial(String iconPath, VoidCallback pressed) {
    return Expanded(
      flex: 1,
      child: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white),
          borderRadius: BorderRadius.circular(
            15,
          ),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(
              15,
            ),
            onTap: () {
              pressed();
            },
            child: Padding(
              padding: EdgeInsets.all(
                10,
              ),
              child: Center(
                child: SvgPicture.asset(
                  iconPath,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void buyTariffPressed() {
    Navigator.of(context).pushNamed(TariffsPage.routeName, arguments: {
      "tariff_filter": null,
    });
  }

  void fillBalancePressed(BuildContext context, int userID) {
    Navigator.of(context).pushNamed(FillBalancePage.routeName, arguments: {
      'userID': userID,
    });
  }

  void paymentHistoryPressed() {
    Navigator.of(context).pushNamed(PaymentHistoryPage.routeName);
  }

  void activeTariffPressed() {
    Navigator.of(context).pushNamed(ActiveTariffsPage.routeName);
  }

  void orderTablePressed(String? tariff_expireAt) {
    if (tariff_expireAt == null) {
      openNoTariffOrderDialog(context);
      return;
    }
    Navigator.of(context).pushNamed(OrdersPage.routeName);
  }

  void downloadsPressed() {
    Navigator.of(context).pushNamed(DownloadsPage.routeName);
  }

  void cardsPressed() {}

  void promocodePressed() {
    openActivateDialog();
  }

  void activeDevicesPressed() {
    Navigator.of(context).pushNamed(SessionPage.routeName);
  }

  void exitProfilePressed(BuildContext blocContext) {
    openLogoutDialog(context);
  }

  void settingsPressed() {}

  void contactsPressed() async {
    await launchUrl(Uri.parse(Constants.telegram_contact),
        mode: LaunchMode.externalApplication);
  }

  void ratePressed() async {
    if (Platform.isIOS) {
      inAppReview.openStoreListing(
          appStoreId: "6448133913", microsoftStoreId: '...');
      return;
    }
    await launchUrl(Uri.parse('market://details?id=uz.yangi.app'));
  }

  void ytPressed() async {
    await launchUrl(Uri.parse(Constants.youtube),
        mode: LaunchMode.externalApplication);
  }

  void fbPressed() async {
    await launchUrl(Uri.parse(Constants.facebook),
        mode: LaunchMode.externalApplication);
  }

  void igPressed() async {
    await launchUrl(Uri.parse(Constants.instagram),
        mode: LaunchMode.externalApplication);
  }

  void tkPressed() async {
    await launchUrl(Uri.parse(Constants.tiktok),
        mode: LaunchMode.externalApplication);
  }

  void tgPressed() async {
    await launchUrl(Uri.parse(Constants.telegram),
        mode: LaunchMode.externalApplication);
  }

  var errorColor = HexColor('#FF0000');
  var simpleColor = Colors.white;
  FocusNode promocodeFocusnode = FocusNode();
  TextEditingController promocodeController = TextEditingController();

  void openActivateDialog() {
    showModalBottomSheet(
      context: context,
      barrierColor: Colors.transparent,
      shape: LinearBorder(),
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) {
        return BlocConsumer<PromocodeBloc, PromocodeState>(
          listener: (context, state) {},
          builder: (context, state) {
            Color getColor() {
              if (state is PromocodeErrorState) return errorColor;
              return simpleColor;
            }

            Color getColorBorder() {
              if (state is PromocodeErrorState) return errorColor;
              return simpleColor;
            }

            if (state is PromocodeLoadingState)
              return SingleChildScrollView(
                child: Stack(
                  children: [
                    Container(
                      width: double.infinity,
                      height: 350,
                      color: Colors.transparent,
                    ).blurred(
                      blur: 20,
                      blurColor: HexColor('#4D4D4D'),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Divider(
                          height: 0.5,
                          color: HexColor('#4D4D4D'),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          "Promokod kiritish:",
                          style: GoogleFonts.montserrat(
                            textStyle: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Center(
                          child: CircularProgressIndicator(
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );

            if (state is PromocodeInitialState || state is PromocodeErrorState)
              return SingleChildScrollView(
                child: Stack(
                  children: [
                    Container(
                      width: double.infinity,
                      height: 350,
                      color: Colors.transparent,
                    ).blurred(
                      blur: 20,
                      blurColor: HexColor('#4D4D4D'),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Divider(
                          height: 0.5,
                          color: HexColor('#4D4D4D'),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          "Promokod kiritish:",
                          style: GoogleFonts.montserrat(
                            textStyle: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            left: 20,
                            right: 20,
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              color: HexColor('#535353'),
                              borderRadius: BorderRadius.circular(
                                10,
                              ),
                              border: Border.all(
                                color: getColorBorder(),
                              ),
                            ),
                            child: Padding(
                              padding: EdgeInsets.only(
                                left: 0,
                                top: 0,
                                bottom: 0,
                              ),
                              child: TextField(
                                focusNode: promocodeFocusnode,
                                controller: promocodeController,
                                cursorColor: Colors.white,
                                style: TextStyle(
                                  color: getColor(),
                                ),
                                onChanged: (value) {
                                  BlocProvider.of<PromocodeBloc>(context).add(
                                    DefaultPromocodeEvent(),
                                  );
                                },
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.only(top: 12),
                                  border: InputBorder.none,
                                  hintText: 'Promokod...',
                                  hintStyle: TextStyle(
                                    color: getColor(),
                                  ),
                                  prefixIcon: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: SvgPicture.asset(
                                      'assets/icons/promocode/ic_promocode_gift.svg',
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          height: 70,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: 10,
                              ),
                              if (state is PromocodeErrorState)
                                Text(
                                  state.error,
                                  style: GoogleFonts.montserrat(
                                    textStyle: TextStyle(
                                      color: getColor(),
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              RawMaterialButton(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10),
                                  ),
                                ),
                                fillColor: Colors.white,
                                onPressed: () {
                                  Navigator.of(context).maybePop();
                                },
                                child: Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 40.0),
                                  child: Text(
                                    'Bekor qilish',
                                    style: GoogleFonts.inter(
                                      textStyle: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              RawMaterialButton(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10),
                                  ),
                                ),
                                fillColor: HexColor('#FF4747'),
                                onPressed: () {
                                  BlocProvider.of<PromocodeBloc>(context)
                                    ..add(ActivatePromocodeEvent(
                                        promocodeController.text));
                                },
                                child: Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 60.0),
                                  child: Text(
                                    "Kiritish",
                                    style: GoogleFonts.inter(
                                      textStyle: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                            padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).viewInsets.bottom + 30,
                        )),
                      ],
                    ),
                  ],
                ),
              );

            if (state is PromocodeSuccessState)
              return SingleChildScrollView(
                child: Stack(
                  children: [
                    Container(
                      width: double.infinity,
                      height: 350,
                      color: Colors.transparent,
                    ).blurred(
                      blur: 5,
                      blurColor: HexColor('#4D4D4D'),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Divider(
                          height: 0.5,
                          color: HexColor('#4D4D4D'),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          "Promokod kiritish:",
                          style: GoogleFonts.montserrat(
                            textStyle: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Center(
                          child: SvgPicture.asset(
                            'assets/icons/tariff/ic_tariff_bought.svg',
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Center(
                          child: Text(
                            'Tabriklaymiz! Siz kiritgan\npromokod faollashdi!',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.montserrat(
                              textStyle: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 40,
                        ),
                        RawMaterialButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(10),
                            ),
                          ),
                          fillColor: Colors.white,
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 60.0),
                            child: Text(
                              "Rahmat!",
                              style: GoogleFonts.inter(
                                textStyle: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );

            return Container();
          },
        );
      },
    ).then((value) {
      BlocProvider.of<PromocodeBloc>(context)..add(DefaultPromocodeEvent());
      promocodeFocusnode.unfocus();
      promocodeController.text = '';
    });
  }
}
