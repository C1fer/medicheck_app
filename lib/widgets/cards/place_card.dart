import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:medicheck/models/extensions/string_apis.dart';
import 'package:medicheck/widgets/cards/feature_card.dart';
import 'package:provider/provider.dart';
import '../../models/google_place.dart';
import '../../styles/app_styles.dart';
import '../../styles/app_colors.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PlaceCard extends StatelessWidget {
  const PlaceCard({super.key, required this.place, this.placePhotoURL});

  final GooglePlace place;
  final String? placePhotoURL;

  @override
  Widget build(BuildContext context) {
    final distance = AppLocalizations.of(context).distance_from_place(place.distance.toStringAsFixed(2));
    return GestureDetector(
      onTap: () => MapsLauncher.launchCoordinates(
          place.establecimiento.latitud, place.establecimiento.longitud),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20.0),
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
                width: 150,
                height: 125,
                child: placePhotoURL != null
                    ? CachedNetworkImage(
                        imageUrl: placePhotoURL!,
                        placeholder: (context, url) =>
                            const CircularProgressIndicator(
                          color: AppColors.jadeGreen,
                        ),
                      )
                    : SvgPicture.asset('assets/icons/hospital-colored.svg')),
            const SizedBox(
              width: 30.0,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    place.establecimiento.nombre.toProperCaseData(),
                    style: AppStyles.sectionTextStyle,
                  ),
                  Text(
                      place.establecimiento.categoria!
                          .replaceUnderScores()
                          .toProperCase(),
                      style: AppStyles.subSmallTextStyle),
                  const SizedBox(
                    height: 4,
                  ),
                  if (place.rating != null) PlaceRatingBar(context),
                  const SizedBox(
                    height: 4,
                  ),
                  if (place.establecimiento.telefono != null)
                    PlacePhoneNumbers(),
                  const SizedBox(
                    height: 4,
                  ),
                  if (place.establecimiento.direccion != null) PlaceLocation(),
                  const SizedBox(
                    height: 6,
                  ),
                  Text(
                    distance,
                    style: AppStyles.subSmallTextStyle
                        .copyWith(fontWeight: FontWeight.w600),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget PlacePhoneNumbers() {
    return Column(
        children: place.establecimiento.telefono!
            .split(", ")
            .map((String phoneNo) => Row(
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
                      phoneNo,
                      style: AppStyles.subSmallTextStyle
                          .copyWith(color: AppColors.jadeGreen),
                    ),
                  ],
                ))
            .toList());
  }

  Widget PlaceLocation() {
    return Row(
      children: [
        const Icon(
          Icons.location_on,
          size: 14.0,
          color: AppColors.jadeGreen,
        ),
        const SizedBox(
          width: 4,
        ),
        Expanded(
          child: Text(
            place.establecimiento.direccion!.toProperCaseData(),
            style: AppStyles.subSmallTextStyle
                .copyWith(color: AppColors.jadeGreen),
          ),
        )
      ],
    );
  }

  Widget PlaceRatingBar(BuildContext context) {
    return RatingBarIndicator(
      itemBuilder: (context, index) => const Icon(
        Icons.star,
        color: Colors.amber,
      ),
      itemCount: 5,
      rating: place.rating!,
      direction: Axis.horizontal,
      itemSize: 15,
    );
  }
}
/*

 */
