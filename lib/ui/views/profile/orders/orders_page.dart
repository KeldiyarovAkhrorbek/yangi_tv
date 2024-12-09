import 'package:blur/blur.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../bloc/blocs/app_blocs.dart';
import '../../../../bloc/blocs/app_events.dart';
import '../../../../bloc/blocs/app_states.dart';
import '../../../../bloc/repos/mainrepository.dart';
import '../../../../helpers/color_changer.dart';
import '../../../widgets/order_item.dart';

class OrdersPage extends StatefulWidget {
  static const routeName = '/orders-page';

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  var errorColor = HexColor('#E30000');
  var successColor = HexColor('#00AA2E');
  var simpleColor = Colors.white;
  FocusNode paymentFocusNode = FocusNode();
  final ScrollController scrollController = ScrollController();
  bool show = false;

  TextEditingController _nameController = TextEditingController();
  FocusNode _nameFocusNode = FocusNode();
  TextEditingController _yearController = TextEditingController();
  FocusNode _yearFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    scrollController.addListener(() {
      if (scrollController.position.pixels > 50) {
        show = true;
      } else
        show = false;
      setState(() {});
    });
    return BlocProvider<OrdersBloc>(
      create: (context) =>
          OrdersBloc(RepositoryProvider.of<MainRepository>(context))
            ..add(LoadOrdersEvent()),
      child: BlocConsumer<OrdersBloc, OrdersState>(
          listener: (context, state) {},
          builder: (context, state) {
            scrollController.addListener(
              () async {
                if (state is OrdersLoadedState) if (!state
                    .isPaginating) if (scrollController
                        .position.pixels ==
                    scrollController.position.maxScrollExtent) {
                  BlocProvider.of<OrdersBloc>(context).add(
                    PaginateOrdersEvent(),
                  );
                }
              },
            );
            return Scaffold(
              backgroundColor: Colors.black,
              extendBodyBehindAppBar: true,
              appBar: makeAppbar(),
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
                      if (state is OrdersLoadingState) {
                        return Center(
                          child: CircularProgressIndicator(
                            color: Colors.white,
                          ),
                        );
                      }

                      if (state is OrdersLoadedState) {
                        return Builder(
                          builder: (_) {
                            if (state.orders.length == 0) {
                              return Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 20.0),
                                    child: Divider(
                                      color: HexColor('#1E1E34'),
                                    ),
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SvgPicture.asset(
                                          'assets/icons/order/ic_order.svg'),
                                      SizedBox(
                                        height: 22,
                                      ),
                                      Text(
                                        'Hali sizda buyurtmalar\nmavjud emas',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w400,
                                          fontSize: 15,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                      SizedBox(
                                        height: 22,
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          color: Colors.white,
                                        ),
                                        child: Material(
                                          color: Colors.transparent,
                                          child: InkWell(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            splashColor: Colors.white60,
                                            onTap: () {
                                              openTakeOrderDialog(
                                                  context.read<OrdersBloc>());
                                            },
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(
                                                horizontal: 38,
                                                vertical: 13,
                                              ),
                                              child: Text(
                                                'Buyurtma berish',
                                                style: TextStyle(
                                                  fontSize: 15,
                                                  fontFamily: 'Inter',
                                                  fontWeight: FontWeight.w700,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(),
                                ],
                              );
                            }
                            return SingleChildScrollView(
                              controller: scrollController,
                              child: Column(
                                children: [
                                  Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 20),
                                    child: ListView.builder(
                                      shrinkWrap: true,
                                      padding: EdgeInsets.only(top: 130),
                                      physics: BouncingScrollPhysics(),
                                      itemBuilder: (context, index) {
                                        return OrderItem(state.orders[index]);
                                      },
                                      itemCount: state.orders.length,
                                    ),
                                  ),
                                  if (state.isPaginating)
                                    Container(
                                      child: Center(
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: Colors.white,
                                    ),
                                    child: Material(
                                      color: Colors.transparent,
                                      child: InkWell(
                                        borderRadius: BorderRadius.circular(20),
                                        splashColor: Colors.white60,
                                        onTap: () {
                                          openTakeOrderDialog(
                                              context.read<OrdersBloc>());
                                        },
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 38,
                                            vertical: 13,
                                          ),
                                          child: Text(
                                            'Buyurtma berish',
                                            style: TextStyle(
                                              fontSize: 15,
                                              fontFamily: 'Inter',
                                              fontWeight: FontWeight.w700,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 40,
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      }
                      return Container();
                    },
                  ),
                ],
              ),
            );
          }),
    );
  }

  void openTakeOrderDialog(OrdersBloc ordersBloc) {
    showModalBottomSheet(
      context: context,
      barrierColor: Colors.transparent,
      shape: LinearBorder(),
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) {
        return BlocConsumer<OrdersBloc, OrdersState>(
          bloc: ordersBloc,
          listener: (context, state) {
            if (state is OrdersLoadedState && state.orderAdded) {
              Navigator.of(context).maybePop();
              scrollController.jumpTo(0);
            }
          },
          builder: (context, state) {
            if (state is OrdersLoadedState)
              return SingleChildScrollView(
                child: Stack(
                  children: [
                    Container(
                      width: double.infinity,
                      height: 400,
                      color: Colors.transparent,
                    ).frosted(blur: 9, frostColor: HexColor('#4D4D4D')),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Divider(
                          height: 0.5,
                          color: HexColor('#4D4D4D'),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Text(
                          'Buyurtma berish',
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(
                          height: 40,
                        ),

                        //name
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.0),
                          child: TextField(
                            focusNode: _nameFocusNode,
                            controller: _nameController,
                            style: TextStyle(
                              color: state.errorName != null
                                  ? errorColor
                                  : Colors.white,
                              fontSize: 15,
                            ),
                            textAlign: TextAlign.start,
                            onChanged: (value) {
                              ordersBloc.add(ChangeOrderNameErrorEvent(null));
                            },
                            decoration: InputDecoration(
                              isDense: true,
                              filled: true,
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 10),
                              fillColor: Colors.black54,
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide:
                                    BorderSide(color: Colors.white, width: 2.0),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color: Colors.black54,
                                  width: 2.0,
                                ),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color: HexColor('#E30000'),
                                  width: 2.0,
                                ),
                              ),
                              errorText: state.errorName,
                              hintText: 'Kontent nomini kiriting',
                              hintStyle: TextStyle(
                                color: state.errorName != null
                                    ? errorColor
                                    : Colors.white,
                                fontSize: 15,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10),
                                ),
                              ),
                            ),
                          ),
                        ),

                        SizedBox(
                          height: 15,
                        ),

                        //year
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.0),
                          child: TextField(
                            focusNode: _yearFocusNode,
                            controller: _yearController,
                            style: TextStyle(
                              color: state.errorYear != null
                                  ? errorColor
                                  : Colors.white,
                              fontSize: 15,
                            ),
                            onChanged: (value) {
                              ordersBloc.add(ChangeOrderYearErrorEvent(null));
                            },
                            maxLength: 4,
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.start,
                            decoration: InputDecoration(
                              filled: true,
                              counterText: '',
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 10),
                              isDense: true,
                              fillColor: Colors.black54,
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide:
                                    BorderSide(color: Colors.white, width: 2.0),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color: Colors.black54,
                                  width: 2.0,
                                ),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color: errorColor,
                                  width: 2.0,
                                ),
                              ),
                              hintText: 'Yilni kiriting',
                              hintStyle: TextStyle(
                                color: state.errorYear != null
                                    ? errorColor
                                    : Colors.white,
                                fontSize: 15,
                              ),
                              errorText: state.errorYear,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(0.0),
                                ),
                              ),
                            ),
                          ),
                        ),

                        SizedBox(
                          height: 30,
                        ),

                        Padding(
                          padding: EdgeInsets.only(
                              bottom: MediaQuery.of(context).viewInsets.bottom +
                                  30),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.white,
                            ),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(20),
                                splashColor: Colors.white60,
                                onTap: state.addingOrder
                                    ? null
                                    : () async {
                                        if (_nameController.text.length < 4) {
                                          ordersBloc.add(ChangeOrderNameErrorEvent(
                                              "Minimum film nomi uzunligi: 4"));
                                          return;
                                        }

                                        DateTime nowDate = DateTime.now();
                                        int? yearInt =
                                            int.tryParse(_yearController.text);

                                        if (_yearController.text.length != 4 ||
                                            yearInt == null) {
                                          ordersBloc.add(ChangeOrderYearErrorEvent(
                                              'Yil 1000 va ${nowDate.year} orasida bo\'lishi shart'));
                                          return;
                                        }

                                        if (!(yearInt >= 1000 &&
                                            yearInt <= nowDate.year)) {
                                          ordersBloc.add(ChangeOrderYearErrorEvent(
                                              'Yil 1000 va ${nowDate.year} orasida bo\'lishi shart'));
                                          return;
                                        }

                                        ordersBloc.add(
                                          AddOrderEvent(_nameController.text,
                                              _yearController.text),
                                        );
                                        _nameController.text = '';
                                        _yearController.text = '';
                                      },
                                child: Container(
                                  width: 210,
                                  height: 50,
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 38,
                                    vertical: 6,
                                  ),
                                  child: Center(
                                    child: Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        Visibility(
                                          visible: !state.addingOrder,
                                          child: Text(
                                            'Buyurtma berish',
                                            style: TextStyle(
                                              fontSize: 15,
                                              fontFamily: 'Inter',
                                              fontWeight: FontWeight.w700,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                        Visibility(
                                          visible: state.addingOrder,
                                          child: CircularProgressIndicator(
                                            color: Colors.black,
                                            strokeAlign: -2,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
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
    );
  }

  PreferredSize makeAppbar() {
    return PreferredSize(
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
          "Buyurtmalar stoli",
          style: GoogleFonts.montserrat(
            textStyle: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w400,
              fontSize: 15,
            ),
          ),
        ),
      ),
    );
  }
}
