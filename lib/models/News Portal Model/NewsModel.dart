class NewsModel {
  int? currentPage;
  List<NewsData>? data;
  String? firstPageUrl;
  int? from;
  int? lastPage;
  String? lastPageUrl;
  String? nextPageUrl;
  String? path;
  int? perPage;
  String? prevPageUrl;
  int? to;
  int? total;

  NewsModel(
      {this.currentPage,
      this.data,
      this.firstPageUrl,
      this.from,
      this.lastPage,
      this.lastPageUrl,
      this.nextPageUrl,
      this.path,
      this.perPage,
      this.prevPageUrl,
      this.to,
      this.total});

  NewsModel.fromJson(Map<String, dynamic> json) {
    currentPage = json['current_page'];
    if (json['data'] != null) {
      data = <NewsData>[];
      json['data'].forEach((v) {
        data!.add(NewsData.fromJson(v));
      });
    }
    firstPageUrl = json['first_page_url'];
    from = json['from'];
    lastPage = json['last_page'];
    lastPageUrl = json['last_page_url'];
    nextPageUrl = json['next_page_url'];
    path = json['path'];
    perPage = json['per_page'];
    prevPageUrl = json['prev_page_url'];
    to = json['to'];
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['current_page'] = currentPage;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['first_page_url'] = firstPageUrl;
    data['from'] = from;
    data['last_page'] = lastPage;
    data['last_page_url'] = lastPageUrl;
    data['next_page_url'] = nextPageUrl;
    data['path'] = path;
    data['per_page'] = perPage;
    data['prev_page_url'] = prevPageUrl;
    data['to'] = to;
    data['total'] = total;
    return data;
  }
}

class NewsData {
  int? id;
  int? menuId;
  int? userId;
  String? titleEn;
  String? descriptionEn;
  String? image;
  String? imagePath;
  String? slug;
  String? seoTitleEn;
  String? seoKeywordsEn;
  String? seoDescriptionEn;
  int? views;
  String? code;
  int? status;
  int? featured;
  String? createdAt;
  String? updatedAt;
  Menu? menu;
  NewsUser? user;

  NewsData(
      {this.id,
      this.menuId,
      this.userId,
      this.titleEn,
      this.descriptionEn,
      this.image,
      this.imagePath,
      this.slug,
      this.seoTitleEn,
      this.seoKeywordsEn,
      this.seoDescriptionEn,
      this.views,
      this.code,
      this.status,
      this.featured,
      this.createdAt,
      this.updatedAt,
      this.menu,
      this.user});

  NewsData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    menuId = json['menu_id'];
    userId = json['user_id'];
    titleEn = json['title_en'];
    descriptionEn = json['description_en'];
    image = json['image'];
    imagePath = json['image_path'];
    slug = json['slug'];
    seoTitleEn = json['seo_title_en'];
    seoKeywordsEn = json['seo_keywords_en'];
    seoDescriptionEn = json['seo_description_en'];
    views = json['views'];
    code = json['code'];
    status = json['status'];
    featured = json['featured'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    menu = json['menu'] != null ? Menu.fromJson(json['menu']) : null;
    user = json['user'] != null ? NewsUser.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['menu_id'] = menuId;
    data['user_id'] = userId;
    data['title_en'] = titleEn;
    data['description_en'] = descriptionEn;
    data['image'] = image;
    data['image_path'] = imagePath;
    data['slug'] = slug;
    data['seo_title_en'] = seoTitleEn;
    data['seo_keywords_en'] = seoKeywordsEn;
    data['seo_description_en'] = seoDescriptionEn;
    data['views'] = views;
    data['code'] = code;
    data['status'] = status;
    data['featured'] = featured;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (menu != null) {
      data['menu'] = menu!.toJson();
    }
    if (user != null) {
      data['user'] = user!.toJson();
    }
    return data;
  }
}

class Menu {
  int? id;
  String? titleEn;

  Menu({this.id, this.titleEn});

  Menu.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    titleEn = json['title_en'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title_en'] = titleEn;
    return data;
  }
}

class NewsUser {
  int? id;
  String? name;
  String? referralLink;

  NewsUser({this.id, this.name, this.referralLink});

  NewsUser.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    referralLink = json['referral_link'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['referral_link'] = referralLink;
    return data;
  }
}
