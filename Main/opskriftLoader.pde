//Liste med opskrifter
ArrayList<Opskrift> opskrifter = new ArrayList<Opskrift>();

//Funktion til at loade opskrifter ud af JSON fil
void loadOpskrifter(String jsonFilePath) {
  //Sletter de nuværende opskrifter for at de ikke loades flere gange
  opskrifter.clear();

  // load JSON filen
  JSONArray jsonOpskrifter = loadJSONArray(jsonFilePath);

  // går igennem hver af opskrifterne i JSON filen
  for (int i = 0; i < jsonOpskrifter.size(); i++) {
    JSONObject jsonOpskrift = jsonOpskrifter.getJSONObject(i);

    // gem værdierne i JSON filen
    String titel = jsonOpskrift.getString("titel");
    String link = jsonOpskrift.getString("link");
    String sværhedsgrad = jsonOpskrift.getString("svaerhedsgrad");
    String produktType = jsonOpskrift.getString("produktType");

    // load billedet
    PImage billede = null;
    if (jsonOpskrift.hasKey("billedePath")) {
      String billedePath = jsonOpskrift.getString("billedePath");
      billede = loadImage(billedePath);
      // hvis billedet ikke loades bruges et andet et
      if (billede == null) {
        println("Kunne ikke loade billede for: " + titel);
        billede = createImage(100, 100, RGB); // det andet billede
      }
    }

    // Laver opskrift objectet
    Opskrift nyOpskrift = new Opskrift(titel, link, sværhedsgrad, produktType, billede);

    // tilføj de krævne garn
    if (jsonOpskrift.hasKey("kraevneGarn")) {
      JSONArray garnTyper = jsonOpskrift.getJSONArray("kraevneGarn");
      for (int j = 0; j < garnTyper.size(); j++) {
        String garnType = garnTyper.getString(j);
        nyOpskrift.tilfoejGarntype(garnType);
      }
    }

    // tilføjer de fundne opskrifter til listen
    opskrifter.add(nyOpskrift);
  }

  println("Loaded " + opskrifter.size() + " opskrifter fra " + jsonFilePath);
}

// Funktion til at gemme opskrifter til en JSON fil
void saveOpskrifter(String jsonFilePath) {
  JSONArray jsonOpskrifter = new JSONArray();

  for (int i = 0; i < opskrifter.size(); i++) {
    Opskrift opskrift = opskrifter.get(i);
    JSONObject jsonOpskrift = new JSONObject();

    // Gemmer de basale egenskaber af opskrifterne
    jsonOpskrift.setString("titel", opskrift.titel);
    jsonOpskrift.setString("link", opskrift.link);
    jsonOpskrift.setString("svaerhedsgrad", opskrift.sværhedsgrad);
    jsonOpskrift.setString("produktType", opskrift.produktType);

    // Gemmer garntyper
    JSONArray garnTyper = new JSONArray();
    for (int j = 0; j < opskrift.krævneGarn.size(); j++) {
      garnTyper.setString(j, opskrift.krævneGarn.get(j));
    }
    jsonOpskrift.setJSONArray("kraevneGarn", garnTyper);

    // tilføjer opskriften til en JSON fil
    jsonOpskrifter.setJSONObject(i, jsonOpskrift);
  }

  // Gemmer JSON filen
  saveJSONArray(jsonOpskrifter, jsonFilePath);
  println("Saved " + opskrifter.size() + " opskrifter to " + jsonFilePath);
}

//
void displayOpskrifter(Opskrift opskrifter[]) {
  //Værdier der bestemmer position og størrelse af viste opskrifter
  float posY=height/5*2;
  float posX=width/7*3;
  float bredde=width/2;
  float højde=height/4;
  float spacing=height/32;
  strokeCap(SQUARE);

  //Går igennem de opskrifter der er i arrayet som funktionen modtager
  for (Opskrift opskrift : opskrifter) {
    noStroke();
    rectMode(CORNER);
    //tegner selve kassen
    fill(247, 239, 210);
    rect(posX, posY-camY, bredde, højde);
    //skriver titlen
    fill(0);
    textFont(boldFont);
    textAlign(CORNER);
    textSize(30);
    text(opskrift.titel, posX+width/100, posY-camY+width/50);
    //skriver sværhedsgraden
    textFont(generalFont);
    textSize(20);
    text("Sværhedsgrad: " + opskrift.sværhedsgrad, posX+width/100, posY-camY+højde/4+width/50);
    //Skriver produkttypen
    text("produkttype: "+opskrift.produktType, posX+width/100, posY-camY+højde/4*2+width/50);
    //skriver garntyperne og tilføjer tegn imellem hvis der er flere
    String garnInfo = "Garntyper: ";
    for (int i = 0; i < opskrift.krævneGarn.size(); i++) {
      garnInfo += opskrift.krævneGarn.get(i);
      if (i < opskrift.krævneGarn.size() - 2) {
        garnInfo += ", ";
      } else if (i < opskrift.krævneGarn.size() - 1) {
        garnInfo += " og ";
      }
    }
    text(garnInfo, posX+width/100, posY-camY+højde/4*3+width/50);
//Viser billedet 
 if (opskrift.billede == null) {
    fill(200);
    rect(posX+bredde/24*17, posY-camY+højde/10, bredde/24*5, højde/10*8);
    fill(0);
    textAlign(CENTER, CENTER);
    text("No Image", posX+bredde/24*17+bredde/48*5, posY+højde/10+højde/10*4);
  } else {
    image(opskrift.billede, posX+bredde/24*17, posY-camY+højde/10, bredde/24*5, højde/10*8);
  }

    stroke(71, 92, 108);
    strokeWeight(10);
    line(posX+bredde/24*15, posY-camY-1, posX+bredde/24*15, posY-camY+højde);

    posY+=spacing+højde;
  }
}
