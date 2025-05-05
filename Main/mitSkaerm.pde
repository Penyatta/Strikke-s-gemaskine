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
  text("Mit Garn", 290*width/1440, height/3 -height/30-camY);
  //text("Gemte opskrifter", 1020*width/1440,height/3-height/30-camY);
  textFont(generalFont);
  textSize(80);
  fill(71, 92, 108);
  textAlign(CENTER);
  text("Opskrifter", width / 7 * 3 + width / 4, height / 3 - camY);

  if (!gemteOpskrifter.isEmpty()) {
    Opskrift[] opskriftArray = gemteOpskrifter.toArray(new Opskrift[0]);
    displayOpskrifter(opskriftArray);
  }



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
  rect(580*width/1440, 202*width/1440, 18*width/1440, 780*width/1440);
  fill(#475C6C);
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
  // Check if saved recipes file exists and create it if needed
  checkRecipeFile();
  // Load saved recipes from file
  loadSavedRecipes();
}

void mitSkærmKnapper() {
  if (mitSkærmTilbageKnap.mouseOver()) {
    skærm=startSkærm;
    // sætter scroll til nul når man går ud af skærmen
    camY = 0;
    openDropdown=-1;
    for (Dropdown dropdown : garnDropdowns) {
      dropdown.isOpen=false;
    }
  }
  //holder styr på om man skal kunne åben en ny dropdown
  if (openDropdown==-1) {
    allowOpen=true;
  } else {
    allowOpen=false;
  }

  // Checker om der skal ske noget med nogen af dropdownsne
  if (skærm==mitSkærm) {
    for (Dropdown dropdown : garnDropdowns) {
      if (allowOpen) {
        dropdown.checkMouse();
      } else if (openDropdown==dropdown.dropdownIndex) {
        dropdown.checkMouse();
      }
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
  //Fjerner gemte opskrifter hvis der trykkes på stjernen
  if (mouseY>height/9*2 && mouseX>580*width/1440 && !opskrifter.isEmpty()) {
    float posY = height/5*2;
    float posX = 653*width/1440;
    float bredde = width/31*16;
    float højde = height/4;
    float spacing = height/32;
    int gemtIndex=-1;
    boolean fjern=false;
    for (Opskrift opskrift : gemteOpskrifter) {
      if (mouseX>posX+bredde/31*17 && mouseX<posX+bredde/31*17+bredde/15 && mouseY>posY-camY && mouseY<posY+højde/5-camY) {
        fjern=true;
        for (int i = 0; i < gemteOpskrifter.size(); i++) {
          if (opskrift.titel.equals(gemteOpskrifter.get(i).titel)) {
            gemtIndex = i;
            break;
          }
        }
      }
    }
    if (fjern) {
      if (gemtIndex!=-1) {
        gemteOpskrifter.remove(gemtIndex);
        saveRecipesToFile();
      }
    }
  }
}

// Function to add a new yarn dropdown
void addGarnDropdown() {
  // Calculate position for the new dropdown
  float dropdownY = height/3 + (garnDropdowns.size() * (height/14 + 15*width/1440));

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

  for (Dropdown dropdown : garnDropdowns) {
    mitGarn.add(dropdown.chosen);
  }

  // Reset dropdown state
  openDropdown = -1;

  // Check if we need to add a new dropdown
  checkAddNewDropdown();
}

void tegnStjerne(float posX, float posY, boolean fyldt) {
  pushMatrix();
  translate(posX, posY);
  stroke(0);
  if (fyldt) {
    fill(230, 214, 2);
    stroke(0);
  } else {
    fill(255, 0);
  }
  strokeWeight(2);
  beginShape();
  vertex(0*width/1920, -25*width/1920);
  vertex(7*width/1920, -10*width/1920);
  vertex(23.5*width/1920, -7.5*width/1920);
  vertex(11.5*width/1920, 3.5*width/1920);
  vertex(14.5*width/1920, 20*width/1920);
  vertex(0*width/1920, 12.5*width/1920);
  vertex(-14.5*width/1920, 20*width/1920);
  vertex(-11.5*width/1920, 3.5*width/1920);
  vertex(-23.5*width/1920, -7.5*width/1920);
  vertex(-7*width/1920, -10*width/1920);
  endShape(CLOSE);
  popMatrix();
}

// Function to check if the JSON file exists and create it if needed
void checkRecipeFile() {
  File f = new File(dataPath("savedRecipes.json"));
  if (!f.exists()) {
    // Create an empty JSON array and save it
    JSONArray emptyArray = new JSONArray();
    saveJSONArray(emptyArray, "data/savedRecipes.json");
    println("Created new savedRecipes.json file");
  }
}

// Function to load saved recipes from JSON file
void loadSavedRecipes() {
  try {
    JSONArray savedRecipesJSON = loadJSONArray("data/savedRecipes.json");
    gemteOpskrifter.clear();

    for (int i = 0; i < savedRecipesJSON.size(); i++) {
      JSONObject recipeJSON = savedRecipesJSON.getJSONObject(i);

      // Extract recipe data
      String titel = recipeJSON.getString("titel");
      String link = recipeJSON.getString("link", "");
      String svaerhedsgrad = recipeJSON.getString("svaerhedsgrad", "");
      String produktType = recipeJSON.getString("produktType", "");

      // Create new recipe object
      Opskrift savedRecipe = new Opskrift(titel, link, svaerhedsgrad, produktType, null);

      // Add yarn types if they exist
      if (recipeJSON.hasKey("garn")) {
        JSONArray garnArray = recipeJSON.getJSONArray("garn");
        for (int j = 0; j < garnArray.size(); j++) {
          savedRecipe.tilfoejGarntype(garnArray.getString(j));
        }
      }

      // Set image URL if it exists - use "image" key to match hentOpskrifterFraServer
      if (recipeJSON.hasKey("image")) {
        savedRecipe.imageUrl = recipeJSON.getString("image");
        savedRecipe.billedeHentes = true;
      }

      gemteOpskrifter.add(savedRecipe);
    }
    println("Loaded " + gemteOpskrifter.size() + " saved recipes");

    // Start a thread to load images for saved recipes
    thread("hentGemteOpskrifterBilleder");
  }
  catch (Exception e) {
    println("Error loading saved recipes: " + e.getMessage());
    // If there's an error, create a new file
    checkRecipeFile();
  }
}

// Function to save recipes to JSON file
void saveRecipesToFile() {
  JSONArray savedRecipesJSON = new JSONArray();

  for (int i = 0; i < gemteOpskrifter.size(); i++) {
    Opskrift recipe = gemteOpskrifter.get(i);
    JSONObject recipeJSON = new JSONObject();

    // Save basic recipe information
    recipeJSON.setString("titel", recipe.titel);
    recipeJSON.setString("link", recipe.link);
    recipeJSON.setString("kategori", recipe.kategori);
    recipeJSON.setString("produktType", recipe.produktType);

    // Save image URL with the same key name as in hentOpskrifterFraServer
    if (recipe.imageUrl != null) {
      recipeJSON.setString("image", recipe.imageUrl);
    }

    // Save yarn types
    JSONArray garnArray = new JSONArray();
    for (int j = 0; j < recipe.krævneGarn.size(); j++) {
      garnArray.setString(j, recipe.krævneGarn.get(j));
    }
    recipeJSON.setJSONArray("garn", garnArray);

    savedRecipesJSON.setJSONObject(i, recipeJSON);
  }

  saveJSONArray(savedRecipesJSON, "data/savedRecipes.json");
  println("Saved " + gemteOpskrifter.size() + " recipes to file");
}
