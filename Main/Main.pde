import java.util.Arrays;



import java.awt.Desktop;
import java.io.File;
import java.io.IOException;
import java.net.URI;
import java.net.URISyntaxException;


PFont generalFont;
PFont boldFont;

int skyggeAfstand = 5;

//State maschine der holder styr på hvilken skærm der skal vises
//man kan skifte mellem de forskellige skærme ved at sætte skærm= (navnet på skærmen der refereres til)
int startSkærm=0;
int søgeSkærm=1;
int mitSkærm=2;
int opretSkærm=3;
int hjælpSkærm=4;
int skærm=startSkærm;

//Værdi der bruges til at display når der scrolles
float camY=0;
//holdet styr på musens sidste position til brug i scroll
int lastY;
//Hvorhurtigt man kan scroll
int scrollSpeed = 10;
// Hvor langt man kan scroll ned justeres baseret på længden af siden
float maxScroll = 2000;
int lastMouseY;

// Scrollbar
float scrollBarX;
float scrollBarY;
float scrollBarW = 25;
float scrollBarH = 0; // Bruges til at beregne højde på scrollbar
boolean scrollbarAktiv = false;
float scrollOffsetY;
// ændres undervejs
float scrollContentHeight = 3000;


void setup() {
  fullScreen();
  //funktioner der kører de dele der kræves i setup for hver skærm
  generalFont=createFont("InriaSerif-Regular.ttf", 32);
  boldFont=createFont("InriaSerif-Bold.ttf", 32);
  startSkærmSetup();
  hjælpSkærmSetup();
  søgeSkærmSetup();
  mitSkærmSetup();
  opretSkærmSetup();


  // Initialisere musens sudste position iY
  lastMouseY = mouseY;

  italicFont = loadFont("Arial-ItalicMT-15.vlw");  // Fontnavnet skal passe til systemets skrifttyper
}

void draw() {
  background(100);
  // Skærmfordeling via state machine
  if (skærm == startSkærm) {
    startSkærm();
  } else if (skærm == søgeSkærm) {
    søgeSkærm();
  } else if (skærm == mitSkærm) {
    mitSkærm();
  } else if (skærm == opretSkærm) {
    opretSkærm();
  } else if (skærm == hjælpSkærm) {
    hjælpSkærm();
  } else {
    println("error - skærm ikke defineret rigtigt");
  }

  for (Textfield field : textfields) {
    field.tegnPåSkærm();
  }
  //tegner knapper
  for (Knap k : knapper) {
    k.tegn();
  }
  //hvis man er inde på en af de tre skærme skal den tegnes
  if (skærm == søgeSkærm || skærm == opretSkærm || skærm == mitSkærm) {
    scrollBarX = width - scrollBarW;
    tegnScrollbar();    // tegner scrollbaren i uændret koordinatsystem
  }
  //hvis man er inde på søgeskærmen eller opretskærm så skal søgefeltene forsvinde under overskriftbjælken, men ikke tilbageknap og hjælpknap
  if (skærm==opretSkærm) {
    overskriftBjælke("Tilføj din egen opskrift");
    opretSkærmTilbageKnap.tegn();
    hjælpKnap.tegn();
  }
  if (skærm == søgeSkærm) {
    overskriftBjælke("Søg efter opskrifter");
    søgeSkærmTilbageKnap.tegn();
    hjælpKnap.tegn();
  }

  //  loaderAngle += 0.5;
  //if (loaderAngle > TWO_PI) loaderAngle = 0;
}


void tegnScrollbar() {
  // justere højden på scrollbar
  if (skærm == søgeSkærm && !visteOpskrifter.isEmpty()) {
    scrollContentHeight = height/5*2 + (height/4 + height/32) * visteOpskrifter.size();
  } else {
    scrollContentHeight = 3000;
  }

  maxScroll = scrollContentHeight - height;
  if (maxScroll < 0) maxScroll = 0;

  float scrollRatio = (float) height / scrollContentHeight;
  scrollBarH = constrain(height * scrollRatio, 30, height);

  scrollBarY = map(camY, 0, maxScroll, height/9*2, height - scrollBarH);

  noStroke();
  fill(200);
  // Tegn selve scrollbaren
  noStroke();
  fill(200);
  rect(scrollBarX, height/9*2, scrollBarW, 2*height); // scrollbar baggrund
  fill(100);
  rect(scrollBarX+4*width/1920, scrollBarY, scrollBarW-8*width/1920, scrollBarH, scrollBarW/2); // håndtaget
}



void mouseDragged() {
  // hvis skærmen er en hvor der kan scrolles
  if (skærm == søgeSkærm || skærm == opretSkærm || skærm == mitSkærm) {
    // beregner forskellen mellem nuværende og sidste musY
    int diff = mouseY - lastMouseY;

    if (!scrollbarAktiv && abs(diff) > 1) {
      camY -= diff;
      camY = constrain(camY, 0, maxScroll);
    }
    //Ændre position af scrollbar og camY til at afspejle ændringen i musY
    if (scrollbarAktiv) {
      scrollBarY = mouseY - scrollOffsetY;
      scrollBarY = constrain(scrollBarY, height/9*2, height - scrollBarH);
      camY = map(scrollBarY, height/9*2, height - scrollBarH, 0, maxScroll);
    }
    //gemmer nuværende musY til at være sidste frame musY
    lastMouseY = mouseY;
  }
}


