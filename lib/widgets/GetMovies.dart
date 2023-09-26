import 'package:flutter/material.dart';
import 'package:mmovies/Models/Result.dart';
import 'package:mmovies/utils.dart';

String GetUrl(BuildContext context, Result data) {
  String url = '';
  print(data.originalTitle);
  try {
    switch (data.originalTitle) {
      case 'Spider-Man: No Way Home':
        url = 'https://bit.ly/3t711xD';
        break;

      default:
        return '';
    }
  } catch (e) {
    showsnackbar(context, e.toString());
  }
  
  return url;
}
