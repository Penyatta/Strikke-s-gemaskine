void opretSkærm(){
  background(255);
  overskriftBjælke("Tilføj din egen opskrift");
}

Knap opretSkærmTilbageKnap;
Knap opretSkærmOpretKnap;

void opretSkærmSetup(){
  //laver knapperne
  opretSkærmTilbageKnap = new TilbageKnap(height/9-height/15, height/9-height/17, height/15*2, height/17*2, color(0), "tilbage", 10, color(205, 139, 98), color(0, 255, 0), 10, opretSkærm);
  knapper.add(opretSkærmTilbageKnap);
  opretSkærmOpretKnap = new Knap(width/2, height/2, width/16, height/16, color(0), "Opret", 10, color(255, 0, 0), color(0, 255, 0), 10, opretSkærm);
  knapper.add(opretSkærmOpretKnap);
}

void opretSkærmKnapper(){
  if(opretSkærmTilbageKnap.mouseOver()){
  skærm=startSkærm;
  }
  if(opretSkærmOpretKnap.mouseOver()){
  saveOpskrifter("opskrifter.json");
  }
}
