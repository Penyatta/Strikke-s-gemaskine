void søgeSkærm(){
  
}

Knap søgeSkærmTilbageKnap;

void søgeSkærmSetup(){
  //laver knapperne
  søgeSkærmTilbageKnap = new TilbageKnap(width/8, height/16, width/16, height/16, color(0), "tilbage", 10, color(255, 0, 0), color(0, 255, 0), 10, søgeSkærm);
  knapper.add(søgeSkærmTilbageKnap);
}

void søgeSkærmKnapper(){
  if(søgeSkærmTilbageKnap.mouseOver()){
  skærm=startSkærm;
  }
}
