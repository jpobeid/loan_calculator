import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class AmortizationPlot extends StatelessWidget {
  final Widget title;
  final List<LineChartBarData> lineBarsData;
  final List<double> sequenceX;
  final List<LineTooltipItem?> Function(List<LineBarSpot>) getTooltipItems;

  const AmortizationPlot({
    super.key,
    required this.title,
    required this.lineBarsData,
    required this.sequenceX,
    required this.getTooltipItems,
  });

  @override
  Widget build(BuildContext context) {
    double intervalX = (sequenceX.length / 6).roundToDouble();

    return Center(
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.9,
        child: AspectRatio(
          aspectRatio: 1.2,
          child: LineChart(
            LineChartData(
              lineBarsData: lineBarsData,
              gridData: FlGridData(
                drawHorizontalLine: false,
                verticalInterval: intervalX,
              ),
              lineTouchData: LineTouchData(
                touchTooltipData: LineTouchTooltipData(
                  fitInsideHorizontally: true,
                  getTooltipItems: getTooltipItems,
                ),
              ),
              titlesData: FlTitlesData(
                topTitles: AxisTitles(
                    axisNameWidget: title,
                    axisNameSize: 36,
                    sideTitles: const SideTitles(showTitles: false)),
                rightTitles:
                    const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                leftTitles:
                    const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    interval: intervalX,
                    reservedSize: 40,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
