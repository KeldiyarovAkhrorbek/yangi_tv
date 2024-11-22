import 'package:blur/blur.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:yangi_tv_new/bloc/blocs/app_blocs.dart';
import 'package:yangi_tv_new/models/profile.dart';
import 'package:yangi_tv_new/models/tariff.dart';
import 'package:yangi_tv_new/ui/views/profile/fill_balance/fill_balance_page.dart';
import 'package:yangi_tv_new/ui/widgets/tariff/premium_tariff_item.dart';

import '../../../../bloc/blocs/app_events.dart';
import '../../../../bloc/blocs/app_states.dart';
import '../../../../bloc/repos/mainrepository.dart';
import '../../../../helpers/color_changer.dart';
import '../active_tariffs/active_tariffs_page.dart';

class TariffsPage extends StatefulWidget {
  static const routeName = '/tarif-page';

  @override
  State<TariffsPage> createState() => _TariffsPageState();
}

class _TariffsPageState extends State<TariffsPage> {
  String tariff_filter = '';
  List<String> images = [];
  List<List<String>> partitionImages = [];

  @override
  void initState() {
    super.initState();
    for (int i = 1; i <= 100; i++) {
      images.add('${i}');
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    tariff_filter = args['tariff_filter'] ?? '';
    partitionImages = images.slices(10).toList();
  }

  void openConfirmPaymentDialog(
      Profile profile, Tariff tariff, TariffBloc tariffBloc) {
    showModalBottomSheet(
      context: context,
      barrierColor: Colors.transparent,
      shape: LinearBorder(),
      backgroundColor: Colors.black,
      isScrollControlled: true,
      builder: (_) {
        return BlocConsumer<TariffBloc, TariffState>(
          bloc: tariffBloc,
          listener: (context, state) async {},
          builder: (context, state) {
            if (state is TariffSuccessState)
              return SingleChildScrollView(
                child: Stack(
                  children: [
                    Container(
                      width: double.infinity,
                      height: 400,
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
                          "Tarif sotib olish",
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
                        Builder(
                          builder: (_) {
                            //insufficient balance
                            if (tariff.cost > profile.balance ||
                                (state.errorText != null &&
                                    state.errorText!.contains('yetarli')))
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SvgPicture.asset(
                                      'assets/icons/tariff/ic_money.svg'),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Text(
                                    "«${tariff.name}» tarifi uchun\nhisobingizda mablag’ yetarli emas!",
                                    style: GoogleFonts.montserrat(
                                      textStyle: TextStyle(
                                        color: HexColor('#FF0000'),
                                        fontWeight: FontWeight.w700,
                                        fontSize: 15,
                                      ),
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    "Balans: ${profile.balance.toInt()} UZS",
                                    style: GoogleFonts.montserrat(
                                      textStyle: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 13,
                                      ),
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 20.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
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
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 40.0),
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
                                            Navigator.of(context)
                                              ..pop()
                                              ..pushNamed(
                                                  FillBalancePage.routeName,
                                                  arguments: {
                                                    'userID': profile.id,
                                                  });
                                          },
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 20.0),
                                            child: Text(
                                              "Balansni to'ldirish",
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
                              );

                            //unexpected error
                            if (state.errorText != null)
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    height: 50,
                                  ),
                                  Text(
                                    "Qandaydir muammo yuzaga keldi!",
                                    style: GoogleFonts.montserrat(
                                      textStyle: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 15,
                                      ),
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  SizedBox(
                                    height: 50,
                                  ),
                                  Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 20.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
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
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 20.0),
                                            child: Text(
                                              'Oynani yopish',
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
                                  ),
                                ],
                              );

                            //buying tariff
                            if (state.isBuyingTariff)
                              return Padding(
                                padding: EdgeInsets.only(top: 8.0),
                                child: Center(
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                  ),
                                ),
                              );

                            //tariff bought
                            if (state.boughtTariff)
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SvgPicture.asset(
                                    'assets/icons/tariff/ic_tariff_bought.svg',
                                    height: 70,
                                    width: 70,
                                  ),
                                  SizedBox(
                                    height: 30,
                                  ),
                                  Text(
                                    "Tabriklaymiz! Siz «${tariff.name}»\ntarifini sotib oldingiz!",
                                    style: GoogleFonts.montserrat(
                                      textStyle: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 15,
                                      ),
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  SizedBox(
                                    height: 50,
                                  ),
                                  Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 20.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        RawMaterialButton(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(10),
                                            ),
                                          ),
                                          fillColor: HexColor('#FF4747'),
                                          onPressed: () {
                                            //show active tariff
                                            Navigator.of(context).pop();
                                            Navigator.of(context).pushNamed(
                                                ActiveTariffsPage.routeName);
                                          },
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 20.0),
                                            child: Text(
                                              "Faol tariflarni ko’rish",
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
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 20.0),
                                            child: Text(
                                              'Oynani yopish',
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
                                  ),
                                ],
                              );

                            //buy
                            if (tariff.cost <= profile.balance)
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    height: 30,
                                  ),
                                  Text(
                                    "«${tariff.name}» tarifini sotib olishni\ntasdiqlaysizmi?",
                                    style: GoogleFonts.montserrat(
                                      textStyle: TextStyle(
                                        color: HexColor('#FF0000'),
                                        fontWeight: FontWeight.w700,
                                        fontSize: 15,
                                      ),
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  SizedBox(
                                    height: 50,
                                  ),
                                  Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 20.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
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
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 40.0),
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
                                            //confirmation
                                            tariffBloc
                                              ..add(BuyTariffEvent(tariff));
                                          },
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 40.0),
                                            child: Text(
                                              "Ha, albatta!",
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
                              );

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(
                                  height: 50,
                                ),
                                Text(
                                  "Qandaydir xatolik yuzaga keldi!",
                                  style: GoogleFonts.montserrat(
                                    textStyle: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 15,
                                    ),
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(
                                  height: 50,
                                ),
                                Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 20.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
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
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 20.0),
                                          child: Text(
                                            'Oynani yopish',
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
                                ),
                              ],
                            );
                          },
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
            return Container();
          },
        );
      },
    ).then(
      (value) {
        tariffBloc..add(ChangeDefaultBuyTariffEvent());
      },
    );
  }

  final ScrollController scrollController = ScrollController();
  bool show = false;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          TariffBloc(RepositoryProvider.of<MainRepository>(context))
            ..add(GetTariffsEvent(tariff_filter)),
      child: BlocConsumer<TariffBloc, TariffState>(
        listener: (context, state) async {},
        builder: (context, state) {
          return SafeArea(
            child: Scaffold(
              backgroundColor: Colors.black,
              extendBodyBehindAppBar: true,
              appBar: PreferredSize(
                preferredSize: Size.fromHeight(45),
                child: AppBar(
                  automaticallyImplyLeading: false,
                  surfaceTintColor: Colors.transparent,
                  backgroundColor: Colors.transparent,
                  centerTitle: true,
                  iconTheme: IconThemeData(
                    color: Colors.white,
                  ),
                  leading: Padding(
                    padding: EdgeInsets.only(
                      left: 10.0,
                      right: 10.0,
                      top: 6.0,
                      bottom: 6.0,
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black,
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
                            Navigator.of(context).maybePop();
                          },
                          child: Center(
                            child: Icon(
                              Icons.arrow_back_ios_new,
                              color: Colors.white,
                              size: 18,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  flexibleSpace: AnimatedContainer(
                    duration: Duration(milliseconds: 500),
                    width: double.infinity,
                    height: double.infinity,
                    color: show ? Colors.black : Colors.transparent,
                  ),
                  title: Text(
                    "Tarif sotib olish",
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
              body: Builder(
                builder: (_) {
                  scrollController.addListener(() {
                    if (scrollController.position.pixels > 50) {
                      show = true;
                    } else
                      show = false;
                    setState(() {});
                  });

                  return Stack(
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
                      if (state is TariffLoadingState)
                        Center(
                          child: CircularProgressIndicator(
                            color: Colors.white,
                          ),
                        ),
                      if (state is TariffSuccessState)
                        SingleChildScrollView(
                          controller: scrollController,
                          child: Column(
                            children: [
                              SizedBox(
                                height: 60,
                              ),
                              ListView.separated(
                                shrinkWrap: true,
                                physics: PageScrollPhysics(),
                                padding: EdgeInsets.zero,
                                separatorBuilder: (context, index) => SizedBox(
                                  height: 10,
                                ),
                                itemBuilder: (context, index) {
                                  if (!state.tariffs[index].name
                                      .toLowerCase()
                                      .contains(tariff_filter.toLowerCase())) {
                                    return SizedBox();
                                  }

                                  if (state.tariffs[index].name
                                      .toLowerCase()
                                      .contains('prem'))
                                    return PremiumTariffItem(
                                      tariff: state.tariffs[index],
                                      index: index % partitionImages.length,
                                      buyPressed: () {
                                        openConfirmPaymentDialog(
                                          state.profile,
                                          state.tariffs[index],
                                          BlocProvider.of<TariffBloc>(context),
                                        );
                                      },
                                      movies: partitionImages[
                                          index % partitionImages.length],
                                    );
                                  return PremiumTariffItem(
                                    tariff: state.tariffs[index],
                                    index: index % partitionImages.length,
                                    buyPressed: () {
                                      openConfirmPaymentDialog(
                                        state.profile,
                                        state.tariffs[index],
                                        BlocProvider.of<TariffBloc>(context),
                                      );
                                    },
                                    movies: partitionImages[
                                        index % partitionImages.length],
                                    isAnime: true,
                                  );
                                },
                                itemCount: state.tariffs.length,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                            ],
                          ),
                        ),
                    ],
                  );

                  return Container();
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
