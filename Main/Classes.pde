class Opskrift {
  String titel;
  String link;
  ArrayList<String> krævneGarn = new ArrayList<String>();
  int garntyper;
  String sværhedsgrad;
  String produktType;
  PImage billede;
  Opskrift(String TITEL, String LINK, String SVÆRHEDSGRAD, String PRODUKTTYPE,PImage BILLEDE) {
    titel=TITEL;
    link=LINK;
    sværhedsgrad=SVÆRHEDSGRAD;
    billede=BILLEDE;
    produktType=PRODUKTTYPE;
  }
  void tilfoejGarntype(String garn) {
    krævneGarn.add(garn);
    garntyper++;
  }
  void displayOpskrift(int x, int y) {
     fill(247, 239, 210);
    noStroke();
    rect(x, y, width / 2, height / 4);  // En boks til opskriften
    
    fill(0);
    textFont(createFont("Arial", 16));
    textAlign(CORNER);
    textSize(18);

    // Vis opskriftens titel, sværhedsgrad, produktType og garn
    text(titel, x + 10, y + 20);
    text("Sværhedsgrad: " + sværhedsgrad, x + 10, y + 50);
    text("Produkttype: " + produktType, x + 10, y + 80);
    text("Garn: " + String.join(", ", krævneGarn), x + 10, y + 110);  // Garn kan være flere typer

    // Hvis der er et billede, vis det (hvis nødvendigt)
    if (billede != null) {
      image(billede, x + width / 2, y);
    }
  }
}

class SearchToken {
  String token;
}

ArrayList<Knap> knapper = new ArrayList <Knap>();

class Knap {
  //position af det øverste venstre hjørne af tekstfeltet
  float posX;
  float posY;
  //Størrelsen af tekstfeltet
  float sizeX;
  float sizeY;
  //Farven på teksten
  color tekstFarve;
  //Teksten der vises på knappen
  String tekst;
  //Størrelsen af teksten der vises
  int tekstSize;
  //Basis farve på knappen
  color feltFarve;
  //Farven der vises når musen er placeret over knappen
  color mouseOverFarve;
  //Værdi der bruges til at afrunde hjørnerne på knappen
  float rundhed;
  //Skærmen som tekst feltet er på
  int knapSkærm;

  Knap(float POSX, float POSY, float SIZEX, float SIZEY, color TEKSTFARVE, String TEKST,
    int TEKSTSIZE, color FELTFARVE, color MOUSEOVERFARVE, float RUNDHED, int KNAPSKÆRM) {
    //Gemmer alle værdierne som der inputtes i constructoren
    posX=POSX;
    posY=POSY;
    sizeX=SIZEX;
    sizeY=SIZEY;
    tekstFarve=TEKSTFARVE;
    tekst=TEKST;
    tekstSize=TEKSTSIZE;
    feltFarve=FELTFARVE;
    rundhed=RUNDHED;
    knapSkærm=KNAPSKÆRM;
    mouseOverFarve=MOUSEOVERFARVE;
  }
  void tegn() {
    //Tegnes kun hvis knappen er på den samme skærm som brugeren er
    if (knapSkærm==skærm) {
      //Sørger for at det er det øverste venstre hjørne som knappen tegnes fra
      rectMode(CORNER);
      skyggeImplement(posX,posY+sizeY-1,sizeX);
      //Skifter farven hvis musen er over knappen
      if (mouseOver()) {
        fill(mouseOverFarve);
      } else {
        fill(feltFarve);
      }
      //Tegner selve knappen
      rect(posX, posY-camY, sizeX, sizeY, rundhed);
      //Sørger for at tekst tegnes med udgangspunkt i centrum af knappen
      textAlign(CENTER, CENTER);
      //Skifter farven på teksten
      fill(tekstFarve);
      textSize(20);
      //Skriver teksten
      text(tekst, posX+sizeX/2, posY-camY+sizeY/2);
    }
  }
  //funktion der returnerer sand når musen er over knappen men ellers falsk
  boolean mouseOver() {
    if (posX < mouseX && mouseX < (posX+sizeX) && posY < mouseY && mouseY < (posY+sizeY) && knapSkærm==skærm) {
      return(true);
    } else {
      return(false);
    }
  }
}

class TilbageKnap extends Knap {
  TilbageKnap(float POSX, float POSY, float SIZEX, float SIZEY, color TEKSTFARVE, String TEKST,
    int TEKSTSIZE, color FELTFARVE, color MOUSEOVERFARVE, float RUNDHED, int KNAPSKÆRM) {
    super(POSX, POSY, SIZEX, SIZEY, TEKSTFARVE, TEKST, TEKSTSIZE, FELTFARVE, MOUSEOVERFARVE, RUNDHED, KNAPSKÆRM);
  }
  @Override
    void tegn() {      
      //Tegnes kun hvis knappen er på den samme skærm som brugeren er
    if (knapSkærm==skærm) {
      
      //dette herinde skal erstattes af en flot model til tilbage knappen
      
      //Sørger for at det er det øverste venstre hjørne som knappen tegnes fra
      rectMode(CORNER);
      noStroke();
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
      textSize(20);
      text(tekst, posX+sizeX/2, posY-camY+sizeY/2);
    }
    }
}
      
