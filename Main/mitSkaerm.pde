ArrayList<String> mitGarn = new ArrayList<String>();
int openDropdown=-1;
boolean allowOpen;
boolean needRemove=false;
int needRemoved;
ArrayList<Opskrift> gemteOpskrifter = new ArrayList<Opskrift>();

void mitSkærm() {
  background(255);
  // Viser titlen til mit garn
  fill(71, 92, 108);
  textAlign(CENTER);
  textSize(35*width/1440);
  //text("Mit Garn", 290*width/1440, height/3 - 40-camY);



  // Tegner alle dropdowns starter med den nederste så hvis man åbner en længere oppe vises den ikke under dem som kommer senere
  for (int i = garnDropdowns.size() - 1; i >= 0; i--) {
    garnDropdowns.get(i).tegn();
  }
  // Checker om der skal tilføjes ny dropdown
  if (needToAddDropdown) {
    addGarnDropdown();
    needToAddDropdown = false;
  }
  noStroke();
  fill(247, 239, 210);
  rect(580*width/1440, 150*width/1440, 18*width/1440, 780*width/1440);
  overskriftBjælke("Min profil");
  rect(580*width/1440,202*width/1440,18*width/1440,780*width/1440);
  fill(#475C6C);
  text("Mit garn", 285*width/1440, height/3 - 40-camY);
  text("Gemte opskrifter", 1020,260);

}

Knap mitSkærmTilbageKnap;
ArrayList<Dropdown> garnDropdowns = new ArrayList<Dropdown>();
boolean needToAddDropdown = false; 

void mitSkærmSetup() {
  //laver knapperne
  mitSkærmTilbageKnap = new TilbageKnap(height/9-height/15, height/9-height/17, height/15*2, height/17*2, color(0), "tilbage", 10, color(205, 139, 98), color(247, 239, 210), 10, mitSkærm);
  knapper.add(mitSkærmTilbageKnap);
  // laver den første dropdown menu
  addGarnDropdown();
}

void mitSkærmKnapper() {
  if (mitSkærmTilbageKnap.mouseOver()) {
    skærm=startSkærm;
    // sætter scroll til nul når man går ud af skærmen
    camY = 0;
  }
  //holder styr på om man skal kunne åben en ny dropdown
  if (openDropdown==-1) {
    allowOpen=true;
  } else {
    allowOpen=false;
  }

  // Checker om der skal ske noget med nogen af dropdownsne
  for (Dropdown dropdown : garnDropdowns) {
    if (allowOpen) {
      dropdown.checkMouse();
    } else if (openDropdown==dropdown.dropdownIndex) {
      dropdown.checkMouse();
    }
  }
//Hvis man kan trykke en menu vil alle handlinger lukke denne menu og dermed gøre det muligt at åbne en ny
  if (!allowOpen) {
    openDropdown=-1;
  }
  //hvis det er blevet markeret at der skal fjernes en
  if (needRemove) {
    removeDropdown(needRemoved);
    needRemove = false;
    checkAddNewDropdown();
  }
}

// Function to add a new yarn dropdown
void addGarnDropdown() {
  // Calculate position for the new dropdown
  float dropdownY = height/3+20 + (garnDropdowns.size() * (height/14 + 15*width/1440));

  // Create dropdown menu for yarn types
  String[] garnTyper = {"Uld", "Bomuld", "Akryl", "Alpaka", "Hør", "Silke", "Mohair", "Merino", "Bambus"};
  ArrayList<String> temp = new ArrayList<String>(Arrays.asList(garnTyper));
  temp.removeAll(mitGarn);
  if (temp.size()!=0) {
    temp.add("Ingen");
    String[] garnUdenGengang = temp.toArray(new String[0]);
    Dropdown newDropdown = new Dropdown(83*width/1440, dropdownY, 425*width/1440, height/14, garnUdenGengang, "Vælg garntype", mitSkærm, garnDropdowns.size());
    // Add to the list of dropdowns
    garnDropdowns.add(newDropdown);
  }
}

// Check if we need to add a new dropdown
void checkAddNewDropdown() {
  // Create dropdown menu for yarn types
  String[] garnTyper = {"Uld", "Bomuld", "Akryl", "Alpaka", "Hør", "Silke", "Mohair", "Merino", "Bambus"};
  ArrayList<String> temp = new ArrayList<String>(Arrays.asList(garnTyper));
  temp.removeAll(mitGarn);

  // Only add "Ingen" if there are options available
  if (temp.size() > 0) {
    temp.add("Ingen");
    String[] garnUdenGengang = temp.toArray(new String[0]);

    // Update options for existing dropdowns
    for (Dropdown dropdown : garnDropdowns) {
      dropdown.options = garnUdenGengang.clone(); // Use clone to avoid reference issues
    }

    // Check if we need to add a new dropdown
    boolean hasEmptyDropdown = false;
    for (Dropdown dropdown : garnDropdowns) {
      if (dropdown.chosen == "") {
        hasEmptyDropdown = true;
        break;
      }
    }

    // If there's no empty dropdown and we have available yarn types, set flag to add a new one
    if (!hasEmptyDropdown && temp.size() > 1 && garnDropdowns.size() < garnTyper.length) {
      needToAddDropdown = true;
    }
  }
}

// Add this new method to mitSkaerm.pde
void removeDropdown(int index) {
  // Clear mitGarn
  mitGarn.clear();
  
  // Remove the dropdown
  garnDropdowns.remove(index);
  
  for(Dropdown dropdown : garnDropdowns){
    mitGarn.add(dropdown.chosen);
  }

  // Reset dropdown state
  openDropdown = -1;

  // Check if we need to add a new dropdown
  checkAddNewDropdown();
}
