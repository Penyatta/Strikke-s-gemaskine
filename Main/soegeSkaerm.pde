

// Declare the back button for the search screen
Knap søgeSkærmTilbageKnap;
Knap søgeSkærmSøgKnap;

void søgeSkærm() {
  background(255);

  // Tjek om opskrifter er tomt
  if (!opskrifter.isEmpty()) {
    
    // Konverterer opskrifter til et array og viser dem
    Opskrift[] opskriftArray = opskrifter.toArray(new Opskrift[0]);
    
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
  
  textSize(40*width/1440);
  fill(71, 92, 108);
  textAlign(CORNER,CORNER);
  text("Filtrer - kryds af",45*width/1440,370*height/982);
  textSize(30*width/1440);
  text("Produkttype",45*width/1440,420*height/982);
  text("Søg udfra mit garn",45*width/1440,814*height/982);
  
  produktTypeGroup.tegnAlle();
  udfraGarnGroup.tegnAlle();
}

SwitchGroup produktTypeGroup;
SwitchGroup udfraGarnGroup;

void søgeSkærmSetup() {

  hentOpskrifterFraServer("søg");

  produktTypeGroup =new SwitchGroup();
  udfraGarnGroup = new SwitchGroup();

  // Laver alle produkttype switchesne
  Switch sweatersSwitch = new Switch((80*width/1440), 460*height/982, 30*width/1440, "Sweaters", false);
  Switch cardigansSwitch = new Switch((200*width/1440), 460*height/982, 30*width/1440, "Cardigans", false);
  Switch huerSwitch = new Switch((350*width/1440), 460*height/982, 30*width/1440, "Huer", false);
  Switch vanterSwitch = new Switch((500*width/1440), 460*height/982, 30*width/1440, "Vanter", false);
  
  
  Switch vesteSwitch = new Switch((80*width/1440), 560*height/982, 30*width/1440, "Veste", false);
  Switch toppeSwitch = new Switch((200*width/1440), 560*height/982, 30*width/1440, "Toppe", false);
  Switch halstørklæderSwitch = new Switch((350*width/1440), 560*height/982, 30*width/1440, "Halstørklæder", false);
  Switch tæpperSwitch = new Switch((500*width/1440), 560*height/982, 30*width/1440, "Tæpper", false);
  
  Switch karkludeSwitch = new Switch((80*width/1440),660*height/982, 30*width/1440, "Karklude", false);
  Switch kjolerSwitch = new Switch((200*width/1440), 660*height/982, 30*width/1440, "Kjoler", false);
  
  // Tilføjer alle switchesne til en gruppe
  produktTypeGroup.addSwitch(sweatersSwitch);
  produktTypeGroup.addSwitch(cardigansSwitch);
  produktTypeGroup.addSwitch(huerSwitch);
  produktTypeGroup.addSwitch(vanterSwitch);
  produktTypeGroup.addSwitch(vesteSwitch);
  produktTypeGroup.addSwitch(toppeSwitch);
   produktTypeGroup.addSwitch(halstørklæderSwitch);
  produktTypeGroup.addSwitch(tæpperSwitch);
  produktTypeGroup.addSwitch(karkludeSwitch);
  produktTypeGroup.addSwitch(kjolerSwitch);
  
  Switch jaSwitch = new Switch((580*width/1440)/4, 845*height/982, 30*width/1440, "Ja", false);
  udfraGarnGroup.addSwitch(jaSwitch);
  
  // Laver tilbageknappen til søgeskærmen
  søgeSkærmTilbageKnap = new TilbageKnap(height/9-height/15, height/9-height/17, height/15*2, height/17*2, color(0), "tilbage", 10, color(205, 139, 98), color(0, 255, 0), 10, søgeSkærm);
  knapper.add(søgeSkærmTilbageKnap);
  
  //laver søgefeltknappen til søgeskærmen
  søgeSkærmSøgKnap = new Knap(493*width/1440, height/9*2+height/40, 67*width/1440, 67*height/982, color(71, 92, 108), "Søg", 30, color(247, 239, 210), color(247, 239, 210), 0, søgeSkærm);
  knapper.add(søgeSkærmSøgKnap);
  textfields.add(new Textfield(35*width/1440, height/9*2+height/40, 440*width/1440, 67*height/982, color(71, 92, 108), color(247, 239, 210), color(247, 239, 210), color(247, 239, 210), 30*width/1440, "Søgefelt", "", 0, søgeSkærm,false));
  
 
}

void søgeSkærmKnapper() {
  if (søgeSkærmTilbageKnap.mouseOver()) {
    skærm=startSkærm;
    // Reset scroll position when leaving the screen
    camY = 0;
  }

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
