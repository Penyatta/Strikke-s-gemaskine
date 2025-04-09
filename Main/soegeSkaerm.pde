void søgeSkærm() {
  background(255);
  overskriftBjælke("Søg efter opskrifter");
  //Tjekker om arrayet er tomt før det viser det
  if (!opskrifter.isEmpty()) {
    // Converterer opskrifter til et normalt array i stedet for en arraylist
    Opskrift[] opskriftArray = opskrifter.toArray(new Opskrift[0]);
    displayOpskrifter(opskriftArray);
    textFont(generalFont);
    textSize(80);
    fill(71, 92, 108);
    textAlign(CENTER);
    text("Opskrifter",width/7*3+width/4,height/3);
  }
}

Knap søgeSkærmTilbageKnap;

void søgeSkærmSetup() {
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
  textAlign(CENTER,CENTER);
  textSize(100);
  text(tekst,width/2,height/9-camY);
}
