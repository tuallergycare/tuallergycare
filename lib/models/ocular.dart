class Ocular {
  int itchy;
  int red;
  int tearing;

  Map<String, int> _ocular = {};

  void setOcular(String title, int value) {
    if (title == 'ระคายเคืองตา') {
      itchy = value;
      _ocular.addAll({'itchy_ocular': value});
    } else if (title == 'ตาแดง') {
      red = value;
      _ocular.addAll({'red_ocular': value});
    } else {
      tearing = value;
      _ocular.addAll({'tearing_ocular': value});
    }
  }

  bool isFinished() {
    if (itchy == null || red == null || tearing == null) {
      return false;
    } else {
      return true;
    }
  }

  Map<String, int> get getOcularLevel {
    return {..._ocular};
  }
}
