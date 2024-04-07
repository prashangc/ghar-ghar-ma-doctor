class SocialMedia {
  final String image;
  final String appType;
  final String ifNotSupported;
  final String? alternateAppType;

  SocialMedia({
    required this.image,
    required this.appType,
    required this.ifNotSupported,
    this.alternateAppType,
  });
}

List<SocialMedia> socialMediaList = [
  // SocialMedia(
  //   image: 'assets/messenger.png',
  //   appType: 'fb-messenger://user/100083409311129',
  //   ifNotSupported: 'https://www.facebook.com/profile.php?id=100083409311129',
  //   alternateAppType: 'fb://profile/100083409311129',
  // ),
  // SocialMedia(
  //   image: 'assets/viber.png',
  //   appType: 'viber://chat?number=9840308344',
  //   ifNotSupported: 'https://viber.com/chat/9840308344',
  // ),
  // SocialMedia(
  //   image: 'assets/whatsapp.png',
  //   appType: 'whatsapp://send?phone=9840308344',
  //   ifNotSupported: 'https://wa.me/9840308344',
  // ),
  SocialMedia(
    image: 'assets/fb.png',
    appType: 'fb://profile/100083409311129',
    ifNotSupported: 'https://www.facebook.com/profile.php?id=100083409311129',
  ),
  SocialMedia(
    image: 'assets/instagram.png',
    appType: 'instagram://user?username=ghargharma.doctor',
    ifNotSupported: 'https://www.instagram.com/ghargharma.doctor/',
  ),
  SocialMedia(
    image: 'assets/linkedin.png',
    appType: 'linkedin://company/ghargharmadoctor',
    ifNotSupported: 'https://www.linkedin.com/company/ghargharmadoctor/',
  ),
  SocialMedia(
    image: 'assets/gmail.png',
    appType: 'googlegmail://co?to=info@ghargharmadoctor.com',
    ifNotSupported: 'mailto:info@ghargharmadoctor.com',
  ),
];
