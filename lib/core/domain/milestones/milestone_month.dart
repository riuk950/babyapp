// Months 1..60 of child development (spec 004 RF-1, CL-8, CL-11). Pure Dart,
// no Flutter imports (constitution §3A). Identifiers in English; the age
// labels (used for display and search) are in Spanish.
enum MilestoneMonth {
  month1(1, 'Nacimiento a 1 mes'),
  month2(2, '1 a 2 meses'),
  month3(3, '2 a 3 meses'),
  month4(4, '3 a 4 meses'),
  month5(5, '4 a 5 meses'),
  month6(6, '5 a 6 meses'),
  month7(7, '6 a 7 meses'),
  month8(8, '7 a 8 meses'),
  month9(9, '8 a 9 meses'),
  month10(10, '9 a 10 meses'),
  month11(11, '10 a 11 meses'),
  month12(12, '11 a 12 meses'),
  month13(13, '12 a 13 meses'),
  month14(14, '13 a 14 meses'),
  month15(15, '14 a 15 meses'),
  month16(16, '15 a 16 meses'),
  month17(17, '16 a 17 meses'),
  month18(18, '17 a 18 meses'),
  month19(19, '18 a 19 meses'),
  month20(20, '19 a 20 meses'),
  month21(21, '20 a 21 meses'),
  month22(22, '21 a 22 meses'),
  month23(23, '22 a 23 meses'),
  month24(24, '23 a 24 meses'),
  month25(25, '24 a 25 meses'),
  month26(26, '25 a 26 meses'),
  month27(27, '26 a 27 meses'),
  month28(28, '27 a 28 meses'),
  month29(29, '28 a 29 meses'),
  month30(30, '29 a 30 meses'),
  month31(31, '30 a 31 meses'),
  month32(32, '31 a 32 meses'),
  month33(33, '32 a 33 meses'),
  month34(34, '33 a 34 meses'),
  month35(35, '34 a 35 meses'),
  month36(36, '35 a 36 meses'),
  month37(37, '36 a 37 meses'),
  month38(38, '37 a 38 meses'),
  month39(39, '38 a 39 meses'),
  month40(40, '39 a 40 meses'),
  month41(41, '40 a 41 meses'),
  month42(42, '41 a 42 meses'),
  month43(43, '42 a 43 meses'),
  month44(44, '43 a 44 meses'),
  month45(45, '44 a 45 meses'),
  month46(46, '45 a 46 meses'),
  month47(47, '46 a 47 meses'),
  month48(48, '47 a 48 meses'),
  month49(49, '48 a 49 meses'),
  month50(50, '49 a 50 meses'),
  month51(51, '50 a 51 meses'),
  month52(52, '51 a 52 meses'),
  month53(53, '52 a 53 meses'),
  month54(54, '53 a 54 meses'),
  month55(55, '54 a 55 meses'),
  month56(56, '55 a 56 meses'),
  month57(57, '56 a 57 meses'),
  month58(58, '57 a 58 meses'),
  month59(59, '58 a 59 meses'),
  month60(60, '59 a 60 meses');

  const MilestoneMonth(this.number, this.ageLabel);

  /// The 1-based month number (1..60).
  final int number;

  /// Spanish label of the age interval covered by this month (RF-1).
  final String ageLabel;

  /// Returns the [MilestoneMonth] for [number] (1..60), or `null` when out of
  /// range (CL-11).
  static MilestoneMonth? forNumber(int number) {
    if (number < 1 || number > 60) return null;
    return MilestoneMonth.values[number - 1];
  }
}
