import 'package:app_fractal/index.dart';
import 'package:flutter/material.dart';
import 'package:fractal_flutter/index.dart';
import 'package:textfield_tags/textfield_tags.dart';

class FractalTags extends StatefulWidget {
  final List<String>? list;
  final Function(List<String>) onChanged;
  const FractalTags({
    super.key,
    this.list,
    required this.onChanged,
  });

  @override
  State<FractalTags> createState() => _FractalTagsState();
}

class _FractalTagsState extends State<FractalTags> {
  double _distanceToField = 0;
  late final _controller = TextfieldTagsController();

  @override
  void initState() {
    _controller.addListener(() {
      //widget.onChanged(_controller.getTags ?? <String>[]);
    });
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _distanceToField = MediaQuery.of(context).size.width;
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  static const List<String> _pickLanguage = <String>[
    'c',
    'c++',
    'java',
    'python',
    'javascript',
    'php',
    'sql',
    'yaml',
    'gradle',
    'xml',
    'html',
    'flutter',
    'css',
    'dockerfile'
  ];

  final color = AppFractal.active.color.toMaterial;

  @override
  Widget build(BuildContext context) {
    return /*Autocomplete<String>(
      optionsViewBuilder: (context, onSelected, options) {
        return Container(
          width: 200,
          margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
          child: Align(
            alignment: Alignment.topCenter,
            child: Material(
              elevation: 4.0,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 200),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: options.length,
                  itemBuilder: (BuildContext context, int index) {
                    final dynamic option = options.elementAt(index);
                    return TextButton(
                      onPressed: () {
                        onSelected(option);
                      },
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 15.0),
                          child: Text(
                            option,
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              color: color,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        );
      },
      optionsBuilder: (TextEditingValue textEditingValue) {
        if (textEditingValue.text == '') {
          return const Iterable<String>.empty();
        }
        return _pickLanguage.where((String option) {
          return option.contains(textEditingValue.text.toLowerCase());
        });
      },
      onSelected: (String selectedTag) {
        _controller.addTag = selectedTag;
      },
      fieldViewBuilder: (context, ttec, tfn, onFieldSubmitted) {
        return */
        TextFieldTags(
      //textEditingController: ttec,
      //focusNode: tfn,
      textfieldTagsController: _controller,
      initialTags: widget.list,
      textSeparators: const [' ', ','],
      letterCase: LetterCase.normal,
      validator: (tag) {
        if (tag == 'php') {
          return 'No, please just no';
        } else if ((_controller.getTags ?? []).contains(tag)) {
          return 'you already entered that';
        }
        return null;
      },

      inputFieldBuilder: (context, values) {
        return Padding(
          padding: const EdgeInsets.all(8),
          child: TextField(
            //controller: tec,
            //focusNode: fn,
            decoration: InputDecoration(
              enabledBorder: const UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.transparent,
                  width: 2.0,
                ),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: color, width: 2.0),
              ),
              helperStyle: TextStyle(
                color: color,
              ),
              hintText: _controller.getTags == null ? '' : "Enter tags...",
              //errorText: error,
              prefixIconConstraints:
                  BoxConstraints(maxWidth: _distanceToField * 0.74),
              /*
              prefixIcon: tags.isNotEmpty
                  ? Wrap(
                      children: tags
                          .map(
                            (s) => buildTag(
                              s,
                              onTagDelete,
                            ),
                          )
                          .toList(),
                    )
                  : null,
                  */
            ),
            //onChanged: onChanged,
            //onSubmitted: onSubmitted,
          ),
        );
      },
    );
  }

  Widget buildTag(String tag, Function(String) onTagDelete) {
    return Padding(
      padding: const EdgeInsets.only(right: 4),
      child: FilledButton.icon(
        onPressed: () {},
        style: const ButtonStyle(
          iconSize: MaterialStatePropertyAll(14),
          visualDensity: VisualDensity.compact,
          padding: MaterialStatePropertyAll(
            EdgeInsets.symmetric(horizontal: 8, vertical: 0),
          ),
        ),
        icon: InkWell(
          child: const Icon(
            Icons.cancel,
            size: 12.0,
            color: Color.fromARGB(255, 233, 233, 233),
          ),
          onTap: () {
            onTagDelete(tag);
          },
        ),
        label: Text(tag),
      ),
    );
  }
}
