import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:slack_cards/routing/route_names.dart';
import 'package:slack_cards/screens/login_email_password_screen.dart';
import 'package:slack_cards/screens/signup_email_password_screen.dart';

import '../screens/website/read_profile.dart';

// Route<dynamic> generateRoute(RouteSettings settings) {
//   var routingData = settings.name.getRoutingData; // Get the routing Data
//   switch (routingData.route) { // Switch on the path from the data
//     case HomeRoute:
//       return _getPageRoute(HomeView(), settings);
//     case AboutRoute:
//       return _getPageRoute(AboutView(), settings);
//     case EpisodesRoute:
//       return _getPageRoute(EpisodesView(), settings);
//     case EpisodeDetailsRoute:
//       var id = int.tryParse(routingData['id']); // Get the id from the data.
//       return _getPageRoute(EpisodeDetails(id: id), settings);
//     default:
//       return _getPageRoute(HomeView(), settings);
//   }
// }

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case HomeRoute:
      return _getPageRoute(EmailPasswordLogin(), settings);
    case LoginRoute:
      return _getPageRoute(EmailPasswordLogin(), settings);
    case SignupRoute:
      return _getPageRoute(EmailPasswordSignup(), settings);
    case UserRoute:
      return _getPageRoute(ReadProfile(), settings);
    default:
      return _getPageRoute(EmailPasswordLogin(), settings);
  }
}

PageRoute _getPageRoute(Widget child, RouteSettings settings) {
  return _FadeRoute(child: child, routeName: settings.name!);
}

class _FadeRoute extends PageRouteBuilder {
  final Widget? child;
  final String? routeName;
  _FadeRoute({this.child, this.routeName})
      : super(
          settings: RouteSettings(name: routeName),
          pageBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) =>
              child!,
          transitionsBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) =>
              FadeTransition(
            opacity: animation,
            child: child,
          ),
        );
}
