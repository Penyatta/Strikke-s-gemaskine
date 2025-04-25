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
  rect(580*width/1440,150*width/1440,18*width/1440,780*width/1440);

  overskriftBjælke("Søg efter opskrifter");
  
  textSize(30*width/1440);
  fill(71, 92, 108);
  textAlign(CORNER,CORNER);
  text("Sværhedsgrad",105*width/1440,425*height/982);
  text("Produkttype",105*width/1440,563*height/982);
  text("Søg udfra mit garn",105*width/1440,814*height/982);
  
  sværhedsgradsGroup.tegnAlle();
  produktTypeGroup.tegnAlle();
  udfraGarnGroup.tegnAlle();
}

SwitchGroup sværhedsgradsGroup;
SwitchGroup produktTypeGroup;
SwitchGroup udfraGarnGroup;

void søgeSkærmSetup() {
  sværhedsgradsGroup = new SwitchGroup();
  produktTypeGroup =new SwitchGroup();
  udfraGarnGroup = new SwitchGroup();
  
  // Laver alle switchesne
  Switch begynderSwitch = new Switch((580*width/1440)/4, 456*height/982, 30*width/1440, "Let", false);
  Switch øvetSwitch = new Switch((580*width/1440)/2, 456*height/982, 30*width/1440, "Mellem", false);
  Switch ekspertSwitch = new Switch((580*width/1440)/4*3, 456*height/982, 30*width/1440, "Svær", false);
  
  // Tilføjer alle switchesne til en gruppe
  sværhedsgradsGroup.addSwitch(begynderSwitch);
  sværhedsgradsGroup.addSwitch(øvetSwitch);
  sværhedsgradsGroup.addSwitch(ekspertSwitch);
  
  // Laver alle switchesne
  Switch sweaterSwitch = new Switch((580*width/1440)/4, 607*height/982, 30*width/1440, "Sweater", false);
  Switch cardiganSwitch = new Switch((580*width/1440)/2, 607*height/982, 30*width/1440, "Cardigan", false);
  Switch hueSwitch = new Switch((580*width/1440)/4*3, 607*height/982, 30*width/1440, "Hue", false);
  Switch vanterSwitch = new Switch((580*width/1440)/4, 698*height/982, 30*width/1440, "Vanter", false);
  Switch vestSwitch = new Switch((580*width/1440)/2, 698*height/982, 30*width/1440, "Vest", false);
  Switch topSwitch = new Switch((580*width/1440)/4*3, 698*height/982, 30*width/1440, "Top", false);
  
  // Tilføjer alle switchesne til en gruppe
  produktTypeGroup.addSwitch(sweaterSwitch);
  produktTypeGroup.addSwitch(cardiganSwitch);
  produktTypeGroup.addSwitch(hueSwitch);
  produktTypeGroup.addSwitch(vanterSwitch);
  produktTypeGroup.addSwitch(vestSwitch);
  produktTypeGroup.addSwitch(topSwitch);
  
  Switch jaSwitch = new Switch((580*width/1440)/4, 845*height/982, 30*width/1440, "Ja", false);
  udfraGarnGroup.addSwitch(jaSwitch);
  
  // Laver tilbageknappen til søgeskærmen
  søgeSkærmTilbageKnap = new TilbageKnap(height/9-height/15, height/9-height/17, height/15*2, height/17*2, color(0), "tilbage", 10, color(205, 139, 98), color(0, 255, 0), 10, søgeSkærm);
  knapper.add(søgeSkærmTilbageKnap);
  søgeSkærmSøgKnap = new Knap(493*width/1440, height/9*2+height/40, 67*width/1440, 67*height/982, color(71, 92, 108), "Søg", 30, color(247, 239, 210), color(247, 239, 210), 0, søgeSkærm);
  knapper.add(søgeSkærmSøgKnap);
  textfields.add(new Textfield(35*width/1440, height/9*2+height/40, 440*width/1440, 67*height/982, color(71, 92, 108), color(247, 239, 210), color(247, 239, 210), color(247, 239, 210), 30*width/1440, "Søgefelt", "", 0, søgeSkærm,false));
  // Load recipes from server if using server functionality
  // You can comment this out if you're not using the server feature
  //hentOpskrifterFraServer();
}

void søgeSkærmKnapper() {
  if (søgeSkærmTilbageKnap.mouseOver()) {
    skærm=startSkærm;
    // Reset scroll position when leaving the screen
    camY = 0;
  }
  sværhedsgradsGroup.checkMouse();
  produktTypeGroup.checkMouse();
  udfraGarnGroup.checkMouse();
}

void overskriftBjælke(String tekst) {
  rectMode(CORNER);
  fill(71, 92, 108);
  rect(0, 0, width, height/9*2); // Note: removed camY offset for header - headers typically stay fixed
  fill(247, 239, 210);
  textFont(generalFont);
  textAlign(CENTER, CENTER);
  textSize(100*width/1920);
  text(tekst, width/2, height/9);
}

void hentOpskrifterFraServer() {
  opskrifter.clear();  // Tømmer eksisterende opskrifter, før vi henter nye

  GetRequest get = new GetRequest("http://10.194.169.47:3000/opskrifter");
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
