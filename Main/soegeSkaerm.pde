import http.requests.*;

// Definer sammenhænge mellem kategori og produkttyper
HashMap<String, ArrayList<String>> kategoriTilProdukter = new HashMap<String, ArrayList<String>>();

// Declare the back button for the search screen
Knap søgeSkærmTilbageKnap;
Knap søgeSkærmSøgKnap;

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
  text("Produkttype", 45*width/1440, 690*height/982-camY);
  text("Søg udfra mit garn", 52*width/1440, 1125*height/982-camY);

  kategoriGroup.tegnAlle();
  produktTypeGroup.tegnAlle();
  udfraGarnGroup.tegnAlle();

  overskriftBjælke("Søg efter opskrifter");
}

SwitchGroup kategoriGroup;
SwitchGroup produktTypeGroup;
SwitchGroup udfraGarnGroup;

void søgeSkærmSetup() {
  
    // Initialiser kategori til produkttype mapping
  initialiserKategoriProdukter();
  
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
  Switch jaSwitch = new Switch((580*width/1440)/4, 1170*height/982, 30*width/1440, "Ja", false);
  udfraGarnGroup.addSwitch(jaSwitch);

  // Laver tilbageknappen til søgeskærmen
  søgeSkærmTilbageKnap = new TilbageKnap(height/9-height/15, height/9-height/17, height/15*2, height/17*2, color(0), "tilbage", 10, color(205, 139, 98), color(0, 255, 0), 10, søgeSkærm);
  knapper.add(søgeSkærmTilbageKnap);

  //laver søgefeltknappen til søgeskærmen
  søgeSkærmSøgKnap = new Knap(493*width/1440, height/9*2+height/40-camY, 67*width/1440, 67*height/982, color(71, 92, 108), "Søg", 30, color(247, 239, 210), color(247, 239, 210), 0, søgeSkærm);
  knapper.add(søgeSkærmSøgKnap);
  textfields.add(new Textfield(35*width/1440, height/9*2+height/40, 440*width/1440, 67*height/982, color(71, 92, 108), color(247, 239, 210), color(247, 239, 210), color(247, 239, 210), 30*width/1440, "Søgefelt", "", 0, søgeSkærm, false));

  // Laver tilbageknappen til søgeskærmen
  søgeSkærmTilbageKnap = new TilbageKnap(height/9-height/15, height/9-height/17, height/15*2, height/17*2, color(0), "tilbage", 10, color(205, 139, 98), color(247, 239, 210), 10, søgeSkærm);
  knapper.add(søgeSkærmTilbageKnap);
  søgeSkærmSøgKnap = new Knap(493*width/1440, height/9*2+height/40, 67*width/1440, 67*height/982, color(71, 92, 108), "Søg", 30, color(247, 239, 210), color(247, 239, 210), 0, søgeSkærm);
  knapper.add(søgeSkærmSøgKnap);
  textfields.add(new Textfield(35*width/1440, height/9*2+height/40, 440*width/1440, 67*height/982, color(71, 92, 108), color(247, 239, 210), color(247, 239, 210), color(247, 239, 210), 30*width/1440, "Søgefelt", "", 0, søgeSkærm, false));


}

// Funktion til at initialisere kategori-produkttype sammenhængen
void initialiserKategoriProdukter() {
  // Opretter ArrayLists for hver kategori
  kategoriTilProdukter.put("Kvinde", new ArrayList<String>());
  kategoriTilProdukter.put("Mand", new ArrayList<String>());
  kategoriTilProdukter.put("Baby (0-4 år)", new ArrayList<String>());
  kategoriTilProdukter.put("Børn (2-14 år)", new ArrayList<String>());
  kategoriTilProdukter.put("Hjem", new ArrayList<String>());
  
  // Tilføj produkttyper til Kvinde
  kategoriTilProdukter.get("Kvinde").add("Sweater");
  kategoriTilProdukter.get("Kvinde").add("Cardigans");
  kategoriTilProdukter.get("Kvinde").add("Huer");
  kategoriTilProdukter.get("Kvinde").add("Veste & Toppe");
  kategoriTilProdukter.get("Kvinde").add("Veste");
  kategoriTilProdukter.get("Kvinde").add("Toppe");
  kategoriTilProdukter.get("Kvinde").add("Strømper");
  kategoriTilProdukter.get("Kvinde").add("Kjoler og Tunikaer");
  kategoriTilProdukter.get("Kvinde").add("Shawls");
  
  // Tilføj produkttyper til Mand
  kategoriTilProdukter.get("Mand").add("Sweater");
  kategoriTilProdukter.get("Mand").add("Cardigans");
  kategoriTilProdukter.get("Mand").add("Huer");
  kategoriTilProdukter.get("Mand").add("Veste");
  kategoriTilProdukter.get("Mand").add("Strømper");
  
  // Tilføj produkttyper til Baby
  kategoriTilProdukter.get("Baby (0-4 år)").add("Sweater");
  kategoriTilProdukter.get("Baby (0-4 år)").add("Cardigans");
  kategoriTilProdukter.get("Baby (0-4 år)").add("Huer");
  kategoriTilProdukter.get("Baby (0-4 år)").add("Babytæpper");
  kategoriTilProdukter.get("Baby (0-4 år)").add("Strømper");
  
  // Tilføj produkttyper til Børn
  kategoriTilProdukter.get("Børn (2-14 år)").add("Sweater");
  kategoriTilProdukter.get("Børn (2-14 år)").add("Cardigans");
  kategoriTilProdukter.get("Børn (2-14 år)").add("Huer");
  kategoriTilProdukter.get("Børn (2-14 år)").add("Strømper");
  
  // Tilføj produkttyper til Hjem
  kategoriTilProdukter.get("Hjem").add("Børneværelse");
  kategoriTilProdukter.get("Hjem").add("Påske");
}

