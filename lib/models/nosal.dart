class Nasal {
  int congrestion;
  int itchy;
  int sneezing;
  int runny;

  Map<String, int> _nasal = {};

  void setNasal(String title, int value) {
    if (title == 'คัดจมูก') {
      congrestion = value;
      _nasal.addAll({'congrestion_nasal': value});
    } else if (title == 'คันจมูก') {
      itchy = value;
      _nasal.addAll({'itchy_nasal': value});
    } else if (title == 'จาม') {
      sneezing = value;
      _nasal.addAll({'sneezing_nasal': value});
    } else {
      runny = value;
      _nasal.addAll({'runny_nasal': value});
    }
  }

  bool isFinished() {
    if (itchy == null ||
        sneezing == null ||
        runny == null ||
        congrestion == null) {
      return false;
    } else {
      return true;
    }
  }

  Map<String, int> get getNasalLevel {
    return {..._nasal};
  }
}
