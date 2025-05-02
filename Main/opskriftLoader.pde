
// Liste med opskrifter
ArrayList<Opskrift> opskrifter = new ArrayList<Opskrift>();

// Funktion til at hente opskrifter fra serveren (nu med parameter for at vælge kilde)
void hentOpskrifterFraServer(String kilde) {

  opskrifter.clear();  // Tømmer eksisterende opskrifter, før vi henter nye

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
      String link = jsonOpskrift.getString("url"); // ændret fra "link"
      String sværhedsgrad = jsonOpskrift.getString("sværhedsgrad"); // korrekt stavet
      String produktType = jsonOpskrift.getString("produkttype"); // korrekt stavet

      // Load billede

      String imagePath = null;
      if (jsonOpskrift.hasKey("image")) {
        imagePath = jsonOpskrift.getString("image");
      }

      Opskrift nyOpskrift = new Opskrift(titel, link, sværhedsgrad, produktType, null);
      nyOpskrift.imageUrl = imagePath;
      nyOpskrift.billedeHentes = true;
      opskrifter.add(nyOpskrift);

      // Tilføj garn
      if (jsonOpskrift.hasKey("garn")) {
        JSONArray garnTyper = jsonOpskrift.getJSONArray("garn");


        for (int j = 0; j < garnTyper.size(); j++) {
          String garnType = garnTyper.getString(j);
          nyOpskrift.tilfoejGarntype(garnType);
        }
      }
    }

    // Debugging: Bekræft hvor mange opskrifter der er blevet tilføjet
    println("✅ Hentede " + opskrifter.size() + " opskrifter fra serveren");
  } else {
    println("⚠️ Fejl: Kunne ikke hente opskrifter fra serveren");
  }

  // Debugging: Tjek indholdet af opskrifter listen
  println("Opskrifter listen indeholder " + opskrifter.size() + " opskrifter.");

  thread("hentBillederThread");
}

void hentBilledeTilOpskrift(Opskrift opskrift, String imageUrl) {
  opskrift.imageUrl = imageUrl; // gem url i objektet
  opskrift.billedeHentes = true;
  thread("hentBilledeThread");
}

void hentBillederThread() {
  for (Opskrift o : opskrifter) {
    if (o.billedeHentes && o.imageUrl != null && o.billede == null) {
      println("🔄 Henter billede for: " + o.titel);
      PImage img = loadImage(o.imageUrl);
      if (img != null) {
        o.billede = img;
        println("📷 Hentet billede for: " + o.titel);
      } else {
        println("⚠️ Kunne ikke hente billede for: " + o.titel);
      }
      o.billedeHentes = false;
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
