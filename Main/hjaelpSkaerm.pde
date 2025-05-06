void hjælpSkærm() {
  background(255);
  stroke(247, 239, 210);
  strokeWeight(8*width/1440);
  line(width/3, height/6, width/3, height);
  line(2*width/3, height/6, 2*width/3, height);
  line(0, height/3, width, height/3);
  stroke(71, 92, 108);
  textAlign(CORNER, CORNER);
  textSize(24*width/1440);
  text("Hvordan søger jeg?", width/100, height/3-height/40);
  text("Hvordan indsætter jeg mit eget garn?", width/3+width/100, height/3-height/40);
  text("Hvordan kommer jeg længere ned?", 2*width/3+width/100, height/3-height/40);
  //Hvordan søger jeg
  displayText(
    "1. Tryk på pilen oppe i venstre hjørne.\n"+
    "2. Tryk på \"Søg efter opskrifter\" knappen.\n"+
    "3. Marker en kategori hvis relevant\nved at trykke på den tilsvarende cirkel.\n"+
    "4. Marker en produkttype hvis relevant.\n"+
    "5. Marker om du vil søge baseret på\neget garn.\n"+
    "6. Tryk på søgefeltet og skriv hvad du\nleder efter.\n"+
    "7. Tryk på \"Søg\" knappen\n"+
    "8. Truk på opskriften du leder efter"
    , width/100, height/3+32*width/1440+width/75, 34*width/1440);

  displayText(
    "1. Tryk på pilen oppe i venstre hjørne.\n"+
    "2. Tryk på \"Min profil\" knappen.\n"+
    "3. Tryk på feltet i venstre side\nunder \"Mit garn\" overskriften.\n"+
    "4. Tryk på den rigtige garn type.\n"+
    "5. Hvis du har flere garntyper tryk på det\nnye felt.\n"+
    "6. Tryk på den rigtige garn type.\n"+
    "7. Gentag fra skridt 5 indtil alt dit garn er\ni programmet."
    , width/3+width/100, height/3+32*width/1440+width/75, 34*width/1440);

  displayText(
    "Uden mus\n"+
    "1. Placer to fingre på pladen du bruger\ntil at flytte rundt på skærmen.\n"+
    "2. Flyt begge fingre synkront opad\npå pladen.\n\n"+
    "Med mus\n"+
    "1. Placer en finger på hjulet i midten af musen.\n"+
    "2. Træk toppen af hjulet mod dig selv"
    , 2*width/3+width/100, height/3+32*width/1440+width/75, 34*width/1440);

  noStroke();
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
    skyggeImplement(posX-sizeX/2, posY+sizeY/2, sizeX, false);

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
    if (skærm==mitSkærm) {
      openDropdown=-1;
      for (Dropdown dropdown : garnDropdowns) {
        dropdown.isOpen=false;
      }
    }
    skærm=hjælpSkærm;
    camY=0;
  }
  if (hjælpSkærmTilbageKnap.mouseOver()) {
    skærm=startSkærm;
  }
}

void skyggeImplement(float posX, float posY, float bredde, boolean lysBaggrund) {
  for (int i=1; i<skyggeAfstand+1; i++) {
    if (lysBaggrund) {
      stroke(0, (skyggeAfstand-i)*15);
    } else {
      stroke(0, (skyggeAfstand-i)*30);
    }
    strokeWeight(1);
    line(posX, posY+i, posX+bredde-1, posY+i);
  }
  noStroke();
}

void displayText(String text, float x, float y, float lineHeight) {
  // Split the text at newline characters
  String[] lines = split(text, '\n');

  // Display each line
  for (int i = 0; i < lines.length; i++) {
    text(lines[i], x, y + (i * lineHeight));
  }
}
