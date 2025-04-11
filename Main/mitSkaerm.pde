void mitSkærm(){
  background(255);
  overskriftBjælke("Min profil");
}

Knap mitSkærmTilbageKnap;

void mitSkærmSetup(){
  //laver knapperne
  mitSkærmTilbageKnap = new TilbageKnap(height/9-height/15, height/9-height/17, height/15*2, height/17*2, color(0), "tilbage", 10, color(205, 139, 98), color(0, 255, 0), 10, mitSkærm);
  knapper.add(mitSkærmTilbageKnap);
}

void mitSkærmKnapper(){
  if(mitSkærmTilbageKnap.mouseOver()){
  skærm=startSkærm;
  }
}
