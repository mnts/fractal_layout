import 'package:flutter/material.dart';
import 'package:fractal_flutter/index.dart';
import 'package:intl/intl.dart';
import 'package:signed_fractal/signed_fractal.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import '../widgets/dialog.dart';

class FInputDate extends StatefulWidget {
  final NodeFractal fractal;
  final Widget? trailing;
  final Widget? leading;
  const FInputDate(
    this.fractal, {
    super.key,
    this.trailing,
    this.leading,
  });

  @override
  State<FInputDate> createState() => _FInputDateState();
}

class _FInputDateState extends State<FInputDate> {
  NodeFractal get f => widget.fractal;
  Rewritable? get rew => context.read<Rewritable?>();

  void selectorDialog() {
    showDialog(
      context: context,
      builder: (ctx) => FDialog(
        width: 480,
        height: 640,
        child: SfDateRangePicker(
          view: DateRangePickerView.year,
          onSelectionChanged: (selection) {
            //DateTime date = selection.value;
            setState(() {
              final val = DateFormat('${f['format'] ?? 'yMd'}').format(
                selection.value,
              );
              rew!.write(f.name, val);
              ctrl.text = val;
            });
            Navigator.of(ctx).pop();
          },
        ),
      ),
    );
  }

  late final ctrl = TextEditingController(text: value);

  String get value {
    return (rew?.m[widget.fractal.name]?.content ?? '').trim();
  }

  FocusNode focusNode = FocusNode();

  @override
  void initState() {
    if (rew != null) {
      rew!.m.listen(updateValue);
    }

    focusNode.addListener(() {
      submit();
    });
    super.initState();
  }

  submit([ev]) {
    if (rew != null &&
        value != ctrl.text.trim() &&
        !(value == ' ' && ctrl.text == '')) {
      rew!.write(f.name, ctrl.text);
    }
  }

  updateValue(PostFractal post) {
    if (post case WriterFractal writer) {
      if (writer.attr == widget.fractal.name) {
        ctrl.text = post.content;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(0, 2, 0, 0),
      child: TextFormField(
        controller: ctrl,
        focusNode: focusNode,
        decoration: InputDecoration(
          labelText: f.title.value?.content ?? f.name,
          /* ??
              SizedBox.square(
                dimension: 62,
                child: FIcon(f),
              )*/

          contentPadding: const EdgeInsets.all(2),
          isDense: true,
          suffixIcon: IconButton(
            icon: const Icon(Icons.date_range_outlined),
            onPressed: selectorDialog,
          ),
        ),
        keyboardType: TextInputType.datetime,
        maxLines: 1,
      ),
    );
  }
}
