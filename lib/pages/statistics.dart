import 'package:dringo/domain/stats.dart';
import 'package:dringo/pages/dashboard.dart';
import 'package:dringo/providers/degustation_provider.dart';
import 'package:dringo/services/stream_socket.dart';
import 'package:dringo/widgets/app_drawer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Statistics extends StatefulWidget {
  static const routeName = '/statistics';
  @override
  _StatisticsState createState() => _StatisticsState();
}

class _StatisticsState extends State<Statistics> {

  List<Stats> stats= [];

  @override
  void initState() {

    List<Stats> stats = Provider.of<DegustationProvider>(context, listen: false).stats;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      drawer: AppDrawer(),
      body: Container(
        child: Consumer<DegustationProvider>(
         builder: (context, degustationProvider, child) {
           stats = degustationProvider.stats;
           return Column(
             mainAxisSize: MainAxisSize.min,
             mainAxisAlignment: MainAxisAlignment.center,
             crossAxisAlignment: CrossAxisAlignment.center,
             children: [
               SizedBox(
                 height: 50.0,
               ),
               Center(
                 child: Text(
                   'Statistics',
                   style: TextStyle(
                       fontSize: 28.0,
                       fontWeight: FontWeight.w900,
                       color: Colors.indigo),
                 ),
               ),
               Container(
                 height: 500,
                 child: ListView.builder(
                   physics: const BouncingScrollPhysics(),
                   scrollDirection: Axis.vertical,
                   shrinkWrap: true,
                   itemCount: stats.length,
                   itemBuilder: (context, index) {
                     return Center(
                       child: ListTile(
                         title: Row(
                           children: [
                             Padding(
                               padding: const EdgeInsets.all(8.0),
                               child: Text(
                                 stats[index].beer.name,
                                 style: TextStyle(
                                     color: Colors.black87,
                                     fontSize: 16.0),
                               ),
                             ),
                             Padding(
                               padding: const EdgeInsets.all(8.0),
                               child: Text(
                                 stats[index].beer.abv.toString() + '%',
                                 style: TextStyle(
                                     color: Colors.black87,
                                     fontSize: 16.0),
                               ),
                             ),
                             Padding(
                               padding: const EdgeInsets.all(8.0),
                               child: Text(
                                 stats[index].avg,
                                 style: TextStyle(
                                     color: Colors.black87,
                                     fontSize: 16.0),
                               ),
                             ),

                           ],
                         ),
                       ),
                     );
                   },
                 ),
               ),
             ],
           );
         },
        ),
      ),
    );
  }


}
