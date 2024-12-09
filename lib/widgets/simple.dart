import 'package:flutter/material.dart';
import 'package:fractal/utils/random.dart';
import 'package:fractal_flutter/index.dart';
import 'package:fractal_layout/index.dart';
import 'package:signed_fractal/signed_fractal.dart';
import 'package:currency_fractal/fractals/transaction.dart';

class FSimpleTile extends StatefulWidget {
  final NodeFractal item;
  FSimpleTile({required this.item, Key? key}) : super(key: key);

  @override
  _TreatmentItemState createState() => _TreatmentItemState();
}

class _TreatmentItemState extends State<FSimpleTile> {
  late TextEditingController ctrl;

  final descCtrl = TextEditingController();
  NodeFractal get f => widget.item;

  @override
  void initState() {
    f.preload();
    super.initState();
    ctrl = TextEditingController();

    ctrl.text = '${f['price'] ?? 0}';

    descCtrl.text = description;
  }

  bool payed = false;

  late final user = context.read<UserFractal>();
  String get description => f.m['description']?.content ?? '';

  double price = 0;
  double approved = 0;

  @override
  Widget build(BuildContext context) {
    return Listen(f.m, (ctx, child) {
      final status = f['status'];

      return Container(
        width: 200,
        child: Card(
          elevation: 2.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8), // if you need this
            side: BorderSide(
              color: Colors.grey.withOpacity(0.2),
              width: 1,
            ),
          ),
          clipBehavior: Clip.antiAlias,
          child: Row(
            children: [
              SizedBox.square(
                dimension: 48,
                child: (f.extend ?? f).icon,
              ),
              Expanded(
                child: FTitle(f.extend ?? f),
              ),
            ],
          ),
        ),
      );
    });
  }
}
