import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:riolive/utile/app_url.dart';

import '../models/host_model.dart';

class HostController extends GetxController {
  var hosts = <Host>[].obs;

  Future<void> fetchHosts() async {
    try {
      final res = await http.get(
        Uri.parse(AppUrl.liveListCall),
        headers: {'Authorization': "Bearer ${AppUrl.token}"},
      );
      if (res.statusCode == 200) {
        final data = json.decode(res.body);
        final List list = data['hosts'] ?? [];
        hosts.value = list.map((e) => Host.fromJson(e)).toList();
      }
    } catch (e) {
      print("Error fetching hosts: $e");
    }
  }

  @override
  void onInit() {
    super.onInit();
    fetchHosts();

    // auto refresh every 5s (simulate real-time)
    ever(hosts, (_) => print("Hosts updated: ${hosts.length}"));
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 5));
      await fetchHosts();
      return true;
    });
  }
}
