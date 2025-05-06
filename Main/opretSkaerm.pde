PImage uploadedImage; // Variabel til at gemme det uploadede billede

float linkRectX, linkRectY, linkRectW, linkRectH;
String aktivtLink = "";

String placeholder = "Indtast link her";
// styre feedback når der er blevet lavet en opskrift
int opskriftCreationFeedback=0;
// sørger for at denne vises i en kortere periode
int opskriftTimer;
int opskriftFeedbackTid=30;

boolean ugyldigtLink = false;
boolean visLinkFejl = false;

void opretSkærm() {
  background(255);
  textSize(30*width/1440);
  fill(71, 92, 108);
  textFont(boldFont);
  textAlign(CORNER, CORNER);
  //text("Navn:",50*width/1440,300*height/982-camY);
  text("Vælg kategori", 100*width/1440, 445*height/982-camY);
  text("Vælg produkttype", 100*width/1440, 690*height/982-camY);
  text("Type af garn:", 100*width/1440, 1135*height/982-camY);
  textFont(generalFont);

  noStroke();
  fill(247, 239, 210);
  rect(700*width/1440, 100*width/1440, 18*width/1440, height*2);

  opretKategorierGroup.tegnAlle();
  opretProduktTypeGroup.tegnAlle();
  garnTypeGroup.tegnAlle();

  // Hvis et billede er uploadet, vis det
  float posY = height/6*2;
  float posX = 250*width/1440;
  float bredde = (width/31*16);
  float højde = (height/4);

  //billedramme
  stroke(0);
  noFill();
  rectMode(CORNER);
  rect(posX + bredde/24*17*width/1920, posY - camY + højde/10*width/1920, bredde/24*5, højde/10*8);

  if (uploadedImage != null) {
    image(uploadedImage, posX + bredde/24*17*width/1920, posY - camY + højde/10*width/1920, bredde/24*5, højde/10*8); // Placér billede
  }

  // Hent teksten fra link-textfield
  String brugerLink = "";
  for (Textfield tf : textfields) {
    if (skærm == opretSkærm && tf.startTekst.equals("Indsæt link til opskrift (https://...)")) {
      brugerLink = tf.tekst;
      if (brugerLink.trim().length() == 0) {
        visLinkFejl = false;  // skjul fejl, hvis feltet er tomt
      } else if (brugerLink.startsWith("http://") || brugerLink.startsWith("https://")) {
        visLinkFejl = false;  // skjul fejl, hvis linket er gyldigt
      }
      break;
    }
  }

  // Hvis der står noget i feltet, så gør teksten klikbar
  if (brugerLink.length() > 0) {

    // Valider link her også!
    if (brugerLink.startsWith("http://") || brugerLink.startsWith("https://")) {
      ugyldigtLink = false;
    } else {
      ugyldigtLink = true;
    }


    fill(0); // blå tekst som et link
    textSize(24);
    textAlign(LEFT, TOP);
    float linkX = width-150*width/1920;
    float linkY = 765*width/1920-camY;
    text("Åbn", linkX, linkY);

    // Gem positionen, så vi kan bruge den ved klik
    linkRectX = linkX;
    linkRectY = linkY;
    linkRectW = textWidth("Åbn");
    linkRectH = 30;
    aktivtLink = brugerLink;

    // Udskriv URL'en for at kontrollere, at den er korrekt
    //  println("Aktivt link: " + aktivtLink);
  }
  if (visLinkFejl) {
    fill(200, 0, 0); // Rød farve
    textSize(18);
    textAlign(LEFT, TOP);
    text("Ugyldigt link. Skal starte med http:// eller https://", 200*width/1440+1000, 820*width/1920-camY);
  }

  if (brugerLink.startsWith("http://") || brugerLink.startsWith("https://")) {
    visLinkFejl = false;
  }
  opretOpskriftFeedback();
}


// Funktion til at vælge billede
void selectImage() {
  selectInput("Vælg et billede til upload:", "fileSelected");
}

// Funktion der bliver kaldt, når en fil er valgt
void fileSelected(File selection) {
  if (selection != null) {
    uploadedImage = loadImage(selection.getAbsolutePath()); // Indlæs billede
    if (uploadedImage == null) {
      println("Fejl: Kunne ikke indlæse billedet.");
    }
  }
}

SwitchGroup opretKategorierGroup;
SwitchGroup opretProduktTypeGroup;
SwitchGroupA garnTypeGroup;
Knap opretSkærmTilbageKnap;
Knap opretSkærmIndsætKnap;
Knap opretSkærmOpretKnap;
Textfield TitelTextfelt;
Knap billedeKnap;

