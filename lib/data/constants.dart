enum Frequency {
  monthly('Monthly', 1),
  quarterly('Quarterly', 3),
  annually('Annually', 12);

  final String frequency;
  final int divisorToMonthly;

  const Frequency(this.frequency, this.divisorToMonthly);
}
