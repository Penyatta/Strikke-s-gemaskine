//Library til at lave tekstfelter
import controlP5.*;

ControlP5 cp5;

//Værdi der bruges til at display når der scrolles
int camY=0;

//String[] tags = {"Vinter", "Forår", "Sommer", "Efterår"};

PFont generalFont;
PFont boldFont;

int skyggeAfstand=5;

//State maschine der holder styr på hvilken skærm der skal vises
//man kan skifte mellem de forskellige skærme ved at sætte skærm= (navnet på skærmen der refereres til)
int startSkærm=0;
int søgeSkærm=1;
int mitSkærm=2;
int opretSkærm=3;
int hjælpSkærm=4;
int skærm=startSkærm;

void setup() {
  fullScreen();
  cp5=new ControlP5(this); 
  //funktioner der kører de dele der kræves i setup for hver skærm
  startSkærmSetup();
  hjælpSkærmSetup();
  søgeSkærmSetup();
  mitSkærmSetup();
  opretSkærmSetup();
  loadOpskrifter("opskrifter.json");
  generalFont=createFont("InriaSerif-Regular.ttf",32);
  boldFont=createFont("InriaSerif-Bold.ttf",32);
  
}
void draw() {
  background(100);
  //fordeling på statemachine, hvis skærm værdi er lig en specifik skærm er det den som skal vises
  if (skærm==startSkærm) {
    startSkærm();
  } else if (skærm==søgeSkærm) {
    søgeSkærm();
  } else if (skærm==mitSkærm) {
    mitSkærm();
  } else if (skærm==opretSkærm) {
    opretSkærm();
  } else if (skærm==hjælpSkærm) {
    hjælpSkærm();
  } else {
    //Hvis det ikke er en valid værdi for skærm ender programmet her og der printes en fejl til konsollen
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

void mouseDragged(){
 if (skærm==opretSkærm){
   
 }
}

void mousePressed(){
  //kører knap funktionerne der tjekker om knapperne tilhørende de forskellige skærme er blevet trykket på
  startSkærmKnapper();
  søgeSkærmKnapper();
  hjælpSkærmKnapper();
  mitSkærmKnapper();
  opretSkærmKnapper();
}


void keyPressed(){
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
