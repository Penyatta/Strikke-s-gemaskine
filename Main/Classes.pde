class Opskrift {
  String titel;
  String link;
  ArrayList<String> krævneGarn = new ArrayList<String>();
  IntList tags = new IntList();
  int garntyper;
  int sværhedsgrad;
  PImage billede;
  Opskrift(String TITEL, String LINK, int SVÆRHEDSGRAD, PImage BILLEDE) {
    titel=TITEL;
    link=LINK;
    sværhedsgrad=SVÆRHEDSGRAD;
    billede=BILLEDE;
  }
  void tilfoejGarntype(String garn) {
    krævneGarn.add(garn);
    garntyper++;
  }
  void tilfoejTag(int tag) {
    tags.append(tag);
  }
  void displayOpskrift(int x, int y) {
  }
}

class SearchToken {
  String token;
}
