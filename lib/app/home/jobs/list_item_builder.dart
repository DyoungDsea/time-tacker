import 'package:flutter/material.dart';
import 'package:flutter_1/app/home/jobs/empty_content.dart';

typedef ItemWidgetuilder<T> = Widget Function(BuildContext context, T item);

class ListItemBuilder<T> extends StatelessWidget {
  const ListItemBuilder({
    Key? key,
    required this.snapshot,
    required this.itemBuilder,
  }) : super(key: key);
  final AsyncSnapshot<List<T>> snapshot;
  final ItemWidgetuilder<T> itemBuilder;

  @override
  Widget build(BuildContext context) {
    if (snapshot.hasData) {
      final List<T> items = snapshot.data!;
      if (items.isNotEmpty) {
        return _buildList(items);
      } else {
        return const EmptyContent();
      }
    } else if (snapshot.hasError) {
      return const EmptyContent(
        title: "Someting went wrong!",
        message: "Can't load item now.",
      );
    }
    return const Center(child: CircularProgressIndicator());
  }

  Widget _buildList(List<T> items) {
    return ListView.separated(
        itemCount: items.length + 2,
        separatorBuilder: (context, index) => const Divider(
              height: .5,
            ),
        itemBuilder: (context, index) {
          if (index == 0 || index == items.length + 1) {
            return Container();
          }
          return itemBuilder(context, items[index - 1]);
        });
  }
}
