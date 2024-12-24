import 'package:flutter/material.dart';

class AnimatedListPage extends StatefulWidget {
  const AnimatedListPage({super.key});

  @override
  State<AnimatedListPage> createState() => _AnimatedListPageState();
}

class _AnimatedListPageState extends State<AnimatedListPage> {
  @override
  final _items = [];
  final _listKey = GlobalKey<AnimatedListState>();
  // GlobalKey<AnimatedListState> listKey = GlobalKey<AnimatedListState>();

  void _addItem() {
    _items.insert(0, "Item ${_items.length + 1}");
    _listKey.currentState!.insertItem(0, duration: const Duration(seconds: 1));
  }

  void _removeItem(int index) {
    _listKey.currentState!.removeItem(index, (_, animation) {
      return SizeTransition(
        sizeFactor: animation,
        child: const Card(
          margin: EdgeInsets.all(10),
          color: Colors.red,
          child: ListTile(
            title: Center(
              child: Text(
                "Deleted!",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
      );
    }, duration: const Duration(milliseconds: 500));
    _items.removeAt(index);
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text("Animated List")),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addItem,
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          Expanded(
              child: AnimatedList(
            key: _listKey,
            initialItemCount: 0,
            itemBuilder: (context, index, animation) {
              return SizeTransition(
                sizeFactor: animation,
                child: Card(
                  margin: const EdgeInsets.all(10),
                  color: Colors.yellow,
                  child: ListTile(
                    title: Text(_items[index]),
                    trailing: IconButton(
                      onPressed: () {
                        _removeItem(index);
                      },
                      icon: const Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),
                    ),
                  ),
                ),
              );
            },
          ))
        ],
      ),
    );
  }
}
