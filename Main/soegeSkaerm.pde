import http.requests.*;

void søgeSkærm() {
  background(255);
  overskriftBjælke("Søg efter opskrifter");

  // Tjek om opskrifter er tomt

  if (!opskrifter.isEmpty()) {
    // Converterer opskrifter til et normalt array i stedet for en arraylist
    Opskrift[] opskriftArray = opskrifter.toArray(new Opskrift[0]);

    displayOpskrifter(opskriftArray);


    // Debugging: Bekræft at vi sender opskrifterne til displayOpskrifter
    println("Viser " + opskriftArray.length + " opskrifter");


    displayOpskrifter(opskriftArray);  // Brug den eksisterende displayOpskrifter metode


    textFont(generalFont);
    textSize(80);
    fill(71, 92, 108);
    textAlign(CENTER);

    text("Opskrifter", width / 7 * 3 + width / 4, height / 3);
  }
}

Knap søgeSkærmTilbageKnap;

void søgeSkærmSetup() {
  hentOpskrifterFraServer();
  //laver knapperne
  søgeSkærmTilbageKnap = new TilbageKnap(width/8, height/16, width/16, height/16, color(0), "tilbage", 10, color(255, 0, 0), color(0, 255, 0), 10, søgeSkærm);
  knapper.add(søgeSkærmTilbageKnap);
}

void søgeSkærmKnapper() {
  if (søgeSkærmTilbageKnap.mouseOver()) {
    skærm=startSkærm;
  }
}

void overskriftBjælke(String tekst) {
  rectMode(CORNER);
  fill(71, 92, 108);
  rect(0, 0-camY, width, height/9*2);
  fill(247, 239, 210);
  textFont(generalFont);
  textAlign(CENTER, CENTER);
  textSize(100);
  text(tekst, width/2, height/9-camY);
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
