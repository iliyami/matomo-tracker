import 'package:flutter_test/flutter_test.dart';
import 'package:matomo_tracker_enhanced/src/session.dart';

import '../ressources/mock/data.dart';

void main() {
  test('it should be able to create Session', () async {
    final session = Session(
      firstVisit: sessionFirstVisite,
      lastVisit: sessionLastVisite,
      visitCount: sessionVisitCount,
    );

    expect(session.firstVisit, sessionFirstVisite);
    expect(session.lastVisit, sessionLastVisite);
    expect(session.visitCount, sessionVisitCount);
  });
}
