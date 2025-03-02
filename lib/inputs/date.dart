import 'package:flutter/material.dart';
import 'package:fractal/utils.dart';
import 'package:fractal_flutter/index.dart';
import 'package:fractal_layout/scaffold.dart';
import 'package:intl/intl.dart';
import 'package:signed_fractal/signed_fractal.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import '../layout.dart';
import '../widgets/dialog.dart';

class FInputDate extends StatefulWidget {
  final NodeFractal fractal;
  final Widget? trailing;
  final Widget? leading;
  final DateRangePickerSelectionMode? mode;
  const FInputDate(
    this.fractal, {
    super.key,
    this.mode,
    this.trailing,
    this.leading,
  });

  @override
  State<FInputDate> createState() => _FInputDateState();
}

class _FInputDateState extends State<FInputDate> {
  NodeFractal get f => widget.fractal;
  Rewritable? get rew => context.read<Rewritable?>();
  CatalogFractal? get catalog => context.read<CatalogFractal?>();

  void selectorDialog() {
    showDialog(
      context: context,
      builder: (ctx) => FDialog(
        width: 480,
        height: 640,
        child: SfDateRangePicker(
          view: DateRangePickerView.year,
          selectionMode: widget.mode ??
              ('${f['ui']}'.contains('range')
                  ? DateRangePickerSelectionMode.range
                  : DateRangePickerSelectionMode.single),
          onSelectionChanged: (selection) {
            //DateTime date = selection.value;

            //Navigator.of(ctx).pop();
            switch (selection.value) {
              case PickerDateRange range:
                if (range.startDate == null || range.endDate == null) return;
                setState(() {
                  final format = '${f['date_format'] ?? 'yMMdd'}';
                  final startDate = DateFormat(format).format(range.startDate!);

                  final endDate = DateFormat(format).format(range.endDate!);

                  final startTime = range.startDate!.unixSeconds;
                  final endTime = range.endDate!.unixSeconds;
                  final flt = {
                    'gte': startTime,
                    'lte': endTime,
                  };

                  if (catalog?.reMake case Function reMake) {
                    reMake({
                      'filter': {
                        f.name: flt,
                      }
                    });
                  } else if (catalog != null) {
                    catalog!.filter[f.name] = flt;
                    catalog!.refresh();
                  } else {
                    final dt = '$startDate - $endDate';
                    rew?.write(f.name, dt);
                    ctrl.text = dt;
                  }
                });
                Navigator.of(ctx).pop();
              case DateTime dt when f['ui'] == 'date_time':
                Navigator.of(ctx).pop();
                timeDialog(selection.value);
              case DateTime dt:
                setState(() {
                  final date = DateFormat(
                    '${f['date_format'] ?? 'yMd'}',
                  ).format(
                    dt,
                  );

                  rew!.write(f.name, date);
                  ctrl.text = date;
                });
                Navigator.of(ctx).pop();
            }
          },
        ),
      ),
    );
  }

  void timeDialog(DateTime? dt) async {
    dt ??= DateTime.now();
    final tds = TimeOfDay.fromDateTime(dt);

    final td = await showTimePicker(
      initialTime: tds,
      context: context,
    );

    if (td == null) return;

    final date = DateTime(
      dt.year,
      dt.month,
      dt.day,
      td.hour,
      td.minute,
    );

    setState(() {
      final val = DateFormat('${f['date_format'] ?? 'M/d/y h:m'}').format(
        date,
      );
      rew!.write(f.name, val);
      ctrl.text = val;
    });
  }

  DateFormat get df => DateFormat('${f['date_format'] ?? 'M/d/y h:m'}');

  late final ctrl = TextEditingController(
      text: switch (value) {
    'now' => df.format(DateTime.now()),
    _ => value,
  });

  String get catalogValue {
    final filter = catalog?.filter[f.name];
    if (filter case Map flt) {
      if (flt['gte'] is int && flt['lte'] is int) {
        final from = DateTime.fromMillisecondsSinceEpoch(flt['gte'] * 1000);
        final to = DateTime.fromMillisecondsSinceEpoch(flt['lte'] * 1000);

        return '${df.format(from)} - ${df.format(to)}';
      }
    }
    return '';
  }

  //1641031200000
  //1719766800000

  String get value {
    if (catalog != null) {
      return catalogValue;
    }
    return [
      rew?.m[widget.fractal.name]?.content ?? '',
      '${widget.fractal['value'] ?? ''}'
    ].firstWhere((e) => (e.trim().isNotEmpty), orElse: () => '').trim();
  }

  FocusNode focusNode = FocusNode();

  @override
  void initState() {
    if (rew != null) {
      rew!.m.listen(updateValue);
    }

    /*
    focusNode.addListener(() {
      submit();
    });
    */
    super.initState();
  }

  submit([ev]) {
    final val = ctrl.text.trim();
    if (value == val) return;

    if (catalog?.reMake case Function reMake) {
      reMake({
        'filter': {f.name: null},
      });
    } else if (catalog != null) {
      catalog!.filter[f.name] = null;
      catalog!.refresh();
    } else if (rew != null && !(value == ' ' && ctrl.text == '')) {
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
        onFieldSubmitted: submit,
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
