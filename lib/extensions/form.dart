import '../widget.dart';

extension FormExtFractal on NodeFractal {
  readValue(String key) {}

  Future<Rewritable> get rew => myInteraction;

  Future<String> getVal(String name) async {
    return ((await rew).m[name]?.content ?? '').trim();
  }

  setVal(String name, String value) {
    rew.then((f) {
      f.write(name, value);
    });
  }
}
