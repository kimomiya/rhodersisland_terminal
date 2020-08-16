import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:styled_widget/styled_widget.dart';

import '../../cubit/prefetch/prefetch_cubit.dart';
import '../../injection.dart';
import '../router.gr.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, width: 750, height: 1334);

    return Scaffold(
      body: BlocProvider(
        create: (_) => locator<PrefetchCubit>(),
        child: const _ContentView(),
      ),
      backgroundColor: Colors.grey[50],
    );
  }
}

class _ContentView extends StatefulWidget {
  const _ContentView({Key key}) : super(key: key);

  @override
  _ContentViewState createState() => _ContentViewState();
}

class _ContentViewState extends State<_ContentView> {
  @override
  void initState() {
    super.initState();

    context.bloc<PrefetchCubit>().fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<PrefetchCubit, PrefetchState>(
      listener: _listenCubitState,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildLogo(),
          _buildLoadingView(),
        ],
      ),
    );
  }

  void _listenCubitState(BuildContext context, PrefetchState state) {
    state.maybeMap(
      fetchSuccess: (_) => context.navigator.push(Routes.home),
      orElse: () {},
    );
  }

  Widget _buildLogo() {
    return Image.asset(
      'assets/images/logo/logo_rhodes.png',
      width: ScreenUtil.screenWidth * 0.618,
      fit: BoxFit.fitWidth,
    ).center().padding(top: 180);
  }

  Widget _buildLoadingView() {
    return Column(
      children: [
        LoadingIndicator(
          indicatorType: Indicator.ballRotateChase,
          color: const Color(0xFF0F0F0F),
        ).constrained(height: 88.h.toDouble(), width: 88.h.toDouble()),
        SizedBox(height: 64.h.toDouble()),
        const Text(
          'Connecting to the neural network of Rhodes Island.',
          textAlign: TextAlign.center,
        ).textColor(Colors.grey[700]).fontSize(30.sp.toDouble()),
      ],
    ).center().padding(
          horizontal: 60.w.toDouble(),
          bottom: ScreenUtil.bottomBarHeight + kToolbarHeight,
        );
  }
}