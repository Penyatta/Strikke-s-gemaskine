import http.requests.*;



// Declare the back button for the search screen
Knap søgeSkærmTilbageKnap;
Knap søgeSkærmSøgKnap;

void søgeSkærm() {
  background(255);

  // Tjek om opskrifter er tomt
  if (!opskrifter.isEmpty()) {

    // Konverterer opskrifter til et array og viser dem
    Opskrift[] opskriftArray = opskrifter.toArray(new Opskrift[0]);

    // Debugging: Bekræft at vi sender opskrifterne til displayOpskrifter
    //println("Viser " + opskriftArray.length + " opskrifter");

    // Add the "Opskrifter" title text with proper camY offset
    textFont(generalFont);
    textSize(80);
    fill(71, 92, 108);
    textAlign(CENTER);
    text("Opskrifter", width / 7 * 3 + width / 4, height / 3 - camY);

    displayOpskrifter(opskriftArray);
  }
  noStroke();
  fill(247, 239, 210);
  rect(580*width/1440, 150*width/1440, 18*width/1440, 780*width/1440);


  textSize(30*width/1440);
  fill(71, 92, 108);
  textAlign(CORNER, CORNER);
  text("Filtrer - kryds af", 52*width/1440, 370*height/982-camY);
  textSize(25*width/1440);
  text("Kategorier", 52*width/1440, 425*height/982-camY);
  text("Produkttype", 52*width/1440, 690*height/982-camY);
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

  hentOpskrifterFraServer();

  kategoriGroup = new SwitchGroup();
  produktTypeGroup =new SwitchGroup();
  udfraGarnGroup = new SwitchGroup();

  // Laver alle switchesne

  float højde=410*height/982;
  float bredde1=(580*width/1440)/4;
  float bredde2=(580*width/1440)/2;
  float bredde3=(580*width/1440)/4*3;

  Switch KvinderSwitch = new Switch(bredde1, højde+75, 30*width/1440-camY, "Kvinder", false);
  Switch MændSwitch = new Switch(bredde2, højde+75, 30*width/1440-camY, "Mænd", false);
  Switch BabySwitch = new Switch(bredde3, højde+75, 30*width/1440-camY, "Baby (0-4 år)", false);
  Switch BarnSwitch = new Switch(bredde1, 585*height/982-10, 30*width/1440-camY, "Barn (2-14 år)", false);
  Switch HjemSwitch = new Switch(bredde2, 585*height/982-10, 30*width/1440-camY, "Hjem", false);

  //// Tilføjer alle switchesne til en gruppe
  kategoriGroup.addSwitch(KvinderSwitch);
  kategoriGroup.addSwitch(MændSwitch);
  kategoriGroup.addSwitch(BabySwitch);
  kategoriGroup.addSwitch(BarnSwitch);
  kategoriGroup.addSwitch(HjemSwitch);
  // Laver alle switchesne


  Switch jaSwitch = new Switch((580*width/1440)/4, 1110*height/982, 30*width/1440, "Ja", false);

  udfraGarnGroup.addSwitch(jaSwitch);

  // Laver tilbageknappen til søgeskærmen
  søgeSkærmTilbageKnap = new TilbageKnap(height/9-height/15, height/9-height/17, height/15*2, height/17*2, color(0), "tilbage", 10, color(205, 139, 98), color(0, 255, 0), 10, søgeSkærm);
  knapper.add(søgeSkærmTilbageKnap);

  //laver søgefeltknappen til søgeskærmen
  søgeSkærmSøgKnap = new Knap(493*width/1440, height/9*2+height/40-camY, 67*width/1440, 67*height/982, color(71, 92, 108), "Søg", 30, color(247, 239, 210), color(247, 239, 210), 0, søgeSkærm);
  knapper.add(søgeSkærmSøgKnap);

  textfields.add(new Textfield(35*width/1440, height/9*2+height/40, 440*width/1440, 67*height/982, color(71, 92, 108), color(247, 239, 210), color(247, 239, 210), color(247, 239, 210), 30*width/1440, "Søgefelt", "", 0, søgeSkærm, false));

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

  // Tilføjer alle switchesne til en gruppe
  produktTypeGroup.addSwitch(sweaterSwitch);
  produktTypeGroup.addSwitch(cardiganSwitch);
  produktTypeGroup.addSwitch(hueSwitch);
  produktTypeGroup.addSwitch(vanterSwitch);
  produktTypeGroup.addSwitch(vestSwitch);
  produktTypeGroup.addSwitch(topSwitch);
  produktTypeGroup.addSwitch(shortsSwitch);
  produktTypeGroup.addSwitch(strømperSwitch);
  produktTypeGroup.addSwitch(nederdelSwitch);

  //Switch jaSwitch = new Switch(bredde1, 850*height/982, 30*width/1440, "Ja", false);
  udfraGarnGroup.addSwitch(jaSwitch);

  // Laver tilbageknappen til søgeskærmen
  søgeSkærmTilbageKnap = new TilbageKnap(height/9-height/15, height/9-height/17, height/15*2, height/17*2, color(0), "tilbage", 10, color(205, 139, 98), color(247, 239, 210), 10, søgeSkærm);
  knapper.add(søgeSkærmTilbageKnap);
  søgeSkærmSøgKnap = new Knap(493*width/1440, height/9*2+height/40, 67*width/1440, 67*height/982, color(71, 92, 108), "Søg", 30, color(247, 239, 210), color(247, 239, 210), 0, søgeSkærm);
  knapper.add(søgeSkærmSøgKnap);
  textfields.add(new Textfield(35*width/1440, height/9*2+height/40, 440*width/1440, 67*height/982, color(71, 92, 108), color(247, 239, 210), color(247, 239, 210), color(247, 239, 210), 30*width/1440, "Søgefelt", "", 0, søgeSkærm, false));

  hentOpskrifterFraServer();
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


  //gemmer opskrifter hvis man trykker på stjernen
  if (mouseY>height/9*2 && mouseX>580*width/1440 && !opskrifter.isEmpty()) {
    float posY = height/5*2;
    float posX = 653*width/1440;
    float bredde = width/31*16;
    float højde = height/4;
    float spacing = height/32;
    for (Opskrift opskrift : opskrifter) {
      if (mouseX>posX+bredde/31*17 && mouseX<posX+bredde/31*17+bredde/15 && mouseY>posY-camY && mouseY<posY+højde/5-camY) {
        boolean gemt=false;
        int gemtIndex = -1;
        // Check if recipe is already saved
        for (int i = 0; i < gemteOpskrifter.size(); i++) {
          if (opskrift.titel.equals(gemteOpskrifter.get(i).titel)) {
            gemt = true;
            gemtIndex = i;
            break;
          }
        }

        if (gemt) {
          // Remove the recipe if it's already saved
          gemteOpskrifter.remove(gemtIndex);
        } else {
          // Add the recipe if it's not saved
          gemteOpskrifter.add(opskrift);
        }
        saveRecipesToFile();
      }
      posY += spacing + højde;
    }
  }
}


