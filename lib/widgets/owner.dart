import 'package:app_fractal/index.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fractal_flutter/index.dart';
import 'package:fractal_layout/index.dart';
import 'package:fractal_layout/widgets/title.dart';
import 'package:go_router/go_router.dart';

class OwnerGap extends StatefulWidget {
  final EventFractal fractal;
  final Widget child;
  const OwnerGap(
    this.child, {
    super.key,
    required this.fractal,
  });

  @override
  State<OwnerGap> createState() => _OwnerState();
}

class _OwnerState extends State<OwnerGap> {
  UserFractal? get owner => widget.fractal.owner;

  @override
  void initState() {
    if (owner == null) {
      widget.fractal.ownerC.future.then((v) {
        setState(() {});
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      padding: EdgeInsets.all(4),
      decoration: BoxDecoration(
          color: Colors.grey.withAlpha(20),
          borderRadius: BorderRadius.circular(
            8,
          )),
      child: owner == null
          ? const CupertinoActivityIndicator()
          : Row(children: [
              Container(
                width: 54,
                child: owner!.icon,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextButton(
                      onPressed: () {
                        context.go('/~${owner!.name}');
                      },
                      style: TextButton.styleFrom(
                        minimumSize: Size.zero,
                        textStyle: TextStyle(color: Colors.black),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: FTitle(owner!),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8,
                      ),
                      child: widget.child,
                    ),
                  ],
                ),
              )
            ]),
    );
  }
}
