import http.requests.*;


// Definer sammenhænge mellem kategori og produkttyper
HashMap<String, ArrayList<String>> kategoriTilProdukter = new HashMap<String, ArrayList<String>>();

float HøjdeForGarn=0;

// Opretter tilbage knappen for søg skærmen
Knap søgeSkærmTilbageKnap;
Knap søgeSkærmSøgKnap;
Textfield søgeSkærmSøgeTekstfelt;

SwitchGroup garnFilterGroup;

void søgeSkærm() {
  background(255);

  // Tjek om opskrifter er tomt
  if (!visteOpskrifter.isEmpty()) {

    // Konverterer opskrifter til et array og viser dem
    Opskrift[] visteOpskriftArray = visteOpskrifter.toArray(new Opskrift[0]);

    displayOpskrifter(visteOpskriftArray);
  }
  // Add the "Opskrifter" title text with proper camY offset
  textFont(generalFont);
  textSize(80);
  fill(71, 92, 108);
  textAlign(CENTER);
  text("Opskrifter", width / 7 * 3 + width / 4, height / 3 - camY);

  // den lige bjælke der opdeler skærmen
  rectMode(CORNER);
  noStroke();
  fill(247, 239, 210);
  rect(585*width/1440, 150*height/900, 18*width/1440, 780*height/900);

  textSize(40*width/1440);
  fill(71, 92, 108);
  textAlign(CORNER, CORNER);
  text("Filtrer - kryds af", 45*width/1440, 370*height/982-camY);
  textSize(30*width/1440);
  text("Kategorier", 45*width/1440, 425*height/982-camY);
  if(HøjdeForGarn!=0){
  text("Produkttype", 45*width/1440, 690*height/982-camY);
  text("Søg udfra mit garn", 52*width/1440, HøjdeForGarn-camY);
  } else {
    text("Søg udfra mit garn", 52*width/1440, 690*height/982-camY);
  }

  kategoriGroup.tegnAlle();
  produktTypeGroup.tegnAlle();
  udfraGarnGroup.tegnAlle();

  overskriftBjælke("Søg efter opskrifter");
}

SwitchGroup kategoriGroup;
SwitchGroup produktTypeGroup;
SwitchGroup udfraGarnGroup;

Switch jaSwitch;

void søgeSkærmSetup() {

  // Initialiser kategori til produkttype mapping
  initialiserKategoriProdukter();

  hentOpskrifterFraServer("søg");


  kategoriGroup = new SwitchGroup();
  produktTypeGroup =new SwitchGroup();
  udfraGarnGroup = new SwitchGroup();

  // Laver kategori switchesne
  float højde=475*height/982;
  float bredde1=(580*width/1440)/4-50;
  float bredde2=(580*width/1440)/2-30;
  float bredde3=(580*width/1440)/4*3;
  float radius=30*width/1440;
  Switch KvindeSwitch = new Switch(bredde1, højde, radius, "Kvinde", false);
  Switch BarnSwitch = new Switch(bredde3, højde, radius, "Børn (2-14 år)", false);
  Switch BabySwitch = new Switch(bredde2, højde, radius, "Baby (0-4 år)", false);
  højde+=110*height/982;
  Switch MandSwitch = new Switch(bredde1, højde, radius, "Mand", false);
  Switch HjemSwitch = new Switch(bredde2, højde, radius, "Hjem", false);

  //Tilføjer kategori switchesne til en gruppe
  kategoriGroup.addSwitch(KvindeSwitch);
  kategoriGroup.addSwitch(BarnSwitch);
  kategoriGroup.addSwitch(BabySwitch);
  kategoriGroup.addSwitch(MandSwitch);
  kategoriGroup.addSwitch(HjemSwitch);

  // laver udfra garn switch
  jaSwitch = new Switch(bredde1, 750 * height / 982, radius, "Ja", false);
  udfraGarnGroup.addSwitch(jaSwitch);

  // Laver tilbageknappen til søgeskærmen
  søgeSkærmTilbageKnap = new TilbageKnap(height/9-height/15, height/9-height/17, height/15*2, height/17*2, color(0), "tilbage", 10, color(205, 139, 98), color(0, 255, 0), 10, søgeSkærm);
  knapper.add(søgeSkærmTilbageKnap);

  //laver søgefeltknappen til søgeskærmen
  søgeSkærmSøgKnap = new Knap(493*width/1440, height/9*2+height/40-camY, 67*width/1440, 67*height/982, color(71, 92, 108), "Søg", 30, color(247, 239, 210), color(205, 139, 98), 0, søgeSkærm);
  knapper.add(søgeSkærmSøgKnap);
  
  søgeSkærmSøgeTekstfelt =new Textfield(35*width/1440, height/9*2+height/40, 440*width/1440, 67*height/982, color(71, 92, 108), color(247, 239, 210), color(247, 239, 210), color(247, 239, 210),
  30*width/1440, "Søgefelt", "", 0, søgeSkærm, false);
  textfields.add(søgeSkærmSøgeTekstfelt);

  // Laver tilbageknappen til søgeskærmen
  søgeSkærmTilbageKnap = new TilbageKnap(height/9-height/15, height/9-height/17, height/15*2, height/17*2, color(0), "tilbage", 10, color(205, 139, 98), color(247, 239, 210), 10, søgeSkærm);
  knapper.add(søgeSkærmTilbageKnap);
  
}

