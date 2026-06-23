// lib/services/notification_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:seva_meal/services/accessToken.dart';

class NotificationService {
  static const String _fcmUrl = 'https://fcm.googleapis.com/v1/projects/seva-meal/messages:send';

  // ─── SEND TO SINGLE USER ───
  static Future<void> sendToUser({
    required String token,
    required String title,
    required String body,
    Map<String, String>? data,
  }) async {
    final accessToken = await AccessToken.getAccessToken();

    try {
      final response = await http.post(
        Uri.parse(_fcmUrl),
        headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $accessToken'},
        body: jsonEncode({
          'message': {
            // ✅ v1 wrapper
            'token': token, // ✅ 'token' not 'to'
            'notification': {'title': title, 'body': body}, // ✅ no 'sound' here
            'data': data ?? {},
            'android': {'priority': 'HIGH'}, // ✅ priority goes here
          },
        }),
      );

      print(response.body);

      if (response.statusCode == 200) {
        print('✅ Notification sent successfully');
      } else {
        print('❌ Failed: ${response.body}');
      }
    } catch (e) {
      print('❌ Error sending notification: $e');
    }
  }

  static Future<void> notifyVolunteerAssigned({
    required String donorToken,
    required String volunteerName,
    required String donationId,
    required String foodTitle,
  }) async {
    await sendToUser(
      token: donorToken,
      title: '🚴 Volunteer on the way!',
      body: '$volunteerName accepted your $foodTitle pickup.',
      data: {'type': 'volunteer_assigned', 'donationId': donationId},
    );
  }

  // food collected from donor
  static Future<void> notifyFoodCollected({
    required String donorToken,
    required String donationId,
    required String foodTitle,
  }) async {
    await sendToUser(
      token: donorToken,
      title: '✅ Food collected!',
      body: 'Your $foodTitle has been picked up and is heading to the shelter.',
      data: {'type': 'food_collected', 'donationId': donationId},
    );
  }

  // food delivered to NGO
  static Future<void> notifyFoodDelivered({
    required String donorToken,
    required String donationId,
    required String foodTitle,
    required String ngoName,
  }) async {
    await sendToUser(
      token: donorToken,
      title: '🎉 Delivered successfully!',
      body: 'Your $foodTitle reached $ngoName. Thank you for your kindness!',
      data: {'type': 'food_delivered', 'donationId': donationId},
    );
  }

  // donation expiring soon — no volunteer yet
  static Future<void> notifyExpiryWarning({
    required String donorToken,
    required String donationId,
    required String foodTitle,
  }) async {
    await sendToUser(
      token: donorToken,
      title: '⏰ Donation expiring soon',
      body: 'Your $foodTitle expires in 1 hour and has no volunteer yet.',
      data: {'type': 'expiry_warning', 'donationId': donationId},
    );
  }

  // ─── VOLUNTEER NOTIFICATIONS ───

  // new donation posted near volunteer
  static Future<void> notifyNewDonationNearby({
    required String volunteerToken,
    required String donationId,
    required String foodTitle,
    required String distance,
  }) async {
    await sendToUser(
      token: volunteerToken,
      title: '🍱 New donation nearby!',
      body: '$foodTitle available $distance away. Pick it up before it expires.',
      data: {'type': 'new_donation', 'donationId': donationId},
    );
  }

  // another volunteer joined same mission
  static Future<void> notifyVolunteerJoined({
    required String volunteerToken,
    required String donationId,
    required String newVolunteerName,
    required String foodTitle,
  }) async {
    await sendToUser(
      token: volunteerToken,
      title: '👥 $newVolunteerName joined!',
      body: '$newVolunteerName joined your $foodTitle mission.',
      data: {'type': 'volunteer_joined', 'donationId': donationId},
    );
  }

  static Future<void> sendToMultipleUsers({
    required List<String> tokens,
    required String title,
    required String body,
    Map<String, String>? data,
  }) async {
    if (tokens.isEmpty) return;
    String token = await AccessToken.getAccessToken();

    // FCM allows max 1000 tokens per request
    // split into chunks of 1000 just to be safe
    final chunks = _chunkList(tokens, 1000);

    for (final chunk in chunks) {
      try {
        final response = await http.post(
          Uri.parse(_fcmUrl),
          headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $token'},
          body: jsonEncode({
            'registration_ids': chunk,
            'priority': 'high',
            'notification': {'title': title, 'body': body, 'sound': 'default'},
            'data': data ?? {},
          }),
        );

        if (response.statusCode == 200) {
          print('Bulk notification sent to ${chunk.length} users');
        } else {
          print('Failed: ${response.body}');
        }
      } catch (e) {
        print('Error: $e');
      }
    }
  }

  // helper to split list into chunks
  static List<List<T>> _chunkList<T>(List<T> list, int size) {
    final chunks = <List<T>>[];
    for (var i = 0; i < list.length; i += size) {
      chunks.add(list.sublist(i, i + size > list.length ? list.length : i + size));
    }
    return chunks;
  }
}
