import 'package:flutter/material.dart';

class MyReorderableListView<T> extends StatefulWidget {
  const MyReorderableListView(
    this._items, {
    this.onDrop,
    @required this.onReorder,
    @required this.builder,
    this.feedBack,
    this.hovered,
  });

  final List<T> _items;
  final void Function(int fromIdx, int toIdx) onDrop;
  final void Function(int oldIdx, int newIdx) onReorder;
  final Widget Function(BuildContext context, T item) builder;
  final Widget Function(BuildContext context, T item) feedBack;
  final Widget Function(BuildContext context, int fromIdx, int toIdx) hovered;

  @override
  _MyReorderableListViewState<T> createState() => _MyReorderableListViewState<T>();
}

class _MyReorderableListViewState<T> extends State<MyReorderableListView<T>> {
  int _draggedIndex;

  void _onReorder(int oldIndex, int newIndex) {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    if (oldIndex == newIndex) {
      return;
    }
    setState(() => _draggedIndex = newIndex);
    widget.onReorder(oldIndex, newIndex);
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: widget._items.length,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (BuildContext context, int index) {
        final item = widget._items[index];

        return Column(
          children: [
            DragTarget<T>(
              onWillAccept: (value) {
                if (_draggedIndex == null) {
                } else {
                  _onReorder(_draggedIndex, index);
                }
                return false;
              },
              builder: (context, candidates, rejects) {
                return Container(height: 8);
              },
            ),
            if (_draggedIndex == null)
              LongPressDraggable<T>(
                data: item,
                axis: Axis.vertical,
                child: widget.builder(context, item),
                feedback: Opacity(
                  opacity: 0.7,
                  child: Material(
                    color: Colors.transparent,
                    child: widget.feedBack != null
                        ? widget.feedBack(context, item)
                        : widget.builder(context, item),
                  ),
                ),
                onDragStarted: () => setState(() => _draggedIndex = index),
                onDragCompleted: () => setState(() => _draggedIndex = null),
                onDraggableCanceled: (velocity, offset) => setState(() {
                  _draggedIndex = null;
                }),
              )
            else if (_draggedIndex != index)
              DragTarget<T>(
                onAccept: (value) {
                  if (widget.onDrop != null) {
                    widget.onDrop(_draggedIndex, index);
                  }
                },
                builder: (context, candidates, rejects) {
                  if (candidates.isNotEmpty && widget.hovered != null) {
                    return widget.hovered(context, _draggedIndex, index);
                  }
                  return widget.builder(context, item);
                },
              )
            else
              Opacity(
                opacity: 0,
                child: widget.builder(context, item),
              ),
          ],
        );
      },
    );
  }
}