void søgEfterTitel() {
  String søgetekst = søgeSkærmSøgeTekstfelt.tekst.trim().toLowerCase();  // Få input og gør småt

  visteOpskrifter.clear();

  for (Opskrift o : alleOpskrifter) {
    if (o.titel.toLowerCase().contains(søgetekst)) {
      visteOpskrifter.add(o);
    }
  }
}

// Funktion til at initialisere kategori-produkttype sammenhængen
void initialiserKategoriProdukter() {
  // Opretter ArrayLists for hver kategori
  kategoriTilProdukter.put("Kvinde", new ArrayList<String>());
  kategoriTilProdukter.put("Børn (2-14 år)", new ArrayList<String>());
  kategoriTilProdukter.put("Baby (0-4 år)", new ArrayList<String>());
  kategoriTilProdukter.put("Mand", new ArrayList<String>());
  kategoriTilProdukter.put("Hjem", new ArrayList<String>());
  kategoriTilProdukter.put("Højtider", new ArrayList<String>());

  // Tilføj produkttyper til Kvinde
  String[] Kvindeprodukttyper = {"Huer", "Sweater", "Nederdele", "Veste", "Ponchoer", "Bukser og shorts", "Toppe", "Bikinier", "Strømper og Futsko", "Andet", "Cardigans", "Kjoler og Tunikaer", "Sjaler", "Tørklæder"};
  lavSwitches3(Kvindeprodukttyper, "Kvinde");


  // Tilføj produkttyper til Mand
  String[] Mandprodukttyper = {"Veste", "Sweater", "Strømper og Futsko", "Andet", "Cardigans"};
  lavSwitches3(Mandprodukttyper, "Mand");

  // Tilføj produkttyper til Baby
  String[] Babyprodukttyper = { "Huer", "Cardigans", "Kjoler og Tunikaer", "Andet", "Køreposer", "Strømper og Støvler", "Sweater", "Babytæpper", "Sparkedragter o.lign", "Hentesæt", "Veste og Toppe", "Ponchoer", "Bukser og shorts"};
  lavSwitches3(Babyprodukttyper, "Baby (0-4 år)");

  // Tilføj produkttyper til Børn
  String[] Børnprodukttyper = {"Huer", "Cardigans", "Bukser og Overalls", "Andet", "Veste og Toppe", "Kjoler og nederdele", "Sweater", "Strømper og Futsko"};
  lavSwitches3(Børnprodukttyper, "Børn (2-14 år)");


  // Tilføj produkttyper til Hjem
  String[] Hjemprodukttyper = {"Jul", "Karklude", "Puder og Puffer", "Påske", "Bogmærker", "Dekorative Blomster", "kurve", "Æggevarmer", "Gryddelapper o.lign.", "Tæpper", "Børneværelse", "Glasunderlag o.lign.", "Betræk", "Siddeunderlag", "Dekorationer", "Kæledyr"};
  lavSwitches3(Hjemprodukttyper, "Hjem");

  // Tilføj produkttyper til Højtider
  String[] Højtiderprodukttyper = {"Påske", "Jul", "Halloween og Karnival", "Andet"};
  lavSwitches3(Højtiderprodukttyper, "Højtider");
}

