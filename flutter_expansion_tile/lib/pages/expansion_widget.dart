import 'package:flutter/material.dart';

class ExpansionWidget extends StatefulWidget {
  const ExpansionWidget({super.key});

  @override
  State<ExpansionWidget> createState() => _ExpansionWidgetState();
}

class _ExpansionWidgetState extends State<ExpansionWidget> {
  final _key = GlobalKey<AnimatedListState>();

  final List<Map<String, dynamic>> _itemsList = List.generate(
    0,
    (index) => {
      "id": index,
      "title": "Item $index",
      "description": "The description of item $index"
    },
  );

  void _addItem() {
    final newItem = {
      "id": _itemsList.length,
      "title": "Item ${_itemsList.length}",
      "description": "The description of item ${_itemsList.length}"
    };
    _itemsList.insert(0, newItem);
    _key.currentState!.insertItem(0, duration: const Duration(seconds: 1));
  }

  void _removeItem(int index) {
    final removedItem = _itemsList[index];
    _key.currentState!.removeItem(
      index,
      (context, animation) {
        return SizeTransition(
          sizeFactor: animation,
          child: const Card(
            color: Colors.red,
            child: ListTile(
              title: Text(
                "Deleted!",
                style: TextStyle(fontSize: 18),
              ),
            ),
          ),
        );
      },
      duration: const Duration(milliseconds: 300),
    );
    _itemsList.removeAt(index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text("Expansion List")),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addItem,
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          Expanded(
            child: AnimatedList(
              key: _key,
              initialItemCount: 0,
              itemBuilder: (context, index, animation) {
                return SizeTransition(
                  sizeFactor: animation,
                  child: Card(
                    color: Colors.yellow,
                    margin: const EdgeInsets.all(10),
                    child: ExpansionTile(
                      iconColor: Colors.white,
                      collapsedIconColor: Colors.white,
                      childrenPadding: const EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 20,
                      ),
                      expandedCrossAxisAlignment: CrossAxisAlignment.end,
                      title: Text(_itemsList[index]['title']),
                      children: [
                        Text(_itemsList[index]['description']),
                        IconButton(
                            onPressed: () {
                              _removeItem(index);
                            },
                            icon: const Icon(
                              Icons.delete,
                              color: Colors.red,
                            ))
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
