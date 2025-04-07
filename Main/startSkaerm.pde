void startSkærm() {
  background(255);
}

//Opretter knapperne til at starte med
Knap startSkærmSøgeKnap;
Knap startSkærmOpretKnap;
Knap startSkærmMitKnap;


void startSkærmSetup() {
  //Tilføjer egenskaberne til kanpperne som er blevet oprettet tidligere og tilføjer dem til en array list med alle knapper i knap klassen
  startSkærmSøgeKnap = new Knap(width/6*2-width/32, height/2, width/16, height/16, color(0), "Søg", 10, color(255, 0, 0), color(0, 255, 0), 10, startSkærm);
  knapper.add(startSkærmSøgeKnap);
  startSkærmOpretKnap = new Knap(width/6*3-width/32, height/2, width/16, height/16, color(0), "Opret", 10, color(255, 0, 0), color(0, 255, 0), 10, startSkærm);
  knapper.add(startSkærmOpretKnap);
  startSkærmMitKnap = new Knap(width/6*4-width/32, height/2, width/16, height/16, color(0), "Mit", 10, color(255, 0, 0), color(0, 255, 0), 10, startSkærm);
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