void opdaterProdukttypeVisning() {
  String valgtKategori = kategoriGroup.getSelectedTitle();
  produktTypeGroup.clear();

  if (valgtKategori.equals("")) {
   HøjdeForGarn=0; 
   jaSwitch.posY=750 * height / 982;
    return;
  }

  ArrayList<String> produkttyper = kategoriTilProdukter.get(valgtKategori);
  if (produkttyper == null || produkttyper.isEmpty()) return;

  // Konverter ArrayList til String[]
  String[] produktArray = produkttyper.toArray(new String[0]);

  // Brug lavSwitches3 til at oprette switches
  float højde=lavSwitches03(produktTypeGroup, produktArray, 750 * height / 982);
  HøjdeForGarn=højde+110*height/982;
  jaSwitch.posY=HøjdeForGarn+50*height/982;
}



void opdaterFiltreretListe() {
  visteOpskrifter.clear();

  // Få navnet på den valgte switch (kategori)
  String valgtKategori = kategoriGroup.getSelectedTitle();

  // Få navnet på den valgte switch (Produkttype)
  String valgtproduktType = produktTypeGroup.getSelectedTitle();
  
  String søgeord = textfields.get(0).tekst.toLowerCase().trim();

  for (Opskrift o : alleOpskrifter) {
    boolean match = true;

    if (!valgtKategori.equals("") && !o.kategori.equals(valgtKategori)) {
      match = false;
    }

    if (!valgtproduktType.equals("") && !o.produktType.equals(valgtproduktType)) {
      match = false;
    }
      
      if (!søgeord.equals("") && !o.titel.toLowerCase().contains(søgeord)) {
      match = false;
    }

    if (udfraGarnGroup.erSwitchAktiv("Ja")) {
      if (!o.krævneGarn.isEmpty()) {
        for (String krævetGarn : o.krævneGarn) {
          boolean fundet = false;
          for (String mit : mitGarn) {
            if (mit.trim().equalsIgnoreCase(krævetGarn.trim())) {
              fundet = true;
              break;
            }
          }
          if (!fundet) {
            match = false;
            break;
          }
        }
      }
    }


    if (match) {
      visteOpskrifter.add(o);
    }
  }
}


// Opdateret version af søgeSkærmKnapper
void søgeSkærmKnapper() {
  if (søgeSkærmTilbageKnap.mouseOver()) {
    skærm=startSkærm;
    // Reset scroll position when leaving the screen
    camY = 0;
  }
  
  if (søgeSkærmSøgKnap.mouseOver()) {
  søgEfterTitel();
}

  // Gem den tidligere valgte kategori før vi checker for museklik
  String forrigeValgtKategori = kategoriGroup.getSelectedTitle();

  kategoriGroup.checkMouse();

  // Hvis kategorien er ændret, opdater produkttyper
  String nuværendeValgtKategori = kategoriGroup.getSelectedTitle();
  if (!forrigeValgtKategori.equals(nuværendeValgtKategori)) {
    opdaterProdukttypeVisning();
  }

  produktTypeGroup.checkMouse();
  udfraGarnGroup.checkMouse();

  //gemmer opskrifter hvis man trykker på stjernen
  if (mouseY>height/9*2 && mouseX>580*width/1440 && !visteOpskrifter.isEmpty()) {
    float posY = height/5*2;
    float posX = 653*width/1440;
    float bredde = width/31*16;
    float højde = height/4;
    float spacing = height/32;
    for (Opskrift opskrift : visteOpskrifter) {
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
