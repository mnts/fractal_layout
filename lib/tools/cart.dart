import 'dart:ui';

import 'package:app_fractal/index.dart';
import 'package:flutter/material.dart';
import 'package:fractal_flutter/index.dart';
import 'package:go_router/go_router.dart';

import '../widgets/index.dart';

class CartTool extends StatefulWidget {
  const CartTool({super.key});

  @override
  State<CartTool> createState() => _CartToolState();
}

class _CartToolState extends State<CartTool> {
  late final cart = UserFractal.active.value!.require('cart');
  final _cartTip = FTipCtrl();

  @override
  Widget build(BuildContext context) {
    final user = UserFractal.active.value!;

    double total = 0;
    for (NodeFractal f in cart.sub.list) {
      total += double.parse('${f['price'] ?? 0}');
    }
    return FractalTooltip(
        controller: _cartTip,
        content: Container(
          constraints: const BoxConstraints(
            maxHeight: 524,
            minHeight: 100,
          ),
          width: 360,
          child: ClipRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: 6,
                sigmaY: 6,
              ),
              child: Stack(
                children: [
                  if (cart.sub.list.isNotEmpty)
                    Listen(
                      cart.sub,
                      (ctx, child) => ListView(
                        shrinkWrap: true,
                        padding: EdgeInsets.only(bottom: 56),
                        physics: const ClampingScrollPhysics(),
                        children: [
                          ...cart.sub.list.map(
                            (node) => FractalMovable(
                              event: node,
                              child: FractalTile(node),
                            ),
                          ),
                        ],
                      ),
                    )
                  else
                    Container(
                      child: const Text('Cart is empty'),
                    ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    height: 32,
                    child: ClipRect(
                      child: BackdropFilter(
                        filter: ImageFilter.blur(
                          sigmaX: 6,
                          sigmaY: 6,
                        ),
                        child: Row(
                          children: [
                            IconButton(
                              tooltip: 'Manage payment methods',
                              onPressed: () {
                                context.go('/payment_methods');
                              },
                              icon: const Icon(
                                Icons.credit_card_outlined,
                              ),
                            ),
                            const Spacer(),
                            Text('$total€',
                                style: TextStyle(
                                  color: Colors.black,
                                )),
                            const Spacer(),
                            IconButton(
                              tooltip: 'Pay all',
                              onPressed: () {},
                              icon: const Icon(
                                Icons.payments_outlined,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        child: IconButton(
          onPressed: () {
            _cartTip.showTooltip();
            //context.go(active.value!.path);
          },
          icon: const Icon(
            Icons.shopping_basket_rounded,
            color: Colors.white,
          ),
        ));
  }
}
