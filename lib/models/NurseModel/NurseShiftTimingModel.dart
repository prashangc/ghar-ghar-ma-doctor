class NurseShiftTimingModel {
  final String shift;

  NurseShiftTimingModel({
    required this.shift,
  });
}

List<NurseShiftTimingModel> nurseShiftTimingList = [
  NurseShiftTimingModel(
    shift: "7 AM - 1 PM",
  ),
  NurseShiftTimingModel(
    shift: "1 PM - 7 PM",
  ),
  NurseShiftTimingModel(
    shift: "7 AM - 7 PM",
  ),
  NurseShiftTimingModel(
    shift: "No Shift",
  ),
];
