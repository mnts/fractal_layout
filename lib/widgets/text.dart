import 'dart:convert';

import 'package:flutter_code_editor/flutter_code_editor.dart';
import 'package:flutter_highlight/themes/monokai-sublime.dart';
import 'package:fractal_layout/layout.dart';
import 'package:highlight/highlight.dart';
import 'package:highlight/languages/all.dart' as lang;
import '../scaffold.dart';
import '../widget.dart';

class FTextWidget extends FNodeWidget {
  FTextWidget(super.f, {super.key});

  String get text => f.file != null ? utf8.decode(f.file?.bytes ?? []) : '';

  Mode? get mode {
    String type = 'txt';
    if (f case FileFractal file) {
      type = switch (file.ext) {
        'js' => 'javascript',
        _ => file.ext,
      };
    }

    f.file?.load().then((v) {
      final text = utf8.decode(v);
      controller.value = TextEditingValue(text: text);
    });

    return lang.allLanguages[type];
  }

  late final controller = CodeController(
    text: text, // Initial code
    language: mode, // Language for syntax highlighting
  );

  @override
  Widget scaffold() {
    return FractalScaffold(
      node: f,
      title: Row(
        children: [
          FilledButton(
            child: const Icon(Icons.save),
            onPressed: () {
              final file = f.file?.file;
              if (file != null) {
                //file.createSync(recursive: true);
                f.file?.bytes = utf8.encode(controller.text);
                file.writeAsString(controller.text);
              }
            },
          ),
          if (f case FileFractal file)
            Text(
              file.localPath,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white,
              ),
            ),
          const Spacer(),
        ],
      ),
      body: area(),
    );
  }

  @override
  area() => CodeTheme(
        data: CodeThemeData(styles: monokaiSublimeTheme),
        child: SingleChildScrollView(
          child: FutureBuilder(
            future: f.file?.load(),
            builder: (ctx, snap) => Container(
              padding: EdgeInsets.only(
                top: FractalScaffoldState.active.pad,
              ),
              child: CodeField(
                controller: controller,
              ),
            ),
          ),
        ),
      );
}
