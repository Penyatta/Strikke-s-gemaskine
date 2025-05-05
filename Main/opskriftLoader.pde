
// Indeholder alle opskrifter hentet fra serveren – ændres ikke ved filtrering
ArrayList<Opskrift> alleOpskrifter = new ArrayList<Opskrift>();

// Indeholder de opskrifter der vises på skærmen – opdateres når man filtrerer
ArrayList<Opskrift> visteOpskrifter = new ArrayList<Opskrift>();

// Funktion til at hente opskrifter fra serveren 
void hentOpskrifterFraServer(String kilde) {

  alleOpskrifter.clear();     // Ryd hele listen først
  visteOpskrifter.clear();    // Start med at vise alle opskrifter

  String url = "";

  // Juster URL afhængig af kilden (søgeskærm eller hovedskærm)
  if (kilde.equals("søg")) {

    url = "http://server-kopi.onrender.com/opskrifter";  // Standard URL til hovedskærm
  }

  // Udfør GET anmodning
  GetRequest get = new GetRequest(url);
  get.send();

  String json = get.getContent();

  if (json != null && json.length() > 0) {
    JSONArray jsonOpskrifter = parseJSONArray(json);

    for (int i = 0; i < jsonOpskrifter.size(); i++) {
      JSONObject jsonOpskrift = jsonOpskrifter.getJSONObject(i);

      String titel = jsonOpskrift.getString("titel");
      String kategori = jsonOpskrift.getString("kategori");
      String link = jsonOpskrift.getString("url"); // ændret fra "link"

      String produktType = jsonOpskrift.getString("produkttype");

      // Load billede
      String imagePath = null;
      if (jsonOpskrift.hasKey("image")) {
        imagePath = jsonOpskrift.getString("image");
      }

      Opskrift nyOpskrift = new Opskrift(titel, kategori, link, produktType, null);
      nyOpskrift.imageUrl = imagePath;
      nyOpskrift.billedeHentes = true;

      // Tilføj garn
      if (jsonOpskrift.hasKey("garn")) {
        JSONArray garnTyper = jsonOpskrift.getJSONArray("garn"); // ikke "kraevneGarn"

        for (int j = 0; j < garnTyper.size(); j++) {
          String garnType = garnTyper.getString(j);
          nyOpskrift.tilfoejGarntype(garnType);
        }
      }

        // Tilføj opskriften til begge lister
    alleOpskrifter.add(nyOpskrift);
    visteOpskrifter.add(nyOpskrift);
    }

    // Debugging: Bekræft hvor mange opskrifter der er blevet tilføjet
    println("✅ Hentede " + alleOpskrifter.size() + " opskrifter fra serveren");
  } else {
    println("⚠️ Fejl: Kunne ikke hente opskrifter fra serveren");
  }

  thread("hentBillederThread");

  // Beregn max scroll baseret på antal opskrifter og layout
  float antal = alleOpskrifter.size();
  float højde = height / 4;
  float spacing = height / 32;
  maxScroll = (højde + spacing) * antal - (height - height / 5 * 2);

  // Sørg for det ikke bliver negativt
  if (maxScroll < 0) {
    maxScroll = 0;
  }
  
}

void hentBillederThread() {
  for (Opskrift o : alleOpskrifter) {
    if (o.billedeHentes && o.imageUrl != null && o.billede == null) {

      PImage img = loadImage(o.imageUrl);
      if (img != null) {
        o.billede = img;

        o.billedeHentes = false;
      }
    }
  }
}

void displayOpskrifter(Opskrift opskrifter[]) {
  //Værdier der bestemmer position og størrelse af viste opskrifter
  float posY = height/5*2;
  float posX = 653*width/1440;
  float bredde = width/31*16;
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
      skyggeImplement(posX, posY-camY+højde-1, bredde, true);

      //skriver titlen
      fill(0);
      textFont(boldFont);
      textAlign(CORNER);
      textSize(30);
      text(opskrift.titel, posX + width/100, posY - camY + width/50);

      //skriver kategorien
      textFont(generalFont);
      textSize(20);
      text("Kategori: " + opskrift.kategori, posX + width/100, posY - camY + højde/4 + width/50);

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
