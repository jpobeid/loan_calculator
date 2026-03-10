enum Frequency {
  monthly('Monthly', 1),
  quarterly('Quarterly', 3),
  annually('Annually', 12);

  final String label;
  final int divisorToMonthly;

  const Frequency(this.label, this.divisorToMonthly);
}
