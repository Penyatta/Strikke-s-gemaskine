void opretSkærm(){
  background(255);
  overskriftBjælke("Tilføj din egen opskrift");
}

Knap opretSkærmTilbageKnap;

void opretSkærmSetup(){
  //laver knapperne
  opretSkærmTilbageKnap = new TilbageKnap(height/9-height/15, height/9-height/17, height/15*2, height/17*2, color(0), "tilbage", 10, color(205, 139, 98), color(0, 255, 0), 10, opretSkærm);
  knapper.add(opretSkærmTilbageKnap);
}

void opretSkærmKnapper(){
  if(opretSkærmTilbageKnap.mouseOver()){
  skærm=startSkærm;
  }
  
}
