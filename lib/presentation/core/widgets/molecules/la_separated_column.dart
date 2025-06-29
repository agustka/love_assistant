import 'package:flutter/widgets.dart';
import 'package:la/domain/core/extensions/common_extensions.dart';
import 'package:la/presentation/core/widgets/atoms/import.dart';

class LaSeparatedColumn extends StatelessWidget {
  final int itemCount;
  final IndexedWidgetBuilder? separatorBuilder;
  final IndexedWidgetBuilder? itemBuilder;
  final List<Widget>? children;
  final MainAxisAlignment mainAxisAlignment;
  final MainAxisSize mainAxisSize;
  final CrossAxisAlignment crossAxisAlignment;
  final TextDirection? textDirection;
  final VerticalDirection verticalDirection;
  final TextBaseline? textBaseline;

  const LaSeparatedColumn({
    super.key,
    int? itemCount,
    this.separatorBuilder,
    this.itemBuilder,
    this.children,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.mainAxisSize = MainAxisSize.max,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.textDirection,
    this.verticalDirection = VerticalDirection.down,
    this.textBaseline,
  })  : assert(
          itemBuilder == null && itemCount == null || itemBuilder != null && itemCount != null,
          "itemBuilder and itemCount must be provided together or neither should be provided",
        ),
        assert(itemCount == null || itemCount >= 0, "itemCount must be greater than or equal to 0"),
        assert(
          children == null && itemBuilder != null || children != null && itemBuilder == null,
          "Either itemBuilder or children must be provided, not both",
        ),
        itemCount = children != null ? children.length : itemCount ?? 0;

  @override
  Widget build(BuildContext context) {
    final List<Widget> children = this.children ?? [];

    final IndexedWidgetBuilder? itemBuilder = this.itemBuilder;
    if (itemBuilder != null) {
      children.addAll(
        List.generate(
          itemCount,
          (index) => itemBuilder(context, index),
        ),
      );
    }

    return LaColumn(
      mainAxisAlignment: mainAxisAlignment,
      mainAxisSize: mainAxisSize,
      crossAxisAlignment: crossAxisAlignment,
      children: children.spacedWithIndexed(
        (int index) => separatorBuilder?.call(context, index) ?? const LaSizedBox.shrink(),
      ),
    );
  }
}
