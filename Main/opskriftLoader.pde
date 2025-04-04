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
void displayOpskrifter(int startY) {
  int y = startY;
  int spacing = 120;
  
  for (Opskrift opskrift : opskrifter) {
    fill(255);
    rect(width/2 - 200, y - camY, 400, 100, 10);
    
    fill(0);
    textAlign(CENTER, CENTER);
    textSize(16);
    text(opskrift.titel, width/2, y - camY + 20);
    
    textSize(12);
    text("Sværhedsgrad: " + opskrift.sværhedsgrad, width/2, y - camY + 45);
    
    textSize(10);
    String garnInfo = "Garntyper: ";
    for (int i = 0; i < opskrift.krævneGarn.size(); i++) {
      garnInfo += opskrift.krævneGarn.get(i);
      if (i < opskrift.krævneGarn.size() - 1) {
        garnInfo += ", ";
      }
    }
    text(garnInfo, width/2, y - camY + 70);
    
    y += spacing;
  }
}
