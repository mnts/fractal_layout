import 'dart:async';
import 'dart:ui';
import 'package:dartlin/control_flow.dart';
import 'package:app_fractal/index.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:fractal_flutter/index.dart';
import 'package:fractal_layout/index.dart';

class FractalSub extends StatefulWidget {
  final SortedFrac<NodeFractal>? sequence;
  final List<Widget> ctrls;

  const FractalSub({
    super.key,
    this.sequence,
    this.ctrls = const [],
    required this.buildView,
  });

  final Widget Function(
    EventFractal,
    FExpand,
  ) buildView;

  @override
  State<FractalSub> createState() => FractalSubState();
}

class FractalSubState extends State<FractalSub> with TickerProviderStateMixin {
  late TabController _tabCtrl;

  List<NodeFractal> sequence = [];
  List<NodeFractal> get list => widget.sequence?.value ?? [AppFractal.active];

  @override
  void initState() {
    /*
    if (widget.initial != null) {
      sequence.add(widget.initial!);
    }
    */

    sequence = list;
    widget.sequence?.listen((val) {
      setState(() {
        initTabCtrl();
        sequence = list;
      });
    });

    SchedulerBinding.instance.addPostFrameCallback((_) {
      //print(index);
    });

    initTabCtrl();
    super.initState();
  }

