void hjælpSkærm() {
  background(255);
  overskriftBjælke("Hjælp");
}

HjælpKnap hjælpKnap;
TilbageKnap hjælpSkærmTilbageKnap;

void hjælpSkærmSetup() {
  //laver knapperne
  hjælpKnap = new HjælpKnap(width/8*7, height/9, width/8, height/8, color(247, 239, 210), "Hjælp", 60, color(205, 139, 98), color(247, 239, 210), 0, startSkærm);
  knapper.add(hjælpKnap);
  hjælpSkærmTilbageKnap = new TilbageKnap(height/9-height/15, height/9-height/17, height/15*2, height/17*2, color(0), "tilbage", 10, color(205, 139, 98), color(247, 239, 210), 10, hjælpSkærm);
  knapper.add(hjælpSkærmTilbageKnap);
}


//under klasse til knap klasse til hjælp knappen da den er det samme sted på alle siderne
class HjælpKnap extends Knap {
  HjælpKnap(float POSX, float POSY, float SIZEX, float SIZEY, color TEKSTFARVE, String TEKST,
    int TEKSTSIZE, color FELTFARVE, color MOUSEOVERFARVE, float RUNDHED, int KNAPSKÆRM) {
    super(POSX, POSY, SIZEX, SIZEY, TEKSTFARVE, TEKST, TEKSTSIZE, FELTFARVE, MOUSEOVERFARVE, RUNDHED, KNAPSKÆRM);
  }
  @Override
    void tegn() {
    //Sørger for at det er det øverste venstre hjørne som knappen tegnes fra
    rectMode(CENTER);
    noStroke();
    //tegner skyggen
    skyggeImplement(posX-sizeX/2, posY+sizeY/2, sizeX,false);

    //Skifter farven hvis musen er over knappen
    if (mouseOver()) {
      fill(mouseOverFarve);
    } else {
      fill(feltFarve);
    }
    //Tegner selve knappen
    rect(posX, posY, sizeX, sizeY, rundhed);
    //Sørger for at tekst tegnes med udgangspunkt i centrum af knappen
    textAlign(CENTER, CENTER);
    //Skifter farven på teksten
    textSize(tekstSize);
    fill(tekstFarve);
    //Skriver teksten
    text(tekst, posX, posY);
  }
  @Override
    boolean mouseOver() {
    if ((posX-sizeX/2) < mouseX && mouseX < (posX+sizeX/2) && (posY-sizeY/2) < mouseY && mouseY < (posY+sizeY/2)) {
      return(true);
    } else {
      return(false);
    }
  }
}

void hjælpSkærmKnapper() {
  if (hjælpKnap.mouseOver()) {
    skærm=hjælpSkærm;
  }
  if (hjælpSkærmTilbageKnap.mouseOver()) {
    skærm=startSkærm;
  }
}

void skyggeImplement(float posX, float posY, float bredde,boolean lysBaggrund) {
  for (int i=1; i<skyggeAfstand+1; i++) {
    if(lysBaggrund){
      stroke(0, (skyggeAfstand-i)*15);
    } else{
    stroke(0, (skyggeAfstand-i)*30);
    }
    strokeWeight(1);
    line(posX, posY+i, posX+bredde-1, posY+i);
  }
  noStroke();
}
