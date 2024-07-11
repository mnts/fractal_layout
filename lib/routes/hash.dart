import 'package:go_router/go_router.dart';
import '../route.dart';

final hashRoute = GoRoute(
  path: '/-:h',
  builder: (context, state) {
    return FractalRoute(state.pathParameters['h'] ?? '');
  },
);
