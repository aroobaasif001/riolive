class Host {
  final int id;
  final String name;
  final String roomId;
  final String channelName;
  final String appId;
  final String token;
  final bool isLive;

  Host({
    required this.id,
    required this.name,
    required this.roomId,
    required this.channelName,
    required this.appId,
    required this.token,
    required this.isLive,
  });

  factory Host.fromJson(Map<String, dynamic> json) {
    return Host(
      id: json['id'],
      name: json['name'] ?? 'Unknown',
      roomId: json['room_id'],
      channelName: json['channelName'],
      appId: json['appId'],
      token: json['token'],
      isLive: json['is_live'] ?? false,
    );
  }
}
