import 'package:edgehead/fractal_stories/action.dart';
import 'package:edgehead/fractal_stories/situation.dart';
import 'package:edgehead/src/predetermined_result.dart';
import 'package:quiver/core.dart';

abstract class Predeterminable implements Situation {
  static final _failureChance =
      new Optional<ReasonedSuccessChance>.of(ReasonedSuccessChance.sureFailure);

  static final _successChance =
      new Optional<ReasonedSuccessChance>.of(ReasonedSuccessChance.sureSuccess);

  bool get actionsGuaranteedToFail =>
      predeterminedResult == Predetermination.failureGuaranteed;

  bool get actionsGuaranteedToSucceed =>
      predeterminedResult == Predetermination.successGuaranteed;

  Optional<ReasonedSuccessChance> get predeterminedChance {
    switch (predeterminedResult) {
      case Predetermination.none:
        return const Optional<ReasonedSuccessChance>.absent();
      case Predetermination.failureGuaranteed:
        return _failureChance;
      case Predetermination.successGuaranteed:
        return _successChance;
      default:
        throw new ArgumentError(predeterminedResult);
    }
  }

  Predetermination get predeterminedResult;
}
