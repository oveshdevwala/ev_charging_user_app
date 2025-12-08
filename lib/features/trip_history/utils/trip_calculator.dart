/// Utility class for trip-related calculations
class TripCalculator {
  /// Calculate efficiency score
  /// Formula: efficiencyScore = kmDriven / energyConsumedKWh
  static double calculateEfficiencyScore({
    required double kmDriven,
    required double energyConsumedKWh,
  }) {
    if (energyConsumedKWh == 0) {
      return 0;
    }
    return kmDriven / energyConsumedKWh;
  }

  /// Calculate comparison percentage between current and previous values
  /// Formula: percentage = ((current - previous) / previous) * 100
  static double calculateComparisonPercentage({
    required double current,
    required double previous,
  }) {
    if (previous == 0) {
      return 0;
    }
    return ((current - previous) / previous) * 100;
  }

  /// Calculate total cost from a list of amounts
  static double calculateTotalCost(List<double> costs) {
    return costs.fold(0, (sum, cost) => sum + cost);
  }

  /// Calculate total energy from a list of energy values
  static double calculateTotalEnergy(List<double> energyValues) {
    return energyValues.fold(0, (sum, energy) => sum + energy);
  }

  /// Calculate average efficiency from a list of efficiency scores
  static double calculateAverageEfficiency(List<double> efficiencyScores) {
    if (efficiencyScores.isEmpty) {
      return 0;
    }
    final sum = efficiencyScores.fold<double>(0, (sum, score) => sum + score);
    return sum / efficiencyScores.length;
  }
}
