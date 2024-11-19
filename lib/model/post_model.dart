class PostModel{
  final String id;
  final String? link;
  final String title;
  final String? description;
  final String? imageUrl;
  final String communityProfilePic;
  final int upVotes;
  final int downVotes;
  final int commentCount;
  final String userName;
  final String uid;
  final String type;
  final DateTime createdAt;
  final List<String> awards;

  PostModel({
    required this.id,
    this.link,
    this.imageUrl,
    required this.title,
    this.description,
    required this.communityProfilePic,
    required this.upVotes,
    required this.downVotes,
    required this.commentCount,
    required this.userName,
    required this.uid,
    required this.type,
    required this.createdAt,
    required this.awards,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      id: json['id'],
      link: json['link'],
      imageUrl: json['imageUrl'],
      title: json['title'],
      description: json['description'],
      communityProfilePic: json['communityProfilePic'],
      upVotes: json['upVotes'],
      downVotes: json['downVotes'],
      commentCount: json['commentCount'],
      userName: json['userName'],
      uid: json['uid'],
      type: json['type'],
      createdAt: DateTime.parse(json['createdAt']),
      awards: List<String>.from(json['awards']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'link': link,
      'title': title,
      'imageUrl': imageUrl,
      'description': description,
      'communityProfilePic': communityProfilePic,
      'upVotes': upVotes,
      'downVotes': downVotes,
      'commentCount': commentCount,
      'userName': userName,
      'uid': uid,
      'type': type,
      'createdAt': createdAt.toIso8601String(),
      'awards': awards,
    };
  }

  PostModel copyWith({
    String? id,
    String? link,
    String? title,
    String? imageUrl,
    String? description,
    String? communityProfilePic,
    int? upVotes,
    int? downVotes,
    int? commentCount,
    String? userName,
    String? uid,
    String? type,
    DateTime? createdAt,
    List<String>? awards,
  }) {
    return PostModel(
      id: id ?? this.id,
      link: link ?? this.link,
      title: title ?? this.title,
      imageUrl: imageUrl??this.imageUrl,
      description: description ?? this.description,
      communityProfilePic: communityProfilePic ?? this.communityProfilePic,
      upVotes: upVotes ?? this.upVotes,
      downVotes: downVotes ?? this.downVotes,
      commentCount: commentCount ?? this.commentCount,
      userName: userName ?? this.userName,
      uid: uid ?? this.uid,
      type: type ?? this.type,
      createdAt: createdAt ?? this.createdAt,
      awards: awards ?? this.awards,
    );
  }
}