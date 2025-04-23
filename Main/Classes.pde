class Opskrift {
  String titel;
  String link;
  ArrayList<String> krævneGarn = new ArrayList<String>();
  int garntyper;
  String sværhedsgrad;
  String produktType;
  PImage billede;
  Opskrift(String TITEL, String LINK, String SVÆRHEDSGRAD, String PRODUKTTYPE, PImage BILLEDE) {
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
    tekstSize=tekstSize*width/1920;
  }
  void tegn() {
    //Tegnes kun hvis knappen er på den samme skærm som brugeren er
    if (knapSkærm==skærm) {
      //Sørger for at det er det øverste venstre hjørne som knappen tegnes fra
      rectMode(CORNER);
      skyggeImplement(posX, posY+sizeY-1, sizeX);
      //Skifter farven hvis musen er over knappen
      if (mouseOver()) {
        fill(mouseOverFarve);
      } else {
        fill(feltFarve);
      }
      //Tegner selve knappen
      if (knapSkærm==søgeSkærm) {
        rect(posX, posY-camY, sizeX, sizeY, rundhed);
      } else {
        rect(posX, posY, sizeX, sizeY, rundhed);
      }
      //Sørger for at tekst tegnes med udgangspunkt i centrum af knappen
      textAlign(CENTER, CENTER);
      //Skifter farven på teksten
      fill(tekstFarve);
      textSize(tekstSize);
      //Skriver teksten
      if (textWidth(tekst)>=sizeX-10) {
        ArrayList<String> linjer = tekstSplit(tekst, sizeX - 30);
        float linjeHøjde = tekstSize * 1.2;
        float totalHøjde = linjer.size() * linjeHøjde;
        float startY = posY - camY + sizeY/2 - totalHøjde/2 + linjeHøjde/2;
        for (int i = 0; i < linjer.size(); i++) {
          if (knapSkærm==søgeSkærm) {
          text(linjer.get(i), posX + sizeX/2, startY + i * linjeHøjde);
        } else {
          text(linjer.get(i), posX + sizeX/2, startY +camY + i * linjeHøjde);
        }
        }
      } else {
        if (knapSkærm==søgeSkærm) {
          text(tekst, posX+sizeX/2, posY-camY+sizeY/2);
        } else {
          text(tekst, posX+sizeX/2, posY+sizeY/2);
        }
      }
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

ArrayList<String> tekstSplit(String tekst, float maxBredde) {
  //opretter arraylist til linjerne
  ArrayList<String> linjer = new ArrayList<String>();
  //laver et array med alle ordene
  String[] ord = tekst.split(" ");
  //opretter en string hvor linjerne kan samles i
  String linje = "";
  //Kører lige så mange gange osm der er ord
  for (int i = 0; i < ord.length; i++) {
    //laver en test linje
    String testLinje = linje + (linje.equals("") ? "" : " ") + ord[i];
    //tejkker om testlinjen er større end maxBredde
    if (textWidth(testLinje) > maxBredde) {
      //Hvis den er større end den må tilføjes den nuværende linje
      //til arraylisten og der startes på næste linje med det nuværende ord
      linjer.add(linje);
      linje = ord[i];
    } else {
      //Hvis testlinjen er mindre end max ændres den aktuelle linje til at være lig testlinjen
      linje = testLinje;
    }
  }
  //Hvis funktionen er gået igennem alle ordene og den sidste linje ikke er tilføjet gør den det
  if (!linje.equals("")) {
    linjer.add(linje);
  }
  return linjer;
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
      //Sørger for at det er det øverste venstre hjørne som knappen tegnes fra
      pushMatrix();
      rectMode(CORNER);
      noStroke();
      //Tegner selve knappen
      translate(posX, posY);
      fill(feltFarve);
      noStroke();
      beginShape();
      vertex(height/15, 0);
      vertex(height/15, height/17*2);
      vertex(0, height/17);
      endShape(CLOSE);
      arc(height/15, height/17*2, height/15*2, height/25*4, PI/2*3, PI*2);
      fill(71, 92, 108);
      arc(height/15, height/17*2, height/15*2, height/31*2, PI/2*3, PI*2);
      popMatrix();
    }
  }
}

/*
Den følgende klasse er lavet af Noah Magnus Thomsen
 Vi har fået lov til at bruge koden under en verbal aftale
 https://github.com/NuddiGaming/Space-education
 */
ArrayList<Textfield> textfields = new ArrayList<Textfield>();
Textfield activeField = null; // Holder styr på hvilket felt der er aktivt

class Textfield {
  float posX, posY, sizeX, sizeY, rundhed;
  color tekstFarve, activeFarve, outlineFarve, baggrundsFarve;
  int tekstSize, textfieldSkærm;
  String startTekst, tekst;
  boolean active;

  Textfield(float posX, float posY, float sizeX, float sizeY, color tekstFarve, color activeFarve, color outlineFarve,
    color baggrundsFarve, int tekstSize, String startTekst, String tekst, float rundhed, int textfieldSkærm, boolean active) {
    this.posX = posX;
    this.posY = posY;
    this.sizeX = sizeX;
    this.sizeY = sizeY;
    this.tekstFarve = tekstFarve;
    this.activeFarve = activeFarve;
    this.outlineFarve = outlineFarve;
    this.baggrundsFarve = baggrundsFarve;
    this.tekstSize = tekstSize;
    this.startTekst = startTekst;
    this.tekst = tekst;
    this.rundhed = rundhed;
    this.textfieldSkærm = textfieldSkærm;
    this.active = active;
    textfields.add(this);
  }

  void tegn() {
    if (textfieldSkærm == skærm) { // Tjekker skærm
      rectMode(CORNER);
      // Sætte den rigtige farve ud fra om det er active
      if (active) {
        fill(activeFarve);
      } else {
        fill(baggrundsFarve);
      }
      stroke(outlineFarve);
      rect(posX, posY-camY, sizeX, sizeY, rundhed);
      textAlign(CENTER, CENTER);
      fill(tekstFarve);
      textSize(tekstSize);
      // Teksten som står i feltet
      String displayedText;
      if (active) {
        displayedText = tekst;
      } else {
        if (tekst.isEmpty()) {
          displayedText = startTekst;
        } else {
          displayedText = tekst;
        }
      }
      text(displayedText, posX + sizeX / 2, posY-camY + sizeY / 2);
    }
  }

  void tegnPåSkærm() {
    pushMatrix();
    resetMatrix();
    if (textfieldSkærm == skærm) { // Tjekker skærm
      rectMode(CORNER);
      // Sætte den rigtige farve ud fra om det er active
      if (active) {
        fill(activeFarve);
      } else {
        fill(baggrundsFarve);
      }
      stroke(outlineFarve);
      rect(posX, posY, sizeX, sizeY, rundhed);
      textAlign(CENTER, CENTER);
      fill(tekstFarve);
      textSize(tekstSize);
      // Teksten som står i feltet
      String displayedText;
      if (active) {
        displayedText = tekst;
      } else {
        if (tekst.isEmpty()) {
          displayedText = startTekst;
        } else {
          displayedText = tekst;
        }
      }
      text(displayedText, posX + sizeX / 2, posY + sizeY / 2);
    }
    popMatrix();
  }

  // Tjekker om mus er over knap
  boolean mouseOver() {
    return mouseX > posX && mouseX < posX + sizeX && mouseY > posY && mouseY < posY + sizeY;
  }

  // Activate funktion
  void activate() {
    active = true;
    activeField = this;
  }

  // Deactivate funktion
  void deactivate() {
    active = false;
  }
}
