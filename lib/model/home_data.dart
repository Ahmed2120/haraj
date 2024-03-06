// To parse this JSON data, do
//
//     final homeData = homeDataFromMap(jsonString);

import 'dart:convert';

class HomeData {
  HomeData({
    this.status,
    this.ads,
    this.sectionCategory,
    this.msg,
    this.sectionModel,
  });

  final bool status;
  final List<Ad> ads;
  final List<SectionCategory> sectionCategory;
  final dynamic msg;
  final String sectionModel;

  factory HomeData.fromJson(String str) => HomeData.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory HomeData.fromMap(Map<String, dynamic> json) => HomeData(
        status: json["status"],
        ads: json["ads"] == null
            ? null
            : List<Ad>.from(json["ads"].map((x) => Ad.fromMap(x))),
        sectionCategory: json["data"] == null
            ? null
            : List<SectionCategory>.from(
                json["data"].map((x) => SectionCategory.fromMap(x))),
        msg: json["msg"],
        sectionModel: json["section_model"],
      );

  Map<String, dynamic> toMap() => {
        "status": status,
        "ads":
            ads == null ? null : List<dynamic>.from(ads.map((x) => x.toMap())),
        "SectionCategory": sectionCategory == null
            ? null
            : List<dynamic>.from(sectionCategory.map((x) => x.toMap())),
        "msg": msg,
        "section_model": sectionModel,
      };
}

class Ad {
  Ad({
    this.id,
    this.adTitle,
    this.adType,
    this.imageCover,
    this.sectionId,
    this.countryId,
    this.areaId,
    this.cityId,
    this.hayId,
    this.latitude,
    this.longitude,
    this.adTags,
    this.adContact,
    this.userId,
    this.allowComment,
    this.description,
    this.phoneActive,
    this.phone,
    this.subId,
    this.subSubId,
    this.year,
    this.salary,
    this.fnishAt,
    this.active,
    this.views,
    this.commissionPay,
    this.dateString,
    this.createdAt,
    this.favUser,
    this.followUser,
    this.country,
    this.area,
    this.city,
    this.hay,
    this.section,
    this.subSection,
    this.sub,
    this.user,
    this.images,
  });

  final int id;
  final String adTitle;
  final String adType;
  final String imageCover;
  final String sectionId;
  final String countryId;
  final String areaId;
  final String cityId;
  final dynamic hayId;
  final dynamic latitude;
  final dynamic longitude;
  final String adTags;
  final String adContact;
  final String userId;
  final String allowComment;
  final String description;
  final String phoneActive;
  final String phone;
  final String subId;
  final String subSubId;
  final dynamic year;
  final dynamic salary;
  final DateTime fnishAt;
  final String active;
  final String views;
  final String commissionPay;
  final String dateString;
  final DateTime createdAt;
  bool favUser;
  final int followUser;
  final Country country;
  final Area area;
  final City city;
  final dynamic hay;
  final Section section;
  final SubSection subSection;
  final Sub sub;
  final User user;
  final List<dynamic> images;

  factory Ad.fromJson(String str) => Ad.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Ad.fromMap(Map<String, dynamic> json) => Ad(
        id: json["id"],
        adTitle: json["ad_title"],
        adType: json["ad_type"],
        imageCover: json["image_cover"],
        sectionId: json["section_id"],
        countryId: json["country_id"],
        areaId: json["area_id"],
        cityId: json["city_id"],
        hayId: json["hay_id"],
        latitude: json["Latitude"],
        longitude: json["longitude"],
        adTags: json["ad_tags"],
        adContact: json["ad_contact"],
        userId: json["user_id"],
        allowComment: json["allow_comment"],
        description: json["description"],
        phoneActive: json["phone_active"],
        phone: json["phone"],
        subId: json["sub_id"],
        subSubId: json["sub_sub_id"],
        year: json["year"],
        salary: json["salary"],
        fnishAt:
            json["fnish_at"] == null ? null : DateTime.parse(json["fnish_at"]),
        active: json["active"],
        views: json["views"],
        commissionPay: json["commission_pay"],
        dateString: json["date_string"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        favUser: json["fav_user"] == 0 ? false : true,
        followUser: json["follow_user"],
        country:
            json["country"] == null ? null : Country.fromMap(json["country"]),
        area: json["area"] == null ? null : Area.fromMap(json["area"]),
        city: json["city"] == null ? null : City.fromMap(json["city"]),
        hay: json["hay"],
        section:
            json["section"] == null ? null : Section.fromMap(json["section"]),
        subSection: json["sub_section"] == null
            ? null
            : SubSection.fromMap(json["sub_section"]),
        sub: json["sub"] == null ? null : Sub.fromMap(json["sub"]),
        user: json["user"] == null ? null : User.fromMap(json["user"]),
        images: json["images"] == null
            ? null
            : List<dynamic>.from(json["images"].map((x) => x)),
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "ad_title": adTitle,
        "ad_type": adType,
        "image_cover": imageCover,
        "section_id": sectionId,
        "country_id": countryId,
        "area_id": areaId,
        "city_id": cityId,
        "hay_id": hayId,
        "Latitude": latitude,
        "longitude": longitude,
        "ad_tags": adTags,
        "ad_contact": adContact,
        "user_id": userId,
        "allow_comment": allowComment,
        "description": description,
        "phone_active": phoneActive,
        "phone": phone,
        "sub_id": subId,
        "sub_sub_id": subSubId,
        "year": year,
        "salary": salary,
        "fnish_at": fnishAt == null
            ? null
            : "${fnishAt.year.toString().padLeft(4, '0')}-${fnishAt.month.toString().padLeft(2, '0')}-${fnishAt.day.toString().padLeft(2, '0')}",
        "active": active,
        "views": views,
        "commission_pay": commissionPay,
        "date_string": dateString,
        "created_at": createdAt == null ? null : createdAt.toIso8601String(),
        "fav_user": favUser,
        "follow_user": followUser,
        "country": country == null ? null : country.toMap(),
        "area": area == null ? null : area.toMap(),
        "city": city == null ? null : city.toMap(),
        "hay": hay,
        "section": section == null ? null : section.toMap(),
        "sub_section": subSection == null ? null : subSection.toMap(),
        "sub": sub == null ? null : sub.toMap(),
        "user": user == null ? null : user.toMap(),
        "images":
            images == null ? null : List<dynamic>.from(images.map((x) => x)),
      };
}

class Area {
  Area({
    this.id,
    this.areaName,
  });

