import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeTable extends ConsumerStatefulWidget {
  const HomeTable({super.key, required this.title, required this.listTiles});

  final String title;
  final List<Widget> listTiles;

  @override
  ConsumerState<HomeTable> createState() {
    return _HomeTableState();
  }
}

class _HomeTableState extends ConsumerState<HomeTable> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: TextButton.icon(
            onPressed: () {},
            icon: Icon(
              Icons.arrow_forward_ios,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
            iconAlignment: IconAlignment.end,
            label: Text(
              widget.title,
              style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimary, fontSize: 18),
            ),
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 18),
          child: Divider(),
        ),
        if(widget.listTiles.isNotEmpty)
          ...widget.listTiles
        else 
          const Text("Inserire delle transizioni...")
      ],
    );
  }
}
