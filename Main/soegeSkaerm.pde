
import http.requests.*;

// Declare the back button for the search screen
Knap søgeSkærmTilbageKnap;

void søgeSkærm() {
  background(255);
 

  // Tjek om opskrifter er tomt
  if (!opskrifter.isEmpty()) {
    
    // Konverterer opskrifter til et array og viser dem
    Opskrift[] opskriftArray = opskrifter.toArray(new Opskrift[0]);
    
    // Debugging: Bekræft at vi sender opskrifterne til displayOpskrifter
    println("Viser " + opskriftArray.length + " opskrifter");
    
    // Add the "Opskrifter" title text with proper camY offset
    textFont(generalFont);
    textSize(80);
    fill(71, 92, 108);
    textAlign(CENTER);
    text("Opskrifter", width / 7 * 3 + width / 4, height / 3 - camY);
    
    displayOpskrifter(opskriftArray);
    
     overskriftBjælke("Søg efter opskrifter");
  }
}

void søgeSkærmSetup() {
  // Create the back button for search screen
  søgeSkærmTilbageKnap = new TilbageKnap(width/8, height/16, width/16, height/16, color(0), "tilbage", 10, color(255, 0, 0), color(0, 255, 0), 10, søgeSkærm);
  knapper.add(søgeSkærmTilbageKnap);
  
  // Load recipes from server if using server functionality
  // You can comment this out if you're not using the server feature
  hentOpskrifterFraServer();
}

void søgeSkærmKnapper() {
  if (søgeSkærmTilbageKnap.mouseOver()) {
    skærm=startSkærm;
    // Reset scroll position when leaving the screen
    camY = 0;
  }
}

void overskriftBjælke(String tekst) {
  rectMode(CORNER);
  fill(71, 92, 108);
  rect(0, 0, width, height/9*2); // Note: removed camY offset for header - headers typically stay fixed
  fill(247, 239, 210);
  textFont(generalFont);
  textAlign(CENTER, CENTER);
  textSize(100);
  text(tekst, width/2, height/9);
}

void hentOpskrifterFraServer() {
  opskrifter.clear();  // Tømmer eksisterende opskrifter, før vi henter nye

  GetRequest get = new GetRequest("http://localhost:3000/opskrifter");
  get.send();

  String json = get.getContent();

  // Debugging: Udskriv serverens svar (JSON-data)
  println("Server svar: " + json);

  if (json != null && json.length() > 0) {
    JSONArray jsonOpskrifter = parseJSONArray(json);

    // Debugging: Tjek, om vi modtager data fra serveren
    println("Modtaget JSON data fra serveren: " + jsonOpskrifter.size() + " opskrifter");

    for (int i = 0; i < jsonOpskrifter.size(); i++) {
      JSONObject jsonOpskrift = jsonOpskrifter.getJSONObject(i);

      String titel = jsonOpskrift.getString("titel");
      String produktType = jsonOpskrift.getString("produkttype");
      String sværhedsgrad = jsonOpskrift.getString("sværhedsgrad");
      String garn = jsonOpskrift.getString("garn");

      // Opretter opskrift objektet (uden billede)
      Opskrift nyOpskrift = new Opskrift(titel, "", sværhedsgrad, produktType, null);
      nyOpskrift.tilfoejGarntype(garn);  // Tilføjer garn

      opskrifter.add(nyOpskrift);  // Tilføj til opskrifter listen

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
