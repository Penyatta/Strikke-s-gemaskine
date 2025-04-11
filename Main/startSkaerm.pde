void startSkærm() {
  background(255);
  overskriftBjælke("StrikkeGuiden");
}

//Opretter knapperne til at starte med
Knap startSkærmSøgeKnap;
Knap startSkærmOpretKnap;
Knap startSkærmMitKnap;


void startSkærmSetup() {
  //Tilføjer egenskaberne til kanpperne som er blevet oprettet tidligere og tilføjer dem til en array list med alle knapper i knap klassen
  startSkærmSøgeKnap = new Knap(width/2-width/10, height/5*3-width/10, width/5, width/5, color(247, 239, 210), "Søg efter opskrifter", 10, color(71, 92, 108), color(0, 255, 0), 0, startSkærm);
  knapper.add(startSkærmSøgeKnap);
  startSkærmOpretKnap = new Knap(width/10*7, height/5*3-width/10, width/5, width/5, color(247, 239, 210), "Tilføj din egen opskrift", 10, color(71, 92, 108), color(0, 255, 0), 0, startSkærm);
  knapper.add(startSkærmOpretKnap);
  startSkærmMitKnap = new Knap(width/10, height/5*3-width/10, width/5, width/5, color(247, 239, 210), "Min profil", 10, color(71, 92, 108), color(0, 255, 0), 0, startSkærm);
  knapper.add(startSkærmMitKnap);
}

void startSkærmKnapper() {
  //funktion der kører i mousePressed der tjekker om musen var over en knap og det er dermed de ting som der skal se når en knap trykkes som køres her
  if (startSkærmSøgeKnap.mouseOver()) {
    skærm=søgeSkærm;
  }
  if (startSkærmOpretKnap.mouseOver()) {
    skærm=opretSkærm;
  }
  if (startSkærmMitKnap.mouseOver()) {
    skærm=mitSkærm;
  }
}
