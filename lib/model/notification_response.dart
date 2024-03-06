// To parse this JSON data, do
//
//     final notificationResponse = notificationResponseFromMap(jsonString);

import 'dart:convert';

class NotificationResponse {
  NotificationResponse({
    this.status,
    this.notifications,
    this.msg,
  });

  final bool status;
  final List<Notification> notifications;
  final dynamic msg;

  factory NotificationResponse.fromJson(String str) =>
      NotificationResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory NotificationResponse.fromMap(Map<String, dynamic> json) =>
      NotificationResponse(
        status: json["status"] == null ? null : json["status"],
        notifications: json["data"] == null
            ? null
            : List<Notification>.from(
                json["data"].map((x) => Notification.fromMap(x))),
        msg: json["msg"],
      );

  Map<String, dynamic> toMap() => {
        "status": status == null ? null : status,
        "data": notifications == null
            ? null
            : List<dynamic>.from(notifications.map((x) => x.toMap())),
        "msg": msg,
      };
}

class Notification {
  Notification({
    this.id,
    this.adId,
    this.byUser,
    this.toUserId,
    this.type,
    this.seen,
    this.createdAt,
    this.updatedAt,
    this.ad,
    this.dateString,
  });

  final int id;
  final String adId;
  final String byUser;
  final String toUserId;
  final String type;
  final String seen;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Ad ad;
  final String dateString;

  factory Notification.fromJson(String str) =>
      Notification.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Notification.fromMap(Map<String, dynamic> json) => Notification(
        id: json["id"] == null ? null : json["id"],
        adId: json["ad_id"] == null ? null : json["ad_id"],
        byUser: json["by_user"] == null ? null : json["by_user"],
        toUserId: json["to_user_id"] == null ? null : json["to_user_id"],
        type: json["type"] == null ? null : json["type"],
        seen: json["seen"] == null ? null : json["seen"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        ad: json["ad"] == null ? null : Ad.fromMap(json["ad"]),
        dateString: json["date_string"] == null ? null : json["date_string"],
      );

  Map<String, dynamic> toMap() => {
        "id": id == null ? null : id,
        "ad_id": adId == null ? null : adId,
        "by_user": byUser == null ? null : byUser,
        "to_user_id": toUserId == null ? null : toUserId,
        "type": type == null ? null : type,
        "seen": seen == null ? null : seen,
        "created_at": createdAt == null ? null : createdAt.toIso8601String(),
        "updated_at": updatedAt == null ? null : updatedAt.toIso8601String(),
        "ad": ad == null ? null : ad.toMap(),
        "date_string": dateString == null ? null : dateString,
      };
}

class Ad {
  Ad({
    this.id,
    this.adTitle,
    this.refresh,
    this.adType,
    this.imageCover,
    this.sectionId,
    this.countryId,
    this.areaId,
    this.cityId,
    this.hayId,
    this.latitude,
    this.longitude,
    this.see,
    this.adTags,
    this.adContact,
    this.userId,
    this.allowComment,
    this.description,
    this.phoneActive,
    this.phone,
    this.address,
    this.subId,
    this.subSubId,
    this.year,
    this.salary,
    this.fnishAt,
    this.adCustem,
    this.active,
    this.views,
    this.commissionPay,
    this.dateString,
    this.favUser,
    this.followUser,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.city,
    this.username,
  });

  final int id;
  final String adTitle;
  final DateTime refresh;
  final String adType;
  final String imageCover;
  final String sectionId;
  final String countryId;
  final String areaId;
  final String cityId;
  final dynamic hayId;
  final dynamic latitude;
  final dynamic longitude;
  final String see;
  final String adTags;
  final String adContact;
  final String userId;
  final String allowComment;
  final String description;
  final String phoneActive;
  final String phone;
  final dynamic address;
  final String subId;
  final dynamic subSubId;
  final dynamic year;
  final dynamic salary;
  final DateTime fnishAt;
  final String adCustem;
  final String active;
  final String views;
  final String commissionPay;
  final String dateString;
  final int favUser;
  final int followUser;
  final DateTime createdAt;
  final DateTime updatedAt;
  final dynamic deletedAt;
  final String city;
  final String username;

