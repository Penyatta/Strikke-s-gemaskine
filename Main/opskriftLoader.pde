// Liste med opskrifter
ArrayList<Opskrift> opskrifter = new ArrayList<Opskrift>();

// Funktion til at hente opskrifter fra serveren (nu med parameter for at vælge kilde)
void hentOpskrifterFraServer(String kilde) {
  opskrifter.clear();  // Tømmer eksisterende opskrifter, før vi henter nye

  String url = "";

  // Juster URL afhængig af kilden (søgeskærm eller hovedskærm)
  if (kilde.equals("søg")) {
    url = "http://localhost:3000/searchOpskrifter";  // URL til søgning
  } else {
    url = "http://10.194.169.47:3000/opskrifter";  // Standard URL til hovedskærm
  }

  // Udfør GET anmodning
  GetRequest get = new GetRequest(url);
  get.send();

  String json = get.getContent();

  // Debugging: Udskriv serverens svar (JSON-data)
  println("Server svar: " + json);

  if (json != null && json.length() > 0) {
    JSONArray jsonOpskrifter = parseJSONArray(json);

    // Debugging: Tjek om vi modtager data fra serveren
    println("Modtaget JSON data fra serveren: " + jsonOpskrifter.size() + " opskrifter");

    for (int i = 0; i < jsonOpskrifter.size(); i++) {
      JSONObject jsonOpskrift = jsonOpskrifter.getJSONObject(i);

      String titel = jsonOpskrift.getString("titel");
      String link = jsonOpskrift.getString("link");
      String sværhedsgrad = jsonOpskrift.getString("svaerhedsgrad");
      String produktType = jsonOpskrift.getString("produktType");

      // Load billede
      PImage billede = null;
      if (jsonOpskrift.hasKey("billedePath")) {
        String billedePath = jsonOpskrift.getString("billedePath");
        billede = loadImage(billedePath);
        // Hvis billedet ikke kan loades, bruges et standardbillede
        if (billede == null) {
          println("Kunne ikke loade billede for: " + titel);
          billede = createImage(100, 100, RGB); // Anvender et standardbillede
        }
      }

      // Laver opskrift objektet
      Opskrift nyOpskrift = new Opskrift(titel, link, sværhedsgrad, produktType, billede);

      // Tilføj garn
      if (jsonOpskrift.hasKey("kraevneGarn")) {
        JSONArray garnTyper = jsonOpskrift.getJSONArray("kraevneGarn");
        for (int j = 0; j < garnTyper.size(); j++) {
          String garnType = garnTyper.getString(j);
          nyOpskrift.tilfoejGarntype(garnType);
        }
      }

      // Tilføjer opskriften til opskriftslisten
      opskrifter.add(nyOpskrift);

      // Debugging: Udskriv opskriften vi tilføjer
      println("Tilføjer opskrift: " + titel);
    }

    // Debugging: Bekræft hvor mange opskrifter der er blevet tilføjet
    println("✅ Hentede " + opskrifter.size() + " opskrifter fra serveren");
  } else {
    println("⚠️ Fejl: Kunne ikke hente opskrifter fra serveren");
  }

  // Debugging: Tjek indholdet af opskrifter listen
  println("Opskrifter listen indeholder " + opskrifter.size() + " opskrifter.");
}

// Replace your existing displayOpskrifter function with this version
void displayOpskrifter(Opskrift opskrifter[]) {
  //Værdier der bestemmer position og størrelse af viste opskrifter
  float posY = height/5*2;
  float posX = width/7*3;
  float bredde = width/2;
  float højde = height/4;
  float spacing = height/32;
  strokeCap(SQUARE);

  //Går igennem de opskrifter der er i arrayet som funktionen modtager
  for (Opskrift opskrift : opskrifter) {
    // Only draw recipes that would be visible on screen (optimization)
    if (posY - camY < height + højde && posY - camY + højde > 0) {
      noStroke();
      rectMode(CORNER);
      //tegner selve kassen
      fill(247, 239, 210);
      rect(posX, posY - camY, bredde, højde);
      
      //skriver titlen
      fill(0);
      textFont(boldFont);
      textAlign(CORNER);
      textSize(30);
      text(opskrift.titel, posX + width/100, posY - camY + width/50);
      
      //skriver sværhedsgraden
      textFont(generalFont);
      textSize(20);
      text("Sværhedsgrad: " + opskrift.sværhedsgrad, posX + width/100, posY - camY + højde/4 + width/50);
      
      //Skriver produkttypen
      text("produkttype: " + opskrift.produktType, posX + width/100, posY - camY + højde/4*2 + width/50);
      
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
      text(garnInfo, posX + width/100, posY - camY + højde/4*3 + width/50);
      
      //Viser billedet 
      if (opskrift.billede == null) {
        fill(200);
        rect(posX + bredde/24*17, posY - camY + højde/10, bredde/24*5, højde/10*8);
        fill(0);
        textAlign(CENTER, CENTER);
        text("No Image", posX + bredde/24*17 + bredde/48*5, posY - camY + højde/10 + højde/10*4); // Added camY offset here
      } else {
        image(opskrift.billede, posX + bredde/24*17, posY - camY + højde/10, bredde/24*5, højde/10*8);
      }

      stroke(71, 92, 108);
      strokeWeight(10);
      line(posX + bredde/24*15, posY - camY - 1, posX + bredde/24*15, posY - camY + højde);
    }
    
    posY += spacing + højde;
  }
}