  @override
  void didUpdateWidget(oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  initTabCtrl([int? index]) {
    _tabCtrl = TabController(
      length: sequence.length,
      initialIndex: index ?? sequence.length - 1,
      vsync: this,
    );
  }

  @override
  dispose() {
    _tabCtrl.dispose();
    super.dispose();
  }

  //int index = 0;

  int expand(NodeFractal ev) {
    var index = _tabCtrl.index;
    if (index + 1 < sequence.length) {
      if (sequence[index + 1] == ev) {
        _tabCtrl.animateTo(index + 1);
        return sequence.length;
      }
      sequence.removeRange(index + 1, sequence.length);
    }

    setState(() {
      //index = sequence.length;
      sequence.add(ev);

      _tabCtrl.dispose();
      initTabCtrl(index);
    });

    ev.whenLoaded.then((b) {
      _tabCtrl.animateTo(sequence.length - 1);
    });

    return sequence.length;
  }

  Timer? timer;
  dragOpen(int i) {
    timer?.cancel();
    timer = Timer(
      const Duration(milliseconds: 600),
      () {
        _tabCtrl.animateTo(i);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final ctrls = <NodeCtrl>[
      CanvasFractal.controller,
      Attr.controller,
      NodeFractal.controller,
    ];

    return Stack(
      alignment: Alignment.topCenter,
      children: [
        FractalLayer(
          pad: const EdgeInsets.only(top: 57, bottom: 48),
          child: TabBarView(
            controller: _tabCtrl,
            children: [
              ...sequence.map(
                (ev) => Watch<Rewritable?>(
                  ev,
                  (ctx, child) => widget.buildView(
                    ev,
                    expand,
                  ),
                ),
              ),
            ],
          ),
        ),
        Positioned(
          top: FractalPad.maybeOf(context)?.pad.top ?? 0,
          left: 0,
          right: 0,
          height: 56,
          child: ClipRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 6, sigmaY: 2),
              child: Container(
                decoration: FractalScaffoldState.active.decoration,
                child: TabBar(
                  controller: _tabCtrl,
                  isScrollable: true,
                  tabAlignment: TabAlignment.start,
                  labelPadding: const EdgeInsets.only(
                    right: 2,
                    top: 5,
                    left: 2,
                  ),
                  //indicatorColor: AppFractal.active.wb,
                  onTap: (i) {
                    final ind = _tabCtrl.indexIsChanging
                        ? _tabCtrl.previousIndex
                        : _tabCtrl.index;

                    final f = sequence[i];
                    if (i == ind) {
                      sequence.removeRange(i + 1, sequence.length);
                      FractalLayoutState.active.go(f);
                      return;
                    }

                    /*
                    if (index != i) {
                      index = i;
                      return;
                    }
                    index = i;
                    */
                    //FractalLayoutState.active.go(f);
                  },
                  tabs: [
                    for (var i = 0; i < sequence.length; i++)
                      Tab(
                        child: GestureDetector(
                          onLongPress: () {
                            if (sequence[i] case NodeFractal f) {
                              ConfigFArea.openDialog(f);
                            }
                          },
                          onSecondaryTap: () {
                            if (sequence[i] case NodeFractal f) {
                              ConfigFArea.openDialog(f);
                            }
                          },
                          child: DragTarget(
                            builder: (ctx, l, r) => Row(children: [
                              Container(
                                width: 46,
                                height: 46,
                                padding: const EdgeInsets.all(2),
                                child: sequence[i].icon,
                              ),
                              const SizedBox(
                                width: 4,
                              ),
                              FTitle(
                                sequence[i],
                                //style: textStyle,
                              ),
                              /*
                            InkWell(
                              child: 
                              onTap: () {
                                if (_tabCtrl.index == i) {
                                  app.go(sequence[i]);
                                }
                              },
                            ),
                            */
                              if (i < sequence.length - 1)
                                const Icon(
                                  Icons.arrow_right,
                                ),
                            ]),
                            onWillAcceptWithDetails: (d) {
                              dragOpen(i);
                              return true;
                            },
                            onLeave: (d) {
                              timer?.cancel();
                            },
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          left: 9,
          right: 9,
          height: 46,
          child: ClipRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 0, sigmaY: 3),
              child: Row(
                children: [
                  DropdownButton2(
                    customButton: const SizedBox(
                      width: 48,
                      height: 48,
                      child: Icon(Icons.add),
                    ),
                    isDense: true,
                    items: ctrls
                        .map(
                          (c) => DropdownMenuItem<NodeCtrl>(
                            value: c,
                            child: ListTile(
                              leading: c.icon.widget,
                              title: Text(c.label),
                            ),
                          ),
                        )
                        .toList(),
                    dropdownStyleData: DropdownStyleData(
                      width: 240,
                      padding: const EdgeInsets.all(0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    buttonStyleData: const ButtonStyleData(),
                    menuItemStyleData: const MenuItemStyleData(
                      padding: EdgeInsets.all(0),
                    ),
                    onChanged: (value) async {
                      if (value == null) return;

                      final current = sequence[_tabCtrl.index];
                      final extendsHash = current.m['extends']?.content;
                      NodeFractal? extendsNode;
                      if (extendsHash != null) {
                        (await NetworkFractal.request(extendsHash)).let((f) {
                          if (f is NodeFractal) extendsNode = f;
                        });
                      }

                      FDialog.show(
                        child: CreateNodeF(
                          to: current,
                          extend: extendsNode,
                          ctrl: value,
                        ),
                      );

                      /*
                      modal(
                        to: current,
                        extend: extendsNode,
                        cb: (f) {},
                        ctrl: value,
                      );
                      setState(() {
                        rew = makeRew();
                        ctrl = value;
                      });
                      */
                    },
                  ),
                  /*
                  IconButton.filled(
                    onPressed: () async {
                      final current = sequence[_tabCtrl.index];
                      switch (current) {
                        case (NodeFractal node):
                          final extendsHash = node.m['extends']?.content;
                          NodeFractal? extendsNode;
                          if (extendsHash != null) {
                            (await NetworkFractal.request(extendsHash))
                                .let((f) {
                              if (f is NodeFractal) extendsNode = f;
                            });
                          }

                          modal(
                            to: node,
                            extend: extendsNode,
                            cb: (f) {
                              //setState(() {
                              /*
                              node
                                ..sorted.order(f)
                                ..sort();
                              */

                              //FractalLayoutState.active.go(f);

                              //});
                            },
                          );
                        // ignore: use_build_context_synchronously
                      }
                    },
                    //shape: const CircleBorder(),
                    //foregroundColor: theme.primaryColor,
                    //backgroundColor: theme.colorScheme.primary,
                    icon: const Icon(Icons.add),
                  ),
                  */
                  const Spacer(),
                  ...widget.ctrls,
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  static final textStyle = TextStyle(
    fontSize: 18,
    color: AppFractal.active.bw,
    fontWeight: FontWeight.bold,
  );

  static void modal({
    NodeFractal? to,
    NodeFractal? extend,
    Function(NodeFractal)? cb,
    NodeCtrl? ctrl,
  }) {
    showDialog(
      context: FractalScaffoldState.active.context,
      builder: (ctx) => Dialog(
        child: Container(
          /*
          constraints: const BoxConstraints(
            maxWidth: 400,
            maxHeight: 900,
          ),
          */
          height: 480,
          width: 320,
          child: CreateNodeF(
            to: to,
            extend: extend,
            ctrl: ctrl ?? NodeFractal.controller,
            onCreate: (node) {
              //Navigator.of(ctx).pop();
              if (cb != null) cb(node);
            },
          ),
        ),
      ),
    );
  }
}
