class JournalEntryFields {
  int? id;
  DateTime? date;
  int? systolicBP;
  int? diastolicBP;
  int? pulse;
  String? comments;

  JournalEntryFields(
      {this.id,
      this.date,
      this.systolicBP,
      this.diastolicBP,
      this.pulse,
      this.comments});

  String toString() {
    return 'Id: $id, Title: $date, $systolicBP/$diastolicBP, Pulse: $pulse, Comments: $comments';
  }
}
