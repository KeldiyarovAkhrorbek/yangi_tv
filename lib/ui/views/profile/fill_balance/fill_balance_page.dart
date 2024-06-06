import 'package:blur/blur.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:yangi_tv_new/ui/widgets/payment/item_payment.dart';

import '../../../../bloc/blocs/app_blocs.dart';
import '../../../../bloc/blocs/app_events.dart';
import '../../../../bloc/blocs/app_states.dart';
import '../../../../helpers/color_changer.dart';

class FillBalancePage extends StatefulWidget {
  static const routeName = '/fill-balance-page';

  @override
  State<FillBalancePage> createState() => _FillBalancePageState();
}

class _FillBalancePageState extends State<FillBalancePage> {
  String currentPayment = '';
  int userID = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    userID = args['userID'] as int;
  }

  var errorColor = HexColor('#E30000');
  var successColor = HexColor('#00AA2E');
  var simpleColor = Colors.white;
  FocusNode paymentFocusNode = FocusNode();
  TextEditingController paymentController = TextEditingController();

  void openPaymentDialog(String payMethod) {
    showModalBottomSheet(
      context: context,
      barrierColor: Colors.transparent,
      shape: LinearBorder(),
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) {
        return BlocConsumer<PaymentBloc, PaymentState>(
          listener: (context, state) async {
            if (state is PaymentSuccessState) {
              Navigator.of(context).maybePop();
              BlocProvider.of<PaymentBloc>(context).add(
                ChangePaymentErrorEvent(),
              );
              await launchUrl(Uri.parse(state.link));
            }
          },
          builder: (context, state) {
            Color getColor() {
              if (state is PaymentInitialState) {
                return Colors.white;
              }
              return errorColor;
            }

            Color getColorBorder() {
              if (state is PaymentInitialState) {
                return simpleColor;
              }
              return errorColor;
            }

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
                        "To'lov tizimi tanlandi:",
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
                      Center(
                        child: Image.asset(
                          'assets/icons/payment/${payMethod}.png',
                          width: 100,
                          height: 50,
                        ),
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
                              focusNode: paymentFocusNode,
                              controller: paymentController,
                              cursorColor: Colors.white,
                              style: TextStyle(
                                color: getColor(),
                              ),
                              onChanged: (value) {
                                BlocProvider.of<PaymentBloc>(context).add(
                                  ChangePaymentErrorEvent(),
                                );
                              },
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Summani kiriting...',
                                hintStyle: TextStyle(
                                  color: getColor(),
                                ),
                                prefixIcon: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: SvgPicture.asset(
                                    'assets/icons/payment/ic_moneybag.svg',
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
                            Text(
                              state is PaymentErrorState ? state.errorText : '',
                              style: TextStyle(
                                color: getColor(),
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
                                padding: EdgeInsets.symmetric(horizontal: 40.0),
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
                                int? amount =
                                    int.tryParse(paymentController.text);
                                BlocProvider.of<PaymentBloc>(context)
                                  ..add(GetUrlEvent(
                                    payMethod,
                                    userID,
                                    amount,
                                  ));
                              },
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 40.0),
                                child: Text(
                                  "To'lov qilish",
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
          },
        );
      },
    ).then(
      (value) {
        setState(() {
          currentPayment = '';
        });
        BlocProvider.of<PaymentBloc>(context).add(ChangePaymentErrorEvent());
        paymentController.text = '';
      },
    );
  }

  void openPaynetDialog() {
    showModalBottomSheet(
      context: context,
      barrierColor: Colors.transparent,
      shape: LinearBorder(),
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) {
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
                    "To'lov tizimi tanlandi:",
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
                  Center(
                    child: Image.asset(
                      'assets/icons/payment/paynet.png',
                      width: 100,
                      height: 50,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30),
                    child: Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "1.",
                              style: GoogleFonts.montserrat(
                                textStyle: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Flexible(
                              child: Text.rich(
                                TextSpan(
                                  children: [
                                    TextSpan(
                                      text:
                                          "Paynet ilovasi yoki to’lov shahobchasidan ",
                                      style: GoogleFonts.montserrat(
                                        textStyle: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 14,
                                            letterSpacing: 0),
                                      ),
                                    ),
                                    TextSpan(
                                      text: "«Yangi TV» ",
                                      style: GoogleFonts.montserrat(
                                        textStyle: TextStyle(
                                            color: HexColor('#FF0000'),
                                            fontWeight: FontWeight.w600,
                                            fontSize: 14,
                                            letterSpacing: 0),
                                      ),
                                    ),
                                    TextSpan(
                                      text: "ilovasini tanlang.",
                                      style: GoogleFonts.montserrat(
                                        textStyle: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 14,
                                            letterSpacing: 0),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "2.",
                              style: GoogleFonts.montserrat(
                                textStyle: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Flexible(
                              child: Text.rich(
                                TextSpan(
                                  children: [
                                    TextSpan(
                                      text: "Ushbu ID raqamni kiriting:  ",
                                      style: GoogleFonts.montserrat(
                                        textStyle: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 14,
                                            letterSpacing: 0),
                                      ),
                                    ),
                                    TextSpan(
                                      text: userID.toString(),
                                      style: GoogleFonts.montserrat(
                                        textStyle: TextStyle(
                                            color: HexColor('#FF0000'),
                                            fontWeight: FontWeight.w600,
                                            fontSize: 14,
                                            letterSpacing: 0),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            IconButton(
                              onPressed: () async{
                                await Clipboard.setData(ClipboardData(text: userID.toString()));
                                Fluttertoast.showToast(
                                    msg: "ID nusxalandi!",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: Colors.grey,
                                    textColor: Colors.white,
                                    fontSize: 16.0
                                );
                              },
                              icon: Icon(
                                Icons.copy,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "3.",
                              style: GoogleFonts.montserrat(
                                textStyle: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Flexible(
                              child: Text.rich(
                                TextSpan(
                                  children: [
                                    TextSpan(
                                      text:
                                          "Summani kiriting va to'lovni amalga oshiring.",
                                      style: GoogleFonts.montserrat(
                                        textStyle: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 14,
                                            letterSpacing: 0),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
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
                            padding: EdgeInsets.symmetric(horizontal: 40.0),
                            child: Text(
                              'Ortga qaytish',
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
                  Padding(
                      padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom + 30,
                  )),
                ],
              ),
            ],
          ),
        );
      },
    ).then(
      (value) {
        setState(() {
          currentPayment = '';
        });
      },
    );
  }

  final ScrollController scrollController = ScrollController();
  bool show = false;

  @override
  Widget build(BuildContext context) {
    scrollController.addListener(() {
      if (scrollController.position.pixels > 50) {
        show = true;
      } else
        show = false;
      setState(() {});
    });
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
              "Hisobni to'ldirish",
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
            Container(
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 70,
                  ),
                  Text(
                    "To'lov tizimini tanlang:",
                    style: GoogleFonts.montserrat(
                      textStyle: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w400,
                        fontSize: 15,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 0),
                    child: GridView(
                      padding: EdgeInsets.zero,
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 1,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                      ),
                      children: [
                        ItemPayment(
                          currentPayment: currentPayment,
                          paymentName: 'payme',
                          iconPath: 'assets/icons/payment/payme.png',
                          isSvg: false,
                          pressed: () {
                            methodPressed('payme');
                          },
                        ),
                        ItemPayment(
                          currentPayment: currentPayment,
                          paymentName: 'click',
                          iconPath: 'assets/icons/payment/click.png',
                          isSvg: false,
                          pressed: () {
                            methodPressed('click');
                          },
                        ),
                        ItemPayment(
                          currentPayment: currentPayment,
                          paymentName: 'paynet',
                          iconPath: 'assets/icons/payment/paynet.png',
                          isSvg: false,
                          pressed: () {
                            methodPressed('paynet');
                          },
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void methodPressed(String method) {
    setState(() {
      currentPayment = method;
    });
    if (method == 'paynet') {
      openPaynetDialog();
      return;
    }
    openPaymentDialog(method);
  }
}
