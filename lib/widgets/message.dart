import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fractal_flutter/image.dart';
import 'package:fractal_flutter/widgets/movable.dart';
import 'package:signed_fractal/signed_fractal.dart';
import 'package:timeago/timeago.dart';

import '../builders/index.dart';
import 'icon.dart';
import 'tile.dart';

class MessageField extends StatelessWidget {
  const MessageField(
    this.f, {
    Key? key,

    //required this.profile,
  }) : super(key: key);

  final EventFractal f;

  @override
  Widget build(BuildContext context) {
    f.preload();
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 4,
        vertical: 4,
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment:
                f.own ? MainAxisAlignment.end : MainAxisAlignment.start,
            children: chatContents(context),
          ),
          switch (f) {
            PostFractal post => post.file != null
                ? Container(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4.0),
                      child: FractalImage(
                        post.file!,
                      ),
                    ),
                  )
                : const SizedBox(),
            _ => const SizedBox(),
          }
        ],
      ),
    );
  }

  List<Widget> chatContents(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    String? text = switch (f) {
      WriterFractal f => 'set - ${f.attr}:${f.content}',
      PostFractal post => post.content,
      _ => null,
    };

    List<Widget> chatContents = [
      if (!f.own)
        FRL(
          f.owner,
          (user) => SizedBox.square(
            dimension: 32,
            child: FIcon(user),
          ),
          /*profile == null
          ? preloader
          : Text(profile!.username.substring(0, 2)),
        */
        ),
      const SizedBox(width: 8),
      Flexible(
        child: FractalMovable(
          event: f,
          child: Container(
            padding: const EdgeInsets.symmetric(
              vertical: 8,
              horizontal: 12,
            ),
            decoration: BoxDecoration(
              color: (f.own ? scheme.primary : Colors.grey[300])!
                  .withAlpha(switch (f) {
                WriterFractal f => 0,
                _ => 250,
              }),
              borderRadius: BorderRadius.circular(8),
            ),
            child: text != null
                ? Text(
                    text,
                    style: TextStyle(
                      color: f is WriterFractal
                          ? scheme.primary
                          : f.own
                              ? Colors.white
                              : scheme.surface,
                    ),
                  )
                : FractalTile(f),
          ),
        ),
      ),
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
    ];

    if (f.own) {
      chatContents = chatContents.reversed.toList();
    }
    return chatContents;
  }
}
