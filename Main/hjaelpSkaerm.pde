void hjælpSkærm() {
}

HjælpKnap hjælpKnap;
TilbageKnap hjælpSkærmTilbageKnap;

void hjælpSkærmSetup(){
  hjælpKnap = new HjælpKnap(width/8*7, height/16, width/16, height/16, color(0), "Hjælp", 10, color(255, 0, 0), color(0, 255, 0), 10, startSkærm);
  knapper.add(hjælpKnap);
  hjælpSkærmTilbageKnap = new TilbageKnap(width/8, height/16, width/16, height/16, color(0), "tilbage", 10, color(255, 0, 0), color(0, 255, 0), 10, hjælpSkærm);
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
    rectMode(CORNER);
    //Skifter farven hvis musen er over knappen
    if (mouseOver()) {
      fill(mouseOverFarve);
    } else {
      fill(feltFarve);
    }
    //Tegner selve knappen
    rect(posX, posY-camY, sizeX, sizeY, rundhed, rundhed, rundhed, rundhed);
    //Sørger for at tekst tegnes med udgangspunkt i centrum af knappen
    textAlign(CENTER, CENTER);
    //Skifter farven på teksten
    fill(tekstFarve);
    //Skriver teksten
    text(tekst, posX+sizeX/2, posY-camY+sizeY/2);
  }
  @Override
  boolean mouseOver(){
    if (posX < mouseX && mouseX < (posX+sizeX) && posY < mouseY && mouseY < (posY+sizeY)) {
      return(true);
    } else {
      return(false);
    }
  }
}

void hjælpSkærmKnapper(){
  if(hjælpKnap.mouseOver()){
   skærm=hjælpSkærm; 
  }
}
