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
  if (skærm==opretSkærm){
    overskriftBjælke("Tilføj din egen opskrift");
    opretSkærmTilbageKnap.tegn();
    hjælpKnap.tegn();
  }
  
  //hvis man er inde på søgeskærmen eller opretskærm så skal søgefeltene forsvinde under overskriftbjælken, men ikke tilbageknap og hjælpknap
  if(skærm == søgeSkærm){
    overskriftBjælke("Søg efter opskrifter");
    søgeSkærmTilbageKnap.tegn();
    hjælpKnap.tegn();
  }
  
  //hvis man er inde på en af de tre skærme skal den tegnes
  if (skærm == søgeSkærm || skærm == opretSkærm || skærm == mitSkærm) {
    scrollBarX = width - scrollBarW - 10; 
    tegnScrollbar();    // tegner scrollbaren i uændret koordinatsystem

}
}


void tegnScrollbar() {
  
  float scrollContentHeight = 2000; // total højde af indhold, justér evt.

  // Dynamisk opdatering af maxScroll afhængig af antal opskrifter
  if (skærm == søgeSkærm && !opskrifter.isEmpty()) {
    maxScroll = int((height/5*2 + (height/4 + height/32) * opskrifter.size()) - height + 100);
    scrollContentHeight = maxScroll + height;
  }


  float scrollRatio = (float) height / scrollContentHeight;
  scrollBarH = constrain(height * scrollRatio, 30, height);  // Dynamisk justering af højden
  scrollBarY = map(camY, 0, maxScroll, 0, height - scrollBarH);


  // Tegn selve scrollbaren
  noStroke();
  fill(200);
  rect(width - 25, 0, scrollBarW, height*2-100); // Baggrund
  fill(100);
  rect(width - 25, scrollBarY+scrollBarYOffset, scrollBarW, scrollBarH); // Positioner scrollbar korrekt
 
}


 
void mouseDragged() {
  // Kun scroll når vi er på de relevante skærme
  if (skærm == søgeSkærm || skærm == opretSkærm || skærm == mitSkærm) {
    // Beregn forskel i musebevægelse
    int diff = mouseY - lastMouseY;

    // Opdater camY (scrollen), der bevæger sig modsat musebevægelsen for naturlig scrolling
    camY -= diff;

    // Juster maxScroll afhængig af indhold
    int maxScroll = 1000;

    if (skærm == søgeSkærm && !opskrifter.isEmpty()) {
      maxScroll = int((height/5*2 + (height/4 + height/32) * opskrifter.size()) - height + 100);
    }

    // Begræns scrolling
    if (camY < 0) camY = 0;
    if (camY > maxScroll && maxScroll > 0) camY = maxScroll;
  }

  // Opdater sidste position
  lastMouseY = mouseY;

  // Hvis scrollbaren er aktiv, opdater scrollBarY og camY
  if (scrollbarAktiv) {
    scrollBarY = mouseY - scrollOffsetY;
    scrollBarY = constrain(scrollBarY, 0, height - scrollBarH);
    camY = map(scrollBarY, 0, height - scrollBarH, 0, maxScroll);
  }
}


void mousePressed() {
  // Kører knap funktionerne der tjekker om knapperne tilhørende de forskellige skærme er blevet trykket på
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
  
  // Hvis musen er over scrollbaren, aktiver scrollbar
  if (skærm == søgeSkærm || skærm == opretSkærm || skærm == mitSkærm) {
    if (mouseX > scrollBarX && mouseX < scrollBarX + scrollBarW &&
        mouseY > scrollBarY+scrollBarYOffset && mouseY < scrollBarY+scrollBarYOffset + scrollBarH) {
      scrollbarAktiv = true;
      scrollOffsetY = mouseY - (scrollBarY+scrollBarYOffset);
    }
  }
}

void mouseReleased() {
  scrollbarAktiv = false;
}

void mouseWheel(MouseEvent event) {

  if (skærm == søgeSkærm || skærm == opretSkærm || skærm == mitSkærm) {

    // Using mouse wheel for scrolling (positive = scroll down, negative = scroll up)
    float e = event.getCount();

    // Update camY based on mouse wheel direction, constrained to prevent over-scrolling
    camY += e * scrollSpeed;

    // Prevent scrolling above the top
    if (camY < 0) {
      camY = 0;
    }

    // Prevent scrolling too far down (adjust maxScroll based on your content)
    if (camY > maxScroll) {
      camY = maxScroll;
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
