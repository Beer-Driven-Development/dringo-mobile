import 'package:dringo/domain/beer.dart';
import 'package:dringo/domain/pivot.dart';
import 'package:dringo/domain/rating.dart';
import 'package:dringo/providers/degustation_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';

class PivotItem extends StatefulWidget {
  Pivot pivot;
  Beer beer;

  PivotItem({this.pivot, this.beer});

  @override
  _PivotItemState createState() => _PivotItemState();
}

class _PivotItemState extends State<PivotItem> {
  double score;

  Rating currentRating = new Rating();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Voting on ' +
                    widget.pivot.category.name +
                    ' with weight ' +
                    widget.pivot.weight.toString(),
                style: TextStyle(fontSize: 19.0, color: Colors.black87),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: RatingBar.builder(
              glowColor: Colors.indigoAccent,
              initialRating: 0,
              minRating: 0,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
              itemBuilder: (context, _) => Icon(
                Icons.sports_bar_sharp,
                color: Colors.indigo,
              ),
              onRatingUpdate: (score) {
                this.score = score;
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: RaisedButton(
              elevation: 10,
              color: Colors.white,
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 50),
              shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(50.0)),
              child: Text(
                'Vote'.toUpperCase(),
                style: TextStyle(fontSize: 18.0, color: Colors.indigoAccent),
              ),
              onPressed: () async {
                var rating = await Provider.of<DegustationProvider>(context,
                        listen: false)
                    .vote(widget.pivot.room.id, widget.beer.id, widget.pivot.id,
                        score);
                currentRating = rating;
              },
            ),
          ),
        ],
      ),
    );
  }
}
