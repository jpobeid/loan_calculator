import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:loan_calculator/widgets/plot_widgets.dart';

Color colorPrincipal = const Color.fromARGB(255, 20, 180, 220);
Color colorDP = Colors.green;
Color colorDI = Colors.orange;
double sizeDots = 2;

List<LineTooltipItem> getTooltipItemsPrincipal(
        List<LineBarSpot> touchedSpots) =>
    touchedSpots.map((touchedSpot) {
      final textStyle = TextStyle(
        color: touchedSpot.bar.gradient?.colors.first ??
            touchedSpot.bar.color ??
            Colors.blueGrey,
        fontWeight: FontWeight.bold,
        fontSize: 14,
      );
      return LineTooltipItem(
          '${touchedSpot.y}\nt = ${touchedSpot.x.round()}', textStyle);
    }).toList();

List<LineTooltipItem> getTooltipItemsPI(List<LineBarSpot> touchedSpots) =>
    touchedSpots.map((touchedSpot) {
      final textStyle = TextStyle(
        color: touchedSpot.bar.gradient?.colors.first ??
            touchedSpot.bar.color ??
            Colors.blueGrey,
        fontWeight: FontWeight.bold,
        fontSize: 14,
      );
      if (touchedSpot != touchedSpots.last) {
        return LineTooltipItem(touchedSpot.y.toString(), textStyle);
      } else {
        return LineTooltipItem(
            '${touchedSpot.y}\nt = ${touchedSpot.x.round()}', textStyle);
      }
    }).toList();

class AmortizationPlotPage extends StatelessWidget {
  final List<double> sequenceP;
  final List<double> sequenceDP;
  final List<double> sequenceDI;

  const AmortizationPlotPage({
    super.key,
    required this.sequenceP,
    required this.sequenceDP,
    required this.sequenceDI,
  });

  @override
  Widget build(BuildContext context) {
    List<FlSpot> spotsP = [];
    List<FlSpot> spotsDP = [];
    List<FlSpot> spotsDI = [];
    for (int i = 0; i < sequenceP.length; i = i + 1) {
      spotsP.add(
          FlSpot(i.toDouble(), double.parse(sequenceP[i].toStringAsFixed(2))));
    }
    for (int i = 0; i < sequenceDP.length; i = i + 1) {
      spotsDP.add(FlSpot(
          (i + 1).toDouble(), double.parse(sequenceDP[i].toStringAsFixed(2))));
    }
    for (int i = 0; i < sequenceDI.length; i = i + 1) {
      spotsDI.add(FlSpot(
          (i + 1).toDouble(), double.parse(sequenceDI[i].toStringAsFixed(2))));
    }
    List<LineChartBarData> lineBarsDataPrincipal = [
      LineChartBarData(
        spots: spotsP,
        color: colorPrincipal,
        dotData: FlDotData(
          show: true,
          getDotPainter: (spot, percent, barData, index) {
            return FlDotCirclePainter(
              radius: sizeDots,
              color: colorPrincipal,
            );
          },
        ),
      ),
    ];
    List<LineChartBarData> lineBarsDataPI = [
      LineChartBarData(
        spots: spotsDP,
        color: colorDP,
        dotData: FlDotData(
          show: true,
          getDotPainter: (spot, percent, barData, index) {
            return FlDotCirclePainter(
              radius: sizeDots,
              color: colorDP,
            );
          },
        ),
      ),
      LineChartBarData(
        spots: spotsDI,
        color: colorDI,
        dotData: FlDotData(
          show: true,
          getDotPainter: (spot, percent, barData, index) {
            return FlDotCirclePainter(
              radius: sizeDots,
              color: colorDI,
            );
          },
        ),
      ),
    ];

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Amortization plot'),
          backgroundColor: Colors.blue,
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            AmortizationPlot(
              title: Text(
                'Principal',
                style: TextStyle(color: colorPrincipal),
              ),
              lineBarsData: lineBarsDataPrincipal,
              sequenceX: sequenceDP,
              getTooltipItems: getTooltipItemsPrincipal,
            ),
            AmortizationPlot(
              title: RichText(
                text: TextSpan(
                  style: Theme.of(context).textTheme.bodyMedium,
                  children: [
                    TextSpan(text: '\u0394P', style: TextStyle(color: colorDP)),
                    const TextSpan(
                        text: ' & ', style: TextStyle(color: Colors.black)),
                    TextSpan(text: '\u0394I', style: TextStyle(color: colorDI)),
                  ],
                ),
              ),
              lineBarsData: lineBarsDataPI,
              sequenceX: sequenceDP,
              getTooltipItems: getTooltipItemsPI,
            ),
          ],
        ),
      ),
    );
  }
}