void mousePressed() {
  //gemmer nuværende musY til at være sidste musY
  lastMouseY = mouseY;

  //kører knap funktionerne der tjekker om knapperne tilhørende de forskellige skærme er blevet trykket på
  startSkærmKnapper();
  if (skærm==søgeSkærm) {
    søgeSkærmKnapper();
  }
  hjælpSkærmKnapper();
  if (skærm==mitSkærm) {
    mitSkærmKnapper();
  }
  opretSkærmKnapper();


  // Aktivere tekstfelter hvis musen er over dem
  for (Textfield tf : textfields) {
    if (skærm == tf.textfieldSkærm && tf.mouseOver()) {
      activeField = tf;
      tf.active = true;

      // Hvis det ligner et link, og brugeren klikker på det – åbn det
      if (tf.tekst.startsWith("http")) {
        link(tf.tekst);
      }
      break;
    } else {
      tf.active = false;
    }
  }
  //Tjekker om musen er over scroll håndtaget
  if (skærm == søgeSkærm || skærm == opretSkærm || skærm == mitSkærm) {
    if (mouseX > scrollBarX && mouseX < scrollBarX + scrollBarW &&
      mouseY > scrollBarY && mouseY < scrollBarY + scrollBarH) {
      scrollbarAktiv = true;
      scrollOffsetY = mouseY - scrollBarY;  // Gem hvor du klikkede inde i scrollbaren
    }
  }
  
  

  for (KlikOmråde ko : klikOmråder) {
    if (ko.erKlikket(mouseX, mouseY)) {
      println("Åbner link: " + ko.url);  // Til fejlsøgning

      if (ko.url != null && !ko.url.equals("")) {
        // Check om det er en lokal fil path
        if (ko.url.startsWith("LOCAL:")) {
          String filePath = ko.url.substring(6); // Fjerner ordet loacal fra det
          println("Opening local file: " + filePath);

          // åbner filen
          openFile(dataPath(filePath));
        } else {
          // For normale links bruges link funktionen
          link(ko.url);
        }
      } else {
        println("❌ URL er null eller tom.");
      }
      break;
    }
  }
}        //slut mousePressed


void mouseReleased() {
  scrollbarAktiv = false;
}

void mouseWheel(MouseEvent event) {
  //Scroller hvis man er på den rigtige skærm til det
  if (skærm == søgeSkærm || skærm == opretSkærm || skærm == mitSkærm) {
    float e = event.getCount();
    camY += e * scrollSpeed;
    camY = constrain(camY, 0, maxScroll);
  }
}

void keyPressed() {
  if (activeField != null) {
    // Tjekker om det er slet man klikker på
    if (key == BACKSPACE && activeField.tekst.length() > 0) {
      activeField.tekst = activeField.tekst.substring(0, activeField.tekst.length() - 1);
    }
    // Normale tryk. Skal være normale keys, ikke backspace og ikke enter.
    else if (key != CODED && key != BACKSPACE && key != ENTER) {
      activeField.tekst += key;
    }
  }
}

void openFile(String filePath) {
  try {
    File file = new File(filePath);

    // Check om filen eksisterer
    if (!file.exists()) {
      println("File does not exist: " + filePath);
      return;
    }

    // Check om desktop kan gøres
    if (Desktop.isDesktopSupported()) {
      try {
        Desktop.getDesktop().open(file);
        println("Opening file with system default application: " + filePath);
      }
      catch (Exception e) {
        // Hvis mna ikke kan åben det med en standard application åbnes det i browseren
        println("Could not open with default application, trying browser: " + e.getMessage());
        String fileURL = "file:///" + file.getAbsolutePath().replace("\\", "/");
        openURL(fileURL);
      }
    } else {
      // Hvis desktop ikke er supported åben i browser
      println("Desktop not supported, trying browser");
      String fileURL = "file:///" + file.getAbsolutePath().replace("\\", "/");
      openURL(fileURL);
    }
  }
  catch (Exception e) {
    println("Error opening file: " + e.getMessage());
    e.printStackTrace();
  }
}

// function til at åbne urls i browser
void openURL(String url) {
  try {
    if (Desktop.isDesktopSupported() && Desktop.getDesktop().isSupported(Desktop.Action.BROWSE)) {
      Desktop.getDesktop().browse(new URI(url));
      println("Opening URL in browser: " + url);
    } else {
      // Hvis browser ikke er supported
      String[] browserCmd = new String[0];

      // Tejkker browser systemet og bruger den rigtige komando
      String os = System.getProperty("os.name").toLowerCase();
      if (os.contains("win")) {
        browserCmd = new String[]{"cmd", "/c", "start", url};
      } else if (os.contains("mac")) {
        browserCmd = new String[]{"open", url};
      } else if (os.contains("nix") || os.contains("nux")) {
        browserCmd = new String[]{"xdg-open", url};
      }

      if (browserCmd.length > 0) {
        Runtime.getRuntime().exec(browserCmd);
        println("Opening URL with system command: " + url);
      } else {
        println("Could not determine browser command for OS: " + os);
      }
    }
  }
  catch (Exception e) {
    println("Error opening URL: " + e.getMessage());
    e.printStackTrace();
  }
}
