import 'package:flutter/material.dart';

import '../resources/index.dart';
import 'spacing.dart';

class EmptyStateWidget extends StatelessWidget {
  const EmptyStateWidget({
    Key? key,
    this.onActionTapped,
    this.title,
    this.titleAction,
    this.subtitle,
    this.padding,
    this.background = AppColors.white,
  }) : super(key: key);

  final String? title;
  final String? subtitle;
  final String? titleAction;
  final double? padding;
  final Function(BuildContext)? onActionTapped;
  final Color background;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: padding ?? 0.0,
        right: padding ?? 0.0,
        bottom: padding ?? 0.0,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(6.0),
        child: Container(
          color: background,
          height: double.infinity,
          width: double.infinity,
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  const Spacing(height: 16),
                  Container(
                    height: 80,
                    width: 80,
                    decoration: BoxDecoration(
                        color: AppColors.backgroundColor, borderRadius: BorderRadius.circular(80)),
                    child: Center(
                      child: AssetImages.iconEmpty.toSvg(height: 35, width: 35),
                    ),
                  ),
                  const Spacing(height: 16),
                  Text(
                    title ?? 'Nothing to show',
                    style: TextStyles.greyNormalBold,
                    textAlign: TextAlign.center,
                  ),
                  if (onActionTapped != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 6.0),
                      child: Text(
                        subtitle ?? 'Add',
                        style: TextStyles.greySmallRegular,
                      ),
                    ),
                  const Spacing(height: 16),
                  Visibility(
                    visible: onActionTapped != null,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          SizedBox(
                            height: 48,
                            child: ElevatedButton(
                                onPressed: () => onActionTapped!(context),
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all(AppColors.primaryColor),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                  child: Center(
                                    child: Text(
                                      titleAction ?? 'Add Items',
                                      style: TextStyles.whiteSmallBold,
                                    ),
                                  ),
                                )),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
