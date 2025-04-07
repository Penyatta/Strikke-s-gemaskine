
void søgeSkærm() {
  background(255);
  fill(71, 92, 108);
  rect(0,0-camY,width,height/9*2);
  //Tjekker om arrayet er tomt før det viser det
  if (!opskrifter.isEmpty()) {
    // Converterer opskrifeter til et normalt array i stedet for en arraylist
    Opskrift[] opskriftArray = opskrifter.toArray(new Opskrift[0]);
    displayOpskrifter(opskriftArray);
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
