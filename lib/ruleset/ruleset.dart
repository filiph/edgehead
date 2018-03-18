library edgehead.ruleset;

import 'package:edgehead/fractal_stories/context.dart';
import 'package:meta/meta.dart';

bool _alwaysApplicableCallback(ApplicabilityContext _) => true;

typedef void RuleApplyCallback(ActionContext context);

typedef bool RuleIsApplicableCallback(ApplicabilityContext context);

@immutable
class Prerequisite implements Comparable<Prerequisite> {
  final int priority;

  final RuleIsApplicableCallback _isApplicableCallback;

  const Prerequisite(this.priority, this._isApplicableCallback);

  const Prerequisite.alwaysTrue()
      : priority = 0,
        _isApplicableCallback = _alwaysApplicableCallback;

  @override
  int compareTo(Prerequisite other) => -priority.compareTo(other.priority);

  bool isSatisfiedBy(ApplicabilityContext context) =>
      _isApplicableCallback(context);
}

@immutable
class Rule {
  final int hash;

  final Prerequisite prerequisite;

  final RuleApplyCallback applyCallback;

  Rule(
    this.hash,
    int priority,
    RuleIsApplicableCallback isApplicableCallback,
    this.applyCallback,
  )
      : prerequisite = new Prerequisite(priority, isApplicableCallback);
}

@immutable
class Ruleset {
  final Rule rule1;
  final Rule rule2;
  final Rule rule3;
  final Rule rule4;
  final Rule rule5;
  final Rule rule6;
  final Rule rule7;
  final Rule rule8;
  final Rule rule9;
  final Rule rule10;

  /// When using this constructor, you **MUST** provide the rules in order
  /// from highest [Prerequisite.priority] to lowest.
  const Ruleset(this.rule1,
      [this.rule2,
      this.rule3,
      this.rule4,
      this.rule5,
      this.rule6,
      this.rule7,
      this.rule8,
      this.rule9,
      this.rule10]);

  /// Prefer using the [Ruleset] constructor, which is much faster, but which
  /// requires the rules to be provided in order from highest priority to
  /// lowest.
  factory Ruleset.unordered(Iterable<Rule> rules) {
    final iter = rules.iterator;
    final ordered = new List.generate(10, (_) {
      if (!iter.moveNext()) return null;
      return iter.current;
    }, growable: false)
      ..sort((a, b) {
        if (a == null) return 1;
        if (b == null) return -1;
        return a.prerequisite.compareTo(b.prerequisite);
      });
    assert(ordered.length == 10);
    return new Ruleset(
      ordered[0],
      ordered[1],
      ordered[2],
      ordered[3],
      ordered[4],
      ordered[5],
      ordered[6],
      ordered[7],
      ordered[8],
      ordered[9],
    );
  }

  /// Runs the ruleset, choosing the most specific rule and running its
  /// [Rule.applyCallback].
  ///
  /// This also record the used rule into [context.outputWorld]'s history.
  void apply(ActionContext context) {
    // TODO: rewrite inline so that we don't need to create a new list
    //       every time
    final all = new List<Rule>.unmodifiable(<Rule>[
      rule1,
      rule2,
      rule3,
      rule4,
      rule5,
      rule6,
      rule7,
      rule8,
      rule9,
      rule10
    ]);

    for (final rule in all) {
      if (rule == null) break;
      if (rule.prerequisite.isSatisfiedBy(context)) {
        rule.applyCallback(context);
        context.outputWorld?.recordRule(rule);
        // TODO: when 2+ rules of same priority is applicable, use sim.random
        return;
      }
    }

    throw new StateError("No rule was applicable");
  }
}
