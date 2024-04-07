class RatingsModel {
  final String? ratingValue;
  final String? ratingType;
  final double? starCount;

  RatingsModel({
    required this.ratingValue,
    required this.ratingType,
    required this.starCount,
  });
}

List<RatingsModel> ratingsList = [
  RatingsModel(
    ratingValue: 'Excellent',
    ratingType: '5',
    starCount: 5,
  ),
  RatingsModel(
    ratingValue: 'Best',
    ratingType: '4',
    starCount: 4,
  ),
  RatingsModel(
    ratingValue: 'Good',
    ratingType: '3',
    starCount: 3,
  ),
  RatingsModel(
    ratingValue: 'Average',
    ratingType: '2',
    starCount: 2,
  ),
  RatingsModel(
    ratingValue: 'Satisfactory',
    ratingType: '1',
    starCount: 1,
  ),
];