  factory Ad.fromJson(String str) => Ad.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Ad.fromMap(Map<String, dynamic> json) => Ad(
        id: json["id"] == null ? null : json["id"],
        adTitle: json["ad_title"] == null ? null : json["ad_title"],
        refresh:
            json["refresh"] == null ? null : DateTime.parse(json["refresh"]),
        adType: json["ad_type"] == null ? null : json["ad_type"],
        imageCover: json["image_cover"] == null ? null : json["image_cover"],
        sectionId: json["section_id"] == null ? null : json["section_id"],
        countryId: json["country_id"] == null ? null : json["country_id"],
        areaId: json["area_id"] == null ? null : json["area_id"],
        cityId: json["city_id"] == null ? null : json["city_id"],
        hayId: json["hay_id"],
        latitude: json["Latitude"],
        longitude: json["longitude"],
        see: json["see"] == null ? null : json["see"],
        adTags: json["ad_tags"] == null ? null : json["ad_tags"],
        adContact: json["ad_contact"] == null ? null : json["ad_contact"],
        userId: json["user_id"] == null ? null : json["user_id"],
        allowComment:
            json["allow_comment"] == null ? null : json["allow_comment"],
        description: json["description"] == null ? null : json["description"],
        phoneActive: json["phone_active"] == null ? null : json["phone_active"],
        phone: json["phone"] == null ? null : json["phone"],
        address: json["address"],
        subId: json["sub_id"] == null ? null : json["sub_id"],
        subSubId: json["sub_sub_id"],
        year: json["year"],
        salary: json["salary"],
        fnishAt:
            json["fnish_at"] == null ? null : DateTime.parse(json["fnish_at"]),
        adCustem: json["ad_custem"] == null ? null : json["ad_custem"],
        active: json["active"] == null ? null : json["active"],
        views: json["views"] == null ? null : json["views"],
        commissionPay:
            json["commission_pay"] == null ? null : json["commission_pay"],
        dateString: json["date_string"] == null ? null : json["date_string"],
        favUser: json["fav_user"] == null ? null : json["fav_user"],
        followUser: json["follow_user"] == null ? null : json["follow_user"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        deletedAt: json["deleted_at"],
        city: json["city"] == null ? null : json["city"],
        username: json["username"] == null ? null : json["username"],
      );

  Map<String, dynamic> toMap() => {
        "id": id == null ? null : id,
        "ad_title": adTitle == null ? null : adTitle,
        "refresh": refresh == null ? null : refresh.toIso8601String(),
        "ad_type": adType == null ? null : adType,
        "image_cover": imageCover == null ? null : imageCover,
        "section_id": sectionId == null ? null : sectionId,
        "country_id": countryId == null ? null : countryId,
        "area_id": areaId == null ? null : areaId,
        "city_id": cityId == null ? null : cityId,
        "hay_id": hayId,
        "Latitude": latitude,
        "longitude": longitude,
        "see": see == null ? null : see,
        "ad_tags": adTags == null ? null : adTags,
        "ad_contact": adContact == null ? null : adContact,
        "user_id": userId == null ? null : userId,
        "allow_comment": allowComment == null ? null : allowComment,
        "description": description == null ? null : description,
        "phone_active": phoneActive == null ? null : phoneActive,
        "phone": phone == null ? null : phone,
        "address": address,
        "sub_id": subId == null ? null : subId,
        "sub_sub_id": subSubId,
        "year": year,
        "salary": salary,
        "fnish_at": fnishAt == null
            ? null
            : "${fnishAt.year.toString().padLeft(4, '0')}-${fnishAt.month.toString().padLeft(2, '0')}-${fnishAt.day.toString().padLeft(2, '0')}",
        "ad_custem": adCustem == null ? null : adCustem,
        "active": active == null ? null : active,
        "views": views == null ? null : views,
        "commission_pay": commissionPay == null ? null : commissionPay,
        "date_string": dateString == null ? null : dateString,
        "fav_user": favUser == null ? null : favUser,
        "follow_user": followUser == null ? null : followUser,
        "created_at": createdAt == null ? null : createdAt.toIso8601String(),
        "updated_at": updatedAt == null ? null : updatedAt.toIso8601String(),
        "deleted_at": deletedAt,
        "city": city == null ? null : city,
        "username": username == null ? null : username,
      };
}