void opretSkærmSetup() {
  //laver knapperne
  opretSkærmTilbageKnap = new TilbageKnap(height/9-height/15, height/9-height/17, height/15*2, height/17*2, color(0), "tilbage", 10, color(205, 139, 98), color(247, 239, 210), 10, opretSkærm);
  knapper.add(opretSkærmTilbageKnap);

  opretSkærmIndsætKnap = new Knap(1000*width/1920, 750*width/1920, 250*width/1920, 50*width/1920, color(247, 239, 210), "Indsæt Udklipsfolder", 20*width/1440, color(71, 92, 108), color(205, 139, 98), 0, opretSkærm);
  knapper.add(opretSkærmIndsætKnap);
  opretSkærmOpretKnap = new Knap(1000*width/1920, 850*width/1920, 500*width/1920, 100*width/1920, color(247, 239, 210), "Opret opskrift", 40*width/1440, color(71, 92, 108), color(205, 139, 98), 0, opretSkærm);
  knapper.add(opretSkærmOpretKnap);

  // Tilføj en knap til at vælge billede
  billedeKnap = new Knap (1000*width/1920, 320*width/1920, 250*width/1920, 50, color(247, 239, 210), "Vælg billede", 30*width/1440, color(71, 92, 108), color(205, 139, 98), 10, opretSkærm);
  knapper.add(billedeKnap);

  // Tilføj Textfield til link
  textfields.add(new Textfield(200*width/1440+1000, 750*width/1920, (width/3)-150, 50,
    color(71, 92, 108), color(247, 239, 210), color(247, 239, 210), color(247, 239, 210),
    20*width/1440, "Indsæt link til opskrift (https://...)", "", 0, opretSkærm, false));

  // Tilføj et tekstfelt til opretSkærm

  // Tilføj et tekstfelt til opretSkærm
  TitelTextfelt = new Textfield( 100*width/1440, 300*height/1125, width/3, 67*height/982, color(71, 92, 108), color(247, 239, 210), color(247, 239, 210), color(247, 239, 210),
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

  // Tilføj en knap til at vælge billede
  billedeKnap = new Knap (1000, 320, 200*width/1440, 50, color(247, 239, 210), "Vælg billede", 30*width/1440, color(71, 92, 108), color(205, 139, 98), 0, opretSkærm);
  knapper.add(billedeKnap);


}

void opretSkærmKnapper() {

  if (opretSkærmTilbageKnap.mouseOver()) {
    skærm=startSkærm;
    camY=0;
  }
  if (skærm==opretSkærm) {
    opskriftCreationFeedback=0;
  }
  opretProduktTypeGroup.checkMouse();
  opretKategorierGroup.checkMouse();
  garnTypeGroup.checkMouse();


  if (opretSkærmIndsætKnap.mouseOver()) {
    String clipboardTekst = getClipboard();

    // Find link-textfieldet og indsæt clipboard-teksten
    for (Textfield tf : textfields) {
      if (skærm == opretSkærm && tf.startTekst.equals("Indsæt link til opskrift (https://...)")) {
        tf.tekst = clipboardTekst;

        // Tjek om det ligner et gyldigt link
        if (clipboardTekst.startsWith("http://") || clipboardTekst.startsWith("https://")) {
          ugyldigtLink = false;
        } else {
          ugyldigtLink = true;
        }

        break;
      }
    }
  }

  if (opretSkærmOpretKnap.mouseOver() ) {
    //Tjekker om alle de nødvændige ting er udfyldt
    if (!TitelTextfelt.tekst.isEmpty() && opretKategorierGroup.getSelectedSwitch() != null
      && uploadedImage != null && opretProduktTypeGroup.getSelectedSwitch() != null && garnTypeGroup.switchValgt()) {
      // kommer den nye opskrift i gemte opskrifter
      gemteOpskrifter.add(new Opskrift(TitelTextfelt.tekst, opretKategorierGroup.getSelectedSwitch().getTitel(),
        "", opretKategorierGroup.getSelectedSwitch().getTitel(), uploadedImage));
      int index=gemteOpskrifter.size();
      for (Switch switchs : garnTypeGroup.switches) {
        if (switchs.getState()) {
          gemteOpskrifter.get(index-1).tilfoejGarntype(switchs.getTitel());
          switchs.tændt=false;
        }
        TitelTextfelt.tekst="";
        opretProduktTypeGroup.getSelectedSwitch().tændt=false;
        opretKategorierGroup.getSelectedSwitch().tændt=false;
        opskriftCreationFeedback=1;
        uploadedImage=null;
        opskriftTimer=millis();
        saveRecipesToFile();
      }
    } else {
      opskriftCreationFeedback=2;
      opskriftTimer=millis();
    }
  }
  // Håndter billede-knap
  if (knapper.get(knapper.size()-1).mouseOver()) {
    selectImage();  // Kald funktionen til at e billede
  }
  // Hvis der er et aktivt link og det klikkes

  if (aktivtLink.length() > 0 &&
    mousePressed &&
    mouseX > linkRectX && mouseX < linkRectX + linkRectW &&
    mouseY > linkRectY && mouseY < linkRectY + linkRectH) {
    //println("Linket er blevet klikket, åbner: " + aktivtLink);
    if (aktivtLink.startsWith("http://") || aktivtLink.startsWith("https://")) {
      link(aktivtLink); // åbner kun hvis link er gyldigt
      visLinkFejl = false;
    } else {
      visLinkFejl = true; // vis fejl hvis ikke gyldigt
    }
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
  }
  catch (Exception e) {
    e.printStackTrace();
  }
  return text;
}

void opretOpskriftFeedback() {
  //opskrift oprettet feedback
  if (opskriftCreationFeedback!=0) {
    stroke(0);
    strokeWeight(1);
    textSize(25*width/1440);
    textAlign(CENTER, CENTER);
    fill(247, 239, 210);
    rect(width/2-width/8, height/2-height/16,width/4,height/8);
    fill(71, 92, 108);
    fill(0);
    if (opskriftCreationFeedback==1) {
      text("Opskrift oprettet", width/2, height/2);
    } else if (opskriftCreationFeedback==2) {
      text("Opskrift ikke oprettet", width/2, height/2);
    }
    if (millis()-opskriftTimer>=opskriftFeedbackTid+opskriftTimer) {
      opskriftCreationFeedback=0;
    }
  }
}
