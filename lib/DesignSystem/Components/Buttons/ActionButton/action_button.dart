import 'package:flutter/material.dart';
import 'package:smartlist/DesignSystem/Components/Buttons/ActionButton/action_button_view_model.dart';
import 'package:smartlist/DesignSystem/shared/colors.dart';
import 'package:smartlist/DesignSystem/shared/styles.dart';

class ActionButton extends StatelessWidget {
  final ActionButtonViewModel viewModel;

  const ActionButton({
    Key? key,
    required this.viewModel,
  }) : super(key: key);

  static Widget instantiate({required ActionButtonViewModel viewModel}) =>
      ActionButton(viewModel: viewModel);

  @override
  Widget build(BuildContext context) {
    double horizontalPadding = 12;
    double verticalPadding = 12;
    double iconSize = 24;
    TextStyle buttonTextStyle = button3Semibold;
    Color buttonColor = lightPrimaryBrandColor;
    Color textColor = lightPurpleBrandColor;

    switch (viewModel.size) {
      case ActionButtonSize.large:
        buttonTextStyle = button1Bold;
        iconSize = 24;
        break;
      case ActionButtonSize.medium:
        buttonTextStyle = button2Semibold;
        iconSize = 24;
        break;
      case ActionButtonSize.small:
        buttonTextStyle = button3Semibold;
        horizontalPadding = 16;
        iconSize = 16;
        break;
      default:
    }

    switch (viewModel.style) {
      case ActionButtonStyle.primary:
        buttonColor = darkPurpleBrandColor;
        textColor = lightPurpleBrandColor;
        break;
      case ActionButtonStyle.secondary:
        buttonColor = normalPurpleBrandColor;
        textColor = darkPurpleBrandColor;
        break;
      case ActionButtonStyle.tertiary:
        buttonColor = lightPurpleBrandColor;
        textColor = darkPurpleBrandColor;
        break;
      default:
    }
    buttonTextStyle = buttonTextStyle.copyWith(color: textColor);
    return IntrinsicWidth(
      child: ElevatedButton(
        onPressed: viewModel.onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: buttonColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          textStyle: buttonTextStyle,
          padding: EdgeInsets.symmetric(
            vertical: verticalPadding,
            horizontal: horizontalPadding
          )
        ),
        child: viewModel.icon !=null ?
        Row(
          children: [
            Icon(
              viewModel.icon,
              size: iconSize,
              color: Colors.white,
            ),
            Text(viewModel.text)
          ],
        ) :
        Text(viewModel.text),
      ),
    );
  }
}