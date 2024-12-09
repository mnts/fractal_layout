import 'package:flutter/material.dart';
import 'package:fractal_flutter/index.dart';
import 'package:intl/intl.dart';
import 'package:signed_fractal/signed_fractal.dart';

class FInputTime extends StatefulWidget {
  final NodeFractal fractal;
  final Widget? trailing;
  final Widget? leading;
  const FInputTime(
    this.fractal, {
    super.key,
    this.trailing,
    this.leading,
  });

  @override
  State<FInputTime> createState() => _FInputTimeState();
}

class _FInputTimeState extends State<FInputTime> {
  NodeFractal get f => widget.fractal;
  Rewritable? get rew => context.read<Rewritable?>();

  void selectorDialog() {
    showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    ).then((t) {
      if (t == null) return;
      setState(() {
        final now = DateTime.now();
        final time = DateTime(now.year, now.month, now.day, t.hour, t.minute);

        final val = DateFormat('${f['format'] ?? 'yMd'}').format(
          time,
        );
        rew!.write(f.name, val);
        ctrl.text = val;
      });
    });

    /*
    onSelectionChanged(selection) {
      //DateTime date = selection.value;
      setState(() {
        final val = DateFormat('${f['format'] ?? 'yMd'}').format(
          selection.value,
        );
        rew!.write(f.name, val);
        ctrl.text = val;
      });
      Navigator.of(ctx).pop();
    };
    */
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

  updateValue(WriterFractal f) {
    if (f.attr == widget.fractal.name) {
      ctrl.text = f.content;
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
            icon: const Icon(Icons.av_timer_rounded),
            onPressed: selectorDialog,
          ),
        ),
        keyboardType: TextInputType.datetime,
        maxLines: 1,
      ),
    );
  }
}
