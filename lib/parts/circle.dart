import '../widget.dart';

class FCircle extends StatelessWidget {
  final Widget child;
  final double size;

  const FCircle(
    this.child, {
    super.key,
    this.size = 48,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(size / 2),
        //color: AppFractal.active.wb,
      ),
      clipBehavior: Clip.antiAlias,
      child: AbsorbPointer(
        child: child,
      ),
    );
  }
}
