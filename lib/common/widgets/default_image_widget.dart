import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';

import '../resources/index.dart';

class DefaultImageWidget extends StatelessWidget {
  const DefaultImageWidget(
    this.image, {
    Key? key,
    this.width,
    this.height,
    this.fit,
    this.radius,
    this.borderColor,
    this.imageFile,
  }) : super(key: key);

  final String? image;
  final double? width;
  final double? height;
  final BoxFit? fit;
  final double? radius;
  final Color? borderColor;
  final File? imageFile;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(radius ?? 0),
          border: Border.all(
            color: borderColor ?? AppColors.transparent,
          )),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(radius ?? 0),
        child: imageFile != null
            ? Image.file(
                imageFile!,
                width: width,
                height: height,
                fit: fit ?? BoxFit.cover,
              )
            : image != null
                ? Image.memory(
                    base64Decode(image ?? ''),
                    width: width,
                    height: height,
                    fit: fit ?? BoxFit.cover,
                    errorBuilder: (_, __, dynamic error) => imageFile != null
                        ? Image.file(
                            imageFile!,
                            width: width,
                            height: height,
                            fit: fit ?? BoxFit.cover,
                          )
                        : Image.asset(
                            AssetImages.imgDefault,
                            width: width,
                            height: height,
                            fit: fit ?? BoxFit.cover,
                          ),
                  )
                : Image.asset(
                    AssetImages.imgDefault,
                    width: width,
                    height: height,
                    fit: fit ?? BoxFit.cover,
                  ),
      ),
    );
  }
}
