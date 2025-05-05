import http.requests.*;

// Declare the back button for the search screen
Knap søgeSkærmTilbageKnap;
Knap søgeSkærmSøgKnap;

void søgeSkærm() {
  background(255);

  // Tjek om opskrifter er tomt
  if (!visteOpskrifter.isEmpty()) {

    // Konverterer opskrifter til et array og viser dem
    Opskrift[] visteOpskriftArray = visteOpskrifter.toArray(new Opskrift[0]);

    // Add the "Opskrifter" title text with proper camY offset
    textFont(generalFont);
    textSize(80);
    fill(71, 92, 108);
    textAlign(CENTER);
    text("Opskrifter", width / 7 * 3 + width / 4, height / 3 - camY);

    displayOpskrifter(visteOpskriftArray);
  }
  noStroke();
  fill(247, 239, 210);
  rect(580*width/1440, 150*width/1440, 18*width/1440, 780*width/1440);

  textSize(40*width/1440);
  fill(71, 92, 108);
  textAlign(CORNER, CORNER);
  text("Filtrer - kryds af", 45*width/1440, 370*height/982-camY);
  textSize(30*width/1440);
  text("Kategorier", 45*width/1440, 425*height/982-camY);
  text("Produkttype", 45*width/1440, 690*height/982-camY);
  text("Søg udfra mit garn", 52*width/1440, 1050*height/982-camY);

  kategoriGroup.tegnAlle();
  produktTypeGroup.tegnAlle();
  udfraGarnGroup.tegnAlle();

  overskriftBjælke("Søg efter opskrifter");
}


SwitchGroup kategoriGroup;
SwitchGroup produktTypeGroup;
SwitchGroup udfraGarnGroup;

