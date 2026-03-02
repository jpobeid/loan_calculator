import 'package:flutter/material.dart';

class AmortizationPage extends StatefulWidget {
  final List<double> sequenceDP;
  final List<double> sequenceDI;

  const AmortizationPage({
    super.key,
    required this.sequenceDP,
    required this.sequenceDI,
  });

  @override
  State<AmortizationPage> createState() => _AmortizationPageState();
}

class _AmortizationPageState extends State<AmortizationPage> {
  final List<String> _columnNames = [
    'Month',
    '\u0394P',
    '\u0394I',
    'Principal',
  ];
  late final List<DataRow> _dataRows;
  double _fontSize = 16;
  final double _fontSizeMin = 12;
  final double _fontSizeMax = 20;

  @override
  void initState() {
    super.initState();
    _dataRows = _makeDataRows();
  }

  @override
  Widget build(BuildContext context) {
    DataTable table = _makeDataTable(
      columnNames: _columnNames,
      dataRows: _dataRows,
      fontSize: _fontSize,
    );

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Amortization table'),
          backgroundColor: Colors.green,
          actions: [
            IconButton(
              onPressed: () {
                if (_fontSize < _fontSizeMax) {
                  setState(() {
                    _fontSize = _fontSize + 1;
                  });
                }
              },
              icon: const Icon(Icons.add),
            ),
            IconButton(
              onPressed: () {
                if (_fontSize > _fontSizeMin) {
                  setState(() {
                    _fontSize = _fontSize - 1;
                  });
                }
              },
              icon: const Icon(Icons.remove),
            ),
          ],
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SingleChildScrollView(
            child: table,
          ),
        ),
      ),
    );
  }

  DataTable _makeDataTable({
    required List<String> columnNames,
    required List<DataRow> dataRows,
    required double fontSize,
  }) {
    return DataTable(
      columnSpacing: 15,
      horizontalMargin: 5,
      columns: columnNames
          .map(
            (e) => DataColumn(
              label: Text(
                e,
                style: TextStyle(fontSize: fontSize),
              ),
              numeric: true,
              headingRowAlignment: MainAxisAlignment.center,
            ),
          )
          .toList(),
      rows: dataRows,
      dataTextStyle: TextStyle(fontSize: fontSize),
      border: const TableBorder(verticalInside: BorderSide()),
    );
  }

  List<DataRow> _makeDataRows() {
    double p0 = widget.sequenceDP.reduce((value, element) => value + element);

    List<DataRow> dataRows = [
      DataRow(cells: [
        const DataCell(Text('0')),
        const DataCell(Text('0')),
        const DataCell(Text('0')),
        DataCell(Text(p0.toStringAsFixed(2))),
      ])
    ];

    for (int i = 1; i <= widget.sequenceDP.length; i++) {
      double p = p0 -
          widget.sequenceDP
              .sublist(0, i)
              .reduce((value, element) => value + element);
      dataRows.add(DataRow(cells: [
        DataCell(Text('$i')),
        DataCell(Text(widget.sequenceDP[i - 1].toStringAsFixed(2))),
        DataCell(Text(widget.sequenceDI[i - 1].toStringAsFixed(2))),
        DataCell(Text(p.toStringAsFixed(2))),
      ]));
    }
    return dataRows;
  }
}
