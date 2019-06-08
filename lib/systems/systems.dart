import 'dart:async';

class systems {
  StreamController hSC = StreamController<double>.broadcast(),
      bSC = StreamController<double>.broadcast();

  Sink get sS => hSC.sink;
  Sink get bS => bSC.sink;

  Stream<double> get hSG => hSC.stream;
  Stream<double> get bSG => bSC.stream;

  addValue(double v) {
    sS.add(v);
  }

  addBulletValue(double v) {
    bS.add(v);
  }

  voiddispose() {
    hSC.close();
    bSC.close();
  }
}