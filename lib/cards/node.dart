import 'dart:ui';

import '../index.dart';
import '../widget.dart';

class FCardNode extends FNodeWidget {
  FCardNode(super.node, {super.key});

  @override
  area() {
    final hasVideo = f.video != null;
    return InkWell(
      child: Hero(
        tag: f.widgetKey('f'),
        child: FractalMovable(
          event: f,
          child: Container(
            //onPressed: () {},
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(5),
            ),
            constraints: const BoxConstraints(
              maxHeight: 200,
              //maxWidth: 250,
            ),
            child: Stack(
              children: [
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: InkWell(
                    child: FIcon(f),
                    onTap: () {
                      if (f case NodeFractal node) {
                        FractalLayoutState.active.go(node);
                      }
                    },
                  ),
                ),
                if (hasVideo)
                  Center(
                    child: IconButton.filled(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                          Colors.grey.shade700.withAlpha(180),
                        ),
                      ),
                      onPressed: () {
                        FractalLayoutState.active.go(f);
                      },
                      icon: const Icon(
                        Icons.play_arrow,
                      ),
                    ),
                  ),
                /*
          if (widget.trailing != null)
            Positioned(
              top: 2,
              right: 2,
              child: widget.trailing!,
            ),
            */
                if (f.price != null)
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.only(
                        left: 4,
                        right: 4,
                        top: 2,
                        bottom: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        '${f.price}€',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color.fromRGBO(
                            180,
                            120,
                            20,
                            1,
                          ),
                        ),
                      ),
                    ),
                  ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: ClipRect(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(
                        sigmaX: 4,
                        sigmaY: 4,
                      ),
                      child: Container(
                        color: Colors.white.withAlpha(100),
                        padding: const EdgeInsets.all(2),
                        alignment: Alignment.center,
                        child: Column(children: [
                          if (f.description != null)
                            Text(
                              f.description ?? '',
                              style: TextStyle(
                                color: Colors.grey.shade800,
                                fontSize: 12,
                                height: 1,
                              ),
                            ),
                          tile(),
                        ]),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      onLongPress: () {
        ConfigFArea.openDialog(f);
      },
      /*
        onTap: () {
          if (widget.onTap != null) {
            widget.onTap!(f);
          } else if (f.runtimeType == NodeFractal) {
            ConfigFArea.openDialog(f as NodeFractal);
          } else if (f case NodeFractal node) {
            FractalLayoutState.active.go(node);
          }
        },
      ),
        */
    );
  }

  @override
  tile() {
    return HoverOver(
      builder: (h) => FractalMovable(
        event: f,
        child: FTitle(
          f,
          style: TextStyle(
            color: h ? Colors.black : Colors.grey.shade600,
            fontWeight: FontWeight.bold,
            fontSize: 18,
            height: 1.6,
          ),
        ),
      ),
    );
  }
}
