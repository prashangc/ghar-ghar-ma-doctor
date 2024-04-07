import 'package:flutter/material.dart';
import 'package:ghargharmadoctor/api/api_imports.dart';
import 'package:ghargharmadoctor/constants/constants_imports.dart';
import 'package:ghargharmadoctor/models/models.dart';
import 'package:ghargharmadoctor/screens/Vendor/profile/editVendorProfile.dart';

StateHandlerBloc refreshVendorProfileBloc = StateHandlerBloc();

class VendorProfileTabView extends StatefulWidget {
  final VendorProfileModel profileModel;
  const VendorProfileTabView({super.key, required this.profileModel});

  @override
  State<VendorProfileTabView> createState() => _VendorProfileTabViewState();
}

class _VendorProfileTabViewState extends State<VendorProfileTabView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(12.0, 12.0, 12.0, 50.0),
      width: maxWidth(context),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    flex: 2,
                    child: myContainer(profileCard()),
                  ),
                  const SizedBox(width: 12.0),
                  Expanded(
                    flex: 1,
                    child: myContainer(productCard()),
                  ),
                ],
              ),
            ),
            const SizedBox16(),
            const SizedBox16(),
          ],
        ),
      ),
    );
  }

  Widget myContainer(Widget myWidget) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 14.0),
      width: maxWidth(context),
      decoration: BoxDecoration(
        color: kWhite.withOpacity(0.4),
        borderRadius: const BorderRadius.all(
          Radius.circular(8.0),
        ),
      ),
      child: myWidget,
    );
  }

  Widget myRow(title, value) {
    return GestureDetector(
      onTap: () {
        if (value == '') {
          goThere(
              context,
              EditVendorProfileScreen(
                profileModel: widget.profileModel,
              ));
        }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: kStyleNormal.copyWith(
                  fontSize: 12.0,
                  color: value == '' ? kRed : kBlack,
                ),
              ),
              const SizedBox(width: 2.0),
              value == ''
                  ? Icon(Icons.error_outline_outlined, size: 11.0, color: kRed)
                  : Expanded(
                      child: Text(
                        value.toString(),
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.right,
                        style: kStyleNormal.copyWith(
                          fontSize: 12.0,
                          fontWeight: FontWeight.bold,
                          color: myColor.primaryColorDark,
                        ),
                      ),
                    ),
            ],
          ),
          const SizedBox8(),
        ],
      ),
    );
  }

  Widget profileCard() {
    return StreamBuilder<dynamic>(
        initialData: widget.profileModel,
        stream: refreshVendorProfileBloc.stateStream,
        builder: (c, s) {
          return Column(
            children: [
              myRow('Phone:', s.data.user!.phone ?? ''),
              myRow('Address:', s.data.address ?? ''),
              myRow('Type:', s.data.types!.vendorType ?? ''),
              myRow('Ratings:', s.data.averageRating ?? ''),
              myRow('Followed:', s.data.followerCount ?? ''),
            ],
          );
        });
  }

  Widget productCard() {
    return GestureDetector(
      onTap: () {},
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'View',
                style: kStyleNormal.copyWith(
                  fontSize: 12.0,
                  fontWeight: FontWeight.bold,
                  color: myColor.primaryColorDark,
                ),
              ),
              Icon(
                Icons.keyboard_arrow_right_outlined,
                color: myColor.primaryColorDark,
                size: 16.0,
              ),
            ],
          ),
          const SizedBox12(),
          Expanded(
            child: Icon(
              Icons.store,
              color: myColor.primaryColorDark,
            ),
          ),
          const SizedBox12(),
          Text(
            "Product",
            style: kStyleNormal.copyWith(
                fontWeight: FontWeight.bold, fontSize: 14.0),
          ),
        ],
      ),
    );
  }
}
