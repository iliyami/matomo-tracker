import 'package:flutter/material.dart';
import 'package:matomo_tracker_enhanced/matomo_tracker.dart';
import 'package:matomo_tracker_enhanced/utils/random_alpha_numeric.dart';

final matomoObserver = RouteObserver<ModalRoute<void>>();

/// Register a [MatomoTracker.trackPageViewWithName] on this widget.
@optionalTypeArgs
mixin TraceableClientMixin<T extends StatefulWidget> on State<T>
    implements RouteAware {
  /// {@template traceableClientMixin.actionName}
  /// Equivalent to the page name. (e.g. `'HomePage'`).
  /// {@endtemplate}
  @protected
  String get actionName => 'Created widget ${widget.toStringShort()}';

  /// {@template traceableClientMixin.pvId}
  /// A 6 character unique page view ID.
  ///
  /// Each unique ID represents one page view.
  ///
  /// The default implementation will generate one on widget creation
  /// (recommended).
  ///
  /// For more information see `pvId` in [MatomoTracker.trackPageViewWithName] and
  /// [MatomoTracker.attachLastScreenInfo].
  /// {@endtemplate}
  @protected
  String get pvId => _pvId;
  String _pvId = randomAlphaNumeric(6);

  /// {@template traceableClientMixin.updatePvIdAfterPop}
  /// Used to control if a [Navigator.pop] back to this page is considered
  /// a new page view.
  ///
  /// If you do not consider this a new page view in your apps logic,
  /// you should return `false` to tell the widget to keep the old [pvId].
  /// If you overworte the [pvId] getter, this has no effect.
  /// {@endtemplate}
  @protected
  bool get updatePvIdAfterPop => true;

  /// {@template traceableClientMixin.path}
  /// Path to the widget. (e.g. `'/home'`).
  ///
  /// This will be combined with [MatomoTracker.contentBase]. The combination
  /// corresponds with `url`.
  /// {@endtemplate}
  @protected
  String? path;

  /// {@template traceableClientMixin.campaign}
  /// The campaign that lead to this interaction or `null` for a
  /// default entry. Setting this multiple times during an apps
  /// lifetime can have some side effects, see the [Campaign] class
  /// for more information.
  /// {@endtemplate}
  @protected
  Campaign? campaign;

  /// {@template traceableClientMixin.dimensions}
  /// A Custom Dimension value for a specific Custom Dimension ID.
  ///
  /// If Custom Dimension ID is 2 use `dimension2=dimensionValue` to send a
  /// value for this dimension.
  ///
  /// For additional remarks see [MatomoTracker.trackDimensions].
  /// {@endtemplate}
  @protected
  Map<String, String>? dimensions;

  /// {@template traceableClientMixin.performanceInfo}
  /// Information on how long it took to generate this content.
  /// {@endtemplate}
  @protected
  PerformanceInfo? performanceInfo;

  /// {@template traceableClientMixin.tracker}
  /// Matomo instance used to send actions.
  ///
  /// By default it uses the global [MatomoTracker.instance].
  /// {@endtemplate}
  @protected
  MatomoTracker get tracker => MatomoTracker.instance;

  @override
  void initState() {
    super.initState();
    _track();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final route = ModalRoute.of(context);
    if (route != null) {
      matomoObserver.subscribe(this, route);
    }
  }

  @override
  void dispose() {
    matomoObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPop() {}

  @override
  void didPopNext() {
    if (updatePvIdAfterPop) {
      _pvId = randomAlphaNumeric(6);
    }
    _track();
  }

  @override
  void didPush() {}

  @override
  void didPushNext() {}

  void _track() {
    tracker.trackPageViewWithName(
      actionName: actionName,
      pvId: pvId,
      path: path,
      campaign: campaign,
      dimensions: dimensions,
      performanceInfo: performanceInfo,
    );
  }
}