  final int id;
  final String areaName;

  factory Area.fromJson(String str) => Area.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Area.fromMap(Map<String, dynamic> json) => Area(
        id: json["id"],
        areaName: json["area_name"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "area_name": areaName,
      };
}

class City {
  City({
    this.id,
    this.cityName,
  });

  final int id;
  final String cityName;

  factory City.fromJson(String str) => City.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory City.fromMap(Map<String, dynamic> json) => City(
        id: json["id"],
        cityName: json["city_name"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "city_name": cityName,
      };
}

class Country {
  Country({
    this.id,
    this.countryName,
  });

  final int id;
  final String countryName;

  factory Country.fromJson(String str) => Country.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Country.fromMap(Map<String, dynamic> json) => Country(
        id: json["id"],
        countryName: json["country_name"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "country_name": countryName,
      };
}

class Section {
  Section({
    this.id,
    this.sectionName,
  });

  final int id;
  final String sectionName;

  factory Section.fromJson(String str) => Section.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Section.fromMap(Map<String, dynamic> json) => Section(
        id: json["id"],
        sectionName: json["section_name"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "section_name": sectionName,
      };
}

class Sub {
  Sub({
    this.id,
    this.subSubName,
  });

  final int id;
  final String subSubName;

  factory Sub.fromJson(String str) => Sub.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Sub.fromMap(Map<String, dynamic> json) => Sub(
        id: json["id"],
        subSubName: json["sub_sub_name"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "sub_sub_name": subSubName,
      };
}

class SubSection {
  SubSection({
    this.id,
    this.subName,
  });

  final int id;
  final String subName;

  factory SubSection.fromJson(String str) =>
      SubSection.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory SubSection.fromMap(Map<String, dynamic> json) => SubSection(
        id: json["id"],
        subName: json["sub_name"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "sub_name": subName,
      };
}

class User {
  User({
    this.id,
    this.username,
    this.createdAt,
    this.dateString,
    this.img,
    this.visitorFollow,
  });

  final int id;
  final String username;
  final DateTime createdAt;
  final String dateString;
  final dynamic img;
  final int visitorFollow;

  factory User.fromJson(String str) => User.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory User.fromMap(Map<String, dynamic> json) => User(
        id: json["id"],
        username: json["username"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        dateString: json["date_string"],
        img: json["img"],
        visitorFollow: json["visitor_follow"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "username": username,
        "created_at": createdAt == null ? null : createdAt.toIso8601String(),
        "date_string": dateString,
        "img": img,
        "visitor_follow": visitorFollow,
      };
}

class SectionCategory {
  SectionCategory({
    this.id,
    this.sectionName,
    this.sectionDesc,
    this.image,
    this.active,
    this.sectionOrder,
    this.sectionAddadText,
  });

  final int id;
  final String sectionName;
  final String sectionDesc;
  final String image;
  final String active;
  final String sectionOrder;
  final String sectionAddadText;

  factory SectionCategory.fromJson(String str) =>
      SectionCategory.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory SectionCategory.fromMap(Map<String, dynamic> json) => SectionCategory(
        id: json["id"],
        sectionName: json["section_name"],
        sectionDesc: json["section_desc"],
        image: json["image"],
        active: json["active"],
        sectionOrder: json["section_order"],
        sectionAddadText: json["section_addad_text"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "section_name": sectionName,
        "section_desc": sectionDesc,
        "image": image,
        "active": active,
        "section_order": sectionOrder,
        "section_addad_text": sectionAddadText,
      };
}
