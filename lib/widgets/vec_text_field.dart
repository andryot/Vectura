import 'package:flutter/cupertino.dart';

import '../style/colors.dart';
import '../style/constants.dart';

class VecTextField extends StatelessWidget {
  final String? placeholder;
  final ValueChanged<String>? onChanged;
  final TextInputType? keyboardType;
  final bool obscureText;
  final TextStyle? textStyle;
  final bool readOnly;
  final TextEditingController? controller;
  final Function()? onTap;
  final TextInputAction? textInputAction;
  const VecTextField({
    Key? key,
    this.placeholder,
    this.onChanged,
    this.keyboardType,
    this.obscureText = false,
    this.textStyle,
    this.readOnly = false,
    this.controller,
    this.onTap,
    this.textInputAction,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: buttonHeight,
      child: CupertinoTextField(
        textInputAction: textInputAction,
        textAlignVertical: TextAlignVertical.center,
        controller: controller,
        readOnly: readOnly,
        decoration: const BoxDecoration(
            borderRadius: kBorderRadius, color: VecColor.highlightColor),
        placeholderStyle: const TextStyle(color: VecColor.placeholderColor),
        onChanged: onChanged,
        placeholder: placeholder,
        keyboardType: keyboardType,
        obscureText: obscureText,
        style: textStyle ?? const TextStyle(fontSize: 16),
        toolbarOptions: const ToolbarOptions(paste: true, selectAll: true),
        padding: const EdgeInsetsDirectional.fromSTEB(14.0, 12.0, 14.0, 12.0),
        onTap: onTap,
      ),
    );
  }
}
