

//Library til at lave tekstfelter
import controlP5.*;
ControlP5 cp5;

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
int camY=0;
int lastY; // To track mouse movement
int scrollSpeed = 10; // You can adjust this value
int maxScroll = 2000; // Maximum scroll limit (adjust based on your content)
int lastMouseY;

void setup() {
  fullScreen();
  cp5=new ControlP5(this);
  //funktioner der kører de dele der kræves i setup for hver skærm
  startSkærmSetup();
  hjælpSkærmSetup();
  søgeSkærmSetup();
  mitSkærmSetup();
  opretSkærmSetup();
  //loadOpskrifter("opskrifter.json");
  generalFont=createFont("InriaSerif-Regular.ttf", 32);
  boldFont=createFont("InriaSerif-Bold.ttf", 32);
  // Initialize lastY for drag scrolling
  lastMouseY = mouseY; // Initialize lastMouseY
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

  //tegner knapper
  for (Knap k : knapper) {
    k.tegn();
  }
  for (Textfield field : textfields) {
    field.tegnPåSkærm();
  }
}

// Replace your mouseDragged function with this version
void mouseDragged() {
  // Only scroll in screens that need scrolling
  if (skærm == søgeSkærm || skærm == opretSkærm) {
    // Calculate difference from last position
    int diff = mouseY - lastMouseY;

    // Update camY (move opposite to drag direction for natural scrolling)
    camY -= diff;

    // Calculate maximum scroll based on content amount
    int maxScroll = 1000; // Default value

    if (skærm == søgeSkærm && !opskrifter.isEmpty()) {
      // Calculate based on number of recipes
      maxScroll = int((height/5*2 + (height/4 + height/32) * opskrifter.size()) - height + 100);
    }

    // Boundary checks
    if (camY < 0) camY = 0;
    if (camY > maxScroll && maxScroll > 0) camY = maxScroll;
  }

  // Update last position
  lastMouseY = mouseY;
}
void mousePressed() {
  //kører knap funktionerne der tjekker om knapperne tilhørende de forskellige skærme er blevet trykket på
  startSkærmKnapper();
  søgeSkærmKnapper();
  hjælpSkærmKnapper();
  mitSkærmKnapper();
  opretSkærmKnapper();
}

void mouseWheel(MouseEvent event) {
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
