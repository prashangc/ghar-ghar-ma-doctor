class OnBoardingModelData {
  final String title;
  final String image;
  final String engDesc;
  final String nepDesc;

  OnBoardingModelData({
    required this.title,
    required this.image,
    required this.engDesc,
    required this.nepDesc,
  });
}

List<OnBoardingModelData> onboardingContents = [
  OnBoardingModelData(
    title: 'Prevention',
    image: 'assets/prevention.png',
    engDesc: 'Prevention is better than cure',
    nepDesc: 'रोकथाम उपचार भन्दा उत्तम हो |',
  ),
  OnBoardingModelData(
    title: 'Treatment',
    image: 'assets/treatment.png',
    engDesc: 'Treatment gives Rebirth',
    nepDesc: 'उपचार पुनर्जन्म हो |',
  ),
  OnBoardingModelData(
    title: 'Insurance',
    image: 'assets/insurance.png',
    engDesc: 'Insurance is priority not an option',
    nepDesc: 'विमा विकल्प रहित प्राथमिकता हो |',
  ),
  OnBoardingModelData(
    title: 'Our Future Projects',
    image: 'assets/gdAboard.png',
    engDesc: 'Prevention is better than cure',
    nepDesc: 'रोकथाम उपचार भन्दा उत्तम हो |',
  ),
];
