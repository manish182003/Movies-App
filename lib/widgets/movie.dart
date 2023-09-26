import 'package:flutter/material.dart';

import 'package:mmovies/Models/Result.dart';

class Movietrending extends StatelessWidget {
  final Result data;
  const Movietrending({
    Key? key,
    required this.data,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height*0.412;
    return Container(
      margin: EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
      
        children: [
          Expanded(
           
          //  width: double.infinity,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                'https://image.tmdb.org/t/p/w500/${data.posterPath}',
                fit: BoxFit.cover,
               // height: screenHeight*0.55,
              ),
            ),
          ),
          Container(
          
            padding: EdgeInsets.all(12),
           // width: double.infinity,
            alignment: Alignment.center,
                 //   height: screenHeight*0.12,
                 
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(12),
                bottomRight: Radius.circular(12),
              ),
              color: Colors.yellow,
            ),
            child: Text(
              data.originalTitle,
              style: TextStyle(
                fontSize: 16,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
        ],
      ),
    );
  }
}
