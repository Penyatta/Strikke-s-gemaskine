

void opretSkærm(){
  background(255);
  overskriftBjælke("Tilføj din egen opskrift");
  
  textSize(30*width/1440);
  fill(71, 92, 108);
  textFont(boldFont);
  textAlign(CORNER,CORNER);
  text("Navn:",50*width/1440,300*height/982);
  text("Sværhedsgrad:",50*width/1440,425*height/982);
  text("Produkttype:",50*width/1440,563*height/982);
  text("Type af garn:",50*width/1440,814*height/982);
   textFont(generalFont);
  
  sværhedsgradsGroup.tegnAlle();
  produktTypeGroup.tegnAlle();
  garnTypeGroup.tegnAlle();
}

SwitchGroup garnTypeGroup;
Knap opretSkærmTilbageKnap;

void opretSkærmSetup(){
  //laver knapperne
  opretSkærmTilbageKnap = new TilbageKnap(height/9-height/15, height/9-height/17, height/15*2, height/17*2, color(0), "tilbage", 10, color(205, 139, 98), color(0, 255, 0), 10, opretSkærm);
  knapper.add(opretSkærmTilbageKnap);
  
  // Tilføj et tekstfelt til opretSkærm

  textfields.add(new Textfield( 50*width/1440+100, 300*height/1125,width/3, 50, color(71, 92, 108), color(247, 239, 210), color(247, 239, 210), color(247, 239, 210),
  30*width/1440, "Indtast opskriftens navn", "", 0, opretSkærm, false));
  
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
