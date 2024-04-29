import 'dart:ffi';

import 'package:intl/intl.dart';

class PostResDto {
  final int? id;
  final String? title;
  final String? content;
  final DateTime? created;
  final int? likeCount;
  final String? authorName;

  PostResDto(
      {this.id,
      this.title,
      this.content,
      this.created,
      this.likeCount,
      this.authorName});

  // 통신을 위해서 Json 처럼 생긴 문자열
  PostResDto.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        title = json["title"] ?? '',
        content = json["content"] ?? '',
        created =
            DateFormat("yyyy-MM-ddTHH:mm:ss.SSSSSS").parse(json["createAt"]),
        likeCount = json["likeCount"],
        authorName = json["authorName"] ?? '';
}
