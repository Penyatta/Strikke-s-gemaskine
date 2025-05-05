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
      if (knapSkærm==søgeSkærm) {
        skyggeImplement(posX, posY+sizeY-1, sizeX, true);
      } else {
        skyggeImplement(posX, posY+sizeY-1, sizeX, false);
      }
      //Skifter farven hvis musen er over knappen
      if (mouseOver()) {
        fill(mouseOverFarve);
      } else {
        fill(feltFarve);
      }
      //Tegner selve knappen
      if (knapSkærm==søgeSkærm) {
        rect(posX, posY, sizeX, sizeY, rundhed);
      } else {
        rect(posX, posY, sizeX, sizeY, rundhed);
      }
      //Sørger for at tekst tegnes med udgangspunkt i centrum af knappen
      textAlign(CENTER, CENTER);
      //Skifter farven på teksten
      fill(tekstFarve);
      textSize(tekstSize);
      //Skriver teksten
      if (textWidth(tekst)>=sizeX-10*width/1440) {
        ArrayList<String> linjer = tekstSplit(tekst, sizeX - 30*width/1440);
        float linjeHøjde = tekstSize * 1.2;
        float totalHøjde = linjer.size() * linjeHøjde;
        float startY = posY - camY + sizeY/2 - totalHøjde/2 + linjeHøjde/2;
        for (int i = 0; i < linjer.size(); i++) {
          if (knapSkærm==søgeSkærm) {
            text(linjer.get(i), posX + sizeX/2, startY + i * linjeHøjde);
          } else {
            text(linjer.get(i), posX + sizeX/2, startY + i * linjeHøjde);
          }
        }
      } else {
        if (knapSkærm==søgeSkærm) {
          text(tekst, posX+sizeX/2, posY+sizeY/2);
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
      if (mouseOver()) {
        fill(mouseOverFarve);
      } else {
        fill(feltFarve);
      }
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
  boolean cursor=false;
  int timer=0;

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
      noStroke();
      rect(posX, posY, sizeX, sizeY, rundhed);
      for (int i=1; i<skyggeAfstand+1; i++) {
        stroke(0, (skyggeAfstand-i)*7.5);
        strokeWeight(1);
        line(posX, posY+i+sizeY-1, posX+sizeX-1, posY+i+sizeY-1);
      }
      noStroke();

      //skyggeImplement(posX, posY+sizeY-1, sizeX, true);
      textAlign(CORNER, CENTER);
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
      float maxTextWidth = sizeX - width/100 * 2;
      while (textWidth(displayedText) > maxTextWidth && displayedText.length() > 0) {
        displayedText = displayedText.substring(1);
      }
      text(displayedText, posX + width/100, posY + sizeY / 2);
      if (active) {
        timer++;
        if (timer>60) {
          cursor=!cursor;
          timer=0;
        }
        if (cursor) {
          rect(posX+width/100+textWidth(displayedText)+2, posY+sizeY/2-tekstSize/2, 2, tekstSize);
        }
      }
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

//Class til alle de cirkler vi har som kan være slået til eller fra
class Switch {
  float posX, posY;
  float diameter;
  String titel;
  boolean tændt;

  Switch(float posX, float posY, float diameter, String titel, boolean initialState) {
    this.posX = posX;
    this.posY = posY;
    this.diameter = diameter;
    this.titel = titel;
    this.tændt = initialState;
  }

  void tegn() {
    //Skriver titlen
    fill(71, 92, 108);
    textAlign(CENTER, BOTTOM);
    textSize(20*width/1440);
    text(titel, posX, posY + diameter/2*3);

    // Tegner knappen
    if (tændt) {
      // Fyldt cirkel når tændt
      fill(71, 92, 108);
      stroke(71, 92, 108);
      strokeWeight(4);
      ellipse(posX, posY, diameter, diameter);
    } else {
      // Hul cirkel når slået fra
      fill(255); // Hvid baggrund
      stroke(71, 92, 108);
      strokeWeight(4);
      ellipse(posX, posY, diameter, diameter);
      noStroke();
    }
  }

  boolean mouseOver() {
    // Check om musen er over switchen
    float distance = dist(mouseX, mouseY, posX, posY);
    return distance <= diameter/2;
  }

  void setState(boolean state) {
    tændt = state;
  }

  boolean getState() {
    return tændt;
  }

  String getTitel() {
    return titel;
  }
}

// Klasse til at holde styr på flere switches
class SwitchGroup {
  ArrayList<Switch> switches;
  int selectedIndex = -1; // Index på den valgte switch

  SwitchGroup() {
    switches = new ArrayList<Switch>();
  }

  void addSwitch(Switch newSwitch) {
    switches.add(newSwitch);

    // Hvis det er den første switch og den er tændt sæt den som den valgte switch
    if (switches.size() == 1 && newSwitch.getState()) {
      selectedIndex = 0;
    }
    // Hvis denne er tændt sørg for at alle de andre ikke er
    else if (newSwitch.getState()) {
      selectSwitch(switches.size() - 1);
    }
  }

  void tegnAlle() {
    for (Switch s : switches) {
      s.tegn();
    }
  }

  void checkMouse() {
    for (int i = 0; i < switches.size(); i++) {
      Switch s = switches.get(i);
      if (s.mouseOver()) {
        // Hvis denne er tændt sluk den
        if (s.getState()) {
          s.setState(false);
          selectedIndex = -1; // ingen switch valgt
        }
        // hvis den some er trykket på er slukket
        else {
          // Sluk alle switches
          for (Switch sw : switches) {
            sw.setState(false);
          }

          // Tænd denne switch
          s.setState(true);
          selectedIndex = i;
        }
        break; // Slut efter den rigtige knap er blevet fundet og behandlet
      }
    }
  }

  // Vælg en switch efter index og sæt alle andre til slukket
  void selectSwitch(int index) {
    if (index >= 0 && index < switches.size()) {
      // Slukker alle switches
      for (Switch s : switches) {
        s.setState(false);
      }

      // Tænder for den valgte switch
      switches.get(index).setState(true);
      selectedIndex = index;
    }
  }

  // Skaffer den valgte Switch
  Switch getSelectedSwitch() {
    if (selectedIndex >= 0 && selectedIndex < switches.size()) {
      return switches.get(selectedIndex);
    }
    return null;
  }

  // Skaf titlen på den valgte switch
  String getSelectedTitle() {
    Switch selected = getSelectedSwitch();
    if (selected != null) {
      return selected.getTitel();
    }
    return "";
  }

  // Get the index of the selected switch
  int getSelectedIndex() {
    return selectedIndex;
  }
}

// Dropdowns itil at vælge det garn man har
class Dropdown {
  float posX, posY, sizeX, sizeY;
  //Holder garnet
  String[] options;
  //Titel når intet valgt
  String placeholder;
  //Det der vises når noget er valgt
  String chosen="";
  //Holder styr på om denne dropdown er åben
  boolean isOpen = false;
  // skærmen som dropdownen er på
  int dropdownScreen;
  //Index på denne dropdown i arraylisten med dropdowns
  int dropdownIndex;

  Dropdown(float posX, float posY, float sizeX, float sizeY, String[] options, String placeholder, int dropdownScreen, int dropdownIndex) {
    this.posX = posX;
    this.posY = posY;
    this.sizeX = sizeX;
    this.sizeY = sizeY;
    this.options = options;
    this.placeholder = placeholder;
    this.dropdownScreen = dropdownScreen;
    this.dropdownIndex = dropdownIndex;
  }

  void tegn() {
    if (dropdownScreen == skærm) {
      // tegner boksen til dropdownen
      rectMode(CORNER);
      noStroke();

      // tegner skyggen
      skyggeImplement(posX, posY + sizeY - 1-camY, sizeX, true);

      // Draw hovedkassen
      if (mouseOverMain()) {
        fill(220, 180, 150); // farve ved mouseOver
      } else {
        fill(247, 239, 210); // Normal farbe
      }
      rect(posX, posY-camY, sizeX, sizeY);

      // Tegner texten til dropdown
      fill(71, 92, 108);
      textAlign(LEFT, CENTER);
      textSize(30*width/1440);
      String displayText;
      if (chosen=="") {
        displayText = placeholder;
      } else {
        displayText = chosen;
      }
      text(displayText, posX + 12*width/1440, posY + sizeY/2-camY);

      // DTegner dropdown pilen
      triangle(
        posX + sizeX - 48*width/1440, posY + sizeY/3-camY,
        posX + sizeX - 22*width/1440, posY + sizeY/3-camY,
        posX + sizeX - 35*width/1440, posY + sizeY*2/3-camY
        );

      // Hvis åben tegner mulighederne
      if (isOpen) {
        for (int i = 0; i < options.length; i++) {
          float optionY = posY + sizeY + i * sizeY;

          // Tegner baggrunden til dropdown options
          if (mouseOverOption(i)) {
            fill(220, 180, 150); // mouseOver farve
          } else {
            fill(247, 239, 210); // Normal farve
          }
          rect(posX, optionY-camY, sizeX, sizeY);

          // Tegn options text
          fill(71, 92, 108);
          textAlign(LEFT, CENTER);
          text(options[i], posX + 15, optionY + sizeY/2-camY);
        }

        // Tegner skyggen til hele options holderen
        skyggeImplement(posX, posY + sizeY + options.length * sizeY - 1-camY, sizeX, true);
      }
    }
  }

  // fortæller om musen er over titel delen af dropdown options
  boolean mouseOverMain() {
    return mouseX > posX && mouseX < posX + sizeX &&
      mouseY > posY-camY && mouseY < posY + sizeY-camY &&
      dropdownScreen == skærm;
  }

  // fortæller om musen  er over en specifik option
  boolean mouseOverOption(int index) {
    float optionY = posY + sizeY + index * sizeY;
    return mouseX > posX && mouseX < posX + sizeX &&
      mouseY > optionY-camY && mouseY < optionY + sizeY-camY &&
      dropdownScreen == skærm;
  }

  void checkMouse() {
    if (mouseOverMain()) {
      // Lukker alle de andre dropdowns
      for (int i = 0; i < garnDropdowns.size(); i++) {
        Dropdown dropdown = garnDropdowns.get(i);
        if (dropdown != this) {
          dropdown.isOpen = false;
        }
      }
      isOpen = !isOpen;
      if (isOpen) {
        openDropdown=dropdownIndex;
      } else {
      }
    } else if (isOpen) {
      for (int i = 0; i < options.length; i++) {
        if (mouseOverOption(i)) {
          // Hvis man ikke har valgt ingen muligheden
          if (options[i]!="Ingen") {
            //hvis denne allerede har en valgt garntype erstattes
            //denne i arrayet med garn typer man har
            if (dropdownIndex < mitGarn.size()) {
              mitGarn.set(dropdownIndex, options[i]);
            } else {
              //Hvis man ikke har valgt en til denne tilføjes denne til arrayet med garn man har
              mitGarn.add(options[i]);
            }
            //opdatere det der vises i toppen a dropdownen
            chosen=options[i];
          } else {
            // hvis man har valgt intet tjekker den om man kan fjerne den nuværende garntype fra arrayet
            if (dropdownIndex >= 0 && dropdownIndex < mitGarn.size()) {
              mitGarn.remove(dropdownIndex);
            }

            /*
            Laver en arraylist med de dropdown som skal opdateres så det kan gøres senere
             Det bliver gjort på denne måde fordi check mouse funktionen bliver kaldet mens
             garnDropdowns bliver kørt igennem, hvilket ville give en fejl hvis vi ændrede i det herinde
             */
            ArrayList<Dropdown> dropdownsToUpdate = new ArrayList<Dropdown>();
            for (int j = 0; j < garnDropdowns.size(); j++) {
              Dropdown dropdown = garnDropdowns.get(j);
              //opdatere kun placeringen af dropdownsne som kommer bagefter
              if (dropdown.dropdownIndex > dropdownIndex) {
                dropdownsToUpdate.add(dropdown);
              }
            }

            // Opdatere de dropdown som blev gemt lige før fordi de nu bliver kørt igennem en anden arraylist sker der ikke fejl
            for (Dropdown dropdown : dropdownsToUpdate) {
              //ændre indeks
              dropdown.dropdownIndex--;
              //ændre placering
              dropdown.posY = dropdown.posY - (height/14 + 15*width/1440);
            }
            //Hvis dette ikke er det sidste dropdown skal det fjernes når der trykkes på intet
            if (garnDropdowns.size()>=2) {
              needRemove=true;
              needRemoved=dropdownIndex;
            }
          }
          //lukker den nuværende dropdown og tjekker om der skal tilføjes et
          isOpen = false;
          checkAddNewDropdown();
          break;
        }
      }

      // Lukker dropdown hvis man trykker udenfor
      if (!mouseOverOptionsArea()) {
        isOpen = false;
      }
    }
  }
//tjekker om musen er over options området
  boolean mouseOverOptionsArea() {
    return mouseX > posX && mouseX < posX + sizeX &&
      mouseY > posY-camY && mouseY < posY + sizeY + (isOpen ? options.length * sizeY : 0)-camY &&
      dropdownScreen == skærm;
  }
}