void overskriftBjælke (String tekst) {
  rectMode(CORNER);
  fill(71, 92, 108);
  rect(0, 0, width, height/9*2);
  fill(247, 239, 210);
  textFont(generalFont);
  textAlign(CENTER, CENTER);
  textSize(100*width/1920);
  text(tekst, width/2, height/9);
}

void hentOpskrifterFraServer() {
  opskrifter.clear();  // Tømmer eksisterende opskrifter, før vi henter nye

  GetRequest get = new GetRequest("http://server-kopi.onrender.com/opskrifter");
  get.send();

  String json = get.getContent();



  if (json != null && json.length() > 0) {
    JSONArray jsonOpskrifter = parseJSONArray(json);

    for (int i = 0; i < jsonOpskrifter.size(); i++) {
      JSONObject jsonOpskrift = jsonOpskrifter.getJSONObject(i);

      String titel = jsonOpskrift.getString("titel");
      String produktType = jsonOpskrift.getString("produkttype");
      String sværhedsgrad = jsonOpskrift.getString("sværhedsgrad");
      JSONArray garnArray = jsonOpskrift.getJSONArray("garn");

      Opskrift nyOpskrift = new Opskrift(titel, "", sværhedsgrad, produktType, null);

      // Tilføj hver garntype enkeltvis
      for (int j = 0; j < garnArray.size(); j++) {
        String garnType = garnArray.getString(j);
        nyOpskrift.tilfoejGarntype(garnType);
      }


      opskrifter.add(nyOpskrift);  // Tilføj til opskrifter listen
    }
  }
}
