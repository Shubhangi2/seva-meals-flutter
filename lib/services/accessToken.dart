import 'dart:convert';
import 'package:googleapis_auth/auth_io.dart';

class AccessToken {
  static Future<String> getAccessToken() async {
    final jsonToken = {
      "type": "service_account",
      "project_id": "seva-meal",
      "private_key_id": "3587a6beeaa652f0b7e284d47bfd5722c0c76e44",
      "private_key":
          "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQDKwk2Xq4bl8nA/\nXnaBgntbEKVcDcXBhRtXEYL2s+JfQoK9YA5bkxjU5ttJs3AnR4flasqVIh+ZhBvo\nKF+ddW07g+gk7C3WilU7FNCa4JXHxA65/bvnNukNEymRQzcl0fT8JwTM5YBEKYXU\nt+WjQ2WTay6CNtjLX4p2UO62uuq7UhXA8XYE35eXftXuzzrNuOWW7oTsykTv6cas\nc98q3wNXE0yNaxAcCN3gYmmYtj58dO6mEN+JFMsvPXUqRgKRBVTNT3sKkGyYcZ7w\nXaCcS/McdWBv3YuIEjzRZggU1FUGH6ayYTprJALgKoNwhOe0RaFKNzzrF9hNI5+v\nld1UvRqpAgMBAAECggEAGhWttEu7ntUWBj0Bm289Le3CDEn0TU1xwz2MPu9M+erd\nVX4oUrUlnmw1vXFRhiggbk4TEmURsicKDQ+2n1P2UdAKO0fMLNvek6t9m9M1Sb4q\nE9j2BcytZkJ3GEpQq7OrZA4kArUqz3oVDtT6vMqEpJbHJLboJJ/duRN35ne9D4yI\n/yX3zY0OgOekNgYwBTrGpF1pBu5KXQiMl1OfpAIA4D77FAMQoz0+8QIbcZyunLcf\nDAsKu6bXEZfi1/is4BJz5zDMGEEr7vNStqte+E6MwMdR9fF4VLyyKQRadMbQcJaX\nBAAu4tsrt0DYNVS0wvfNPp9C0iKQiurcQYE67f2aVQKBgQDpXhTZNB3Tztyo/PyE\nLqUjkzParT1lLRsPTn8RLpLTaumy253XDaIXsqYLlUENafndIq7jX0b0/2WtNq21\ntAFB2bduF/DtQMSIesJc/GbcKK5Z8kjnKdP9BpJ/xdNL7HUw/TemfRE1+nqiBozq\nnrmjVoiLKy6x96eXhr5/OpPmPQKBgQDebEpmX6SXdlB60j+YNSGASgDWdkFUOXg6\n/ODlGmftcyd5AjyyapxMjQ9IeMMmavWurvlcMFCS9QXpjYNelJMQFeAjsDAS53Ih\n7ekgXhMK5zw2ayMXJml1jTBDOIEX74dEAgVZsS2htyVdV/8Llb0NcnDt/lNqaKlt\nXzMRCJo43QKBgCeakcsyrwUtDAGZvXjpOZlJ9/jagZrUBs2YMrRFxSEf+b0izCyc\n4a9H4CoDEGEoZQEES83Gc5JMbYLxzpURkU0Nl7WVVovM/A11V9rT8tjWBpC5L2ob\njSBZpy8L8Ynm/RRtRK56dxtEAN/SYMPIYBS6ML39fBUzxDtQ4K9Sz5q5AoGBANKl\ndlS8EdIMEC4xvl61OtQXwfFaL4bHorEi2w6+0lxUKbb1wmwqgXoSQb4d+JwCwki8\nl5aSf0yeVwoYpqjFRv396beC3hSZM0Mk4RtxXNF/q0vSbXo4O7pDi8it07zKca2b\nyFtobFHydKWReA8NsezxTDhpG7D0DDlz5pYkMoLVAoGAH8WtA24YQ1f0LG1agNr0\nKDVUi6Nm4nhdUdXiTA/8u3nrT/zelvIEPDGZs8kRNCxz6TlzXbQHtKKI3tHO1Oaq\naYj3nNN8uSH/3NUEzOFDcthp2ffAT1jiVLtHFkRsrSZ5f0zYCGsvrzcgf4ozbhhP\nasOQ3Jq2Kw1bDTKJpiW4Ztk=\n-----END PRIVATE KEY-----\n",
      "client_email": "firebase-adminsdk-fbsvc@seva-meal.iam.gserviceaccount.com",
      "client_id": "108277469700182234480",
      "auth_uri": "https://accounts.google.com/o/oauth2/auth",
      "token_uri": "https://oauth2.googleapis.com/token",
      "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
      "client_x509_cert_url":
          "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-fbsvc%40seva-meal.iam.gserviceaccount.com",
      "universe_domain": "googleapis.com",
    };

    final scopes = ['https://www.googleapis.com/auth/firebase.messaging'];

    final credentials = ServiceAccountCredentials.fromJson(jsonToken);
    final client = await clientViaServiceAccount(credentials, scopes);
    final token = client.credentials.accessToken.data;
    client.close();

    return token; // ✅ this is the actual Bearer token
  }
}
