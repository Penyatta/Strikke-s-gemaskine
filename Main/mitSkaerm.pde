
String valgtType = "Ingen valgt";

void mitSkærm(){
  background(255);
  overskriftBjælke("Min profil");
  rect(580*width/1440,202*width/1440,18*width/1440,780*width/1440);
  fill(#475C6C);
  text("Mit garn", 280,260);
  text("Gemte opskrifter", 1020,260);

 //text("Valgt type: " + valgtType, 100, 250);
}

Knap mitSkærmTilbageKnap;

void mitSkærmSetup(){
 
  //laver knapperne
  mitSkærmTilbageKnap = new TilbageKnap(height/9-height/15, height/9-height/17, height/15*2, height/17*2, color(0), "tilbage", 10, color(205, 139, 98), color(0, 255, 0), 10, mitSkærm);
  knapper.add(mitSkærmTilbageKnap);
    dropDownMenu();
}

void mitSkærmKnapper(){
  if(mitSkærmTilbageKnap.mouseOver()){
  skærm=startSkærm;
  
  }
}

void dropDownMenu(){
// Dropdown-menu
  cp5.addScrollableList("garnvalg")
     .setPosition(70*width/1440, 320*width/1440)
     .setSize(420*width/1440, 310*width/1440)
     .setBarHeight(75)
     .setItemHeight(25)
     .setColorBackground(color(#F7EFD2))
     .setColorActive(color(200, 150, 150))
     .setLabel("Tilføj garn")  // <-- Det her sætter teksten på dropdown-baren
     .addItems(new String[] {"Uld", "Bomuld", "Akryl", "Alpaca"})


     .setValue(0)  // Starter med første værdi
     .close();     // Sørger for at den ikke starter åben

  
}

// Denne funktion kaldes automatisk når brugeren vælger noget i dropdown
void opskriftType(int n) {
  valgtType = cp5.get(ScrollableList.class, "opskriftType")
                 .getItem(n).get("name").toString();
}
