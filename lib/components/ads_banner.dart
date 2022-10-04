import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class AdsBanner extends StatefulWidget {
  const AdsBanner({Key? key}) : super(key: key);

  @override
  State<AdsBanner> createState() => _AdsBannerState();
}

class _AdsBannerState extends State<AdsBanner> {
  List<String> _carouselImages = [];
  var _dotPosition = 0;

  fetchCarouselImages() async {
    var _fireStoreInstance = FirebaseFirestore.instance;
    QuerySnapshot qn = await _fireStoreInstance.collection("banners").get();

    setState(() {
      for (int i = 0; i < qn.docs.length; i++) {
        _carouselImages.add(
          qn.docs[i]["source"],
        );
      }
    });

    return qn.docs;
  }

  @override
  void initState() {
    fetchCarouselImages();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Column(
      children: [
        SizedBox(
          height: 20,
        ),
        CarouselSlider(
            items: _carouselImages
                .map(
                  (item) => Container(
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: NetworkImage(item), fit: BoxFit.cover)),
                  ),
                )
                .toList(),
            options: CarouselOptions(
                height: 200,
                autoPlay: true,
                enlargeCenterPage: true,
                viewportFraction: 0.8,
                enlargeStrategy: CenterPageEnlargeStrategy.height,
                onPageChanged: (val, CarouselPageChangedReason) {
                  setState(() {
                    _dotPosition = val;
                  });
                })),
        SizedBox(
          height: 10,
        ),
        DotsIndicator(
          dotsCount: _carouselImages.length == 0 ? 1 : _carouselImages.length,
          position: _dotPosition.toDouble(),
          decorator: DotsDecorator(
            activeColor: Colors.purple.withOpacity(0.5),
            spacing: EdgeInsets.all(2),
            activeSize: Size(8, 8),
            size: Size(6, 6),
          ),
        ),
      ],
    ));
  }
}
