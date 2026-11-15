import 'dart:math' as math;

enum TicketClass {
  economy,
  business;

  String get label => this == TicketClass.economy ? 'Economy' : 'Business';
  double get allowanceKg => this == TicketClass.economy ? 20.0 : 40.0;
}

class BaggageResult {
  final double excessWeightKg;
  final double excessChargeRm;
  final double serviceTaxRm;
  final double totalPayableRm;

  const BaggageResult({
    required this.excessWeightKg,
    required this.excessChargeRm,
    required this.serviceTaxRm,
    required this.totalPayableRm,
  });
}

/// Uses the fixed 8% service tax specified in the ICT602 assignment.
BaggageResult calculateBaggage({
  required double baggageWeightKg,
  required TicketClass ticketClass,
  required double excessRatePerKgRm,
}) {
  if (!baggageWeightKg.isFinite || baggageWeightKg < 0) {
    throw ArgumentError.value(baggageWeightKg, 'baggageWeightKg', 'Must be a non-negative finite number');
  }
  if (!excessRatePerKgRm.isFinite || excessRatePerKgRm < 0) {
    throw ArgumentError.value(excessRatePerKgRm, 'excessRatePerKgRm', 'Must be a non-negative finite number');
  }

  final double excessKg = math.max(0.0, baggageWeightKg - ticketClass.allowanceKg);
  final double charge = excessKg * excessRatePerKgRm;
  final double tax = charge * 0.08;

  return BaggageResult(
    excessWeightKg: excessKg,
    excessChargeRm: charge,
    serviceTaxRm: tax,
    totalPayableRm: charge + tax,
  );
}
