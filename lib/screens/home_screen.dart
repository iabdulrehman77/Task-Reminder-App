import 'package:flutter/material.dart';
import 'package:taskly/widgets/list_item.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, this.title});

  final String? title;

  @override
  State<HomeScreen> createState() {
    return _HomeScreenState();
  }
}

class _HomeScreenState extends State<HomeScreen> {
  final _textController = TextEditingController();

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  final List<ListItem> listItems = [];

  void _addItem() {
    showDialog(
      useSafeArea: true,
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Item!'),
          content: TextField(
            controller: _textController,
            decoration: const InputDecoration(hintText: 'Title Text...'),
          ),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _textController.clear();
                },
                child: const Text('Cancel')),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  if (_textController.text.isEmpty) {
                    return;
                  }

                  listItems.add(ListItem(
                      title: _textController.text,
                      currentTime: DateTime.now(),
                      done: true));
                });
                _textController.clear();
                Navigator.of(context).pop();
              },
              style: ButtonStyle(
                foregroundColor: WidgetStateProperty.all(Colors.white),
                backgroundColor:
                    WidgetStateProperty.all(Colors.red.withOpacity(0.9)),
              ),
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final deviceHeight = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: deviceHeight * 0.20,
          title:  Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              widget.title!,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          backgroundColor: Colors.red,
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Stack(children: [
            listItems.isEmpty
                ? const Center(child: Text('No Task Found'))
                : ListView.builder(
                    itemCount: listItems.length,
                    itemBuilder: (context, index) {
                      return Dismissible(
                        direction: DismissDirection.horizontal,
                        key: ValueKey(listItems[index]),
                        onDismissed: (direction) {
                          setState(() {
                            listItems.removeAt(index);
                          });
                        },
                        child: Card(
                          margin: const EdgeInsets.all(4),
                          child: ListTile(
                            onTap: () {
                              setState(() {
                                listItems[index].done = !listItems[index].done;
                              });
                            },
                            title: Text(
                              listItems[index].title,
                              style: listItems[index].done
                                  ? const TextStyle(
                                      decoration: TextDecoration.none)
                                  : const TextStyle(
                                      decoration: TextDecoration.lineThrough),
                            ),
                            subtitle: Text(
                              listItems[index].currentTime.toString(),
                            ),
                            trailing: Icon(
                              listItems[index].done
                                  ? Icons.check_box_outline_blank
                                  : Icons.check_box_outlined,
                              color: Colors.red,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
            Positioned(
                bottom: 10,
                right: 10,
                child: FloatingActionButton(
                  onPressed: _addItem,
                  backgroundColor: Colors.red,
                  child: const Icon(
                    Icons.add,
                    color: Colors.white70,
                  ),
                ))
          ]),
        ),
      ),
    );
  }
}
