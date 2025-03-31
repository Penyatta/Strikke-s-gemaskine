int camY=0;
String[] tags = {"Vinter", "Forår", "Sommer", "Efterår"};
int startSkærm=0;
int søgeSkærm=1;
int mitSkærm=2;
int opretSkærm=3;
int indstillingerSkærm=4;
int skærm=startSkærm;

void setup() {
  fullScreen();
 
}
void draw() {
 if(skærm==startSkærm){
   startSkærm();
 }
 else if(skærm==søgeSkærm){
   søgeSkærm();
 }
 else if(skærm==mitSkærm){
   mitSkærm();
 }
 else if(skærm==opretSkærm){
   opretSkærm();
 }
 else if(skærm==indstillingerSkærm){
   indstillingerSkærm();
 }
 else{
  println("error - skærm ikke defineret rigtigt"); 
 }
}
