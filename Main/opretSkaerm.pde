

void opretSkærm(){
  background(255);
  overskriftBjælke("Tilføj din egen opskrift");
  
  textSize(30*width/1440);
  fill(71, 92, 108);
  textFont(boldFont);
  textAlign(CORNER,CORNER);
  text("Navn:",50*width/1440,300*height/982);
  text("Sværhedsgrad:",50*width/1440,425*height/982);
  text("Produkttype:",50*width/1440,550*height/982);
  text("Type af garn:",50*width/1440,814*height/982);
   textFont(generalFont);
  
  noStroke();
  fill(247, 239, 210);
  rect(700*width/1440,200*width/1440,18*width/1440,780*width/1440);
  
  opretSværhedsgradsGroup.tegnAlle();
  opretProduktTypeGroup.tegnAlle();
  garnTypeGroup.tegnAlle();
}

SwitchGroup opretSværhedsgradsGroup;
SwitchGroup opretProduktTypeGroup;
SwitchGroup garnTypeGroup;
Knap opretSkærmTilbageKnap;

void opretSkærmSetup(){
  //laver knapperne
  opretSkærmTilbageKnap = new TilbageKnap(height/9-height/15, height/9-height/17, height/15*2, height/17*2, color(0), "tilbage", 10, color(205, 139, 98), color(0, 255, 0), 10, opretSkærm);
  knapper.add(opretSkærmTilbageKnap);
  
  // Tilføj et tekstfelt til opretSkærm

  textfields.add(new Textfield( 50*width/1440+100, 300*height/1125,width/3, 50, color(71, 92, 108), color(247, 239, 210), color(247, 239, 210), color(247, 239, 210),
  30*width/1440, "Indtast opskriftens navn", "", 0, opretSkærm, false));
  
  opretSværhedsgradsGroup = new SwitchGroup();
  
  // Opret switches med nye positioner
  Switch begynderSwitch = new Switch((620*width/1440)/2, 415*height/982, 30*width/1440, "Let", false);
  Switch øvetSwitch = new Switch((620*width/1440)/4*3, 415*height/982  , 30*width/1440, "Mellem", false);
  Switch ekspertSwitch = new Switch((620*width/1440)/2*2, 415*height/982 , 30*width/1440, "Svær", false);
  
  // Tilføj switches til gruppen
  opretSværhedsgradsGroup.addSwitch(begynderSwitch);
  opretSværhedsgradsGroup.addSwitch(øvetSwitch);
  opretSværhedsgradsGroup.addSwitch(ekspertSwitch);
  
  
  opretProduktTypeGroup = new SwitchGroup();
  
  // Laver alle switchesne
  Switch sweatersSwitch = new Switch((580*width/1440)/4, 607*height/982, 30*width/1440, "Sweaters", false);
  Switch cardigansSwitch = new Switch((580*width/1440)/2, 607*height/982, 30*width/1440, "Cardigans", false);
  Switch huerSwitch = new Switch((580*width/1440)/4*3, 607*height/982, 30*width/1440, "Huer", false);
  Switch vanterSwitch = new Switch((580*width/1440)/4, 698*height/982, 30*width/1440, "Vanter", false);
  Switch vesteSwitch = new Switch((580*width/1440)/2, 698*height/982, 30*width/1440, "Veste", false);
  Switch toppeSwitch = new Switch((580*width/1440)/4*3, 698*height/982, 30*width/1440, "Toppe", false);
  Switch halstørklæderSwitch = new Switch((580*width/1440)/4*3, 607*height/982, 30*width/1440, "Halstørklæder", false);
  Switch tæpperSwitch = new Switch((580*width/1440)/4, 698*height/982, 30*width/1440, "Tæpper", false);
  Switch karkludeSwitch = new Switch((580*width/1440)/2, 698*height/982, 30*width/1440, "Karklude", false);
  Switch kjolerSwitch = new Switch((580*width/1440)/4*3, 698*height/982, 30*width/1440, "Kjoler", false);
  
  
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
  
  garnTypeGroup = new SwitchGroup();
  
  // Laver alle switchesne
  Switch uldSwitch = new Switch((580*width/1440)/4, 845*height/982, 30*width/1440, "Uld", false);
  Switch bomuldSwitch = new Switch((580*width/1440)/2, 845*height/982, 30*width/1440, "Bomuld", false);
  Switch mohairSwitch = new Switch((580*width/1440)/4*3, 845*height/982, 30*width/1440, "Mohair", false);
  Switch alpakaSwitch = new Switch((580*width/1440)/4*4, 845*height/982, 30*width/1440, "Alpaka", false);
  Switch merinouldSwitch = new Switch((580*width/1440)/4, 936*height/982, 30*width/1440, "Merinould", false);
  Switch bambusSwitch = new Switch((580*width/1440)/2, 936*height/982, 30*width/1440, "Bambus", false);
  Switch strømpegarnSwitch = new Switch((580*width/1440)/4*3, 936*height/982, 30*width/1440, "Strømpegarn", false);
  Switch silkegarnSwitch = new Switch((580*width/1440)/4*4, 936*height/982, 30*width/1440, "Silkegarn", false);
  
  // Tilføjer alle switchesne til en gruppe
  garnTypeGroup.addSwitch(uldSwitch);
  garnTypeGroup.addSwitch(bomuldSwitch);
  garnTypeGroup.addSwitch(mohairSwitch);
  garnTypeGroup.addSwitch(alpakaSwitch);
  garnTypeGroup.addSwitch(merinouldSwitch);
  garnTypeGroup.addSwitch(bambusSwitch);
  garnTypeGroup.addSwitch(strømpegarnSwitch);
  garnTypeGroup.addSwitch(silkegarnSwitch);
}

void opretSkærmKnapper(){

  if(opretSkærmTilbageKnap.mouseOver()){
  skærm=startSkærm;
  }
  
   garnTypeGroup.checkMouse();
}
