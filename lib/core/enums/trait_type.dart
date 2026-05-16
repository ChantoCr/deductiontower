enum TraitType {
  appearance,
  power,
  origin,
  role,
  story,
  weapon,
  personality,
  series,
  status;

  static TraitType fromValue(String value) {
    return TraitType.values.firstWhere(
      (type) => type.name == value,
      orElse: () => TraitType.appearance,
    );
  }
}
