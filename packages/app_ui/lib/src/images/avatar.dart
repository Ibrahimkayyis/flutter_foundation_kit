import 'package:flutter/material.dart';
import 'package:app_types/types.dart';

import 'image_preview.dart';

class NTICircleAvatar extends StatelessWidget {
  final ImageProvider? image;
  final Color? color;
  final BoxFit? fit;
  final ImageProvider? fullScreenImage;
  final double radius;
  final bool disableOnTap;

  const NTICircleAvatar({
    super.key,
    this.image,
    this.fit,
    this.color,
    this.disableOnTap = false,
    this.fullScreenImage,
    double? radius,
  }) : radius = radius ?? 54;

  factory NTICircleAvatar.fromIAImage(
    NTIImage? iaImage, {
    double? radius,
    BoxFit? fit,
    bool disableOnTap = false,
  }) {
    if (iaImage == null) {
      return NTICircleAvatar(
        disableOnTap: disableOnTap,
        radius: radius,
        fit: fit,
      );
    }
    late final ImageProvider smallImage;
    late final ImageProvider fullScreenImage;
    if (iaImage is! NTICompleteNetworkImage) {
      smallImage = iaImage.provider;
      fullScreenImage = iaImage.provider;
      return NTICircleAvatar(
        disableOnTap: disableOnTap,
        fit: fit,
        fullScreenImage: fullScreenImage,
        image: smallImage,
        radius: radius,
      );
    }
    return NTICircleAvatar(
      disableOnTap: disableOnTap,
      fullScreenImage: iaImage.provider,
      image: iaImage.providerXS,
      radius: radius,
      fit: fit,
    );
  }

  // factory NTICircleAvatar.userProfile({
  //   required String token,
  //   double? radius,
  //   BoxFit? fit,
  //   Key? key,
  //   bool disableOnTap = false,
  // }) => NTICircleAvatar(
  //   key: key,
  //   radius: radius,
  //   fit: fit,
  //   disableOnTap: disableOnTap,
  //   fullScreenImage: NetworkImage(
  //     "${NetworkConstants.apiBaseUrl}/users/profil/gambar?size=small",
  //     headers: {"Authorization": "Bearer $token"},
  //   ),
  //   image: NetworkImage(
  //     "${NetworkConstants.apiBaseUrl}/users/profil/gambar?size=extra-small",
  //     headers: {"Authorization": "Bearer $token"},
  //   ),
  // );

  @override
  Widget build(BuildContext context) {
    final image = this.image;
    return SizedBox(
      height: radius,
      width: radius,
      child: GestureDetector(
        onTap:
            image != null && !disableOnTap
                ? () => NTIImagePreview.asFullScreenDialog(
                  context,
                  fullScreenImage ?? image,
                )
                : null,
        child: Container(
          width: radius,
          height: radius,
          decoration: BoxDecoration(
            color: color ?? Colors.transparent,
            shape: BoxShape.circle,
            image:
                image != null
                    ? DecorationImage(image: image, fit: fit ?? BoxFit.cover)
                    : null,
          ),
        ),
      ),
    );
  }
}
