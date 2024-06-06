import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:yangi_tv_new/bloc/blocs/app_states.dart';
import 'package:yangi_tv_new/ui/views/profile/tariffs_page/tariffs_page.dart';
import 'package:yangi_tv_new/ui/widgets/active_tariff/active_tariff_item.dart';

import '../../../../bloc/blocs/app_blocs.dart';
import '../../../../bloc/blocs/app_events.dart';
import '../../../../bloc/repos/mainrepository.dart';
import '../../../../helpers/color_changer.dart';

class ActiveTariffsPage extends StatefulWidget {
  static const routeName = '/active-tariffs-page';

  @override
  State<ActiveTariffsPage> createState() => _ActiveTariffsPageState();
}

class _ActiveTariffsPageState extends State<ActiveTariffsPage> {
  final ScrollController scrollController = ScrollController();
  bool show = false;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          ActiveTariffsBloc(RepositoryProvider.of<MainRepository>(context))
            ..add(GetActiveTariffsEvent()),
      child: BlocConsumer<ActiveTariffsBloc, ActiveTariffState>(
        listener: (context, state) {},
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
                    "Faol tariflar",
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
                    if (state is ActiveTariffLoadingState) {
                      return Center(
                        child: CircularProgressIndicator(
                          color: Colors.white,
                        ),
                      );
                    }
                    if (state is ActiveTariffSuccessState) {
                      if (state.active_tariffs.isNotEmpty)
                        return SingleChildScrollView(
                          controller: scrollController,
                          child: Column(
                            children: [
                              SizedBox(
                                height: 20,
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 10.0),
                                child: ListView.separated(
                                  shrinkWrap: true,
                                  physics: PageScrollPhysics(),
                                  separatorBuilder: (context, index) => SizedBox(
                                    height: 15,
                                  ),
                                  itemBuilder: (context, index) =>
                                      ActiveTariffItem(
                                    state.active_tariffs[index],
                                  ),
                                  itemCount: state.active_tariffs.length,
                                ),
                              )
                            ],
                          ),
                        );
                      return Container(
                        width: double.infinity,
                        height: double.infinity,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              'assets/icons/tariff/ic_buy_tariff.svg',
                            ),
                            SizedBox(
                              height: 16,
                            ),
                            Text(
                              "Sizda hali faol tariflar mavjud emas!\nFilm va seriallar tomosha qilish\ntarif reja sotib olishingiz kerak!",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.montserrat(
                                textStyle: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            RawMaterialButton(
                              shape: RoundedRectangleBorder(
                                side: BorderSide(
                                  color: Colors.white,
                                  width: 2,
                                ),
                              ),
                              fillColor: Colors.white.withOpacity(0.2),
                              onPressed: () {
                                Navigator.of(context)
                                  ..pop()
                                  ..pushNamed(TariffsPage.routeName,
                                      arguments: {'tariff_filter': ''});
                              },
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 20.0),
                                child: Text(
                                  'Tarif sotib olish',
                                  style: GoogleFonts.montserrat(
                                    textStyle: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                    return Container();
                  }),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
