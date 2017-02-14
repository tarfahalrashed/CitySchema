import java.awt.TextArea;
import java.util.Vector;
import vialab.SMT.*;
import de.bezier.data.sql.*;
import java.io.InputStreamReader;
import java.net.InetAddress;
import java.net.Socket;

//Fiducial 
import TUIO.*;
import java.awt.event.*;
import java.lang.reflect.*;
import processing.core.*;
import java.util.*;

//Define Gloabal Variables
TuioProcessing tuioClient;
TuioObject obj;

int Submitted=0;
int Exist=0;
float object_size = 60;
float scale_factor = 1;


PFont f;
PImage img;

int  Width, Length, NumberOfFloors=2, BlockType;
int ID = 1 , AmenID=0;
double WWNR =0.4, WWSR=0.4, WWER=0.4, WWWR=0.4;
float  xPos, yPos;
String AmentieType = "", Template="xx";

SQLite db;
String InsertQuery="";
String UpdateQuery=""; 
String DeleteQuery=""; 
Socket socket ;
PrintWriter writer;
  


void setup() {
  size( 1280, 1024, SMT.RENDERER); // 1280 - 1024

  tuioClient = new TuioProcessing(this);

  SMT.init( this, TouchSource.AUTOMATIC);

  f = loadFont( "ArialMT-16.vlw" ); 

  // Interactive area   
  Zone BuildZone = new Zone("BuildZone");
  BuildZone.setSize(630, 630);
  BuildZone.setLocation(320, 120);
  SMT.add(BuildZone);

  // Home buttons 
     HomeButtons();
     
  // CS Build Area 
    try {
   socket = new Socket("127.0.0.1", 8001);
   writer = new PrintWriter(socket.getOutputStream(), true);
  writer.println("_CitySchemaBuildArea");
  }
  catch (Exception e) {
  println(e.getMessage());
  }
     
  //DB connection
   db = new SQLite( this, "CitySchemaDatabase.db" ); // open a database connection
   if ( db.connect() )
   {
   println("connected");         
   db.query( "SELECT name as \"Name\" FROM SQLITE_MASTER where type=\"table\"" ); 
   while (db.next()) { 
   println( db.getString("Name") );
 }
   }
   
  // Delete rows from previous run   
  /*DeleteQuery = "DELETE FROM Objects ";
  db.query(DeleteQuery);
  
  DeleteQuery = "DELETE FROM Buildings ";
  db.query(DeleteQuery);

  DeleteQuery = "DELETE FROM Amenties  ";
  db.query(DeleteQuery);*/
 }
 
 void draw() {
  fill(#ffffff); 
  background(#ffffff);
  textFont(f,16); // Step 4: Specify font to be used
  fill(0);        // Step 5: Specify font color
}

//---------- Press Functions ----------//

void pressHome () {
  //Remove
 removeEverything();
 
 //Add 
 HomeButtons(); 
}

void pressAddBlock () {  
  
  //Fiducial Detection
  // Vector objects = tuioClient.getTuioObjectList();
  ArrayList<TuioObject> tuioObjectList = tuioClient.getTuioObjectList();

     int Submitted=0;
     int   Exist=0;
        
 if(tuioObjectList.size()>0)
  {
  int i=0; 

    obj = tuioObjectList.get(i);
    //(TuioObject)objects.elementAt(i);

       println(obj.getSymbolID());
      // println(obj.getScreenX(width));
      // println(obj.getScreenY(height));
      
      ID = obj.getSymbolID();
  }
  
  
  // Remove 
  SMT.remove("AddBlock");
  SMT.remove("UpdateBlock");
  SMT.remove("Run");

  //Add
 // - Detaction Area 
  SMT.add(new ButtonZone ("DetactionZoneAB", 320,800,80,80));
 // - Text 
  SMT.add(new Zone ("Intro", 600,845,0,0));
 //- Buttons 
  SMT.add( new ButtonZone ("Home",320, 910, 70,50));
  SMT.add( new ButtonZone ("Run",830,895, 140,100));
   

  
  /*
  
  delay(5000);
  
  while (ID == 0 ) {
  
     Vector objects = tuioClient.getTuioObjects();

     int Submitted=0;
     int   Exist=0;
        
 if(objects.size()>0)
  {
  int i=0; 
      obj = (TuioObject)objects.elementAt(i);      
      ID = obj.getSymbolID();
      println(ID);
  }
}

showAddPage();
*/
  
  
}

/*
void showAddPage (){

  //Remove 
  SMT.remove("Intro"); 
  
  //Add 
  //-Text
  SMT.add(new Zone ("AddBlockText", 620,810,0,0));
  //-Buttons 
  SMT.add(new ButtonZone ("AddBlockButton", 750,850,70,40));

}*/ 


void pressDetactionZoneAB() {
  //Remove 
  SMT.remove("Intro"); 
  
  //Add 
  //-Text
  SMT.add(new Zone ("AddBlockText", 620,810,0,0));
  //-Buttons 
  SMT.add(new ButtonZone ("AddBlockButton", 750,850,70,40));
}

void pressAddBlockButton (){
  //Remove
  SMT.remove("Home");
  SMT.remove("Run");
  SMT.remove("DetactionZoneAB");
  SMT.remove("AddBlockText");
  SMT.remove("AddBlockButton");
  
  
  //Add 
  HomeButtons();
  
  SMT.add( new ButtonZone ("Run",830,895, 140,100));
  
  
  String Select = "SELECT BlockType,BlockWidth, BlockLength FROM Fiducial WHERE BlockID ="+"\""+ID+"\";";
     db.query(Select);
     int BlockType =  db.getInt("BlockType");
     //int BlockWidth = db.getInt("BlockWidth");
     //int BlockLength = db.getInt("BlockLength");

     
 /* // Insert in DB taking the ID, xPos and Ypos from reactvision
  InsertQuery=  "INSERT INTO InsertedBlock (BlockID, BlockXPos, BlockYPos, BlockType, BlockWidth, BlockLength, NumOfFloors, WWNR, WWSR, WWER, WWWR, Template) VALUES "+"("+"\""+ID+"\","+"\""+xPos+"\","+"\""+yPos+"\","+"\""+BlockType+"\","+"\""+BlockWidth+"\","+"\""+BlockLength+"\","+"\""+NumberOfFloors+"\","+"\""+WWNR+"\","+"\""+WWSR+"\","+"\""+WWER+"\","+"\""+WWWR+"\","+"\""+Template+"\");"; 
  db.query(InsertQuery);*/
  
 // Insert in DB taking the ID, xPos and Ypos from reactvision
  InsertQuery=  "INSERT INTO AddBlock (BlockID, BlockXPos, BlockYPos, BlockType, NumOfFloors, WWNR, WWSR, WWER, WWWR, Template) VALUES "+"("+"\""+ID+"\","+"\""+xPos+"\","+"\""+yPos+"\","+"\""+BlockType+"\","+"\""+NumberOfFloors+"\","+"\""+WWNR+"\","+"\""+WWSR+"\","+"\""+WWER+"\","+"\""+WWWR+"\","+"\""+Template+"\");"; 
  db.query(InsertQuery);
  
    // CS Add Building  
    try {
  writer.println("_CitySchemaAddBuilding");

  }
  catch (Exception e) {
  println(e.getMessage());
  }
}
//---------------------------------------------//

void pressUpdateBlock() {
// Remove 
  SMT.remove("AddBlock");
  SMT.remove("UpdateBlock");
  SMT.remove("Run");

  //Add
 // - Detaction Area 
  SMT.add(new ButtonZone ("DetactionZoneUB",  320,800,80,80));
 // - Text 
  SMT.add(new Zone ("Intro", 600,845,0,0));
 //- Buttons 
  SMT.add( new ButtonZone ("Home",320, 910, 70,50));
  SMT.add( new ButtonZone ("Run",830,895, 140,100));
}

void pressDetactionZoneUB() {
  //Remove 
  SMT.remove("Intro"); 
  
  //Add 
  //-Buttons 
  SMT.add(new ButtonZone ("UpdateBuildings", 415,820,130,50));
  SMT.add(new ButtonZone ("AddAmenities", 560,820,130,50));
  SMT.add(new ButtonZone ("DeleteBlock", 705,820,130,50));
} 
//-----------------------------------------------//
void pressUpdateBuildings () {
 //Remove 
 SMT.remove("UpdateBuildings");
 SMT.remove("AddAmenities");
 SMT.remove("DeleteBlock");
 
 //Add
 //-Text 
  SMT.add (new Zone ("WindowToWallRatio",520,810, 0,0));
  SMT.add (new Zone ("North", 448,845, 0,0));
  SMT.add (new Zone ("South", 448,875, 0,0));
  SMT.add (new Zone ("East", 444,905, 0,0));
  SMT.add (new Zone ("West", 446,935, 0,0));
  SMT.add (new Zone ("NumberOfFloors",700,845, 0,0)); 

 //-Sliders
  SMT.add(new SliderZone("NorthSlider",485,840,125,13,0,100));
  SMT.add(new SliderZone("SouthSlider",485,870,125,13,0,100));
  SMT.add(new SliderZone("EastSlider",485,900,125,13,0,100)); 
  SMT.add(new SliderZone("WestSlider",485,930,125,13,0,100));
  SMT.add(new SliderZone("NumberofFloorsSlider",640,870,125,13,0,100));

 //-Button
 
  SMT.add(new ButtonZone ("UpdateBuildingsUpdate", 695,910,70,35));
}

void pressUpdateBuildingsUpdate () {
  //Remove 
  SMT.remove("WindowToWallRatio");
  SMT.remove("North");
  SMT.remove("South");
  SMT.remove("East");
  SMT.remove("West");
  SMT.remove("NumberOfFloors");
  SMT.remove("NorthSlider");
  SMT.remove("SouthSlider");
  SMT.remove("WestSlider");
  SMT.remove("EastSlider");
  SMT.remove("NumberofFloorsSlider");
  SMT.remove("UpdateBuildingsUpdate");
  //Add
  //-Text
  SMT.add(new Zone ("UpdateBuildingsText", 590,808,0,0));
  //-Buttons 
   SMT.add(new ButtonZone ("UpdateBuildingsYes", 635,840,50,30));
   SMT.add(new ButtonZone ("UpdateBuildingsNo", 700,840,50,30));
   
    //- update query  
    
   // Select x and y pos from Inseted Blocks 
 
   String Select = "SELECT BlockXPos, BlockYPos FROM InsertedBlock WHERE BlockID ="+"\""+ID+"\";";
      db.query(Select);
      xPos =  db.getInt("BlockXPos");
      yPos = db.getInt("BlockYPos");
   
     
  // add to deleted buildings
  InsertQuery=  "INSERT INTO DeleteBlock (BlockID) VALUES "+"("+"\""+ID+"\");"; 
  db.query(InsertQuery);
  
      // CS Delete Building  
    try {

  writer.println("_CitySchemaDeleteBuilding");
  }
  catch (Exception e) {
  println(e.getMessage());
  }
  
  // add to add block
   Select = "SELECT BlockType,BlockWidth, BlockLength FROM Fiducial WHERE BlockID ="+"\""+ID+"\";";
     db.query(Select);
     int BlockType =  db.getInt("BlockType");
     //int BlockWidth = db.getInt("BlockWidth");
     //int BlockLength = db.getInt("BlockLength");
         
  
 // Insert into Add Block 
  InsertQuery=  "INSERT INTO AddBlock (BlockID, BlockXPos, BlockYPos, BlockType, NumOfFloors, WWNR, WWSR, WWER, WWWR, Template) VALUES "+"("+"\""+ID+"\","+"\""+xPos+"\","+"\""+yPos+"\","+"\""+BlockType+"\","+"\""+NumberOfFloors+"\","+"\""+WWNR+"\","+"\""+WWSR+"\","+"\""+WWER+"\","+"\""+WWWR+"\","+"\""+Template+"\");"; 
  db.query(InsertQuery);
 
 // CS Adduilding  
    try {

  writer.println("_CitySchemaAddBuilding");
  }
  catch (Exception e) {
  println(e.getMessage());
  }
  
}

void pressUpdateBuildingsYes () {
   //Remove 
   SMT.remove("UpdateBuildingsText");
   SMT.remove("UpdateBuildingsYes");
   SMT.remove("UpdateBuildingsNo");
 
 //Add
 //-Buttons 
  SMT.add(new ButtonZone ("UpdateBuildings", 415,820,130,50));
  SMT.add(new ButtonZone ("AddAmenities", 560,820,130,50));
  SMT.add(new ButtonZone ("DeleteBlock", 705,820,130,50));
  
}
  


void pressUpdateBuildingsNo  () {
   //Remove 
   SMT.remove("UpdateBuildingsText");
   SMT.remove("UpdateBuildingsYes");
   SMT.remove("UpdateBuildingsNo");
  
   //Add
   //-Text
    SMT.add(new Zone ("UpdateBuildingsText2",  620,808,0,0));
   //-Button
    SMT.add(new ButtonZone ("UpdateBuildingsDone", 750,850,70,40));
}

void pressUpdateBuildingsDone () {
  //Remove
   SMT.remove("UpdateBuildingsText2");
   SMT.remove("UpdateBuildingsDone");
   SMT.remove("Home");
   SMT.remove("DetactionZoneUB");
  //Add
  HomeButtons();
 //- update query  ??
}
//---------------------------------------------//
void pressAddAmenities () {
 //Remove 
 SMT.remove("UpdateBuildings");
 SMT.remove("AddAmenities");
 SMT.remove("DeleteBlock");
 
 //Add
 //- Text
  SMT.add (new Zone ("AmentieType",470,810, 0,0));
 //-Buttons 
  SMT.add( new ButtonZone ("Mousque",420, 840, 80,40));
  SMT.add( new ButtonZone ("Bank",420, 890,  80,40));
  SMT.add( new ButtonZone ("Grocery",520, 840, 80,40));
  SMT.add( new ButtonZone ("Coffee",520, 890, 80,40)); 
  SMT.add( new ButtonZone ("School",620, 840, 80,40));
  SMT.add( new ButtonZone("Book",620, 890,  80,40));
  SMT.add( new ButtonZone ("Entertainment",720, 840, 110,40));  
  SMT.add( new ButtonZone ("Shopping",720, 890, 110,40));
}
  void pressMousque () { AmentieType = "Mousque"; AmentiesChecking ();  }
  void pressBank    () { AmentieType = "Banks"; AmentiesChecking ();    }
  void pressGrocery () { AmentieType = "Grocery"; AmentiesChecking (); }
  void pressCoffee  () { AmentieType = "Coffee"; AmentiesChecking ();  }
  void pressSchool  () { AmentieType = "Schools"; AmentiesChecking ();  }
  void pressBook    () { AmentieType = "Books";    }
  void pressEntertainment () { AmentieType = "Entertainment"; AmentiesChecking (); }
  void pressShopping      () { AmentieType = "Shopping"; AmentiesChecking ();     }
  
  void pressAddAmenitiesYes() {
  //Remove
  SMT.remove("AddAmenitiesText");
  SMT.remove("AddAmenitiesText2");
  SMT.remove("AddAmenitiesYes");
  SMT.remove("AddAmenitiesNo");
  
  //Add
   //-Buttons 
  SMT.add(new ButtonZone ("UpdateBuildings", 415,820,130,50));
  SMT.add(new ButtonZone ("AddAmenities", 560,820,130,50));
  SMT.add(new ButtonZone ("DeleteBlock", 705,820,130,50));
   //- update query    
  }
  
  void pressAddAmenitiesNo() {
  //Remove
  SMT.remove("AddAmenitiesText");
  SMT.remove("AddAmenitiesText2");
  SMT.remove("AddAmenitiesYes");
  SMT.remove("AddAmenitiesNo");
  
   //Add
   //-Text
    SMT.add(new Zone ("AddAmenitiesText3", 620,809,0,0));
   //-Button
    SMT.add(new ButtonZone ("AddAmenitiesDone", 750,850,70,40));
  }
  void pressAddAmenitiesDone (){
    //Remove
   SMT.remove("AddAmenitiesText3");
   SMT.remove("AddAmenitiesDone");
   SMT.remove("Home");
   SMT.remove("DetactionZoneUB");
  //Add
  HomeButtons();
 //- update query  
  }  
//--------------------------------------------//

void pressDeleteBlock () {
 //Remove 
 SMT.remove("UpdateBuildings");
 SMT.remove("AddAmenities");
 SMT.remove("DeleteBlock");
 
 //Add
 SMT.add(new Zone ("DeleteBlockText", 600,810,0,0));
  //-Buttons
 SMT.add(new ButtonZone ("DeleteBlockYes", 610,840,60,35));
 SMT.add(new ButtonZone ("DeleteBlockNo", 690,840,60,35));
}

void pressDeleteBlockYes () {
 //Remove 
 SMT.remove("DeleteBlockText");
 SMT.remove("DeleteBlockYes");
 SMT.remove("DeleteBlockNo");
 SMT.remove("Home");
 SMT.remove("DetactionZoneUB");

 //add
 HomeButtons();
 
 //-delete query 
  /*DeleteQuery = "DELETE FROM InsertedBlock WHERE BlockID ="+"\""+ID+"\";";
  db.query(DeleteQuery);*/
  
  InsertQuery=  "INSERT INTO DeleteBlock (BlockID) VALUES "+"("+"\""+ID+"\");"; 
  db.query(InsertQuery);
  
      // CS Delete Building  
    try {

  writer.println("_CitySchemaDeleteBuilding");

  }
  catch (Exception e) {
  println(e.getMessage());
  }
}

void pressDeleteBlockNo () {
 //Remove 
 SMT.remove("DeleteBlockText");
 SMT.remove("DeleteBlockYes");
 SMT.remove("DeleteBlockNo");

 //add
  SMT.add(new ButtonZone ("UpdateBuildings", 415,820,130,50));
  SMT.add(new ButtonZone ("AddAmenities", 560,820,130,50));
  SMT.add(new ButtonZone ("DeleteBlock", 705,820,130,50));
}
//---------------------------------------------//

void pressRun () {
removeEverything();

//Add
 //-Text 
  SMT.add(new Zone ("ChooseSim", 535, 810, 0,0));
 // -Buttons 
  SMT.add( new ButtonZone ("Home",320, 910, 80,60));
  SMT.add( new ButtonZone ("WalkabilitySim",465, 840, 100,40));
  SMT.add( new ButtonZone ("EnergySim",580, 840, 100,40));
}

void pressWalkabilitySim () {
  //Remove 
  SMT.remove("ChooseSim");
  SMT.remove("WalkabilitySim");
  SMT.remove("EnergySim");
  
  //Connection 
  try {

  writer.println("_CitySchemaRunMobility");

  }
  catch (Exception e) {
  println(e.getMessage());
  }
}

void pressEnergySim () {
  //Remove 
  SMT.remove("ChooseSim");
  SMT.remove("WalkabilitySim");
  SMT.remove("EnergySim");
  
  //Connection 
  //Connection 
  try {

  writer.println("__CitySchemaRunEnergy");

  }
  catch (Exception e) {
  println(e.getMessage());
  }
  //Add
}


 //----------- Touch Functions ---------------//

void touchBuildZone (Zone zone) {
  zone.scale();
  
   Touch t = zone.getTouches()[0];
   xPos = t.getLocalX(zone);
   yPos = t.getLocalY(zone);
   
 // print("Local x =  "+ xPos+"  Local y =  "+yPos+"  ");
 
   String Select ;
   int CellRow, CellColumn, xPosStart, xPosEnd, yPosStart, yPosEnd;
   for ( int i = 1 ; i <= 256; i++){
     
     Select = "SELECT xPosStart, xPosEnd, yPosStart, yPosEnd FROM Cells WHERE ID ="+"\""+i+"\";";
     db.query(Select);
     xPosStart =  db.getInt("xPosStart"); 
     xPosEnd =  db.getInt("xPosEnd");
     yPosStart =  db.getInt("yPosStart");
     yPosEnd =  db.getInt("yPosEnd");
     //print(" xPosStart  =" + xPosStart +"  xPosEnd  = " + xPosEnd +"  yPosStart  = "+ yPosStart+ " yPosEnd = " +yPosEnd);

     if (( xPos >= xPosStart && xPos < xPosEnd) && ( yPos >= yPosStart && yPos < yPosEnd)) {
     Select = "SELECT CellR,CellC FROM Cells WHERE ID ="+"\""+i+"\";";
     db.query(Select);
     CellRow =  db.getInt("CellC");
     CellColumn = db.getInt("CellR");
      xPos = CellRow;
      yPos = CellColumn;
     print(" Cell Row    "+xPos+"  Cell Column    "+yPos);

      break;

     }
   }
}

void touchUpNorthSlider(SliderZone s, Touch t){
 WWNR = s.getCurrentValue();
 WWNR = WWNR/100;
}
void touchUpSouthSlider(SliderZone s, Touch t){
 WWSR = s.getCurrentValue();
 WWSR = WWSR/100;
}
void touchUpEastSlider(SliderZone s, Touch t){
 WWER = s.getCurrentValue();
 WWSR = WWSR/100;
}
void touchUpWestSlider(SliderZone s, Touch t){
 WWWR = s.getCurrentValue();
 WWWR = WWWR/100;
}


void touchUpNumberofFloorsSlider(SliderZone s, Touch t){
 NumberOfFloors = s.getCurrentValue();
 print(NumberOfFloors);
}


void touchAddBlock (Zone zone)    { zone.scale(); }
void touchUpdateBlock (Zone zone) { zone.scale(); }
void touchDetactionZoneAB (Zone zone)  { zone.scale(); }
void touchDetactionZoneUB (Zone zone)  { zone.scale(); }
void touchHome (Zone zone) {zone.scale(); }
void touchRun (Zone zone) {zone.scale(); }
void touchAddBlockButton (Zone zone) {zone.scale(); }
void touchNorthSlider(Zone zone) {zone.scale(); }
void touchSouthSlide (Zone zone) {zone.scale(); }
void touchEastSlider(Zone zone) {zone.scale(); }
void touchWestSlider(Zone zone) {zone.scale(); }
void touchNumberofFloorsSlide(Zone zone) {zone.scale(); }
void touchUpdateBuildingsUpdate (Zone zone) {zone.scale(); }
void touchUpdateBuildingsYes (Zone zone) {zone.scale(); }
void touchUpdateBuildingsNo (Zone zone) {zone.scale(); }
void touchUpdateBuildingsDone (Zone zone) {zone.scale(); }
void touchMousque(Zone zone) {zone.scale(); }
void touchBank(Zone zone) {zone.scale(); }
void touhGrocery(Zone zone) {zone.scale(); }
void touchCoffee(Zone zone) {zone.scale(); }
void touchSchool(Zone zone) {zone.scale(); }
void touchBook(Zone zone) {zone.scale(); }
void touchEntertainment (Zone zone) {zone.scale(); }
void touchShopping (Zone zone) {zone.scale(); }
void touchAddAmenitiesYes  (Zone zone) {zone.scale(); }
void touchAddAmenitiesNo (Zone zone) {zone.scale(); }
void touchAddAmenitiesDone (Zone zone) {zone.scale(); }
void touchDeleteBlockYes(Zone zone) {zone.scale(); }
void touchDeleteBlockNo (Zone zone) {zone.scale(); }
void touchWalkabilitySim (Zone zone) {zone.scale(); }
void touchEnergySim (Zone zone) {zone.scale(); }

//---------- Draw Functions-----------------// 

void drawBuildZone (Zone zone) {
 // image should be loaded here
  img = loadImage("grid1.png");
  image(img,0, 0); }
 
 void drawAddBlock (Zone zone){
  fill(#a0a0a0);
  stroke(15, 220);
  rect( 0, 0, zone.width, zone.height);
  //draw text
  fill(#ffffff);
  textAlign( CENTER, CENTER);
  textSize(24);
  text("Add Block", zone.width / 2, zone.height / 2);
}

 void drawUpdateBlock (Zone zone){
  fill(#a0a0a0);
  stroke(15, 220);
  rect( 0, 0, zone.width, zone.height);
  //draw text
  fill(#ffffff);
  textAlign( CENTER, CENTER);
  textSize(24);
  text("Update Block", zone.width / 2, zone.height / 2);
}

void drawHome (Zone zone) {
  noFill();
  stroke( 15, 220);
 img = loadImage("HomeB.png");
  image(img,-60, -60);
}

void drawRun (Zone zone){
  noFill();
  stroke( 15, 220);
  img = loadImage("SimObj.png");
  image(img,-5, 10);
}

 void drawDetactionZoneAB (Zone zone){
   noFill();
  stroke( 15, 220);
  rect( 0, 0, zone.width, zone.height);
  img = loadImage("block25.png");
  image(img,7, 8);
}

void drawIntro (Zone zone) {
  noFill();
  stroke( 15, 220);
  //draw text
  fill(#76a2b8);
  textAlign( CENTER, CENTER);
  textSize(24);
  text( "<-- Place the selected block here ", zone.width / 2, zone.height / 2);
}

void drawAddBlockText(Zone zone) {
  noFill();
  stroke( 15, 220);
  //draw text
  fill(0);
  textAlign( CENTER, CENTER);
  textSize(17);
  text( "Place the block on the Interactive Area, then press Add  ", zone.width / 2, zone.height / 2);
}

void drawAddBlockButton (Zone zone) {
 fill(#a0a0a0);
  stroke(15, 220);
  rect( 0, 0, zone.width, zone.height);
  //draw text
  fill(#ffffff);
  textAlign( CENTER, CENTER);
  textSize(17.5);
  text("Add", zone.width / 2, zone.height / 2); 
  
}

 void drawDetactionZoneUB (Zone zone){
   noFill();
  stroke( 15, 220);
  rect( 0, 0, zone.width, zone.height);
  img = loadImage("block25.png");
  image(img,7, 8);
}

 void drawUpdateBuildings (Zone zone){
  fill(#a0a0a0);
  stroke(15, 220);
  rect( 0, 0, zone.width, zone.height);
  //draw text
  fill(#ffffff);
  textAlign( CENTER, CENTER);
  textSize(16);
  text("Update Buildings", zone.width / 2, zone.height / 2);
}

 void drawAddAmenities (Zone zone){
  fill(#a0a0a0);
  stroke(15, 220);
  rect( 0, 0, zone.width, zone.height);
  //draw text
  fill(#ffffff);
  textAlign( CENTER, CENTER);
  textSize(16);
  text("Add Amenities", zone.width / 2, zone.height / 2);
}

 void drawDeleteBlock (Zone zone){
  fill(#a0a0a0);
  stroke(15, 220);
  rect( 0, 0, zone.width, zone.height);
  //draw text
  fill(#ffffff);
  textAlign( CENTER, CENTER);
  textSize(16);
  text("Delete Block", zone.width / 2, zone.height / 2);
}

void drawWindowToWallRatio(Zone zone) {
  noFill();
  stroke( 15, 220);
  //dr‰aw text
  fill(127,0,0);
  textAlign( CENTER, CENTER);
  textSize(16.5);
  text( "Window-to-Wall Ratio (%)", zone.width / 2, zone.height / 2);
}
void drawNorth(Zone zone) {
  noFill();
  stroke( 15, 220);
  //dr‰aw text
  fill(0);
  textAlign( CENTER, CENTER);
  textSize(16.5);
  text( "North", zone.width / 2, zone.height / 2);
}
void drawSouth(Zone zone) {
  noFill();
  stroke( 15, 220);
  //dr‰aw text
  fill(0);
  textAlign( CENTER, CENTER);
  textSize(16.5);
  text( "South", zone.width / 2, zone.height / 2);
}
void drawWest (Zone zone) {
noFill();
  stroke( 15, 220);
  //draw text
  fill(0);
  textAlign( CENTER, CENTER);
  textSize(16.5);
  text( "West", zone.width / 2, zone.height / 2);
}
void drawEast (Zone zone) {
  noFill();
  stroke( 15, 220);
  //dr‰aw text
  fill(0);
  textAlign( CENTER, CENTER);
  textSize(16.5);
  text( "East", zone.width / 2, zone.height / 2);
}
void drawNumberOfFloors (Zone zone) {
  noFill();
  stroke( 15, 220);
  //dr‰aw text
  fill(0);
  textAlign( CENTER, CENTER);
  textSize(16.5);
  text( "Number of Floors", zone.width / 2, zone.height / 2);
}
 
 void drawUpdateBuildingsUpdate (Zone zone) {
 fill(#a0a0a0);
  stroke(15, 220);
  rect( 0, 0, zone.width, zone.height);
  //draw text
  fill(#ffffff);
  textAlign( CENTER, CENTER);
  textSize(17);
  text("Update", zone.width / 2, zone.height / 2);  
}

void drawUpdateBuildingsText(Zone zone) {
  noFill();
  stroke( 15, 220);
  //draw text
  fill(0);
  textAlign( CENTER, CENTER);
  textSize(17);
  text( "Do you want to continue updating the block ?", zone.width / 2, zone.height / 2);
}

 void drawUpdateBuildingsYes (Zone zone) {
 fill(#a0a0a0);
  stroke(15, 220);
  rect( 0, 0, zone.width, zone.height);
  //draw text
  fill( #ffffff);
  textAlign( CENTER, CENTER);
  textSize(16.5);
  text("Yes", zone.width / 2, zone.height / 2);  
}
 void drawUpdateBuildingsNo (Zone zone) {
 fill(#a0a0a0);
  stroke(15, 220);
  rect( 0, 0, zone.width, zone.height);
  //draw text
  fill(#ffffff);
  textAlign( CENTER, CENTER);
  textSize(16.5);
  text("No", zone.width / 2, zone.height / 2);  
}
void drawUpdateBuildingsText2(Zone zone) {
  noFill();
  stroke( 15, 220);
  //draw text
  fill(0);
  textAlign( CENTER, CENTER);
  textSize(16.5);
  text( "Place the block on the Interactive Area, then press Done ", zone.width / 2, zone.height / 2);
}
 void drawUpdateBuildingsDone (Zone zone) {
 fill(#a0a0a0);
  stroke(15, 220);
  rect( 0, 0, zone.width, zone.height);
  //draw text
  fill(#ffffff);
  textAlign( CENTER, CENTER);
  textSize(16.5);
  text("Done", zone.width / 2, zone.height / 2);  
}

void drawAmentieType(Zone zone) {
  noFill();
  stroke( 15, 220);
  //dr‰aw text
  fill(127,0,0);
  textAlign( CENTER, CENTER);
  textSize(17);
  text( "Amentie Type", zone.width / 2, zone.height / 2);
}

void drawMousque (Zone zone){
   fill(#a0a0a0);
  stroke( 15, 220);
  rect( 0, 0, zone.width, zone.height);
  //draw text
  fill(#ffffff);
  textAlign( CENTER, CENTER);
  textSize(15.5);
  text("Mousque", zone.width / 2, zone.height / 2);
}
void drawBank (Zone zone){
   fill(#a0a0a0);
  stroke( 15, 220);
  rect( 0, 0, zone.width, zone.height);
  //draw text
  fill(#ffffff);
  textAlign( CENTER, CENTER);
  textSize(15.5);
  text("Bank", zone.width / 2, zone.height / 2);
}

void drawGrocery(Zone zone){
   fill(#a0a0a0);
  stroke( 15, 220);
  rect( 0, 0, zone.width, zone.height);
  //draw text
  fill(#ffffff);
  textAlign( CENTER, CENTER);
  textSize(15.5);
  text("Grocery", zone.width / 2, zone.height / 2);
}

void drawCoffee(Zone zone){
   fill(#a0a0a0);
  stroke( 15, 220);
  rect( 0, 0, zone.width, zone.height);
  //draw text
  fill(#ffffff);
  textAlign( CENTER, CENTER);
  textSize(15.5);
  text("Coffee", zone.width / 2, zone.height / 2);
}
void drawSchool(Zone zone){
   fill(#a0a0a0);
  stroke( 15, 220);
  rect( 0, 0, zone.width, zone.height);
  //draw text
  fill(#ffffff);
  textAlign( CENTER, CENTER);
  textSize(15.5);
  text("School", zone.width / 2, zone.height / 2);
}
void drawBook(Zone zone){
   fill(#a0a0a0);
  stroke( 15, 220);
  rect( 0, 0, zone.width, zone.height);
  //draw text
  fill(#ffffff);
  textAlign( CENTER, CENTER);
  textSize(15.5);
  text("Book", zone.width / 2, zone.height / 2);
}

void drawEntertainment(Zone zone){
   fill(#a0a0a0);
  stroke( 15, 220);
  rect( 0, 0, zone.width, zone.height);
  //draw text
  fill(#ffffff);
  textAlign( CENTER, CENTER);
  textSize(15.5);
  text("Entertainment", zone.width / 2, zone.height / 2);
}
void drawShopping(Zone zone){
   fill(#a0a0a0);
  stroke( 15, 220);
  rect( 0, 0, zone.width, zone.height);
  //draw text
  fill(#ffffff);
  textAlign( CENTER, CENTER);
  textSize(15.5);
  text("Shopping", zone.width / 2, zone.height / 2);
}
void drawAddAmenitiesText(Zone zone) {
  noFill();
  stroke( 15, 220);
  //draw text
  fill(127,0,0);
  textAlign( CENTER, CENTER);
  textSize(17);
  text( "* Amenity has been added", zone.width / 2, zone.height / 2);
}
void drawAddAmenitiesText2(Zone zone) {
  noFill();
  stroke( 15, 220);
  //draw text
  fill(0);
  textAlign( CENTER, CENTER);
  textSize(17);
  text( "Do you want to continue updating the block ?", zone.width / 2, zone.height / 2);
}
 void drawAddAmenitiesYes(Zone zone) {
 fill(#a0a0a0);
  stroke(15, 220);
  rect( 0, 0, zone.width, zone.height);
  //draw text
  fill(#ffffff);
  textAlign( CENTER, CENTER);
  textSize(16.5);
  text("Yes", zone.width / 2, zone.height / 2);  
}
 void drawAddAmenitiesNo(Zone zone) {
 fill(#a0a0a0);
  stroke(15, 220);
  rect( 0, 0, zone.width, zone.height);
  //draw text
  fill(#ffffff);
  textAlign( CENTER, CENTER);
  textSize(16.5);
  text("No", zone.width / 2, zone.height / 2);  
}
void drawAddAmenitiesText3(Zone zone) {
  noFill();
  stroke( 15, 220);
  //draw text
  fill(0);
  textAlign( CENTER, CENTER);
  textSize(16.5);
  text( "Place the block on the Interactive Area, then press Done ", zone.width / 2, zone.height / 2);
}

 void drawAddAmenitiesDone (Zone zone) {
 fill(#a0a0a0);
  stroke(15, 220);
  rect( 0, 0, zone.width, zone.height);
  //draw text
  fill(#ffffff);
  textAlign( CENTER, CENTER);
  textSize(16.5);
  text("Done", zone.width / 2, zone.height / 2);  
}
void drawDeleteBlockText(Zone zone) {
  noFill();
  stroke( 15, 220);
  //draw text
  fill(0);
  textAlign( CENTER, CENTER);
  textSize(17.5);
  text( "Are you sure you want to delete the block ?", zone.width / 2, zone.height / 2);
}

 void drawDeleteBlockYes (Zone zone) {
 fill(#a0a0a0);
  stroke(15, 220);
  rect( 0, 0, zone.width, zone.height);
  //draw text
  fill(#ffffff);
  textAlign( CENTER, CENTER);
  textSize(16.5);
  text("Yes", zone.width / 2, zone.height / 2);  
}
 void drawDeleteBlockNo (Zone zone) {
 fill(#a0a0a0);
  stroke(15, 220);
  rect( 0, 0, zone.width, zone.height);
  //draw text
  fill(#ffffff);
  textAlign( CENTER, CENTER);
  textSize(16.5);
  text("No", zone.width / 2, zone.height / 2);  
}

void drawChooseSim(Zone zone) {
  noFill();
  stroke( 15, 220);
  //dr‰aw text
  fill(127,0,0);
  textAlign( CENTER, CENTER);
  textSize(17);
  text( "Choose Simulation ", zone.width / 2, zone.height / 2);
}

void drawWalkabilitySim(Zone zone){
  fill(#a0a0a0);
  stroke( 15, 220);
  rect( 0, 0, zone.width, zone.height);
  //draw text
  fill(#ffffff);
  textAlign( CENTER, CENTER);
  textSize(16.5);
  text("Walkability", zone.width / 2, zone.height / 2);
}
void drawEnergySim(Zone zone){
  fill(#a0a0a0);
  stroke( 15, 220);
  rect( 0, 0, zone.width, zone.height);
  //draw text
  fill(#ffffff);
  textAlign( CENTER, CENTER);
  textSize(16.5);
  text("Energy", zone.width / 2, zone.height / 2);
}


//------- External Functions -----//

void HomeButtons () {
  SMT.add(new ButtonZone ("AddBlock", 450,800,150,60));
  SMT.add(new ButtonZone ("UpdateBlock", 660,800,150,60));
}

void AmentiesChecking () {
  //Remove 
  SMT.remove("AmentieType");
   SMT.remove("Mousque");
   SMT.remove("Bank");
   SMT.remove("Grocery");
   SMT.remove("Coffee");  
   SMT.remove("School");
   SMT.remove("Book");
   SMT.remove("Entertainment");  
   SMT.remove("Shopping");
   
   //Add
   //Text
   SMT.add(new Zone ("AddAmenitiesText", 530,810,0,0));
   SMT.add(new Zone ("AddAmenitiesText2", 600,840,0,0));
   //-Buttons
   SMT.add(new ButtonZone ("AddAmenitiesYes", 650,870,50,35));
   SMT.add(new ButtonZone ("AddAmenitiesNo", 710,870,50,35));
   
   //Upate query 
  AmenID++;
  InsertQuery=  "INSERT INTO Amenities (AmeID, BlockID, AmenityType) VALUES "+"("+"\""+AmenID+"\","+"\""+ID+"\","+"\""+AmentieType+"\");"; 
  db.query(InsertQuery);
}

void removeEverything () {
//Remove 
    SMT.remove("Home");
    SMT.remove("Intro");

    SMT.remove("AddBlock");
    SMT.remove("DetactionZoneAB");
    SMT.remove("UpdateBlock");
    SMT.remove("DetactionZoneUB");

    
    SMT.remove("AddBlockText");
    SMT.remove("AddBlockDone");
    SMT.remove("AddBlockButton");
    
    SMT.remove("UpdateBuildings");
    SMT.remove("UpdateBuildingsText");
    SMT.remove("UpdateBuildingsText2");
    SMT.remove("UpdateBuildingsText3");
    SMT.remove("UpdateBuildingsUpdate");
    SMT.remove("UpdateBuildingsNo");
    SMT.remove("UpdateBuildingsYes");
    SMT.remove("UpdateBuildingsDone");
  
  SMT.remove("NumberOfFloors");
  SMT.remove("WindowToWallRatio");
  SMT.remove("North");
  SMT.remove("South");
  SMT.remove("West");
  SMT.remove("East");
  SMT.remove("NumberofFloorsSlider");
  SMT.remove("NorthSlider");
  SMT.remove("SouthSlider");
  SMT.remove("WestSlider");
  SMT.remove("EastSlider");   
  
   SMT.remove("AddAmenities");
   SMT.remove("AmentieType");

   SMT.remove("Mousque");
   SMT.remove("Bank");
   SMT.remove("Grocery");
   SMT.remove("Coffee");  
   SMT.remove("School");
   SMT.remove("Book");
   SMT.remove("Entertainment");  
   SMT.remove("Shopping");
   SMT.remove("AddAmenitiesText");
   SMT.remove("AddAmenitiesText2");
   SMT.remove("AddAmenitiesText3");

   SMT.remove("AddAmenitiesYes");
   SMT.remove("AddAmenitiesNo");
   SMT.remove("AddAmenitiesDone");
  
   SMT.remove("DeleteBlock");
   SMT.remove("DeleteBlockText");
   SMT.remove("DeleteBlockYes");
   SMT.remove("DeleteBlockNo");

   SMT.remove("ChooseSim");
   SMT.remove("WalkabilitySim");
   SMT.remove("EnergySim");
   SMT.remove("Results");
}
