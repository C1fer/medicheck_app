import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:medicheck/widgets/cards/feature_card.dart';
import '../../models/place.dart';
import '../../styles/app_styles.dart';
import '../../styles/app_colors.dart';

class PlaceCard extends StatelessWidget {
  const PlaceCard(
      {super.key, required this.place, this.placePhotoURL, this.onTap});
  final GooglePlace place;
  final String? placePhotoURL;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        decoration: ShapeDecoration(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            side: const BorderSide(width: 1, color: Color(0xFFE8F3F1)),
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
                width: 100,
                height: 100,
                /*child: placePhotoURL != null
                    ? CachedNetworkImage(
                        imageUrl: placePhotoURL!,
                        placeholder: (context, url) =>
                            const CircularProgressIndicator(),
                      )
                    : SvgPicture.asset('assets/icons/hospital-colored.svg')*/
              child: SvgPicture.asset('assets/icons/hospital-colored.svg'),
    ),
            const SizedBox(
              width: 32,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    place.name,
                    style: AppStyles.sectionTextStyle,
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Text(place.primaryTypeDisplay,
                      style: AppStyles.subSmallTextStyle),
                  const SizedBox(
                    height: 6,
                  ),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        size: 14.0,
                        color: AppColors.jadeGreen,
                      ),
                      const SizedBox(
                        width: 4,
                      ),
                      Text(
                        place.shortFormattedAddress,
                        style: AppStyles.subSmallTextStyle.copyWith(
                          color: AppColors.jadeGreen,
                        ),
                        maxLines: null,
                      )
                    ],
                  ),
                  if (place.phoneNumber != null)
                    Column(
                      children: [
                        const SizedBox(
                          height: 6,
                        ),
                        Row(
                          children: [
                            const Icon(
                              Icons.phone,
                              size: 14.0,
                              color: AppColors.jadeGreen,
                            ),
                            const SizedBox(
                              width: 4,
                            ),
                            Text(
                              place.phoneNumber!,
                              style: AppStyles.subSmallTextStyle
                                  .copyWith(color: AppColors.jadeGreen),
                            )
                          ],
                        ),
                      ],
                    ),// Phone Number
                  if (place.openNow != null)
                    Column(
                      children: [
                        const SizedBox(
                          height: 6,
                        ),
                        FeatureCard(
                          msg: place.openNow! ? "Open" : "Closed",
                          color: place.openNow!
                              ? AppColors.jadeGreen
                              : AppColors.lightRed,
                        )
                      ],
                    ), // Place
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
