import 'package:fractal_layout/scaffold.dart';
import 'package:fractal_layout/widget.dart';
import 'package:go_router/go_router.dart';
import '../screens/chats.dart';

/*
final chat = GoRoute(
  path: '/chats/:chat',
  builder: (context, state) {
    final chatName = state.pathParameters['chat'];
    if (chatName != null) {
      ChatsScreen.node.preload();
      return FutureBuilder(
          future: ChatsScreen.node.whenLoaded,
          builder: (ctx, snap) {
            if (snap.data == null) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (ChatsScreen.node.sub[chatName] case NodeFractal node) {
              return ChatsScreen(node);
            }

            return ErrorWidget('No chat found');
          });
    }
    return const ChatsIntro();
  },
);

final chatHome = GoRoute(
  path: '/',
  builder: (context, state) {
    return const ChatsIntro();
  },
);

class ChatsIntro extends StatelessWidget {
  const ChatsIntro({super.key});

  @override
  Widget build(BuildContext context) {
    return FractalScaffold(
      body: Center(
          child: ElevatedButton(
        onPressed: () async {
          final chat = await ChatsScreen.create('');
          context.go('/chats/${chat.name}');
        },
        child: Icon(Icons.add),
      )),
    );
  }
}

*/
