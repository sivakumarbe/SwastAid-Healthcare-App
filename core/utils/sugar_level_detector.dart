class SugarLevelDetector {
  static String getCategory(int glucose) {
    if (glucose < 140) return "Normal Level < 140 mg/dL";
    if (glucose <= 180) return "Mild Level 140-180 mg/dL";
    if (glucose <= 250) return "Moderate Level 180-250 mg/dL";
    return "High Level above 250 mg/dL";
  }
}