void søgeSkærmSetup() {

  hentOpskrifterFraServer("søg");

  kategoriGroup = new SwitchGroup();
  produktTypeGroup =new SwitchGroup();
  udfraGarnGroup = new SwitchGroup();

  // Laver kategori switchesne
  float højde=410*height/982;
  float bredde1=(580*width/1440)/4;
  float bredde2=(580*width/1440)/2;
  float bredde3=(580*width/1440)/4*3;
  Switch KvindeSwitch = new Switch(bredde1, højde+75, 30*width/1440-camY, "Kvinde", false);
  Switch MandSwitch = new Switch(bredde2, højde+75, 30*width/1440-camY, "Mand", false);
  Switch BabySwitch = new Switch(bredde3, højde+75, 30*width/1440-camY, "Baby (0-4 år)", false);
  Switch BarnSwitch = new Switch(bredde1, 585*height/982-10, 30*width/1440-camY, "Børn (2-14 år)", false);
  Switch HjemSwitch = new Switch(bredde2, 585*height/982-10, 30*width/1440-camY, "Hjem", false);

  //Tilføjer kategori switchesne til en gruppe
  kategoriGroup.addSwitch(KvindeSwitch);
  kategoriGroup.addSwitch(MandSwitch);
  kategoriGroup.addSwitch(BabySwitch);
  kategoriGroup.addSwitch(BarnSwitch);
  kategoriGroup.addSwitch(HjemSwitch);

  // laver udfra garn switch
  Switch jaSwitch = new Switch((580*width/1440)/4, 1110*height/982, 30*width/1440, "Ja", false);
  udfraGarnGroup.addSwitch(jaSwitch);

  // Laver tilbageknappen til søgeskærmen
  søgeSkærmTilbageKnap = new TilbageKnap(height/9-height/15, height/9-height/17, height/15*2, height/17*2, color(0), "tilbage", 10, color(205, 139, 98), color(0, 255, 0), 10, søgeSkærm);
  knapper.add(søgeSkærmTilbageKnap);

  //laver søgefeltknappen til søgeskærmen
  søgeSkærmSøgKnap = new Knap(493*width/1440, height/9*2+height/40-camY, 67*width/1440, 67*height/982, color(71, 92, 108), "Søg", 30, color(247, 239, 210), color(247, 239, 210), 0, søgeSkærm);
  knapper.add(søgeSkærmSøgKnap);
  textfields.add(new Textfield(35*width/1440, height/9*2+height/40, 440*width/1440, 67*height/982, color(71, 92, 108), color(247, 239, 210), color(247, 239, 210), color(247, 239, 210), 30*width/1440, "Søgefelt", "", 0, søgeSkærm, false));

  // laver produkttype switchesne
  højde=750*height/982-camY;
  Switch sweaterSwitch = new Switch(bredde1, højde, 30*width/1440, "Sweater", false);
  Switch cardiganSwitch = new Switch(bredde2, højde, 30*width/1440, "Cardigan", false);
  Switch hueSwitch = new Switch(bredde3, højde, 30*width/1440, "Hue", false);
  højde=840*height/982-camY;
  Switch vanterSwitch = new Switch(bredde1, højde, 30*width/1440, "Vanter", false);
  Switch vestSwitch = new Switch(bredde2, højde, 30*width/1440, "Vest", false);
  Switch topSwitch = new Switch(bredde3, højde, 30*width/1440, "Top", false);
  højde=930*height/982-camY;
  Switch shortsSwitch = new Switch(bredde1, højde, 30*width/1440, "Shorts", false);
  Switch strømperSwitch = new Switch(bredde2, højde, 30*width/1440, "Strømper", false);
  Switch nederdelSwitch = new Switch(bredde3, højde, 30*width/1440, "Nederdel", false);

  // Tilføjer produkttype switchesne til en gruppe
  produktTypeGroup.addSwitch(sweaterSwitch);
  produktTypeGroup.addSwitch(cardiganSwitch);
  produktTypeGroup.addSwitch(hueSwitch);
  produktTypeGroup.addSwitch(vanterSwitch);
  produktTypeGroup.addSwitch(vestSwitch);
  produktTypeGroup.addSwitch(topSwitch);
  produktTypeGroup.addSwitch(shortsSwitch);
  produktTypeGroup.addSwitch(strømperSwitch);
  produktTypeGroup.addSwitch(nederdelSwitch);

  // tilføjer ud fra garn switch
  udfraGarnGroup.addSwitch(jaSwitch);

  // Laver tilbageknappen til søgeskærmen
  søgeSkærmTilbageKnap = new TilbageKnap(height/9-height/15, height/9-height/17, height/15*2, height/17*2, color(0), "tilbage", 10, color(205, 139, 98), color(247, 239, 210), 10, søgeSkærm);
  knapper.add(søgeSkærmTilbageKnap);
  søgeSkærmSøgKnap = new Knap(493*width/1440, height/9*2+height/40, 67*width/1440, 67*height/982, color(71, 92, 108), "Søg", 30, color(247, 239, 210), color(247, 239, 210), 0, søgeSkærm);
  knapper.add(søgeSkærmSøgKnap);
  textfields.add(new Textfield(35*width/1440, height/9*2+height/40, 440*width/1440, 67*height/982, color(71, 92, 108), color(247, 239, 210), color(247, 239, 210), color(247, 239, 210), 30*width/1440, "Søgefelt", "", 0, søgeSkærm, false));
}

void opdaterFiltreretListe() {
  visteOpskrifter.clear();

  // Få navnet på den valgte switch (kategori)
  String valgtKategori = kategoriGroup.getSelectedTitle();
  
  // Få navnet på den valgte switch (Produkttype)
  String valgtproduktType = produktTypeGroup.getSelectedTitle();

 for (Opskrift o : alleOpskrifter) {
    boolean match = true;

    if (!valgtKategori.equals("") && !o.kategori.equals(valgtKategori)) {
      match = false;
    }

    if (!valgtproduktType.equals("") && !o.produktType.equals(valgtproduktType)) {
      match = false;
    }


    if (match) {
      visteOpskrifter.add(o);
    }
  }
}


void søgeSkærmKnapper() {
  if (søgeSkærmTilbageKnap.mouseOver()) {
    skærm=startSkærm;
    // Reset scroll position when leaving the screen
    camY = 0;
  }
  kategoriGroup.checkMouse();
  produktTypeGroup.checkMouse();
  udfraGarnGroup.checkMouse();
  
    // Opdater visning baseret på valgte filtre
  opdaterFiltreretListe();
  
}


void overskriftBjælke(String tekst) {
  rectMode(CORNER);
  fill(71, 92, 108);
  rect(0, 0, width, height/9*2);
  fill(247, 239, 210);
  textFont(generalFont);
  textAlign(CENTER, CENTER);
  textSize(100*width/1920);
  text(tekst, width/2, height/9);
}
