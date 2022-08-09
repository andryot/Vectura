import 'dart:async';
import 'dart:math';

import 'package:flutter/cupertino.dart';

import '../style/colors.dart';

class LoadingIndicator2 extends StatefulWidget {
  const LoadingIndicator2(
      {Key? key, required this.radius, required this.dotRadius})
      : super(key: key);
  final double radius;
  final double dotRadius;

  @override
  State<LoadingIndicator2> createState() => _LoadingIndicator2State();
}

class _LoadingIndicator2State extends State<LoadingIndicator2> {
  double turns = 0.0;
  late Timer timer;

  @override
  void initState() {
    timer = Timer.periodic(const Duration(milliseconds: 250),
        (_) => setState(() => turns += 1.0 / 8.0));
    super.initState();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double radius = widget.radius;
    final double dotRadius = widget.dotRadius;
    return Center(
      child: SizedBox(
          width: radius * 2.5,
          height: radius * 2.5,
          child: Stack(alignment: AlignmentDirectional.center, children: [
            AnimatedRotation(
              turns: turns,
              duration: const Duration(milliseconds: 250),
              child: Container(
                width: radius * 2.27,
                height: radius * 2.27,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    gradient: SweepGradient(
                      center: FractionalOffset.center,
                      colors: <Color>[
                        VecColor.resolveColor(
                            context,
                            const CupertinoDynamicColor.withBrightness(
                                color: Color.fromRGBO(0, 24, 152, 0.1),
                                darkColor: Color.fromRGBO(0, 167, 220, 0.1))),
                        VecColor.resolveColor(
                            context,
                            const CupertinoDynamicColor.withBrightness(
                                color: Color.fromRGBO(0, 24, 152, 0.25),
                                darkColor: Color.fromRGBO(0, 167, 220, 0.25))),
                        VecColor.resolveColor(
                          context,
                          const CupertinoDynamicColor.withBrightness(
                              color: Color.fromRGBO(0, 24, 152, 0.4),
                              darkColor: Color.fromRGBO(0, 167, 220, 0.4)),
                        ),
                        VecColor.resolveColor(
                          context,
                          const CupertinoDynamicColor.withBrightness(
                              color: Color.fromRGBO(0, 24, 152, 0.55),
                              darkColor: Color.fromRGBO(0, 167, 220, 0.55)),
                        ),
                        VecColor.resolveColor(
                          context,
                          const CupertinoDynamicColor.withBrightness(
                              color: Color.fromRGBO(0, 24, 152, 0.7),
                              darkColor: Color.fromRGBO(0, 167, 220, 0.7)),
                        ),
                        VecColor.resolveColor(
                          context,
                          const CupertinoDynamicColor.withBrightness(
                              color: Color.fromRGBO(0, 24, 152, 0.85),
                              darkColor: Color.fromRGBO(0, 167, 220, 0.85)),
                        ),
                        VecColor.resolveColor(
                          context,
                          const CupertinoDynamicColor.withBrightness(
                              color: Color.fromRGBO(0, 24, 152, 1),
                              darkColor: Color.fromRGBO(0, 167, 220, 1)),
                        ),
                        VecColor.resolveColor(
                            context,
                            const CupertinoDynamicColor.withBrightness(
                                color: Color.fromRGBO(0, 24, 152, 0.1),
                                darkColor: Color.fromRGBO(0, 167, 220, 0.1)))
                      ],
                    )),
              ),
            ),
            PerforatedContainer(
              dotRadius: dotRadius,
              radius: radius,
            ),
          ])),
    );
  }
}

class PerforatedContainer extends StatelessWidget {
  final double radius;
  final double dotRadius;
  const PerforatedContainer(
      {Key? key, required this.radius, required this.dotRadius})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    const Color transparent = Color(0xFF000000);
    return ColorFiltered(
        colorFilter: ColorFilter.mode(
            VecColor.resolveColor(context, VecColor.backgroud),
            BlendMode.srcOut),
        child: Stack(
          children: [
            Transform.translate(
              offset: Offset(radius * cos(pi / 4), radius * sin(pi / 4)),
              child: Dot(
                radius: dotRadius,
                color: transparent,
              ),
            ),
            Transform.translate(
              offset:
                  Offset(radius * cos(2 * pi / 4), radius * sin(2 * pi / 4)),
              child: Dot(
                radius: dotRadius,
                color: transparent,
              ),
            ),
            Transform.translate(
              offset:
                  Offset(radius * cos(3 * pi / 4), radius * sin(3 * pi / 4)),
              child: Dot(
                radius: dotRadius,
                color: transparent,
              ),
            ),
            Transform.translate(
              offset:
                  Offset(radius * cos(4 * pi / 4), radius * sin(4 * pi / 4)),
              child: Dot(
                radius: dotRadius,
                color: transparent,
              ),
            ),
            Transform.translate(
              offset:
                  Offset(radius * cos(5 * pi / 4), radius * sin(5 * pi / 4)),
              child: Dot(
                radius: dotRadius,
                color: transparent,
              ),
            ),
            Transform.translate(
              offset:
                  Offset(radius * cos(6 * pi / 4), radius * sin(6 * pi / 4)),
              child: Dot(
                radius: dotRadius,
                color: transparent,
              ),
            ),
            Transform.translate(
              offset:
                  Offset(radius * cos(7 * pi / 4), radius * sin(7 * pi / 4)),
              child: Dot(
                radius: dotRadius,
                color: transparent,
              ),
            ),
            Transform.translate(
              offset:
                  Offset(radius * cos(8 * pi / 4), radius * sin(8 * pi / 4)),
              child: Dot(
                radius: dotRadius,
                color: transparent,
              ),
            ),
          ],
        ));
  }
}

class Dot extends StatelessWidget {
  final double radius;
  final Color color;
  const Dot({Key? key, required this.radius, required this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: radius,
      height: radius,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}
