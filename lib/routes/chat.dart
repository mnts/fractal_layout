import 'package:app_fractal/index.dart';
import 'package:fractal_layout/widget.dart';
import 'package:go_router/go_router.dart';
import '../screens/chats.dart';

final chat = GoRoute(
  path: '/chats/:chat',
  builder: (context, state) {
    final app = AppFractal.active;

    final chatName = state.pathParameters['chat'];
    if (chatName != null) {
      app.preload();
      return FutureBuilder(
          future: app.whenLoaded,
          builder: (ctx, snap) {
            if (snap.data == null) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            final node = app.sub[chatName];
            return ChatsScreen(app, node);
          });
    }
    return ChatsScreen(app);
  },
);

final chatHome = GoRoute(
  path: '/',
  builder: (context, state) {
    final app = AppFractal.active;

    return ChatsScreen(app);
  },
);
