/*
import 'package:fractal/utils/random.dart';
import 'package:fractal_layout/widget.dart';
import 'package:fractal_layout/widgets/index.dart';
import 'package:go_router/go_router.dart';
import 'package:timeago/timeago.dart';
import '../scaffold.dart';

class ChatsScreen extends StatefulWidget {
  static late final NodeFractal node;

  static Future<NodeFractal> create(String name) async {
    if (name.isEmpty) name = getRandomString(6);
    final node = await NodeFractal.controller.put({
      'name': name.toLowerCase(),
      'to': ChatsScreen.node,
    });
    await node.synch();
    await node.preload();
    return node;
  }

  final NodeFractal? active;
  const ChatsScreen(
    this.active,
  );

  @override
  State<ChatsScreen> createState() => _ChatsScreenState();
}

class _ChatsScreenState extends State<ChatsScreen> {
  late final nameCtrl = TextEditingController(text: widget.active?.name);

  final nameFocus = FocusNode();

  @override
  void initState() {
    nameFocus.addListener(() {
      //create(nameCtrl.text);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FractalScaffold(
      node: widget.active,
      /*
      title: Center(
        child: widget.active == null
            ? Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                width: 192,
                height: 36,
                child: TextFormField(
                  focusNode: nameFocus,
                  controller: nameCtrl,
                  onFieldSubmitted: (s) {
                    create(s);
                  },
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.all(4),
                    hintText: "Chat name",
                  ),
                  style: const TextStyle(fontSize: 16),
                ),
              )
            : Text(
                widget.active!.display,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
      ),
      */
      body: widget.active != null
          ? Listen(
              widget.active!,
              (ctx, ch) {
                final list = [
                  ...widget.active!.list.where(
                    (f) => f is! InteractionFractal,
                  ),
                ];
                return Stack(
                  children: <Widget>[
                    ListView.builder(
                      itemCount: list.length, //catalog.list.length,
                      reverse: true,
                      padding: const EdgeInsets.only(
                        bottom: 50,
                        left: 4,
                      ),
                      itemBuilder: (context, i) => switch (list[i]) {
                        EventFractal f => message(f),
                      },
                    ),
                    poster(),
                  ],
                );
              },
              preload: 'node',
            )
          : chatList,
    );
  }

  late final scheme = Theme.of(context).colorScheme;

  Widget message(EventFractal f) {
    return HoverOver(
      builder: (hovered) => Container(
        padding: const EdgeInsets.fromLTRB(8, 4, 4, 2),
        decoration: BoxDecoration(
          color: hovered ? Colors.grey.withAlpha(40) : null,
        ),
        child: Row(
          children: [
            switch (f.owner) {
              DeviceFractal owner => Text(
                  'Guest ${owner.name}: ',
                  style: TextStyle(
                    color: scheme.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              UserFractal owner => Text(
                  '${owner.display}: ',
                  style: TextStyle(
                    color: scheme.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              _ => Text(''),
            },
            Expanded(
                child: Text(
              f.content,
              style: const TextStyle(
                fontSize: 16,
              ),
            )),
            const SizedBox(width: 6),
            Text(
              format(
                DateTime.fromMillisecondsSinceEpoch(
                  f.createdAt * 1000,
                ),
                locale: 'en_short',
              ),
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(width: 8),
          ],
        ),
      ),
    );
  }

  Widget poster() {
    return Align(
      alignment: Alignment.bottomLeft,
      child: /*Listen(
        UserFractal.active,
        (ctx, child) => UserFractal.active.isNull
            ? Container(
                height: 28,
                alignment: Alignment.center,
                child: Center(
                  child: FilledButton(
                    onPressed: auth,
                    child: Text('Login to post'),
                  ),
                ),
              )
            : */
          Container(
        margin: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          border: Border.all(color: Colors.grey.shade400),
          borderRadius: BorderRadius.circular(8),
        ),
        child: PostArea(
          to: widget.active,
        ),
        //  ),
      ),
    );
  }

  select(NodeFractal f) {
    nameCtrl.text = f.name;
    context.go(
      '/chats/${f.name}',
    );
  }

  auth() {}

  Widget get chatList {
    return Listen(
      ChatsScreen.node.sub,
      (ctx, child) => ListView(
        shrinkWrap: true,
        physics: const ClampingScrollPhysics(),
        children: [
          const SizedBox(height: 64),
          ...ChatsScreen.node.sub.list.map(
            (f) => Container(
              color: (f == widget.active) ? Colors.grey.shade300 : null,
              child: FractalTile(
                f,
                onTap: () {
                  select(f);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  create(String name) async {
    if (name.isEmpty) name = getRandomString(6);
    final node = await NodeFractal.controller.put({
      'name': name.toLowerCase(),
      'to': ChatsScreen.node,
    });
    await node.synch();
    await node.preload();
    nameCtrl.clear();
    select(node);
  }
}

class XnChatButton extends StatefulWidget {
  const XnChatButton({super.key});

  @override
  State<XnChatButton> createState() => _XnChatButtonState();
}

class _XnChatButtonState extends State<XnChatButton> {
  final tipList = SuperTooltipController();
  late final nameCtrl = TextEditingController(text: '');

  final nameFocus = FocusNode();

  @override
  Widget build(BuildContext context) {
    return FractalTooltip(
      controller: tipList,
      direction: TooltipDirection.down,
      content: Container(
        height: 300,
        child: ListView(
          children: [
            TextFormField(
              focusNode: nameFocus,
              controller: nameCtrl,
              onFieldSubmitted: (s) {
                create(s);
              },
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.all(4),
                hintText: "Chat name",
              ),
              style: const TextStyle(fontSize: 16),
            ),
            ...AppFractal.active.sub.list.map(
              (f) => Container(
                color: (f == AppFractal.active) ? Colors.grey.shade300 : null,
                child: FractalTile(
                  f,
                  onTap: () {
                    context.go(
                      '/chats/${f.name}',
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      child: IconButton.filled(
        icon: const Icon(
          Icons.group,
        ),
        onPressed: () async {
          tipList.showTooltip();
          //camera();
        },
      ),
    );
  }

  create(String name) async {
    if (name.isEmpty) return;
    final node = await NodeFractal.controller.put({
      'name': name.toLowerCase(),
      'to': AppFractal.active,
    });
    await node.synch();
    await node.preload();
    nameCtrl.clear();

    context.go(
      '/chats/${node.name}',
    );
    //select(node);
  }
}
*/
