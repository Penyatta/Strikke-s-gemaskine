import java.net.*;
import java.io.*;

// Liste med opskrifter
ArrayList<Opskrift> opskrifter = new ArrayList<Opskrift>();

//ArrayList<Knap> besøgKnapper = new ArrayList<Knap>();
ArrayList<KlikOmråde> klikOmråder = new ArrayList<KlikOmråde>();


// Indeholder alle opskrifter hentet fra serveren – ændres ikke ved filtrering
ArrayList<Opskrift> alleOpskrifter = new ArrayList<Opskrift>();

// Indeholder de opskrifter der vises på skærmen – opdateres når man filtrerer
ArrayList<Opskrift> visteOpskrifter = new ArrayList<Opskrift>();

float loaderAngle = 0;

// Funktion til at hente opskrifter fra serveren
void hentOpskrifterFraServer(String kilde) {

  alleOpskrifter.clear();     // Ryd hele listen først
  visteOpskrifter.clear();    // Start med at vise alle opskrifter

  String url = "";

  // Juster URL afhængig af kilden (søgeskærm eller hovedskærm)

  if (kilde.equals("søg")) {

    url = "http://server-kopi.onrender.com/opskrifter";  // Standard URL til hovedskærm
  }

  // Udfør GET anmodning
  GetRequest get = new GetRequest(url);
  get.send();

  String json = get.getContent();

  if (json != null && json.length() > 0) {
    JSONArray jsonOpskrifter = parseJSONArray(json);

    for (int i = 0; i < jsonOpskrifter.size(); i++) {
      JSONObject jsonOpskrift = jsonOpskrifter.getJSONObject(i);

      String titel = jsonOpskrift.getString("titel");
      String kategori = jsonOpskrift.getString("kategori");
      String link = jsonOpskrift.getString("url");
      String produktType = jsonOpskrift.getString("produkttype");

      // Load billede
      String imagePath = null;
      if (jsonOpskrift.hasKey("image")) {
        imagePath = jsonOpskrift.getString("image");
      }

      Opskrift nyOpskrift = new Opskrift(titel, kategori, link, produktType, null);


      nyOpskrift.imageUrl = imagePath;
      nyOpskrift.billedeHentes = true;

      // Tilføj garn
      if (jsonOpskrift.hasKey("garn")) {
        JSONArray garnTyper = jsonOpskrift.getJSONArray("garn"); // ikke "kraevneGarn"

        for (int j = 0; j < garnTyper.size(); j++) {
          String garnType = garnTyper.getString(j);
          nyOpskrift.tilfoejGarntype(garnType);
        }
      }

      // Tilføj opskriften til begge lister
      alleOpskrifter.add(nyOpskrift);
      visteOpskrifter.add(nyOpskrift);
    }

    // Debugging: Bekræft hvor mange opskrifter der er blevet tilføjet
    println("✅ Hentede " + alleOpskrifter.size() + " opskrifter fra serveren");
  } else {
    println("⚠️ Fejl: Kunne ikke hente opskrifter fra serveren");
  }

  thread("hentBillederThread");

  // Beregn max scroll baseret på antal opskrifter og layout
  float kortHøjde = height / 4;
  float spacing = height / 32;
  float synligHøjde = height - height / 5 * 2;
  float samletHøjde = (kortHøjde + spacing) * visteOpskrifter.size();

  maxScroll = samletHøjde - synligHøjde;
  maxScroll = max(0, maxScroll);  // Undgå negativ scroll

  println(maxScroll);
}

void hentBillederThread() {
  //int i=0;
  for (Opskrift o : alleOpskrifter) {
    if (o.billedeHentes && o.imageUrl != null && o.billede == null) {

      PImage img = loadImage(o.imageUrl);
      if (img != null) {
        o.billede = img;

        o.billedeHentes = false;
      }
    }
    //i++;
    //println(i);
  }
}


