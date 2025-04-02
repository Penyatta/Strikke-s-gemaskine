//Library til at lave knapper og tekstfelter
import controlP5.*;

ControlP5 cp5;

//Værdi der bruges til at display når der scrolles
int camY=0;

String[] tags = {"Vinter", "Forår", "Sommer", "Efterår"};

//State maschine der holder styr på hvilken skærm der skal vises
//man kan skifte mellem de forskellige skærme ved at sætte skærm= (navnet på skærmen der refereres til)
int startSkærm=0;
int søgeSkærm=1;
int mitSkærm=2;
int opretSkærm=3;
int indstillingerSkærm=4;
int skærm=startSkærm;

void setup() {
  fullScreen();
  cp5=new ControlP5(this); 
  startSkærmSetup();
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
  } else if (skærm==indstillingerSkærm) {
    indstillingerSkærm();
  } else {
    //Hvis det ikke er en valid værdi for skærm ender programmet her og der printes en fejl til konsollen
    println("error - skærm ikke defineret rigtigt");
  }
  //tegner knapper
  for (Knap k : knapper) {
    k.tegn();
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
}
