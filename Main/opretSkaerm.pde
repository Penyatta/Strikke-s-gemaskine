void opretSkærm(){
  background(255);
  
  textSize(30*width/1440);
  fill(71, 92, 108);
  textFont(boldFont);
  textAlign(CORNER,CORNER);
  //text("Navn:",50*width/1440,300*height/982-camY);
  text("Vælg kategori",100*width/1440,425*height/982-camY);
  text("Vælg produkttype",100*width/1440,670*height/982-camY);
  //text("Type af garn:",50*width/1440,814*height/982-camY);
   textFont(generalFont);
  
  noStroke();
  fill(247, 239, 210);
  rect(700*width/1440,100*width/1440,18*width/1440,780*width/1440);
  
  opretKategorierGroup.tegnAlle();
  opretProduktTypeGroup.tegnAlle();
  garnTypeGroup.tegnAlle();
}

SwitchGroup opretKategorierGroup;
SwitchGroup opretProduktTypeGroup;
SwitchGroup garnTypeGroup;
Knap opretSkærmTilbageKnap;
Textfield TitelTextfelt;

void opretSkærmSetup(){
  //laver knapperne
  opretSkærmTilbageKnap = new TilbageKnap(height/9-height/15, height/9-height/17, height/15*2, height/17*2, color(0), "tilbage", 10, color(205, 139, 98), color(247, 239, 210), 10, opretSkærm);
  knapper.add(opretSkærmTilbageKnap);

  
  // Tilføj et tekstfelt til opretSkærm

 TitelTextfelt = new Textfield( 100*width/1440, 300*height/1125,width/3, 67*height/982, color(71, 92, 108), color(247, 239, 210), color(247, 239, 210), color(247, 239, 210),
  30*width/1440, "Indtast opskriftens navn", "", 0, opretSkærm, false);
  textfields.add(TitelTextfelt);
  
   float højde=485*height/982;
  float bredde1=(580*width/1440)/4;
  float bredde2=(580*width/1440)/2;
  float bredde3=(580*width/1440)/4*3;
  float bredde4=(580*width/1440)/4*4;
  float size=30*width/1440;
  
  opretKategorierGroup = new SwitchGroup();
  
  // Opret switches med nye positioner
  opretKategorierGroup.addSwitch(new Switch(bredde1, højde, size, "Kvinder", false));
  opretKategorierGroup.addSwitch(new Switch(bredde2, højde, size, "Mænd", false));
  opretKategorierGroup.addSwitch(new Switch(bredde3, højde, size, "Baby (0-4 år)", false));
  opretKategorierGroup.addSwitch(new Switch(bredde4, højde, size, "Barn (2-14 år)", false));
  højde=575*height/982;
  opretKategorierGroup.addSwitch(new Switch(bredde1, højde, size, "Hjem", false));
  
  opretProduktTypeGroup = new SwitchGroup();
  
  højde=750*height/982;


  opretProduktTypeGroup.addSwitch(new Switch(bredde1, højde, size, "Sweater", false));
  opretProduktTypeGroup.addSwitch(new Switch(bredde2, højde, size, "Cardigan", false));
  opretProduktTypeGroup.addSwitch(new Switch(bredde3, højde, size, "Hue", false));
  opretProduktTypeGroup.addSwitch(new Switch(bredde4, højde, size, "Vanter", false));
  højde=840*height/982;
  opretProduktTypeGroup.addSwitch(new Switch(bredde1, højde, size, "Vest", false));
  opretProduktTypeGroup.addSwitch(new Switch(bredde2, højde, size, "Top", false));
  opretProduktTypeGroup.addSwitch(new Switch(bredde3, højde, size, "Shorts", false));
  opretProduktTypeGroup.addSwitch(new Switch(bredde4, højde, size, "Strømper", false));
  højde=930*height/982;
  opretProduktTypeGroup.addSwitch(new Switch(bredde1, højde, size, "Nederdel", false));
  
  garnTypeGroup = new SwitchGroup();
  
  
  højde=1020*height/982;
  // Laver alle switchesne
  garnTypeGroup.addSwitch(new Switch(bredde1, højde, size, "Uld", false));
  garnTypeGroup.addSwitch(new Switch(bredde2, højde, size, "Bomuld", false));
  garnTypeGroup.addSwitch(new Switch(bredde3, højde, size, "Mohair", false));
  garnTypeGroup.addSwitch(new Switch(bredde4, højde, size, "Alpaka", false));
  højde=1110*height/982;
  garnTypeGroup.addSwitch(new Switch(bredde1, højde, size, "Merinould", false));
  garnTypeGroup.addSwitch(new Switch(bredde2, højde, size, "Bambus", false));
  garnTypeGroup.addSwitch(new Switch(bredde3, højde, size, "Strømpegarn", false));
  garnTypeGroup.addSwitch(new Switch(bredde4, højde, size, "Silkegarn", false));
  

}

void opretSkærmKnapper(){

  if(opretSkærmTilbageKnap.mouseOver()){
  skærm=startSkærm;
  camY=0;
  }
  opretProduktTypeGroup.checkMouse();
   garnTypeGroup.checkMouse();
   opretKategorierGroup.checkMouse();
}
