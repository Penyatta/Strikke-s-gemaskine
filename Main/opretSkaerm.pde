void opretSkærm(){
  
}

Knap opretSkærmTilbageKnap;
Knap opretSkærmOpretKnap;

void opretSkærmSetup(){
  //laver knapperne
  opretSkærmTilbageKnap = new TilbageKnap(width/8, height/16, width/16, height/16, color(0), "tilbage", 10, color(255, 0, 0), color(0, 255, 0), 10, opretSkærm);
  knapper.add(opretSkærmTilbageKnap);
  opretSkærmOpretKnap = new Knap(width/2, height/2, width/16, height/16, color(0), "Opret", 10, color(255, 0, 0), color(0, 255, 0), 10, opretSkærm);
  knapper.add(opretSkærmOpretKnap);
}

void opretSkærmKnapper(){
  if(opretSkærmTilbageKnap.mouseOver()){
  skærm=startSkærm;
  }
  if(opretSkærmOpretKnap.mouseOver()){
  saveOpskrifter("data/opskrifter.json");
  }
}
