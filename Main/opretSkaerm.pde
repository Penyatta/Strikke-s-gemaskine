void opretSkærm(){
  background(255);
  textSize(30*width/1440);
  fill(71, 92, 108);
  textFont(boldFont);
  textAlign(CORNER,CORNER);
  //text("Navn:",50*width/1440,300*height/982-camY);
  text("Vælg kategori",100*width/1440,445*height/982-camY);
  text("Vælg produkttype",100*width/1440,690*height/982-camY);
  text("Type af garn:",100*width/1440,1135*height/982-camY);
   textFont(generalFont);
  
  noStroke();
  fill(247, 239, 210);
  rect(700*width/1440,100*width/1440,18*width/1440,height*2);
  
  opretKategorierGroup.tegnAlle();
  opretProduktTypeGroup.tegnAlle();
  garnTypeGroup.tegnAlle();
}

SwitchGroup opretKategorierGroup;
SwitchGroup opretProduktTypeGroup;
SwitchGroupA garnTypeGroup;
Knap opretSkærmTilbageKnap;
Knap opretSkærmIndsætKnap;
Textfield TitelTextfelt;

void opretSkærmSetup(){
  //laver knapperne
  opretSkærmTilbageKnap = new TilbageKnap(height/9-height/15, height/9-height/17, height/15*2, height/17*2, color(0), "tilbage", 10, color(205, 139, 98), color(247, 239, 210), 10, opretSkærm);
  knapper.add(opretSkærmTilbageKnap);
  opretSkærmIndsætKnap = new Knap(height/9*8, height/9*2, height/15*2, height/17*2, color(0), "Indsæt Udklipsfolder", 20*width/1440, color(205, 139, 98), color(247, 239, 210), 0, opretSkærm);
knapper.add(opretSkærmIndsætKnap);
  
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
  højde+=90*height/982;
  opretKategorierGroup.addSwitch(new Switch(bredde1, højde, size, "Hjem", false));
  
  opretProduktTypeGroup = new SwitchGroup();
  
  højde+=175*height/982;


  opretProduktTypeGroup.addSwitch(new Switch(bredde1, højde, size, "Sweater", false));
  opretProduktTypeGroup.addSwitch(new Switch(bredde2, højde, size, "Påske", false));
  opretProduktTypeGroup.addSwitch(new Switch(bredde3, højde, size, "Veste & Toppe", false));
  opretProduktTypeGroup.addSwitch(new Switch(bredde4, højde, size, "Cardigans", false));
  højde+=90*height/982;
  opretProduktTypeGroup.addSwitch(new Switch(bredde1, højde, size, "Vest", false));
  opretProduktTypeGroup.addSwitch(new Switch(bredde2, højde, size, "Babytæpper", false));
  opretProduktTypeGroup.addSwitch(new Switch(bredde3, højde, size, "Toppe", false));
  opretProduktTypeGroup.addSwitch(new Switch(bredde4, højde, size, "Strømper & Hjemmesko", false));
  højde+=90*height/982;
  opretProduktTypeGroup.addSwitch(new Switch(bredde1, højde, size, "Børneværelse", false));
  opretProduktTypeGroup.addSwitch(new Switch(bredde2, højde, size, "Kjoler og Tunika", false));
  opretProduktTypeGroup.addSwitch(new Switch(bredde3, højde, size, "Huer", false));
  opretProduktTypeGroup.addSwitch(new Switch(bredde4, højde, size, "Shawls", false));
  højde+=90*height/982;
  opretProduktTypeGroup.addSwitch(new Switch(bredde1, højde, size, "Unknown", false));
  
  garnTypeGroup = new SwitchGroupA();
  
  højde+=175*height/982;
  // Laver alle switchesne
  garnTypeGroup.addSwitch(new Switch(bredde1, højde, size, "Uld", false));
  garnTypeGroup.addSwitch(new Switch(bredde2, højde, size, "Bomuld", false));
  garnTypeGroup.addSwitch(new Switch(bredde3, højde, size, "Mohair", false));
  garnTypeGroup.addSwitch(new Switch(bredde4, højde, size, "Alpaka", false));
  højde+=90*height/982;
  garnTypeGroup.addSwitch(new Switch(bredde1, højde, size, "Merinould", false));
  garnTypeGroup.addSwitch(new Switch(bredde2, højde, size, "Strømpegarn", false));
  garnTypeGroup.addSwitch(new Switch(bredde3, højde, size, "Silkegarn", false));

}

void opretSkærmKnapper(){

  if(opretSkærmTilbageKnap.mouseOver()){
  skærm=startSkærm;
  camY=0;
  }
  opretProduktTypeGroup.checkMouse();
   garnTypeGroup.checkMouse();
   opretKategorierGroup.checkMouse();
   if(opretSkærmIndsætKnap.mouseOver()){
    String ikkeIBrug=getClipboard(); 
   }
}

String getClipboard() {
  String text = "";
  try {
    java.awt.datatransfer.Clipboard clipboard = java.awt.Toolkit.getDefaultToolkit().getSystemClipboard();
    java.awt.datatransfer.Transferable contents = clipboard.getContents(null);
    boolean hasTransferableText = (contents != null) &&
      contents.isDataFlavorSupported(java.awt.datatransfer.DataFlavor.stringFlavor);
    if (hasTransferableText) {
      text = (String) contents.getTransferData(java.awt.datatransfer.DataFlavor.stringFlavor);
    }
  } catch (Exception e) {
    e.printStackTrace();
  }
  return text;
}
