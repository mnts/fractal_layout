import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fractal_flutter/image.dart';
import 'package:fractal_flutter/widgets/movable.dart';
import 'package:signed_fractal/signed_fractal.dart';
import 'package:timeago/timeago.dart';

class MessageField extends StatelessWidget {
  const MessageField({
    Key? key,
    required this.message,
    //required this.profile,
  }) : super(key: key);

  final PostFractal message;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    var content = message.content;
    if (message case WriterFractal f) {
      content = 'set - ${f.attr}:${f.content}';
    }

    List<Widget> chatContents = [
      if (!message.own)
        CircleAvatar(
          child: Text(
            (message.owner?.name ?? ''),
            maxLines: 1,
            overflow: TextOverflow.fade,
          ),
          /*profile == null
          ? preloader
          : Text(profile!.username.substring(0, 2)),
        */
        ),
      const SizedBox(width: 8),
      Flexible(
        child: FractalMovable(
          event: message,
          child: Container(
            padding: const EdgeInsets.symmetric(
              vertical: 8,
              horizontal: 12,
            ),
            decoration: BoxDecoration(
              color: (message.own ? scheme.primary : Colors.grey[300])!
                  .withAlpha(switch (message) {
                WriterFractal f => 0,
                _ => 250,
              }),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              content,
              style: TextStyle(
                color: message is WriterFractal
                    ? scheme.primary
                    : message.own
                        ? Colors.white
                        : scheme.surface,
              ),
            ),
          ),
        ),
      ),
      const SizedBox(width: 6),
      Text(
        format(
          DateTime.fromMillisecondsSinceEpoch(
            message.createdAt * 1000,
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

    if (message.own) {
      chatContents = chatContents.reversed.toList();
    }
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 4,
        vertical: 4,
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment:
                message.own ? MainAxisAlignment.end : MainAxisAlignment.start,
            children: chatContents,
          ),
          if (message.file != null)
            Container(
              margin: const EdgeInsets.symmetric(vertical: 4),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4.0),
                child: FractalImage(
                  message.file!,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
