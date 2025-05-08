import java.awt.Desktop;
import java.io.File;
import processing.core.PConstants;

PFont italicFont;

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

String selectedPdfPath = "";
String selectedPdfName = "";

float krydsX, krydsY, krydsW = 20, krydsH = 20;

// wrapText funktionen
String[] wrapText(String text, float maxWidth, PFont font) {
  textFont(font);
  String[] words = text.split(" ");
  String currentLine = "";
  ArrayList<String> lines = new ArrayList<String>();

  for (String word : words) {
    if (textWidth(currentLine + word) < maxWidth) {
      currentLine += word + " ";
    } else {
      lines.add(currentLine.trim());
      currentLine = word + " ";
    }
  }

  if (currentLine.length() > 0) {
    lines.add(currentLine.trim());
  }

  return lines.toArray(new String[lines.size()]);
}

ArrayList<SwitchGroup> produkttypeGrupper = new ArrayList<SwitchGroup>();
SwitchGroup selectedSwitchGroup;
String selectedKategori;
float garnOverskriftHøjde=0;

void opretSkærm() {
  background(255);
  textSize(30*width/1440);
  fill(71, 92, 108);
  textFont(boldFont);
  textAlign(CORNER, CORNER);
  //text("Navn:",50*width/1440,300*height/982-camY);
  text("Vælg kategori", 100*width/1440, 445*height/982-camY);
  if (opretKategorierGroup.switchValgt()) {
    text("Vælg produkttype", 100*width/1440, 690*height/982-camY);
  }
  if (selectedSwitchGroup!= null) {
    if (selectedSwitchGroup.getSelectedSwitch() != null) {
      text("Type af garn:", 100*width/1440, garnOverskriftHøjde-camY);
    }
  }
  textFont(generalFont);

  noStroke();
  fill(247, 239, 210);
  rect(700*width/1440, 100*width/1440, 18*width/1440, height*2);

  opretKategorierGroup.tegnAlle();
  if (opretKategorierGroup.switchValgt()) {
    String[] kategorier = {"Mænd", "Kvinder", "Baby (0-4 år)", "Barn (2-14 år)", "Hjem", "Højtider"};
    for (int i=0; i<6; i++) {
      if (kategorier[i]==opretKategorierGroup.getSelectedTitle()) {
        produkttypeGrupper.get(i).tegnAlle();
      }
    }
    if (selectedKategori !=opretKategorierGroup.getSelectedTitle()) {
      selectedKategori= opretKategorierGroup.getSelectedTitle();
      float højde=(485+90*(ceil(selectedSwitchGroup.switches.size()/4)+3)+175)*height/982;
      if (selectedSwitchGroup.switches.size()%4==0) {
        højde=(485+90*(ceil(selectedSwitchGroup.switches.size()/4)+2)+175)*height/982;
      }
      garnOverskriftHøjde=højde-55*height/982;
      int i=0;

      for (Switch switchs : garnTypeGroup.switches) {
        if (i==4) {
          højde+=90*height/982;
          i=0;
        }
        switchs.posY=højde;
        i++;
      }
    }
  }
  if (selectedSwitchGroup!= null) {
    if (selectedSwitchGroup.getSelectedSwitch() != null) {
      garnTypeGroup.tegnAlle();
    }
  }

  // Hvis et billede er uploadet, vis det
  float posY = 400*width/1920+15;
  float posX = 1000*width/1920+25;
  float bredde = (width/31*16);
  float højde = (height/4);

  //billedramme
  stroke(0);
  noFill();
  rectMode(CORNER);
  rect(posX, posY - camY, bredde/24*5, højde/10*8);

  if (uploadedImage != null) {
    image(uploadedImage, posX, posY - camY, bredde/24*5, højde/10*8); // Placér billede
  }

  // Hent filens titel og vis det på skærmen
  if (selectedPdfName != null && !selectedPdfName.isEmpty()) {

    // Farveskift og cursor, hvis musen er over filnavn-området
    if (mouseX > linkRectX && mouseX < linkRectX + linkRectW &&
      mouseY > linkRectY && mouseY < linkRectY + linkRectH) {
      fill(#3F50FA);  // Farve når musen er over
      cursor(HAND);   // Cursor ændres til hånd
    } else {
      fill(0);  // Standardfarve
      cursor(ARROW);  // Normal cursor
    }
    textSize(27);
    textAlign(LEFT, TOP);
    float fileNameX = 1400*width/1920;
    float fileNameY = 400*width/1920+15 - camY;

    // Brug wrapText til at opdele filnavnet, hvis det er for langt
    String[] wrappedText = wrapText(selectedPdfName, 450 * width / 1920, generalFont); // maxWidth er 400
    float lineHeight = 40;  // Højde per linje
    for (int i = 0; i < wrappedText.length; i++) {
      text(wrappedText[i], fileNameX, fileNameY + i * lineHeight);
    }

    // Gem positionen, så vi kan bruge den ved klik
    linkRectX = fileNameX;
    linkRectY = fileNameY;
    linkRectW = textWidth(selectedPdfName);
    linkRectH = lineHeight * wrappedText.length;

    // Vis hjælpetekst hvis det er PDF
    if (selectedPdfName.toLowerCase().endsWith(".pdf")) {
      fill(0);
      textSize(3);
      textFont(italicFont);
      text("Klik på filnavnet for at åbne filen", fileNameX, fileNameY + lineHeight * wrappedText.length + 5);
      textFont(generalFont);
    } else {
      fill(200, 0, 0); // Rød fejltekst
      textSize(3);
      textFont(italicFont);
      text("Ugyldig fil. Det skal være en PDF.", fileNameX, fileNameY + lineHeight * wrappedText.length + 5);
      textFont(generalFont);
    }

    // Tegn "X"-krydset
    krydsX = fileNameX + textWidth(wrappedText[0]) + 25;
    krydsY = fileNameY;

    boolean mouseOverKryds = mouseX > krydsX && mouseX < krydsX + krydsW &&
      mouseY > krydsY && mouseY < krydsY + krydsH;
    if (mouseOverKryds) {
      fill(255, 0, 0); // Rød når musen er over
      cursor(HAND);
    } else {
      fill(150);       // Grå ellers
      cursor(ARROW);
    }

    textSize(30);
    textAlign(LEFT, TOP);
    text("X", krydsX, krydsY);
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

void fileSelected(File selection) {
  if (selection != null) {
    uploadedImage = loadImage(selection.getAbsolutePath());
    println("Billede valgt: " + selection.getAbsolutePath());
  } else {
    println("Ingen fil valgt.");
  }
}


void selectPdf() {
  selectInput("Vælg en PDF til upload:", "fileSelectedPdf");
}

// Funktion der bliver kaldt, når en fil er valgt
void fileSelectedPdf (File selection) {
  if (selection != null) {
    // Få stien til den valgte fil
    selectedPdfPath = selection.getAbsolutePath();
    // Få kun filnavnet uden stien
    selectedPdfName = selection.getName();
    println("PDF valgt: " + selectedPdfName);
  }
}


SwitchGroup opretKategorierGroup;

SwitchGroupA garnTypeGroup;
Knap opretSkærmTilbageKnap;
Knap opretSkærmIndsætKnap;
Knap opretSkærmOpretKnap;
Textfield TitelTextfelt;
Textfield LinkTextfelt;
Knap billedeKnap;
Knap filKnap;

float skalering = min(width, height) / 1000.0;
int skriftStørrelse = max(25, int(30 * skalering));  // Minimum 10 i størrelse

void opretSkærmSetup() {
  
  //laver knapperne
  opretSkærmTilbageKnap = new TilbageKnap(height/9-height/15, height/9-height/17, height/15*2, height/17*2, color(0), 
  "tilbage", 10, color(205, 139, 98), color(247, 239, 210), 10, opretSkærm);
  knapper.add(opretSkærmTilbageKnap);

  opretSkærmIndsætKnap = new Knap(1000*width/1920, 750*width/1920, 250*width/1920, 50*width/1920, color(247, 239, 210), 
  "Indsæt Udklipsfolder", skriftStørrelse, color(71, 92, 108), color(205, 139, 98), 0, opretSkærm);
  knapper.add(opretSkærmIndsætKnap);

  opretSkærmOpretKnap = new Knap(1000*width/1920, 850*width/1920, 500*width/1920, 100*width/1920, color(247, 239, 210), 
  "Opret opskrift", 40*width/1440, color(71, 92, 108), color(205, 139, 98), 0, opretSkærm);
  knapper.add(opretSkærmOpretKnap);

  // Tilføj en knap til at vælge billede
  billedeKnap = new Knap (1000*width/1920, 320*width/1920, 200*width/1440, 50*width/1920, color(247, 239, 210), 
  "Vælg billede", skriftStørrelse+5, color(71, 92, 108), color(205, 139, 98), 0, opretSkærm);
  knapper.add(billedeKnap);

  //Tilføj knap til at vælge fil
  filKnap =new Knap (1400*width/1920, 320*width/1920, 250*width/1920, 50*width/1920, color(247, 239, 210), 
  "Vælg fil", skriftStørrelse+5, color(71, 92, 108), color(205, 139, 98), 0, opretSkærm);
  knapper.add(filKnap);

  // Tilføj Textfield til link
  LinkTextfelt =( new Textfield(1270*width/1920, 750*width/1920, (width/4), 50*width/1920,
    color(71, 92, 108), color(247, 239, 210), color(247, 239, 210), color(247, 239, 210),
    20*width/1440, "Indsæt link til opskrift (https://...)", "", 0, opretSkærm, false));

  textfields.add(LinkTextfelt);

  // Tilføj et tekstfelt til opretSkærm
  TitelTextfelt = new Textfield( 100*width/1440, 300*height/1125, width/3, 67*height/982, color(71, 92, 108), color(247, 239, 210), color(247, 239, 210), color(247, 239, 210),
    30*width/1440, "Indtast opskriftens navn", "", 0, opretSkærm, false);
  textfields.add(TitelTextfelt);

  float højde=485*height/982;

  opretKategorierGroup = new SwitchGroup();
  String[] kategorier = {"Mænd", "Kvinder", "Baby (0-4 år)", "Barn (2-14 år)", "Hjem", "Højtider"};
  // Opret switches med nye positioner
  højde=lavSwitches4(opretKategorierGroup, kategorier, højde);
  for (int i=0; i<6; i++) {
    produkttypeGrupper.add(new SwitchGroup());
  }

  højde+=175*height/982;
  float startHøjde=højde;

  String[] mændProdukttyper = {"Veste", "Sweater", "Andet", "Strømper og Futsko", "Cardigans"};
  højde=lavSwitches4(produkttypeGrupper.get(0), mændProdukttyper, startHøjde);

  String[] kvindeProdukttyper = {"Huer", "Sweater", "Nederdele", "Bukser og shorts", "Veste", "Ponchoer", "Toppe", "Strømper og Futsko", "Bikinier", "Andet", "Cardigans", "Kjoler og Tunikaer", "Sjaler", "Tørklæder"};
  højde=lavSwitches4(produkttypeGrupper.get(1), kvindeProdukttyper, startHøjde);

  String[] babyProdukttyper ={ "Huer", "Cardigans", "Andet", "Kjoler og Tunikaer", "Køreposer", "Babytæpper", "Sweater", "Strømper og Støvler", "Hentesæt", "Veste og Toppe", "Ponchoer", "Sparkedragter o.lign", "Bukser og shorts"};
  højde=lavSwitches4(produkttypeGrupper.get(2), babyProdukttyper, startHøjde);

  String[] børnProdukttyper ={ "Kjoler og nederdele", "Cardigans", "Andet", "Bukser og Overalls", "Veste og Toppe", "Huer", "Sweater", "Strømper og Futsko"};
  højde=lavSwitches4(produkttypeGrupper.get(3), børnProdukttyper, startHøjde);

  String[] hjemProdukttyper ={"Æggevarmer", "Karklude", "Påske", "Puder og Puffer", "Bogmærker", "kurve", "Jul", "Dekorative Blomster", "Tæpper", "Børneværelse", "Betræk", "Gryddelapper o.lign.", "Siddeunderlag", "Dekorationer", "Kæledyr", "Glasunderlag o.lign."};
  højde=lavSwitches4(produkttypeGrupper.get(4), hjemProdukttyper, startHøjde);

  String[] højtiderProdukttyper ={"Påske", "Jul", "Halloween og Karnival", "Andet"};
  højde=lavSwitches4(produkttypeGrupper.get(5), højtiderProdukttyper, startHøjde);


  garnTypeGroup = new SwitchGroupA();

  højde+=175*height/982;
  // Laver alle switchesne
  String[] garnTyper = {"alpaka", "bomuld", "hør", "merino", "mohair", "silke", "uld"};
  højde=lavSwitches4(garnTypeGroup, garnTyper, højde);
}


void opretSkærmKnapper() {

  if (opretSkærmTilbageKnap.mouseOver()) {
    skærm=startSkærm;
    camY=0;
  }
  if (skærm==opretSkærm) {
    opskriftCreationFeedback=0;
  }
  opretKategorierGroup.checkMouse();
  if (opretKategorierGroup.switchValgt()) {
    String[] kategorier = {"Mænd", "Kvinder", "Baby (0-4 år)", "Barn (2-14 år)", "Hjem", "Højtider"};
    for (int i=0; i<6; i++) {
      if (kategorier[i]==opretKategorierGroup.getSelectedTitle()) {
        produkttypeGrupper.get(i).checkMouse();
        if (selectedSwitchGroup!=produkttypeGrupper.get(i)) {
          if (selectedSwitchGroup != null) {
            for (Switch switchs : selectedSwitchGroup.switches) {
              switchs.tændt=false;
            }
          }
          selectedSwitchGroup=produkttypeGrupper.get(i);
        }
        break;
      }
    }
  } else {
    selectedKategori=null;
    selectedSwitchGroup=null;
  }
  if (selectedSwitchGroup!= null) {
    if (selectedSwitchGroup.getSelectedSwitch() != null) {
      garnTypeGroup.checkMouse();
    }
  }

  // Hvis filens titel er klikket på, åbn PDF'en
  if (selectedPdfName != null && !selectedPdfName.isEmpty() &&
    mousePressed &&
    mouseX > linkRectX && mouseX < linkRectX + linkRectW &&
    mouseY > linkRectY && mouseY < linkRectY + linkRectH) {

    if (selectedPdfPath.toLowerCase().endsWith(".pdf")) {
      try {
        File pdfFile = new File(selectedPdfPath);
        if (pdfFile.exists()) {
          // Use our custom file opening function instead of Desktop.open
          openFile(selectedPdfPath);
        } else {
          println("Filen findes ikke: " + selectedPdfPath);
        }
      }
      catch (Exception e) {
        println("Fejl ved åbning af PDF: " + e.getMessage());
      }
    } else {
      println("Ugyldigt filformat. Kun PDF-filer understøttes.");
    }
  }

  if (mousePressed &&
    mouseX > krydsX && mouseX < krydsX + krydsW &&
    mouseY > krydsY && mouseY < krydsY + krydsH) {

    // Ryd PDF-data
    selectedPdfPath = "";
    selectedPdfName = "";
    println("PDF fjernet");
  }

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
    String produkttype="";
    Switch selectedSwitch=null;
    String[] kategorier = {"Mænd", "Kvinder", "Baby (0-4 år)", "Barn (2-14 år)", "Hjem", "Højtider"};
    for (int i=0; i<6; i++) {
      if (kategorier[i]==opretKategorierGroup.getSelectedTitle()) {
        if (produkttypeGrupper.get(i).getSelectedSwitch() !=null) {
          produkttype=produkttypeGrupper.get(i).getSelectedTitle();
          selectedSwitch=produkttypeGrupper.get(i).getSelectedSwitch();
          break;
        }
      }
    }
    //Tjekker om alle de nødvændige ting er udfyldt
    if (!TitelTextfelt.tekst.isEmpty()&& uploadedImage!=null && selectedSwitch != null && garnTypeGroup.switchValgt() && LinkTextfelt.tekst != null) {
      // kommer den nye opskrift i gemte opskrifter
      Opskrift nyOpskrift = new Opskrift(TitelTextfelt.tekst, opretKategorierGroup.getSelectedTitle(),
        LinkTextfelt.tekst, produkttype, uploadedImage);

      // Save the image to a file
      if (uploadedImage != null) {
        // Create directory if it doesn't exist
        File imgDir = new File(dataPath("images"));
        if (!imgDir.exists()) {
          imgDir.mkdirs();
          println("Created directory: " + imgDir.getAbsolutePath());
        }

        // Generate a safe filename
        String safeFileName = TitelTextfelt.tekst.replaceAll("[^a-zA-Z0-9]", "_") + ".png";
        String fileName = "images/" + safeFileName;

        // Save the image
        uploadedImage.save(dataPath(fileName));

        // Set the image URL in the recipe
        nyOpskrift.imageUrl = fileName;
        println("Image saved to: " + fileName);
      }

      // Set the file path if a PDF is selected
      if (selectedPdfPath != null && !selectedPdfPath.isEmpty()) {
        // Create directory if it doesn't exist
        File dir = new File(dataPath("pdf"));
        if (!dir.exists()) {
          dir.mkdirs();
          println("Created directory: " + dir.getAbsolutePath());
        }

        // Generate a safe filename
        String safeFileName = TitelTextfelt.tekst.replaceAll("[^a-zA-Z0-9]", "_") + ".pdf";
        String fileName = "pdf/" + safeFileName;

        try {
          // Copy the file
          File sourceFile = new File(selectedPdfPath);
          File destFile = new File(dataPath(fileName));

          println("Copying from: " + sourceFile.getAbsolutePath());
          println("Copying to: " + destFile.getAbsolutePath());

          // Create parent directories if they don't exist
          if (!destFile.getParentFile().exists()) {
            destFile.getParentFile().mkdirs();
          }

          // Use Java NIO for file copying
          java.nio.file.Files.copy(
            sourceFile.toPath(),
            destFile.toPath(),
            java.nio.file.StandardCopyOption.REPLACE_EXISTING
            );

          // Set the file path in the recipe
          nyOpskrift.filePath = fileName;
          println("File copied successfully to: " + fileName);
        }
        catch (Exception e) {
          println("Error copying file: " + e.getMessage());
          e.printStackTrace();
        }
      }
      gemteOpskrifter.add(nyOpskrift);
      int index=gemteOpskrifter.size();
      for (Switch switchs : garnTypeGroup.switches) {
        if (switchs.getState()) {
          gemteOpskrifter.get(index-1).tilfoejGarntype(switchs.getTitel());
          switchs.tændt=false;
        }
      }
      sendDataToServer(nyOpskrift);
      TitelTextfelt.tekst="";
      selectedSwitch.tændt=false;
      opretKategorierGroup.getSelectedSwitch().tændt=false;
      opskriftCreationFeedback=1;
      uploadedImage=null;
      selectedPdfPath = "";
      selectedPdfName = "";
      opskriftTimer=millis();
      saveRecipesToFile();
    } else {
      opskriftCreationFeedback=2;
      opskriftTimer=millis();
    }
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

  // Håndter billede-knap
  if (billedeKnap.mouseOver()) {
    selectImage();
  }

  // Håndter billede-knap
  if (filKnap.mouseOver()) {
    selectPdf();  // Kald funktionen til at vælge billede
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
    rect(width/2-width/8, height/2-height/16, width/4, height/8);
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

float lavSwitches4(SwitchGroup switchGroup, String[] liste, float startY) {
  float højde=startY;
  float size=30*width/1440;
  float bredde1=(580*width/1440)/4;
  float bredde2=(580*width/1440)/2;
  float bredde3=(580*width/1440)/4*3;
  float bredde4=(580*width/1440)/4*4;
  float[] bredder = {bredde1, bredde2, bredde3, bredde4};
  int counter=0;
  boolean stop=false;
  while (!stop) {
    for (int i=0; i<4; i++) {
      switchGroup.addSwitch(new Switch(bredder[i], højde, size, liste[counter], false));
      counter++;
      if (counter==liste.length) {
        break;
      }
    }
    if (counter==liste.length) {
      break;
    }
    højde+=90*height/982;
  }
  return højde;
}

float lavSwitches03(SwitchGroup switchGroup, String[] liste, float startY) {
  float højde=startY;
  float size=30*width/1440;
  float bredde1=(580*width/1440)/4-50;
  float bredde2=(580*width/1440)/2-40;
  float bredde3=(580*width/1440)/4*3;
  float[] bredder = {bredde1, bredde2, bredde3};
  int counter=0;
  boolean stop=false;
  while (!stop) {
    for (int i=0; i<3; i++) {
      switchGroup.addSwitch(new Switch(bredder[i], højde, size, liste[counter], false));
      counter++;
      if (counter==liste.length) {
        break;
      }
    }
    if (counter==liste.length) {
      break;
    }
    højde+=90*height/982;
  }
  return højde;
}

void lavSwitches3(String[] produkttyper, String kategori) {
  ArrayList<String> liste = kategoriTilProdukter.get(kategori);
  if (liste != null) {
    for (String p : produkttyper) {
      liste.add(p);
    }
  }
}
