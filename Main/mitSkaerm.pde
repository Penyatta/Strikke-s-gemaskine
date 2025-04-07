void mitSkærm(){
  background(255);
}

Knap mitSkærmTilbageKnap;

void mitSkærmSetup(){
  //laver knapperne
  mitSkærmTilbageKnap = new TilbageKnap(width/8, height/16, width/16, height/16, color(0), "tilbage", 10, color(255, 0, 0), color(0, 255, 0), 10, mitSkærm);
  knapper.add(mitSkærmTilbageKnap);
}

void mitSkærmKnapper(){
  if(mitSkærmTilbageKnap.mouseOver()){
  skærm=startSkærm;
  }
}
