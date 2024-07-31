import 'package:flutter/material.dart';

class CollectionPage extends StatefulWidget {
  const CollectionPage({super.key});

  @override
  State<CollectionPage> createState() => _CollectionPageState();
}

class _CollectionPageState extends State<CollectionPage> {
  List<Order> orders = [
    Order(userId: '001', items: '5 items', timestamp: DateTime.now()),
    Order(userId: '002', items: '10 items', timestamp: DateTime.now()),
    // Add more orders here
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Orders Table')),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            columns: [
              DataColumn(label: Text('User ID')),
              DataColumn(label: Text('Items')),
              DataColumn(label: Text('Timestamp')),
              DataColumn(label: Text('Delivered')),
            ],
            rows: orders.map((order) {
              return DataRow(cells: [
                DataCell(Text(order.userId)),
                DataCell(Text(order.items)),
                DataCell(Text(order.timestamp.toString())),
                DataCell(
                  Checkbox(
                    value: order.delivered,
                    onChanged: (bool? value) {
                      setState(() {
                        order.delivered = value ?? false;
                      });
                    },
                  ),
                ),
              ]);
            }).toList(),
          ),
        ),
      ),
    );
  }
}

class Order {
  final String userId;
  final String items;
  final DateTime timestamp;
  bool delivered;

  Order({
    required this.userId,
    required this.items,
    required this.timestamp,
    this.delivered = false,
  });
}
