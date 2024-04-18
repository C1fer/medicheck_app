import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:medicheck/models/extensions/string_apis.dart';
import 'package:medicheck/widgets/cards/feature_card.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';
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
    return GestureDetector(
      onTap: () => MapsLauncher.launchCoordinates(
          place.establecimiento.latitud, place.establecimiento.longitud),
      child: Container(
        decoration: ShapeDecoration(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            side: const BorderSide(width: 1, color: Color(0xFFE8F3F1)),
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            PlaceIllust(context),
            Padding(
              padding:
                  const EdgeInsets.only(top: 8.0, bottom: 10, left: 20.0, right: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(flex: 3, child: PlaceName()),
                      if (place.rating != null)
                        Expanded(child: PlaceRatingBar(context))
                    ],
                  ),
                  PlaceType(),
                  const SizedBox(
                    height: 8,
                  ),
                  if (place.establecimiento.telefono != null)
                    PlacePhoneNumbers(),
                  const SizedBox(
                    height: 8,
                  ),
                  if (place.establecimiento.direccion != null) PlaceLocation(),
                  const SizedBox(
                    height: 10,
                  ),
                  PlaceDistance(context)
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget PlaceDistance(BuildContext context){
    final distance = AppLocalizations.of(context)
        .distance_from_place(place.distance.toStringAsFixed(2));
    return Row(
      children: [
        Icon(Icons.directions_rounded, color: AppColors.darkGray, size: 14,),
        SizedBox(width: 4,),
        Text(
          distance,
          style: AppStyles.subSmallTextStyle
              .copyWith(fontWeight: FontWeight.w600),
        ),
      ],
    );
  }

  Widget PlaceIllust(BuildContext context) {
    return Skeleton.replace(replacement: Bone.square(borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10))),child: placePhotoURL != null
        ? PlacePhoto(context, placePhotoURL!)
        : SvgPicture.asset('assets/icons/hospital-colored.svg'),);
  }

  Widget PlacePhoto(BuildContext context, String imageURL) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: CachedNetworkImage(
        fit: BoxFit.cover,
        imageUrl: imageURL,
        imageBuilder: (context, imageProvider) => Container(
          width: double.infinity,
          padding: const EdgeInsets.all(80),
          decoration: BoxDecoration(
              image: DecorationImage(image: imageProvider, fit:  BoxFit.cover),
              borderRadius: BorderRadius.only(topLeft: Radius.circular(10,), topRight: Radius.circular(10)),),
        ),
        placeholder: (context, url) => const CircularProgressIndicator(
          color: AppColors.jadeGreen,
        ),
      ),
    );
  }

  Widget PlaceName() {
    return Text(
      place.establecimiento.nombre.toProperCaseData(),
      style: AppStyles.sectionTextStyle,
    );
  }

  Widget PlaceType() {
    return Text(
        place.establecimiento.categoria!.replaceUnderScores().toProperCase(),
        style: AppStyles.subSmallTextStyle);
  }

  Widget PlacePhoneNumbers() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
