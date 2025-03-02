import 'dart:convert';

import 'package:flutter_code_editor/flutter_code_editor.dart';
import 'package:flutter_highlight/themes/monokai-sublime.dart';
import 'package:fractal_layout/layout.dart';
import 'package:highlight/highlight.dart';
import 'package:highlight/languages/all.dart' as lang;
import 'package:signed_fractal/services/fs/ff_ext.dart';
import '../scaffold.dart';
import '../widget.dart';
import 'index.dart';

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
      final text = utf8.decode(f.file!.bytes);
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
      body: area(),
    );
  }

  @override
  area() => CodeTheme(
        data: CodeThemeData(styles: monokaiSublimeTheme),
        child: FractalReady(
          f,
          () => Stack(
            children: [
              Positioned.fill(
                child: SingleChildScrollView(
                  child: FutureBuilder(
                    future: f.file?.load(),
                    builder: (ctx, snap) => Container(
                      padding: FractalPad.maybeOf(ctx)?.pad ?? EdgeInsets.zero,
                      child: CodeField(
                        gutterStyle: const GutterStyle(margin: 4),
                        controller: controller,
                      ),
                    ),
                  ),
                ),
              ),
              FractalBar([
                IconButton.filled(
                  icon: const Icon(Icons.save),
                  onPressed: () {
                    if (f case FileFractal ff) {
                      final bytes = utf8.encode(controller.text);
                      ff.write(bytes);
                    }
                  },
                ),
                const Spacer(),
                if (f case FileFractal file)
                  Text(
                    file.localPath,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
              ]),
            ],
          ),
        ),
      );
}
