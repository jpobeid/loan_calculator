enum Frequency {
  monthly('Monthly', 1),
  quarterly('Quarterly', 3),
  annually('Annually', 12);

  final String label;
  final int divisorToMonthly;

  const Frequency(this.label, this.divisorToMonthly);
}

int priceInitial = 0;
int downInputtedInitial = 0;
bool isDownInputtedPercentageInitial = true;
double ratePercentInitial = 7;
int timeInitial = 360;
int taxInitial = 0;
int insuranceInitial = 0;
int hoaInitial = 0;
int pmiInitial = 0;
Frequency frequencyTaxInitial = Frequency.monthly;
Frequency frequencyInsuranceInitial = Frequency.monthly;
Frequency frequencyHoaInitial = Frequency.monthly;

int timeMin = 12;
double ratePercentMin = 0;
double ratePercentMax = 50;