void opdaterProdukttypeVisning() {
  String valgtKategori = kategoriGroup.getSelectedTitle();
  
  // Ryd den eksisterende produkttype gruppe
  produktTypeGroup.clear();
  
  // Hvis ingen kategori er valgt, vis ingen produkttyper
  if (valgtKategori.equals("")) {
    return;
  }
  
  // Hent listen af produkttyper der er relevante for den valgte kategori
  ArrayList<String> relevanteProdukter = kategoriTilProdukter.get(valgtKategori);
  if (relevanteProdukter == null) {
    return; // Sikkerhedscheck
  }
  
  // Genopret alle switches, men tilføj kun de relevante til gruppen
  float højde=750*height/982-camY;
  float bredde1=(580*width/1440)/4;
  float bredde2=(580*width/1440)/2;
  float bredde3=(580*width/1440)/4*3;
  
  // Første række
  if (relevanteProdukter.contains("Sweater")) {
    produktTypeGroup.addSwitch(new Switch(bredde1, højde, 30*width/1440, "Sweater", false));
  }
  if (relevanteProdukter.contains("Cardigans")) {
    produktTypeGroup.addSwitch(new Switch(bredde2, højde, 30*width/1440, "Cardigans", false));
  }
  if (relevanteProdukter.contains("Huer")) {
    produktTypeGroup.addSwitch(new Switch(bredde3, højde, 30*width/1440, "Huer", false));
  }
  
  // Anden række
  højde=840*height/982-camY;
  if (relevanteProdukter.contains("Veste & Toppe")) {
    produktTypeGroup.addSwitch(new Switch(bredde1, højde, 30*width/1440, "Veste & Toppe", false));
  }
  if (relevanteProdukter.contains("Veste")) {
    produktTypeGroup.addSwitch(new Switch(bredde2, højde, 30*width/1440, "Veste", false));
  }
  if (relevanteProdukter.contains("Toppe")) {
    produktTypeGroup.addSwitch(new Switch(bredde3, højde, 30*width/1440, "Toppe", false));
  }
  
  // Tredje række
  højde=930*height/982-camY;
  if (relevanteProdukter.contains("Babytæpper")) {
    produktTypeGroup.addSwitch(new Switch(bredde1, højde, 30*width/1440, "Babytæpper", false));
  }
  if (relevanteProdukter.contains("Strømper")) {
    produktTypeGroup.addSwitch(new Switch(bredde2, højde, 30*width/1440, "Strømper", false));
  }
  if (relevanteProdukter.contains("Børneværelse")) {
    produktTypeGroup.addSwitch(new Switch(bredde3, højde, 30*width/1440, "Børneværelse", false));
  }
  
  // Fjerde række
  højde=1020*height/982-camY;
  if (relevanteProdukter.contains("Kjoler og Tunikaer")) {
    produktTypeGroup.addSwitch(new Switch(bredde1, højde, 30*width/1440, "Kjoler og Tunikaer", false));
  }
  if (relevanteProdukter.contains("Shawls")) {
    produktTypeGroup.addSwitch(new Switch(bredde2, højde, 30*width/1440, "Shawls", false));
  }
  if (relevanteProdukter.contains("Påske")) {
    produktTypeGroup.addSwitch(new Switch(bredde3, højde, 30*width/1440, "Påske", false));
  }
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