void displayOpskrifter(Opskrift opskrifter[]) {
  //Værdier der bestemmer position og størrelse af viste opskrifter
  float posY = height/5*2;
  float posX = 653*width/1440;
  float bredde = width/31*16;
  float højde = height/4;
  float spacing = height/32;
  strokeCap(SQUARE);

  klikOmråder.clear();

  //Går igennem de opskrifter der er i arrayet som funktionen modtager
  for (Opskrift opskrift : opskrifter) {

    // Only draw recipes that would be visible on screen (optimization)
    if (posY - camY < height + højde && posY - camY + højde > 0) {
      noStroke();
      rectMode(CORNER);
      //tegner selve kassen
      fill(247, 239, 210);
      rect(posX, posY - camY, bredde, højde);
      skyggeImplement(posX, posY-camY+højde-1, bredde, true);

      boolean gemt = false;
      for (Opskrift gemtOpskrift : gemteOpskrifter) {
        if (opskrift.titel.equals(gemtOpskrift.titel)) {
          gemt = true;

          break;
        }
      }

      tegnStjerne(posX+bredde/24*14, posY+højde/9-camY, gemt);
      textSize(15*width/1440);
      fill(71, 92, 108);
      text("Gem", posX+bredde/24*14, posY+højde/9+højde/9-camY);
      //skriver titlen
      fill(0);
      textFont(boldFont);
      textAlign(CORNER);
      textSize(30*width/1440);
      text(opskrift.titel, posX + width/100, posY - camY + width/50);

      //skriver kategorien
      textFont(generalFont);
      textSize(20*width/1440);
      text("Kategori: " + opskrift.kategori, posX + width/100, posY - camY + højde/4 + width/50);

      //Skriver produkttypen
      text("produkttype: " + opskrift.produktType, posX + width/100, posY - camY + højde/4*2 + width/50);

      //skriver garntyperne og tilføjer tegn imellem hvis der er flere
      String garnInfo = "Garntyper: ";
      for (int i = 0; i < opskrift.krævneGarn.size(); i++) {
        garnInfo += opskrift.krævneGarn.get(i);
        if (i < opskrift.krævneGarn.size() - 2) {
          garnInfo += ", ";
        } else if (i < opskrift.krævneGarn.size() - 1) {
          garnInfo += " og ";
        }
      }
      text(garnInfo, posX + width/100, posY - camY + højde/4*3 + width/50);

      //Viser billedet
      if (opskrift.billede == null) {

        float imgX = posX + bredde/24*17;
        float imgY = posY - camY + højde/10;
        float imgW = bredde/24*5;
        float imgH  = højde/10*8;

        // Baggrund
        fill(250);
        rect(imgX, imgY, imgW, imgH);

        fill(0);
        textAlign(CENTER, CENTER);
        textSize(20);

        // Animeret punktummer til "Indlæser..."
        int dotCount = (frameCount / 10) % 4;  // Skift punktummer hvert 30. frame (ca. hvert 0.5 sekund ved 60 fps)
        String dots = "";

        for (int i = 0; i < dotCount; i++) {
          dots += ".";
        }

        float t = (millis() % 2000) / 2000.0;  // 0.0 → 1.0 over 2 sekunder
        t = 1 - pow(1 - t, 3);  // Ease-out-cubic (starter hurtigt, slutter langsomt)

        float vinkel = map(t, 0, 1, 0, TWO_PI);  // Brug vinkel til arc'en

        float rotation = radians((frameCount * 2) % 360);

        text("Indlæser" + dots, posX + bredde/24*17 + bredde/48*5, posY - camY + højde/10 + højde/10*4 + 50);

        //Tegn roterende ring midt i billedområdet
        pushMatrix();
        translate(imgX + imgW / 2, imgY + imgH / 2-30);
        noFill();

        strokeWeight(4);
        float r = min(imgW, imgH) / 7;
        stroke(200);
        ellipse(0, 0, r*2, r*2);


        stroke(120);
        //arc(0, 0, r * 2, r * 2, loaderAngle, loaderAngle + PI / 1.5);
        rotate(rotation);
        arc(0, 0, r * 2, r * 2, 0, vinkel);

        popMatrix();
      } else {
        image(opskrift.billede, posX + bredde/24*17, posY - camY + højde/10, bredde/24*5, højde/10*8);
      }


      stroke(71, 92, 108);
      strokeWeight(10);
      line(posX + bredde/24*15, posY - camY - 1, posX + bredde/24*15, posY - camY + højde);
    }

    //"fake" knap til besøg link
    float posiX = 1275*width/1920;
    // Laver en "Besøg"-knap for denne opskrift
    float knapBredde = 120*width/1920;
    float knapHøjde = 40*width/1920;
    float knapX = posiX + 30*width/1920;
    float knapY = posY-camY + højde - knapHøjde-40*width/1920;


    fill(205, 139, 98);  // Baggrundsfarve
    stroke(205, 139, 98);
    rect(knapX, knapY, knapBredde, knapHøjde);

    // Tegn tekst midt i firkanten
    fill(247, 239, 210);  // Tekstfarve
    textAlign(CENTER, CENTER);
    textSize(20);
    text("Besøg", knapX + knapBredde / 2, knapY + knapHøjde / 2);

    // Tilføj klikområde
    KlikOmråde ko = new KlikOmråde(knapX, knapY, knapBredde, knapHøjde, opskrift.link,skærm);
    klikOmråder.add(ko);

    //Beregn position for Print-området
    float printY = posY - camY + højde - 150*width/1920;

    // Tegn området
    fill(205, 139, 98);
    rectMode(CORNER);
    stroke(205, 139, 98);
    rect(knapX, printY, knapBredde, knapHøjde);

    fill(247, 239, 210);
    textAlign(CENTER, CENTER);
    textSize(20);
    text("Udskriv", knapX + knapBredde / 2, printY + knapHøjde / 2);

    // Gem som klikområde
    String printLink = opskrift.getPrintLink();
    if (printLink != null) {
      // Check if it's a local file path
      if (printLink.startsWith("data/") || new File(dataPath(printLink)).exists()) {
        // For local files, we need to handle them differently
        KlikOmråde printKO = new KlikOmråde(knapX, printY, knapBredde, knapHøjde, "LOCAL:" + printLink,skærm);
        klikOmråder.add(printKO);
      } else {
        // For web URLs, use the normal link function
        KlikOmråde printKO = new KlikOmråde(knapX, printY, knapBredde, knapHøjde, printLink,skærm);
        klikOmråder.add(printKO);
      }
    }
    posY += spacing + højde;
  }
}

