import 'package:dringo/domain/pivot.dart';
import 'package:dringo/domain/room.dart';

import 'beer.dart';

class DegustationData {
  Room room;
  Beer beer;
  List<Pivot> pivots;

  DegustationData(this.room, this.beer, this.pivots);
}
