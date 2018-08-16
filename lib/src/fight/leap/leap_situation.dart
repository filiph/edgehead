library stranded.fight.leap_situation;

import 'package:edgehead/fractal_stories/actor.dart';
import 'package:edgehead/fractal_stories/situation.dart';
import 'package:edgehead/src/fight/common/attacker_situation.dart';
import 'package:edgehead/src/fight/leap/actions/finish_leap.dart';

const String leapSituationName = "LeapSituation";

Situation createLeapSituation(int id, Actor attacker, Actor target) =>
    new AttackerSituation.initialized(
        id, leapSituationName, [FinishLeap.singleton], [], attacker, target);
