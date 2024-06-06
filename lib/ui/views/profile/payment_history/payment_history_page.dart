import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:yangi_tv_new/bloc/blocs/app_blocs.dart';
import 'package:yangi_tv_new/bloc/blocs/app_states.dart';
import 'package:yangi_tv_new/ui/widgets/payment_history/payment_history_item_left.dart';
import 'package:yangi_tv_new/ui/widgets/payment_history/payment_history_item_right.dart';

import '../../../../bloc/blocs/app_events.dart';
import '../../../../bloc/repos/mainrepository.dart';

class PaymentHistoryPage extends StatefulWidget {
  static const routeName = '/payment-history-page';

  @override
  State<PaymentHistoryPage> createState() => _PaymentHistoryPageState();
}

class _PaymentHistoryPageState extends State<PaymentHistoryPage> {
  final ScrollController scrollController = ScrollController();
  bool show = false;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          PaymentHistoryBloc(RepositoryProvider.of<MainRepository>(context))
            ..add(GetPaymentHistoryEvent()),
      child: BlocConsumer<PaymentHistoryBloc, PaymentHistoryState>(
        listener: (context, state) {},
        builder: (context, state) {
          scrollController.addListener(() {
            if (scrollController.position.pixels > 50) {
              show = true;
            } else
              show = false;
            setState(() {});
          });

          scrollController.addListener(
            () async {
              if (state is PaymentHistorySuccessState && !state.isPaginating) {
                if (scrollController.position.pixels ==
                    scrollController.position.maxScrollExtent) {
                  BlocProvider.of<PaymentHistoryBloc>(context).add(
                    PaginatePaymentHistoryEvent(),
                  );
                }
              }
            },
          );
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
                    "To'lovlar tarixi",
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
                  Builder(
                    builder: (_) {
                      if (state is PaymentHistoryLoadingState)
                        return Center(
                          child: CircularProgressIndicator(
                            color: Colors.white,
                          ),
                        );

                      if (state is PaymentHistorySuccessState) {
                        if (state.historyList.isEmpty)
                          return Container(
                            width: double.infinity,
                            height: double.infinity,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SvgPicture.asset(
                                  'assets/icons/payment/ic_no_payment.svg',
                                  color: Colors.white,
                                  width: 100,
                                  height: 100,
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  "Sizda hali to'lovlar\nmavjud emas!",
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.roboto(
                                    textStyle: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 19,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );

                        return SingleChildScrollView(
                          controller: scrollController,
                          child: Column(
                            children: [
                              SizedBox(
                                height: 10,
                              ),
                              ListView.builder(
                                shrinkWrap: true,
                                physics: PageScrollPhysics(),
                                itemBuilder: (context, index) {
                                  if (state.historyList[index].status == 'debit')
                                    return PaymentHistoryItemLeft(
                                        state.historyList[index]);
                                  return PaymentHistoryItemRight(
                                      state.historyList[index]);
                                },
                                itemCount: state.historyList.length,
                              ),
                              if (state.isPaginating)
                                SizedBox(
                                  height: 10,
                                ),
                              if (state.isPaginating)
                                Center(
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                  ),
                                )
                            ],
                          ),
                        );
                      }

                      return Container();
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
