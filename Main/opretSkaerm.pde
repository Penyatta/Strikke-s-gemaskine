void opretSkærm(){
  
}

Knap opretSkærmTilbageKnap;

void opretSkærmSetup(){
  //laver knapperne
  opretSkærmTilbageKnap = new TilbageKnap(width/8, height/16, width/16, height/16, color(0), "tilbage", 10, color(255, 0, 0), color(0, 255, 0), 10, opretSkærm);
  knapper.add(opretSkærmTilbageKnap);
}

void opretSkærmKnapper(){
  if(opretSkærmTilbageKnap.mouseOver()){
  skærm=startSkærm;
  }
}
