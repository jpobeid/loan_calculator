import 'package:flutter/material.dart';

class Amortization extends StatelessWidget {
  final List<double> sequenceDP;
  final List<double> sequenceDI;

  const Amortization({
    super.key,
    required this.sequenceDP,
    required this.sequenceDI,
  });

  @override
  Widget build(BuildContext context) {
    List<String> columnNames = ['Month', '\u0394P', '\u0394I', 'Principal'];
    double p0 = sequenceDP.reduce((value, element) => value + element);

    List<DataRow> dataRows = [
      DataRow(cells: [
        const DataCell(Text('0')),
        const DataCell(Text('0')),
        const DataCell(Text('0')),
        DataCell(Text(p0.toStringAsFixed(2))),
      ])
    ];
    for (int i = 1; i <= sequenceDP.length; i++) {
      double p = p0 -
          sequenceDP.sublist(0, i).reduce((value, element) => value + element);
      dataRows.add(DataRow(cells: [
        DataCell(Text('$i')),
        DataCell(Text(sequenceDP[i - 1].toStringAsFixed(2))),
        DataCell(Text(sequenceDI[i - 1].toStringAsFixed(2))),
        DataCell(Text(p.toStringAsFixed(2))),
      ]));
    }

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Amortization table'),
          backgroundColor: Colors.green,
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SingleChildScrollView(
            child: DataTable(
              columns: columnNames
                  .map((e) => DataColumn(
                      label: Text(
                        e,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      numeric: true))
                  .toList(),
              rows: dataRows,
              dataTextStyle: Theme.of(context).textTheme.labelSmall,
              border: const TableBorder(verticalInside: BorderSide()),
            ),
          ),
        ),
      ),
    );
  }
}