void sendDataToServer(Opskrift opskrift) {
  // Del garn korrekt op som liste

  String garnList = convertListToString(opskrift.krævneGarn);

  // Opret JSON-strukturen med de manuelle værdier
  String jsonData = "{"
    + "\"titel\":\"" + opskrift.titel + "\","
    + "\"garn\":[" + garnList + "],"
    + "\"kategori\":\"" + opskrift.kategori + "\","
    + "\"produkttype\":\"" + opskrift.produktType + "\","
    + "\"image\":\"" + opskrift.imageUrl + "\","
    + "\"url\":\"" + opskrift.link + "\""
    + "}";

  // Udskriv dataene til konsollen
  println("Sender følgende data til serveren:");
  println(jsonData);

  String url = "https://server-kopi.onrender.com/opskrifter";

  try {
    URL apiUrl = new URL(url);
    HttpURLConnection connection = (HttpURLConnection) apiUrl.openConnection();
    connection.setRequestMethod("POST");
    connection.setDoOutput(true);
    connection.setRequestProperty("Content-Type", "application/json");

    // Send JSON-data til serveren
    try (OutputStream os = connection.getOutputStream()) {
      byte[] input = jsonData.getBytes("utf-8");
      os.write(input, 0, input.length);
    }

    // Læs serverens svar
    int responseCode = connection.getResponseCode();
    println("Response Code: " + responseCode);

    BufferedReader in = new BufferedReader(new InputStreamReader(connection.getInputStream()));
    String inputLine;
    StringBuilder response = new StringBuilder();
    while ((inputLine = in.readLine()) != null) response.append(inputLine);
    in.close();
    println("Response: " + response.toString());
  }
  catch (Exception e) {
    println("❌ Der opstod en fejl ved afsendelse:");
    e.printStackTrace();
  }
}

String convertListToString(ArrayList<String> list) {
  StringBuilder sb = new StringBuilder();
  sb.append("\"");
  for (int i = 0; i < list.size(); i++) {
    sb.append(list.get(i));
    if (i < list.size() - 1) {
      sb.append(",");
    }
  }
  sb.append("\"");
  return sb.toString();
}
