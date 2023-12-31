import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:fractal_flutter/index.dart';
import 'package:signed_fractal/signed_fractal.dart';

import 'index.dart';

class FractalColor extends StatefulWidget {
  final NodeFractal node;
  final Widget? trailing;
  const FractalColor({
    required this.node,
    this.trailing,
    super.key,
  });

  @override
  State<FractalColor> createState() => _FractalColorState();
}

class _FractalColorState extends State<FractalColor> {
  Rewritable? get rew => context.read<Rewritable?>();

  late var dialogPickerColor =
      Color(int.tryParse('${rew?.m['color']?.content}') ?? 0);
  Future<bool> colorPickerDialog() async {
    return ColorPicker(
      //color: dialogPickerColor,
      onColorChanged: (Color color) {
        setState(() => dialogPickerColor = color);
      },
      width: 40,
      height: 40,
      borderRadius: 4,
      spacing: 5,
      runSpacing: 5,
      wheelDiameter: 155,
      showMaterialName: true,
      showColorName: true,
      showColorCode: true,
      copyPasteBehavior: const ColorPickerCopyPasteBehavior(
        longPressMenu: true,
      ),
      materialNameTextStyle: Theme.of(context).textTheme.bodySmall,
      colorNameTextStyle: Theme.of(context).textTheme.bodySmall,
      colorCodeTextStyle: Theme.of(context).textTheme.bodyMedium,
      colorCodePrefixStyle: Theme.of(context).textTheme.bodySmall,
      selectedPickerTypeColor: Theme.of(context).colorScheme.primary,
      pickersEnabled: const <ColorPickerType, bool>{
        ColorPickerType.both: false,
        ColorPickerType.primary: false,
        ColorPickerType.accent: false,
        ColorPickerType.wheel: true,
      },
      //customColorSwatchesAndNames: colorsNameMap,
    ).showPickerDialog(
      context,
      actionsPadding: const EdgeInsets.all(16),
      constraints: const BoxConstraints(
        minHeight: 280,
        minWidth: 300,
        maxWidth: 320,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Padding(
        padding: const EdgeInsets.only(
          left: 8,
        ),
        child: ColorIndicator(
          width: 32,
          height: 32,
          borderRadius: 6,
          color: dialogPickerColor,
          onSelectFocus: false,
          onSelect: () async {
            final Color colorBeforeDialog = dialogPickerColor;
            if (!(await colorPickerDialog())) {
              setState(() {
                dialogPickerColor = colorBeforeDialog;
              });
            }
            rew!.write(
              widget.node.name,
              '${dialogPickerColor.value}',
            );
          },
        ),
      ),
      minLeadingWidth: 32,
      visualDensity: VisualDensity.compact,
      contentPadding: EdgeInsets.zero,
      title: FTitle(widget.node),
      subtitle: Text(
        ColorTools.materialNameAndCode(
          dialogPickerColor,
        ),
      ),
      trailing: widget.trailing,
    );
  }
}
