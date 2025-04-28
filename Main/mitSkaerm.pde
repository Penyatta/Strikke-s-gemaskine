void mitSkærm(){
  background(255);
   noStroke();
  fill(247, 239, 210);
  rect(580*width/1440,150*width/1440,18*width/1440,780*width/1440);
  overskriftBjælke("Min profil");
  // Display title for the dropdown section
  fill(71, 92, 108);
  textAlign(CENTER);
  textSize(28);
  text("Mit garntyper", 290*width/1440, height/3 - 40);
  
  
 // Display all dropdown menus in reverse order (bottom one first)
  for (int i = garnDropdowns.size() - 1; i >= 0; i--) {
    garnDropdowns.get(i).tegn();
  }
  // Check if we need to add a new dropdown (do this outside of any iteration)
  if (needToAddDropdown) {
    addGarnDropdown();
    needToAddDropdown = false;
  }
}

Knap mitSkærmTilbageKnap;
ArrayList<Dropdown> garnDropdowns = new ArrayList<Dropdown>();
boolean needToAddDropdown = false; // Flag to indicate we need to add a dropdown

void mitSkærmSetup(){
  //laver knapperne
  mitSkærmTilbageKnap = new TilbageKnap(height/9-height/15, height/9-height/17, height/15*2, height/17*2, color(0), "tilbage", 10, color(205, 139, 98), color(0, 255, 0), 10, mitSkærm);
  knapper.add(mitSkærmTilbageKnap);
  // laver den første dropdown menu
  addGarnDropdown();
}

void mitSkærmKnapper(){
  if(mitSkærmTilbageKnap.mouseOver()){
  skærm=startSkærm;
  }
  // Check all dropdown interactions
  for (Dropdown dropdown : garnDropdowns) {
    dropdown.checkMouse();
  }
}

// Function to add a new yarn dropdown
void addGarnDropdown() {
  // Calculate position for the new dropdown
  float dropdownY = height/3 + (garnDropdowns.size() * (height/30 + 10));
  
  // Create dropdown menu for yarn types
  String[] garnTyper = {"Uld", "Bomuld", "Akryl", "Alpaka", "Hør", "Silke", "Mohair", "Merino", "Bambus"};
  Dropdown newDropdown = new Dropdown(83*width/1440, dropdownY, 350*width/1440, height/30, garnTyper, "Vælg garntype", mitSkærm, garnDropdowns.size());
  
  // Add to the list of dropdowns
  garnDropdowns.add(newDropdown);
}

// Check if we need to add a new dropdown
void checkAddNewDropdown() {
  // Only add a new dropdown if the last one has a selection
  if (!garnDropdowns.isEmpty() && garnDropdowns.get(garnDropdowns.size() - 1).selectedIndex != -1) {
    // Check if we already have an empty dropdown at the end
    boolean hasEmptyDropdown = false;
    for (Dropdown dropdown : garnDropdowns) {
      if (dropdown.selectedIndex == -1) {
        hasEmptyDropdown = true;
        break;
      }
    }
    
    // If there's no empty dropdown, set flag to add a new one
    if (!hasEmptyDropdown) {
      needToAddDropdown = true;
    }
  }
}
