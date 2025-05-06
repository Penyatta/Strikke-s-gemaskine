import java.util.Arrays;


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
int lastY; // To track mouse movement
int scrollSpeed = 10; // You can adjust this value
float maxScroll = 2000; // Maximum scroll limit (adjust based on your content)
int lastMouseY;

// Scrollbar
float scrollBarX;
float scrollBarY;
float scrollBarW = 25;
float scrollBarH;
boolean scrollbarAktiv = false;
float scrollOffsetY;
float scrollBarYOffset = 300;
float scrollContentHeight = 3000; // Initial værdi


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
  //loadOpskrifter("opskrifter.json");

  // Initialize lastY for drag scrolling
  lastMouseY = mouseY; // Initialize lastMouseY

  //scrollBarX = width - scrollBarW - 10; // 10 px fra højre kant
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
  if (skærm==opretSkærm) {
    overskriftBjælke("Tilføj din egen opskrift");
    opretSkærmTilbageKnap.tegn();
    hjælpKnap.tegn();
  }

  //hvis man er inde på søgeskærmen eller opretskærm så skal søgefeltene forsvinde under overskriftbjælken, men ikke tilbageknap og hjælpknap
  if (skærm == søgeSkærm) {
    overskriftBjælke("Søg efter opskrifter");
    søgeSkærmTilbageKnap.tegn();
    hjælpKnap.tegn();
  }

  //hvis man er inde på en af de tre skærme skal den tegnes
  if (skærm == søgeSkærm || skærm == opretSkærm || skærm == mitSkærm) {
    scrollBarX = width - scrollBarW;
    tegnScrollbar();    // tegner scrollbaren i uændret koordinatsystem
  }
}


void tegnScrollbar() {
  // Dynamisk opdatering af indholdshøjde afhængig af skærm
  if (skærm == søgeSkærm && !alleOpskrifter.isEmpty()) {
    scrollContentHeight = height/5*2 + (height/4 + height/32) * alleOpskrifter.size();
  } else {
    scrollContentHeight = 3000; // fallback
  }

  // Opdater maxScroll baseret på indhold
  maxScroll = scrollContentHeight - height;
  if (maxScroll < 0) maxScroll = 0;

  float scrollRatio = (float) height / scrollContentHeight;
  scrollBarH = constrain(height * scrollRatio, 30, height);  // Minimum højde

  scrollBarY = map(camY, 0, maxScroll, 0, height - scrollBarH);

  // Tegn scrollbar-baggrund og håndtag
  noStroke();
  fill(200);
  rect(scrollBarX, 0, scrollBarW, height);
  fill(100);
  rect(scrollBarX, scrollBarY, scrollBarW, scrollBarH);
}



float scrollRatio = (float) height / scrollContentHeight;
scrollBarH = constrain(height * scrollRatio, 30, height);  // Minimum højde på scrollbar
scrollBarY = map(camY, 0, maxScroll, 0, height - scrollBarH);


// Tegn selve scrollbaren
noStroke();
fill(200);
rect(width - 25, 0, scrollBarW, height*2-100); // Baggrund
fill(100);
rect(width - 25, scrollBarY, scrollBarW, scrollBarH); // Positioner scrollbar korrekt
}



void mouseDragged() {
  if (skærm == søgeSkærm || skærm == opretSkærm || skærm == mitSkærm) {
    int diff = mouseY - lastMouseY;

    if (!scrollbarAktiv && abs(diff) > 1) {
      camY -= diff;
      camY = constrain(camY, 0, maxScroll);
    }

    if (scrollbarAktiv) {
      scrollBarY = mouseY - scrollOffsetY;
      scrollBarY = constrain(scrollBarY, 0, height - scrollBarH);
      camY = map(scrollBarY, 0, height - scrollBarH, 0, maxScroll);
    }

    lastMouseY = mouseY;
  }
}


void mousePressed() {

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
  for (Textfield field : textfields) {
    if (field.mouseOver()) {
      if (activeField != null) {
        activeField.deactivate(); // Deactivater alle felter
      }
      field.activate(); // Activater det field man klikker på
      return;
    }
  }

  for (Textfield tf : textfields) {
    if (skærm == tf.textfieldSkærm && overField(tf)) {
      activeField = tf;
      tf.active = true;

      // Hvis det ligner et link, og brugeren klikker på det – åbn det
      if (tf.tekst.startsWith("http")) {
        link(tf.tekst);
      }
    } else {
      tf.active = false;
    }
  }

  // Hvis musen er over scrollbaren, aktiver scrollbar
  if (skærm == søgeSkærm || skærm == opretSkærm || skærm == mitSkærm) {
    if (mouseX > scrollBarX && mouseX < scrollBarX + scrollBarW &&
      mouseY > scrollBarY && mouseY < scrollBarY + scrollBarH) {
      scrollbarAktiv = true;
      scrollOffsetY = mouseY - scrollBarY;  // Gem hvor du klikkede inde i scrollbaren
    }
  }
}
// Hjælpefunktion til at tjekke om musen er over et tekstfelt
boolean overField(Textfield tf) {
  return mouseX > tf.posX && mouseX < tf.posX + tf.sizeX &&
    mouseY > tf.posY && mouseY < tf.posY + tf.sizeY;
}

void mouseReleased() {
  scrollbarAktiv = false;
}

void mouseWheel(MouseEvent event) {

  if (skærm == søgeSkærm || skærm == opretSkærm || skærm == mitSkærm) {

    if (skærm == søgeSkærm || skærm == opretSkærm || skærm == mitSkærm) {
      float e = event.getCount();
      camY += e * scrollSpeed;
      camY = constrain(camY, 0, maxScroll);
    }
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
