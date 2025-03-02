import '../index.dart';
import '../section/images.dart';
import '../widget.dart';

class FractalGallery extends FractalCatalog {
  List<EventFractal> get list => [
        ...f.list.where(
          (evf) => evf.kind == FKind.file,
        ),
      ];
  FractalGallery(super.f, {super.key});

  Widget tile(Fractal f) {
    return Container(
      height: 128,
      padding: const EdgeInsets.all(1),
      child: switch (f) {
        EventFractal post when post.kind == FKind.file => cardPost(post),
        _ => super.tile(f),
      },
    );
  }

  @override
  Widget bar() => Center(
        child: IconButton.filled(
          icon: const Icon(
            Icons.camera_alt,
          ),
          onPressed: () async {
            camera();
          },
        ),
      );

  Widget cardPost(EventFractal ev) => InkWell(
        child: Hero(
          tag: ev.widgetKey('img'),
          child: ev.file != null
              ? FractalImage(
                  key: ev.widgetKey('fimg'),
                  ev.file!,
                  fit: BoxFit.cover,
                )
              : Text(ev.content),
        ),
        onTap: () {
          openDialog(ev);
        },
      );

  @override
  area() {
    return LayoutBuilder(builder: (context, constraints) {
      final maxWidth = constraints.maxWidth;
      return Container(
        padding: FractalPad.of(context).pad,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(4),
          child: Wrap(
            children: [
              ...list.map(
                (f) => tile(f),
              ),
              //removal(),
            ],
          ),
        ),
      );
    });
  }

  openDialog(EventFractal f) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          insetPadding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: ImagesFArea(
            list: list,
            initial: list.indexOf(f),
          ),
        );
      },
    );
  }

  void camera() async {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        elevation: 2,
        backgroundColor: Colors.transparent,
        child: Theme(
          data: ThemeData(
            iconTheme: const IconThemeData(
              size: 32,
              color: Colors.white,
            ),
          ),
          child: Container(
            margin: const EdgeInsets.all(40),
            child: TakePictureScreen(
              onSelected: (sel) async {
                final c = f;

                await sel.publish();
                final ev = await EventFractal.controller.put({
                  'content': sel.name,
                  'kind': 2,
                  'to': c?.filter['to'] ?? c!.hash,
                  'owner': UserFractal.active.value?.hash,
                });
                ev.synch();
                //Navigator.pop(ctx);
              },
            ),
          ),
        ),
      ),
    );
  }
}
