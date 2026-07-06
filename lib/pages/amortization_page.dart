import 'package:flutter/material.dart';
import 'package:loan_calculator/pages/amortization_plot_page.dart';

final List<String> columnNames = [
  'Month',
  '\u0394P',
  '\u0394I',
  'Principal',
  '%P'
];

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
  final List<double> _sequenceP = [];
  late final List<double> _sequencePercentP;
  late final List<DataRow> _dataRows;
  double _fontSize = 16;
  final double _fontSizeMin = 12;
  final double _fontSizeMax = 20;

  @override
  void initState() {
    super.initState();
    _makeSequenceP();
    _sequencePercentP = _sequenceP
        .map((e) => double.parse((e / _sequenceP[0] * 100).toStringAsFixed(2)))
        .toList();
    _dataRows = _makeDataRows();
  }

  @override
  Widget build(BuildContext context) {
    DataTable table = _makeDataTable(
      columnNames: columnNames,
      dataRows: _dataRows,
      fontSize: _fontSize,
    );

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Amortization table'),
          backgroundColor: Colors.blue,
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Flexible(
              flex: 9,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SingleChildScrollView(
                  child: table,
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                color: Colors.black87,
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          IconButton(
                            onPressed: () {
                              if (_fontSize < _fontSizeMax) {
                                setState(() {
                                  _fontSize = _fontSize + 1;
                                });
                              }
                            },
                            icon: const Icon(
                              Icons.add,
                              color: Colors.white,
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              if (_fontSize > _fontSizeMin) {
                                setState(() {
                                  _fontSize = _fontSize - 1;
                                });
                              }
                            },
                            icon: const Icon(
                              Icons.remove,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: IconButton(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => AmortizationPlotPage(
                                    sequenceP: _sequenceP,
                                    sequenceDP: widget.sequenceDP,
                                    sequenceDI: widget.sequenceDI,
                                  )));
                        },
                        icon: const Icon(
                          Icons.add_chart,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _makeSequenceP() {
    double p0 = widget.sequenceDP.reduce((value, element) => value + element);
    _sequenceP.add(p0);

    for (int i = 1; i <= widget.sequenceDP.length; i++) {
      double p = p0 -
          widget.sequenceDP
              .sublist(0, i)
              .reduce((value, element) => value + element);
      _sequenceP.add(p);
    }
  }

  List<DataRow> _makeDataRows() {
    Color color0 = Colors.white;
    Color color1 = const Color.fromARGB(255, 235, 235, 235);

    List<DataRow> dataRows = [
      DataRow(
        cells: [
          const DataCell(Text('0')),
          const DataCell(Text('0')),
          const DataCell(Text('0')),
          DataCell(Text(_sequenceP[0].toStringAsFixed(2))),
          const DataCell(Text('100')),
        ],
        color: WidgetStateProperty.all(color0),
      )
    ];

    for (int i = 1; i <= widget.sequenceDP.length; i++) {
      dataRows.add(DataRow(
        cells: [
          DataCell(Text('$i')),
          DataCell(Text(widget.sequenceDP[i - 1].toStringAsFixed(2))),
          DataCell(Text(widget.sequenceDI[i - 1].toStringAsFixed(2))),
          DataCell(Text(_sequenceP[i].toStringAsFixed(2))),
          DataCell(Text(_sequencePercentP[i].toString())),
        ],
        color: WidgetStateProperty.all(i % 2 == 1 ? color1 : color0),
      ));
    }
    return dataRows;
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
}
