import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/history/history_bloc.dart';
import '../style/colors.dart';

class VecAnimatedText extends StatefulWidget {
  final Duration duration;
  final Color beginColor;
  final Color endColor;
  final String text;
  final FontWeight? fontWeight;

  const VecAnimatedText({
    Key? key,
    required this.duration,
    required this.beginColor,
    required this.endColor,
    required this.text,
    this.fontWeight,
  }) : super(key: key);

  @override
  State<VecAnimatedText> createState() => VecAnimatedTextState();
}

class VecAnimatedTextState extends State<VecAnimatedText>
    with SingleTickerProviderStateMixin {
  FontWeight fontWeight = FontWeight.w400;
  late final AnimationController _controller;
  late Animation<Color?> colorTween;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance!.addPostFrameCallback((_) {
      BlocProvider.of<HistoryBloc>(context).calculateWidths();
    });

    fontWeight = widget.fontWeight ?? fontWeight;

    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    colorTween = ColorTween(begin: widget.beginColor, end: widget.endColor)
        .animate(_controller)
      ..addListener(() {
        setState(() {});
      });

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void updateColorWithAnimation(
      Color beginColor, Color endColor, FontWeight newFontWeight) {
    _controller.reset();

    beginColor = VecColor.resolveColor(context, beginColor);
    endColor = VecColor.resolveColor(context, endColor);

    setState(() {
      fontWeight = newFontWeight;
      colorTween =
          ColorTween(begin: beginColor, end: endColor).animate(_controller);
    });

    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      widget.text,
      style: TextStyle(
          // TODO there must be a better way of resolving color
          color: VecColor.resolveColor(context, colorTween.value!),
          fontSize: 18,
          fontWeight: fontWeight),
    );
  }
}
