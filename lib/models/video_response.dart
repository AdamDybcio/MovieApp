import './video.dart';

class VideoResponse {
  final List<Video> videos;
  final String error;

  VideoResponse(
    this.videos,
    this.error,
  );

  VideoResponse.fromJson(Map<String, dynamic> json)
      : videos = (json['results'] as List)
            .map((video) => Video.fromJson(video))
            .toList(),
        error = "";

  VideoResponse.withError(String errorValue)
      : videos = [],
        error = errorValue;
}
