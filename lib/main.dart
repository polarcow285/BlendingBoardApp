import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:ui';
import 'package:flutter/widgets.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_sfsymbols/flutter_sfsymbols.dart';
//import 'package:qr_flutter/qr_flutter.dart';
//import 'package:barcode_scan/barcode_scan.dart';


class SizeConfig {
  static MediaQueryData _mediaQueryData;
  static double screenWidth;
  static double screenHeight;
  static double blockSizeHorizontal;
  static double blockSizeVertical;

  static double _safeAreaHorizontal;
  static double _safeAreaVertical;
  static double safeBlockHorizontal;
	static double safeBlockVertical;

  void init(BuildContext context) {
  _mediaQueryData = MediaQuery.of(context);
  screenWidth = _mediaQueryData.size.width;
  screenHeight = _mediaQueryData.size.height;
  blockSizeHorizontal = screenWidth / 100;
  blockSizeVertical = screenHeight / 100;

  _safeAreaHorizontal = _mediaQueryData.padding.left + _mediaQueryData.padding.right;
	_safeAreaVertical = _mediaQueryData.padding.top + _mediaQueryData.padding.bottom;
  safeBlockHorizontal = (screenWidth -_safeAreaHorizontal) / 100;
	safeBlockVertical = (screenHeight -_safeAreaVertical) / 100;
 }
}
class FadeRoute extends PageRouteBuilder {
  final Widget page;
  FadeRoute({this.page})
      : super(
          pageBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) =>
              page,
          transitionsBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) =>
              FadeTransition(
                opacity: animation,
                child: child,
              ),
        );
}
class SlideLeftRoute extends PageRouteBuilder {
  final Widget page;
  SlideLeftRoute({this.page})
      : super(
          pageBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) =>
              page,
          transitionsBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) =>
              SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(1, 0),
                  end: Offset.zero,
                ).animate(animation),
                child: child,
              ),
        );
}
class SlideRightRoute extends PageRouteBuilder {
  final Widget page;
  SlideRightRoute({this.page})
      : super(
          pageBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) =>
              page,
          transitionsBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) =>
              SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(-1, 0),
                  end: Offset.zero,
                ).animate(animation),
                child: child,
              ),
        );
}
class SlideUpRoute extends PageRouteBuilder {
  final Widget page;
  SlideUpRoute({this.page})
      : super(
          pageBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) =>
              page,
          transitionsBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) =>
              SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0, 1),
                  end: Offset.zero,
                ).animate(animation),
                child: child,
              ),
        );
}
class ScaleRoute extends PageRouteBuilder {
  final Widget page;
  ScaleRoute({this.page})
      : super(
          pageBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) =>
              page,
          transitionsBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) =>
              ScaleTransition(
                scale: Tween<double>(
                  begin: -1.0,
                  end: 1.0,
                ).animate(
                  CurvedAnimation(
                    parent: animation,
                    curve: Curves.fastOutSlowIn,
                  ),
                ),
                child: child,
              ),
        );
}

List<String> dataStringList = [];
List <List> allData = [];
int numberOfLetterPacks;
LetterPack discardPack;
class LetterSet{
  String name;
  List <String> position;
  List<String> letters;
  List<String> lettersToRemove;
  List<String> lettersToAdd;

  LetterSet(String nameString, List<String> positionList, List<String> letterList){
    name = nameString;
    position = positionList;
    if (positionList[0] == "sides"){
      position = ["beginning", "end"];
    }
    if (positionList[0] == "all"){
      position = ["beginning", "middle", "end"];
    }
    if (positionList[0] == "latterHalf"){
      position = ["middle", "end"];
    }
    letters = letterList;
    lettersToRemove = [];
    lettersToAdd = [];
  }
  List<String> generateCustomLetters(){
    List<String> tempList = [];

    //copy letters from original letter set to edited one
    for(int i = 0; i<letters.length; i++){
      tempList.add(letters[i]);
    }

    //removing letters
    for(int j = 0; j<lettersToRemove.length; j++){
      tempList.remove(lettersToRemove[j]);
    }

    //adding letters
    for(int k = 0; k<lettersToAdd.length; k++){
      tempList.add(lettersToAdd[k]);
    }
    //if the user has deleted all the letters, input a blank space into the list
    //this prevents a crash when the BoardScreen tries to load
    if(tempList.length == 0){
      tempList.add(" ");
    }
    return tempList;
  }
  
  void dataEncode(List<String> stringList){
    stringList.add("#" + name);
    stringList.add(position[0]);
    for(int i=0; i<letters.length; i++){
      stringList.add(letters[i]);
    }
  }
  void letterSetInfo(){
    print (name);
    print (position);
    print (letters);
  }
  
}

class LetterPack{
  String name;
  LetterSet beginning;
  LetterSet middle;
  LetterSet end;
  
  List<LetterSet> sets;
  
  LetterPack(String nameString, LetterSet beg, LetterSet mid, LetterSet e){
    name = nameString;
    beginning = beg;
    middle = mid;
    end = e;
    
    sets = [beginning, middle, end];
    
  }
  void dataEncode(List<String> stringList){
    stringList.add(name);
    beginning.dataEncode(stringList);
    middle.dataEncode(stringList);
    end.dataEncode(stringList);
  }
  
  void letterPackInfo(){
    print (name);
    print (beginning.name);
    print (beginning.letters);
    print (middle.name);
    print (middle.letters);
    print (end.name);
    print (end.letters);
  }
  
  static void encodeAll(){
    for (int i=0; i<allPacks.length; i++){
      List <String> temp = [];
      allPacks[i].dataEncode(temp);
      //add stuff from temp into dataStringList
      allData.add(temp);
    }
  }
  static LetterPack decodeLetterPack(List <String> letterSetList){
    LetterPack tempLP;
    String letterPackName = "";
    LetterSet tempLS1;
    LetterSet tempLS2;
    LetterSet tempLS3;
    int index1;
    int index2;
    int index3;
    String letterSetName1 = "";
    String letterSetName2 = "";
    String letterSetName3 = "";
    List<String> position1 = [];
    List<String> position2 = [];
    List<String> position3 = [];
    List<String> lettersList1 = [];
    List<String> lettersList2 = [];
    List<String> lettersList3 = [];
    int count = 0;
    
    for(int i =0; i<letterSetList.length; i++){
      //if the first character of the string is a #, then the string is the name of a letter set
       if(letterSetList[i][0] == "#"){
         count++;
         if(count == 1){
           index1 = i;
           letterSetName1 = letterSetList[i].substring(1,letterSetList[i].length);
           position1.add(letterSetList[i+1]);
         }
         if(count == 2){
           index2 = i;
           letterSetName2 = letterSetList[i].substring(1,letterSetList[i].length);
           position2.add(letterSetList[i+1]);
         }
         if(count == 3){
           index3 = i;
           letterSetName3 = letterSetList[i].substring(1,letterSetList[i].length);
           position3.add(letterSetList[i+1]);
         }
       }
    }
    letterPackName = letterSetList[0];
    lettersList1 = letterSetList.sublist(index1+2, index2);
    lettersList2 = letterSetList.sublist(index2+2, index3);
    lettersList3 = letterSetList.sublist(index3+2);
    
    tempLS1 = new LetterSet(letterSetName1, position1, lettersList1);
    tempLS2 = new LetterSet(letterSetName2, position2, lettersList2);
    tempLS3 = new LetterSet(letterSetName3, position3, lettersList3);
    tempLP = new LetterPack(letterPackName, tempLS1, tempLS2, tempLS3);
    return tempLP;

  }
  //decodeAll will take allData and update allPacks.
  static void decodeAll(){
    //allPacks is a list of letterpacks
    allPacks.clear();
    //allData is a list of stringLists
    //decodeLetterPack converts stringList into a letterPack
    for (int i=0; i<allData.length; i++){
      allPacks.add(decodeLetterPack(allData[i]));
    }
  }
  
}
LetterSet singleConsonantsBeginning = LetterSet("Single Consonants", ["beginning"], ["b", "c", "d", "f", "g", "h", "j", "k", "l", "m", "n", "p", "qu", "r", "s", "t", "v", "w", "x", "y", "z"]);  
LetterSet singleConsonantsEnding = LetterSet("Single Consonants",["end"], ["b", "c", "d", "f", "g", "h", "j", "k", "l", "m", "n", "p", "r", "s", "t", "v", "w", "x", "y", "z"]);
LetterSet hBrothers = LetterSet("H Brothers", ["sides"], ["ch", "ph", "sh", "th", "wh"]);
LetterSet beginningBlends = LetterSet("Beginning Blends", ["beginning"], ["bl", "br", "cl", "cr", "dr", "fl", "fr", "gl", "gr", "pl", "pr", "sc", "scr", "shr", "sk", "sl", "sm", "sn", "sp", "spl", "spr", "squ", "st", "str", "sw", "thr", "tr", "tw"]);
LetterSet shortVowelPointers = LetterSet("Short Vowel Pointers", ["latterHalf"], ["ck", "dge", "tch", "ff", "ll", "ss", "zz"]);
LetterSet endingBlends = LetterSet("Ending Blends", ["end"], ["sk", "sp", "st", "ct", "ft", "lk", "lt", "mp", "nch", "nd", "nt", "pt"]);
LetterSet magicEEnding = LetterSet("Magic E", ["end"], ["be", "ce", "de", "fe", "ge", "ke", "le", "me", "ne", "pe", "se", "te"]);
LetterSet closedSyllable = LetterSet("Closed Syllable", ["middle"], ["a", "e", "i", "o", "u"]);
LetterSet openSyllable = LetterSet("Open Syllable", ["middle"], ["a", "e", "i", "o", "u"]);
LetterSet magicEMiddle = LetterSet("Magic E", ["middle"], ["a", "e", "i", "o", "u"]);
LetterSet controlledR = LetterSet("Controlled R", ["middle"], ["ar", "er", "ir", "or", "ur"]);
LetterSet shortVowelExceptions = LetterSet("Short Vowel Exceptions", ["middle"], ["ang", "ank", "ild", "ind", "ing", "ink", "old", "oll", "olt", "ong", "onk", "ost", "ung", "unk"]);
LetterSet vowelTeamBasic = LetterSet("Vowel Team Basic", ["middle"], ["ai", "ay", "ea", "ee", "igh", "oa", "oy"]);
LetterSet vowelTeamIntermediate = LetterSet("Vowel Team Intermediate", ["middle"], ["aw", "eigh", "ew", "ey", "ie", "oe", "oi", "oo", "ou", "ow"]);
LetterSet vowelTeamAdvanced = LetterSet("Vowel Team Advanced", ["middle"], ["aw", "eigh", "ew", "ey", "ie", "oe", "oi", "oo", "ou", "ow"]);
LetterSet vowelA = LetterSet("Vowel A", ["middle"], ["al", "all", "wa", "al", "all", "wa"]);
LetterSet empty = LetterSet("Empty", ["all"], [" ", " ", " ", " "]);
  
List<LetterSet> allSets = [singleConsonantsBeginning, singleConsonantsEnding,  hBrothers, beginningBlends, endingBlends, magicEEnding, closedSyllable, openSyllable, magicEMiddle, shortVowelPointers,  controlledR, shortVowelExceptions, vowelTeamBasic, vowelTeamIntermediate, vowelTeamAdvanced, vowelA, empty];

LetterPack standardClosed = LetterPack("Standard (Closed Syllable)", singleConsonantsBeginning, closedSyllable, singleConsonantsEnding);
LetterPack standardOpen = LetterPack("Standard (Open Syllable)", singleConsonantsBeginning, openSyllable, singleConsonantsEnding);
LetterPack blendingDemo = LetterPack("Blending Demo", LetterSet("Bl",  ["beginning"], ["bl"]), LetterSet("e", ["middle"], ["E"]), LetterSet("Nd", ["beginning"], ["nd"]));
  
List<LetterPack> defaultPacks = [standardClosed, standardOpen, blendingDemo];
List<LetterPack> allPacks = [standardClosed, standardOpen, blendingDemo];

var letterPackMap = {"Standard (Closed Syllable)": standardClosed, "Standard (Open Syllable)": standardOpen, "Blending Demo": blendingDemo};
String letterPackName = "";

LetterSet selectedBeginningSet;
LetterSet selectedMiddleSet;
LetterSet selectedEndSet;
bool firstBuild = true;
bool isLargeScreen;

LetterSet beg;
LetterSet mid;
LetterSet end;

/*_reset() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.clear(); 
    // allPacks.clear();  
    print("CLEARED ALL");
}*/
void main(){
    WidgetsFlutterBinding.ensureInitialized(); 
    SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft]).then((_){
    runApp(MyApp());
  });
} 

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Blending Board',
      theme: ThemeData(
        fontFamily: 'SF-Pro-Rounded',
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Blending Board'),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
 
  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String barcode = "";
  @override
  void initState(){
    super.initState();
    SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeRight,
        DeviceOrientation.landscapeLeft,
    ]);
    
    if (firstBuild == true){
      //_reset();
      readAll();
      firstBuild = false;
    }  

  }

  Future<List> _read(String keyNumberString) async {
    final prefs = await SharedPreferences.getInstance();
    final key = keyNumberString;
    final value = prefs.getStringList(key) ?? [];
    //print('read: $value');
    return value;
  }

  Future<List> _readDiscardPack(String discardKey) async {
    final prefs = await SharedPreferences.getInstance();
    final key = discardKey;
    final value = prefs.getStringList(key);
    //print(value);
    return value;
  }

  Future <int>_readInt(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return int
    int intValue = prefs.getInt(key);
    return intValue;
  }

  void readAll() async {
        await _readInt("numberOfKeys").then((value) {
              numberOfLetterPacks = value;
        });
        print(numberOfLetterPacks);
        if (numberOfLetterPacks == null){
          setState(() { 
            numberOfLetterPacks = 3;
          });        
          //print("First time. Default packs will be set");
        }
        else{
          numberOfLetterPacks = numberOfLetterPacks;
          allPacks.clear();
          
          for(int i = 0; i<numberOfLetterPacks; i++){
            await _read("$i").then((value) {
              //print(value);
              LetterPack tempPack = LetterPack.decodeLetterPack(value);
              
              allPacks.add(tempPack);
              //adding pack to letterPackMap
              letterPackMap[value[0]] = tempPack;
              
            });
            
          }
          print("Read and decoded all packs");
        }
        print(numberOfLetterPacks);
      }
  Future <String>_readLetterPackName(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String stringValue = prefs.getString(key);
    return stringValue;
  }

  Future <void> readAtLogoButton() async{
    await _readLetterPackName("currentLetterPackName").then((value) {
      if (value == null){
        print("First time, letterPackName = null");
        value = "Standard (Closed Syllable)";
      }
      letterPackName = value;
      print(letterPackName);
    });
    if (letterPackName == "discardPack"){
        print("Last pack was a discard Pack, need to load discardPack");
        await _readDiscardPack("discardPackKey").then((value) {
            discardPack = LetterPack.decodeLetterPack(value);
            //adding pack to letterPackMap
            letterPackMap["discardPack"] = discardPack;
      
              
        });
      }
     
  }
  /*Future scan() async {
    try {
      String barcode = await BarcodeScanner.scan();
      setState(() => this.barcode = barcode);
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.CameraAccessDenied) {
        setState(() {
          this.barcode = 'The user did not grant the camera permission!';
        });
      } else {
        setState(() => this.barcode = 'Unknown error: $e');
      }
    } on FormatException{
      setState(() => this.barcode = 'null (User returned using the "back"-button before scanning anything. Result)');
    } catch (e) {
      setState(() => this.barcode = 'Unknown error: $e');
    }
  }*/
  _reset() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.clear(); 
    // allPacks.clear();  
    print("CLEARED ALL");
  }
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    if (MediaQuery.of(context).size.height > 600) {
      isLargeScreen = true;
    } 
    else {
      isLargeScreen = false;
    }
    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'SF-Pro-Rounded',
      ),
      debugShowCheckedModeBanner: false,
      home: Stack(children: <Widget>[ 
        Container(
          height: SizeConfig.screenHeight,
          width: SizeConfig.screenWidth,
          decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/water-blue-ocean.jpg"), 
                fit: BoxFit.cover
              )
            ),
            child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.4),
                  ),
                )
            )
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: Stack(
        children: <Widget>[
          Align(
            child: miscButtonRow(),
            alignment: Alignment.bottomCenter,
          ),
          Align(
            child: mainButtonRow(),
            alignment: Alignment.center,
          ),
          Positioned(
                bottom: 20,
                left: 20,
                    child: IconButton(
                      icon: Icon(Icons.access_alarm),
                        color: Color(0xFF0690d4),
                        onPressed: () {
                          Navigator.push(
                            context,
                            SlideRightRoute(page: Test1Screen()),
                          );
                        },
                )
              )
            /*Positioned(
                bottom: 20,
                left: 20,
                    //child: Text("Version 1.0")
              )*/
        ],
      )
      )
        ],
      )
    );
  }
  Widget mainButtonRow(){
    return Container(
    child: Row(
      //crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
        children: [
          //CustomListItem(),
          createDeckButton(),
          logoButton(),
          myDecksButton()
        ],
    )
   );
  }
  Widget miscButtonRow(){
    return Container(
      margin: EdgeInsets.only(bottom: 20),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
        children: [
          missionStatementButton(),
          qrCamera(),
        ],
    )
   );
  }
  Widget createDeckButton() {
    return Container( 
      margin: EdgeInsets.only(top: 20, right: 10,),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          IconButton(
            icon: Icon(SFSymbols.plus_square_fill),
            color: Colors.white,
            iconSize: (isLargeScreen == true) ? SizeConfig.screenHeight * 0.20 : SizeConfig.screenHeight * 0.35,//125,
            onPressed: (){
              Navigator.push(
                context,
                SlideRightRoute(page: CreateDecksScreen()),
              );
            }  
          ),
          Text(
            "Create Deck",
            style: TextStyle(
              color: Colors.blue,
              fontFamily: 'SF-Pro-Rounded',
              fontWeight: FontWeight.w600,
              fontSize: (isLargeScreen == true) ? SizeConfig.safeBlockVertical * 3 : SizeConfig.safeBlockVertical * 4,
            ),
          )
        ],
      )
    );
  }
 
  Widget logoButton() {
    return Container(
      margin: EdgeInsets.only(top: 20, right: 5, left: 5, bottom: 20),
      
      child: GestureDetector(
        child: Image(
          image: AssetImage('assets/blendingBoardLogo.png'),
          height: (isLargeScreen == true) ? SizeConfig.screenHeight * 0.50 : SizeConfig.screenHeight * 0.65,
          width: (isLargeScreen == true) ? SizeConfig.screenHeight * 0.50 : SizeConfig.screenHeight * 0.65,
        ),
        onTap: () async{
          //read
        await _readLetterPackName("currentLetterPackName").then((value) {
          if (value == null){
              print("First time, letterPackName = null");
              value = "Standard (Closed Syllable)";
            }
            letterPackName = value;
            print(letterPackName);
        });
        if (letterPackName == "discardPack"){
          print("Last pack was a discard Pack, need to load discardPack");
          //read the discard pack from shared preferences
          //List<String> tempStringList = [];
          await _read("discardPackKey").then((value) {
              discardPack = LetterPack.decodeLetterPack(value);
              letterPackMap["discardPack"] = discardPack;
            });
      }
          Navigator.push(
            context,
            FadeRoute(page: BoardScreen()),
          );
        },
      ),
    );
  }
  Widget myDecksButton() {
    return Container(
      margin: EdgeInsets.only(top: 20, left: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          IconButton(
            icon: Icon(SFSymbols.square_grid_2x2_fill),
            color: Colors.white,
            iconSize: (isLargeScreen == true) ? SizeConfig.screenHeight * 0.20 : SizeConfig.screenHeight * 0.35,//125,
            onPressed: (){
              Navigator.push(
                context,
                SlideLeftRoute(page: MyDecksScreen())
              );
            },
          ),
          Text(
            "My Decks",
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: (isLargeScreen == true) ? SizeConfig.safeBlockVertical * 3 : SizeConfig.safeBlockVertical * 4,
              color: Colors.lightBlue
            ),
          )
        ],
      )
    );
  }
  Widget missionStatementButton() {
    return Container(
      margin: EdgeInsets.only(bottom: SizeConfig.safeBlockHorizontal),
      height: SizeConfig.screenWidth * (0.05),
      width: SizeConfig.screenWidth * (0.05),
      decoration: BoxDecoration( 
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
    child: Container(
      margin: EdgeInsets.all(5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(5)),
        image: DecorationImage(
          fit: BoxFit.scaleDown,
            image: AssetImage('assets/outlineDyslexiaBrainLogo.png'),
        ),
      ),
        child: FlatButton(
          child: Text(""),
        onPressed: () {
          Navigator.push(
            context,
            SlideUpRoute(page: MissionStatementScreen())
          );
        },
      ),
    )
    );
  }
  Widget settingsButton() {
    return Container(
      margin: EdgeInsets.all(20),
      child: IconButton(
        icon: Icon(Icons.settings),
        onPressed: () {
          
        },
      ),
    );
  }
  Widget qrCamera() {
    return Container(
      margin: EdgeInsets.all(20),
      child: IconButton(
        icon: Icon(Icons.camera),
        onPressed: () {
          //scan();
        },
      ),
    );
  }
}
class MissionStatementScreen extends StatefulWidget {
  @override
  _MissionStatementScreenState createState() => _MissionStatementScreenState();
}
class _MissionStatementScreenState extends State<MissionStatementScreen>{
  @override
  void initState(){
    super.initState();
    SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeRight,
        DeviceOrientation.landscapeLeft,
    ]);
  }
  Future<void> _launchURL() async {
  const url = 'http://www.dyslexicmindset.com';
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        //alignment: Alignment.center,
        children: <Widget>[
          Container(
              constraints: BoxConstraints.expand(),
              decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/water-blue-ocean.jpg"),
                fit: BoxFit.cover)
              ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            //crossAxisAlignment: ,
            children: <Widget>[
              Flexible(
                child: missionStatementImage(),
              ),           
              missionStatementText()
            ],
          ),
          Positioned(
            top: SizeConfig._safeAreaVertical + 10,
            left: 20,
            child: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.cancel),
              iconSize: SizeConfig.screenHeight * 0.05,
              color: Colors.white
            ),
          )
        ],
      )
      
    );
  }
  Widget missionStatementImage() {
   
    return GestureDetector(
      onTap: () {
        _launchURL(); 
      },
      child: Image(
            image: AssetImage('assets/dyslexiaBrain.png'),

            height: SizeConfig.screenWidth * 0.9,
            width: SizeConfig.screenHeight * 0.9,
          ),
    );
  }
  Widget missionStatementText() {
    return Container(
      margin: EdgeInsets.all(SizeConfig._safeAreaVertical + 20),
      child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
     
        Text("Mission:",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: SizeConfig.safeBlockHorizontal * 2.5),
          ),
        
        ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: SizeConfig.screenHeight/2,
            maxHeight: SizeConfig.screenWidth,
          ),
          child: Text("\nThis app was created to ensure access to FREE dyslexia resources as part of Nadine Gilkison's Google Innovator Project.\nSpecial thanks to Brayden Gogis for creating this app to help millions of teachers and students on a global scale.\nTap the brain for more FREE resources!",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w400, fontSize: SizeConfig.safeBlockHorizontal * 2),
          )
        )
      ],
      )
    );
  }
}
class CustomListItem extends StatefulWidget{
  const CustomListItem({
    Key key,
    this.thumbnail,
    this.title,
    this.user,
    this.viewCount,
  }): super(key: key);

  final Widget thumbnail;
  final String title;
  final String user;
  final int viewCount;

  
  
  @override
  _CustomListItemState createState() => _CustomListItemState();
}
class _CustomListItemState extends State<CustomListItem>{
  
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      //child: Card(
        
        child: Row(
        //spacing: 80,
        mainAxisAlignment: MainAxisAlignment.center,
        //crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          
         // Text("Hellloo"),
          Card(
            color: Colors.yellow,
            child: IconButton(
            icon: Icon(Icons.volume_up),
            //tooltip: 'Increase volume by 10',
            onPressed: () {
              setState(() {
                //_volume += 10;
                print("opfir");
              });
            },
          ),
          )
          /*
          )*/
        ],
        )
      //),
    );
  }
}

class CreateDecksScreen extends StatefulWidget {
  @override
  _CreateDecksScreenState createState() => _CreateDecksScreenState();
}

class _CreateDecksScreenState extends State<CreateDecksScreen>{
  static int editBeginningIndex = 0;
  static int editMiddleIndex = 0;
  static int editEndIndex = 0;
  int _defaultBeginningChoiceIndex = 0;
  int _defaultMiddleChoiceIndex = 1;
  int _defaultEndChoiceIndex = 0;
  List <ChoiceChip> choiceChipList = [];
  static List <LetterSet> beginningSetsList = [];
  static List <LetterSet> middleSetsList = [];
  static List <LetterSet> endSetsList = [];
  static LetterSet tempBeginningSet;
  static LetterSet tempMiddleSet;
  static LetterSet tempEndSet;

  void sortChips(){
    beginningSetsList.clear();
    middleSetsList.clear();
    endSetsList.clear();
    //go through all the sets, take the ones that are beginning, and put them into a list
    for(int i = 0; i<allSets.length; i++){
     
     for(int j = 0; j<allSets[i].position.length; j++){
       if(allSets[i].position[j] == "beginning"){
        
        beginningSetsList.add(allSets[i]);
       } 
       if (allSets[i].position[j] == "middle"){
         middleSetsList.add(allSets[i]);
       }
       if (allSets[i].position[j] == "end"){
         endSetsList.add(allSets[i]);
       }
     }
    }
  }

  @override
  void initState(){
    super.initState();
    SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeRight,
        DeviceOrientation.landscapeLeft,
    ]);
    
    sortChips();
    print("length: ${beginningSetsList.length}");
   }
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'SF-Pro-Rounded',
      ),
      debugShowCheckedModeBanner: false,
      home: Stack (
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/water-blue-ocean.jpg"), 
                fit: BoxFit.cover
            )
          ),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
              child: Container(
                decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.4),
                ),
              )
            )
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: Stack(
            
            children: <Widget>[
             choiceChipRow(),
             
              Positioned(
                bottom: 20,
                left: 20,
                child: IconButton(
                  icon: Icon(SFSymbols.house_fill),
                  iconSize: SizeConfig.screenHeight * 0.05,
                  color: Color(0xFF0690d4),
                  onPressed: () {
                  setState(() {
                      sortChips();
                    });
                    
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MyApp()),
                    );
                    
                  },
                )
              )
            ],
          )
        )   
      ],
      )
    );
  }
  
          
  Widget beginningChoiceChips() {
    return ListView.builder(
      itemCount: beginningSetsList.length,
      //itemExtent: 100,
      itemBuilder: (BuildContext context, int index) {
        return Container(
          //height: 50,
          //width: SizeConfig.screenWidth * 0.25,
          margin: EdgeInsets.only(bottom: 10,),
         // padding: EdgeInsets.only(bottom: 10,),
            child: InputChip(
        selected: _defaultBeginningChoiceIndex == index,
        label: Container(
          width: 200,
          margin: EdgeInsets.all(10),
          child:  
            Text(beginningSetsList[index].name,
                style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 2, fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
            ),
        ),
        showCheckmark: false,
        deleteButtonTooltipMessage: "Edit",
        onDeleted: () {
          mid = beginningSetsList[index];
            Navigator.push(
              context,
              //pass letterset index
              MaterialPageRoute(builder: (context) => TestScreen()),
            );    
        },
        deleteIcon: Icon(SFSymbols.pencil,
        color: Color(0xFF0342dc),),
        onPressed: () {
          setState(() {
            _defaultBeginningChoiceIndex = index;
           // print("defaultindex: $defaultIndex");
           // print("listbuilder: $listBuilderIndex");
          });
        },
      
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(topRight: Radius.circular(10),bottomRight: Radius.circular(10),topLeft: Radius.circular(10),bottomLeft: Radius.circular(10))),
            selectedColor: Color(0xFF3478F6).withOpacity(0.3),
            backgroundColor: Colors.white,
            labelStyle: TextStyle(color: Color(0xFF0342dc)),
            )
        );
          
        },
      
    );
    
  }
  Widget middleChoiceChips() {
    return ListView.builder(
      itemCount: middleSetsList.length,
      //itemExtent: 50,
      itemBuilder: (BuildContext context, int index) {
        return Container(
          margin: EdgeInsets.only(bottom: 10),
          child: InputChip(
        selected: _defaultMiddleChoiceIndex == index,
        label: Container(
          width: 200,
          margin: EdgeInsets.all(10),
          child:  
            Text(middleSetsList[index].name,
                style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 2, fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
            ),
        ),
        showCheckmark: false,
        deleteButtonTooltipMessage: "Edit",
        onDeleted: () {
          mid = middleSetsList[index];
            Navigator.push(
              context,
              //pass letterset index
              MaterialPageRoute(builder: (context) => TestScreen()),
            );    
        },
        deleteIcon: Icon(SFSymbols.pencil,
        color: Color(0xFF0342dc),),
        onPressed: () {
          setState(() {
            _defaultMiddleChoiceIndex = index;
           // print("defaultindex: $defaultIndex");
           // print("listbuilder: $listBuilderIndex");
          });
        },
      
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(topRight: Radius.circular(10),bottomRight: Radius.circular(10),topLeft: Radius.circular(10),bottomLeft: Radius.circular(10))),
            selectedColor: Color(0xFF3478F6).withOpacity(0.3),
            backgroundColor: Colors.white,
            labelStyle: TextStyle(color: Color(0xFF0342dc)),
            )
        );
        
          
        },
      
    );
  }
  Widget endChoiceChips() {
      return ListView.builder(
        itemCount: endSetsList.length,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            margin: EdgeInsets.only(bottom: 10,),
            child: InputChip(
        selected: _defaultEndChoiceIndex == index,
        label: Container(
          width: 200,
          margin: EdgeInsets.all(10),
          child:  
            Text(endSetsList[index].name,
                style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 2, fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
            ),
        ),
        showCheckmark: false,
        deleteButtonTooltipMessage: "Edit",
        onDeleted: () {
          mid = endSetsList[index];
            Navigator.push(
              context,
              //pass letterset index
              MaterialPageRoute(builder: (context) => TestScreen()),
            );    
        },
        deleteIcon: Icon(SFSymbols.pencil,
        color: Color(0xFF0342dc),),
        onPressed: () {
          setState(() {
            _defaultEndChoiceIndex = index;
           // print("defaultindex: $defaultIndex");
           // print("listbuilder: $listBuilderIndex");
          });
        },
      
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(topRight: Radius.circular(10),bottomRight: Radius.circular(10),topLeft: Radius.circular(10),bottomLeft: Radius.circular(10))),
            selectedColor: Color(0xFF3478F6).withOpacity(0.3),
            backgroundColor: Colors.white,
            labelStyle: TextStyle(color: Color(0xFF0342dc)),
            )
        );
          
        },
      
    );
  }
  Widget checkmarkButton() {
    return Container(
      margin: EdgeInsets.only(top: 20, right: SizeConfig._safeAreaVertical + 5, left: SizeConfig._safeAreaVertical + 5, bottom: 20),
      child: IconButton(
          icon: Icon(SFSymbols.checkmark_circle_fill),
          color: Color(0xFF00cbfb),
          iconSize: SizeConfig.screenHeight * 0.1,
          onPressed: () {
            setState(() {
              //sortChips();
              
              selectedBeginningSet = beginningSetsList[_defaultBeginningChoiceIndex];
              selectedMiddleSet = middleSetsList[_defaultMiddleChoiceIndex];
              selectedEndSet = endSetsList[_defaultEndChoiceIndex];
  
       
             
              print(selectedMiddleSet.lettersToRemove);
              tempBeginningSet = LetterSet(selectedBeginningSet.name, selectedBeginningSet.position, selectedBeginningSet.generateCustomLetters());
              tempMiddleSet = LetterSet(selectedMiddleSet.name, selectedMiddleSet.position, selectedMiddleSet.generateCustomLetters());
              tempEndSet = LetterSet(selectedEndSet.name, selectedEndSet.position, selectedEndSet.generateCustomLetters());
              //clear lettersToRemove and lettersToAdd

              //HAVE TO DO TO ALL, NOT JUST SELECTED
              for (LetterSet b in beginningSetsList){
                b.lettersToAdd.clear();
                b.lettersToRemove.clear();
              }
              for (LetterSet m in middleSetsList){
                m.lettersToAdd.clear();
                m.lettersToRemove.clear();
              }
              for (LetterSet e in endSetsList){
                e.lettersToAdd.clear();
                e.lettersToRemove.clear();
              }
          
              Navigator.push(
                context,
                ScaleRoute(page: SaveScreen()),
              );
            });
          },
        ),
    );
  }
  Widget column1(){
    return Container(
      width: SizeConfig.screenWidth * 0.25,
      height: 500,
      margin: EdgeInsets.only(top: SizeConfig._safeAreaVertical + 20, right: 5,),
      child: Column(
        mainAxisSize: MainAxisSize.max,
      children: [
        Container( 
          margin: EdgeInsets.only(bottom: 10),
          child: Text("Column 1",
            style: TextStyle(
              fontWeight: FontWeight.w700,
              color: Colors.blue,
              fontSize: SizeConfig.safeBlockHorizontal * 3,
            )
          ), 
        ),
        Flexible(
          child: beginningChoiceChips(),
        )

        
      ],
      )
    );
  }
  Widget column2(){
    return Container(
      width: SizeConfig.screenWidth * 0.25,
      height: 500,
      margin: EdgeInsets.only(top: SizeConfig._safeAreaVertical + 20, right: 5, left: 5,),
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(bottom: 10),
            child: Text("Column 2",
              style: TextStyle(
                fontWeight: FontWeight.w700,
                color: Colors.blue,
                fontSize: (SizeConfig.safeBlockHorizontal * 3)
              )
            ),
          ),
          Flexible(
            child: middleChoiceChips(),
          )
          
        ],
      )
    );
  }
  Widget column3(){
    return Container(
      width: SizeConfig.screenWidth * 0.25,
      height: 500,
      margin: EdgeInsets.only(top: SizeConfig._safeAreaVertical + 20, left: 5),
      child: Column(
        children: [
          Container( 
            margin: EdgeInsets.only(bottom: 10),
            child: Text("Column 3",
              style: TextStyle(
                fontWeight: FontWeight.w700,
                color: Colors.blue,
                fontSize: (SizeConfig.safeBlockHorizontal * 3),
              )
            ),
          ),
          Flexible(
            child: endChoiceChips(),
          )
          
        ],
      )
   );
  }
  Widget choiceChipRow(){
    return Row(
        children: [
          Spacer(),
          column1(),
          column2(),
          column3(),
          /*Expanded(
            child: column1(),
            flex: 2,
          ),
          Expanded(
            child: column2(),
            flex: 2,
          ),
          Expanded(
            child: column3(),
            flex: 2,
          ),
          */
          checkmarkButton(),
        ],
    );
  }
  
}

class TestScreen extends StatefulWidget {
  @override
  _TestScreenState createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  final _controller = TextEditingController();
  static List<String> removeMiddleLetterList = [];
  static List<String> addMiddleLetterList = [];

  @override
  void initState(){
    super.initState();
    SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeRight,
        DeviceOrientation.landscapeLeft,
    ]);
    //mid = _CreateDecksScreenState.middleSetsList[_CreateDecksScreenState.editMiddleIndex];
    
    
    
  }
  Widget build(BuildContext context) {
    final double itemWidth = SizeConfig.screenWidth/50;
    final double itemHeight = SizeConfig.screenWidth/50;
    
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Stack(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.all(30),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text("Letter sets"),
                      Text(mid.name)
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(30),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text("Letters"),
                      gridView(itemWidth, itemHeight)
                    ],
                  ),
                ),
              ]
            ),
            Positioned(
              bottom: 20,
              left: 20,
              child: IconButton(
                onPressed: () {
                  /*Navigator.push(
                    context,
                    //FadeSlideRightRoute(page: MyApp()),
                    //MaterialPageRoute(builder: (context) => CreateDecksScreen()),
                    
                  );*/
                  Navigator.pop(context);
                },
                icon: Icon(SFSymbols.house_fill),
                iconSize: SizeConfig.screenHeight * 0.05,
                color: Color(0xFF0690d4)
              ),
            ),   
          ]
        )
      )
    );
  }
  Widget gridView(double width, double height) {
    return ConstrainedBox(
      constraints: new BoxConstraints(
      //minHeight: ,
      maxHeight: SizeConfig.screenWidth-514,
      maxWidth: SizeConfig.screenWidth/2
    ),

    child: GridView.count(
      // Create a grid with 3 columns. If you change the scrollDirection to
      // horizontal, this produces 3 rows.
      crossAxisCount: 3,
      childAspectRatio: (width / height),
      // Generate allPacks.length amount widgets that display their index in the List.
      children: List.generate(mid.letters.length + 1 + mid.lettersToAdd.length, (index) {
       
        //print("index: $index");
       
        //last element of gridview should be a textformfield
        if(index == mid.letters.length + mid.lettersToAdd.length){
          return Container(
            width: SizeConfig.screenWidth * 0.3,
            decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10)
          ),
            child: TextFormField(
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
              onFieldSubmitted: (String input){

            setState(() {
              //when text is submitted to the textformfield, the letters are added to lettersToAdd list of the selected letterset
              mid.lettersToAdd.add(input);
            });
            
            
          },
          textAlign: TextAlign.center,
           decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: SizeConfig.screenWidth * 0.02,),
            fillColor: Colors.black.withOpacity(0.3),
            filled: true,
            border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide.none)
          ),
          controller: _controller,
        ),
        
      
    );
        }
        //sorting letters that were manually added, putting their filterchips after original letters 
        else if(mid.letters.length-1<index && index <mid.letters.length + mid.lettersToAdd.length){
          return Container(
            margin: EdgeInsets.only(top: 5, right: 5, left: SizeConfig._safeAreaVertical + 10, bottom: 5),
           
            child: FilterChip(
              label: FittedBox(
                fit: BoxFit.fitWidth,
                child: Text(mid.lettersToAdd[index-mid.letters.length],
                  style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 2, fontWeight: FontWeight.w500),
                    textAlign: TextAlign.center),
              ),
              selected: !mid.lettersToRemove.contains(mid.lettersToAdd[index-mid.letters.length]),
              onSelected: (bool selected) {
                setState(() {
                  if(selected){
                    //not selected yet, you are selecting now
                    //(undoing the remove) you do not want to remove this letter from the letter set, so remove it form removeMiddleLetterList
                    mid.lettersToRemove.remove(mid.lettersToAdd[index-mid.letters.length]);
                  }
                  else{
                    //already selected, you are deselecting now
                    //adding letter you want to remove into removeMiddleLetterList
                  
                    mid.lettersToRemove.add(mid.lettersToAdd[index-mid.letters.length]);
                   
                  }
                });
              }
            )
           
            );
        }
        else{
          return Container(
            
            margin: EdgeInsets.only(top: 5, right: 5, left: SizeConfig._safeAreaVertical + 10, bottom: 5),
            child: FilterChip(
              label:  Container( 
                width: 50,
                height: 50,
                child:Text(mid.letters[index],
                  style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 2, fontWeight: FontWeight.w500),
                    textAlign: TextAlign.center),
              ),
              selected: !mid.lettersToRemove.contains(mid.letters[index]),
              
              onSelected: (bool selected) {
                setState(() {
                  if(selected){
                    //not selected yet, you are selecting now
                    //undoing the remove
                    
                    mid.lettersToRemove.remove(mid.letters[index]);
                    //_CreateDecksScreenState.middleSetsList[editMiddleIndex].letters.remove(_CreateDecksScreenState.middleSetsList[editMiddleIndex].letters[index]);
                  }
                  else{
                    //already selected, you are deselecting now
                    //removeMiddleLetterList.add(_CreateDecksScreenState.middleSetsList[_CreateDecksScreenState.editMiddleIndex].letters[index]);
                    mid.lettersToRemove.add(mid.letters[index]);
                   
                  }
                });
              }
            )
           
            );
        }
        
          
      }),
    ),
     
    );
  }
  
}

class MyDecksScreen extends StatefulWidget {
  @override
  _MyDecksScreenState createState() => _MyDecksScreenState();
}

class _MyDecksScreenState extends State<MyDecksScreen> {
  @override

  void initState(){
    super.initState();
    SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeRight,
        DeviceOrientation.landscapeLeft,
    ]);
  }
  Widget build(BuildContext context) {
    //var size = MediaQuery.of(context).size;

    /*24 is for notification bar on Android*/
    //final double itemHeight = (size.height - kToolbarHeight - 24) / 2;

    final double itemWidth = SizeConfig.screenWidth;
    final double itemHeight = itemWidth/5;
  
    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'SF-Pro-Rounded',
      ),
      debugShowCheckedModeBanner: false,
      home: Stack( 
      children: [
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/water-blue-ocean.jpg"), 
                fit: BoxFit.cover
            )
          ),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
              child: Container(
                decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.4),
                ),
              )
            )
          ),
          Scaffold(
            backgroundColor: Colors.transparent,
            body: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                Positioned(
                  top: 20,
                  child: myDecksColumn(itemWidth, itemHeight),
                ),
            Positioned(
              bottom: 20,
              left: 20,
              child: IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    //FadeSlideRightRoute(page: MyApp()),
                    MaterialPageRoute(builder: (context) => MyApp()),
                  );
                },
                icon: Icon(SFSymbols.house_fill),
                iconSize: SizeConfig.screenHeight * 0.05,
                color: Color(0xFF0690d4)
              ),
            ),   
              ]
            )
          ) 
            
          ],
        
      )
    );
  }
  Widget myDecksColumn(double width, double height){
    return Container(
      margin: EdgeInsets.only(top: SizeConfig.safeBlockHorizontal),
      child: Column(
        children: [
          Container( 
            margin: EdgeInsets.all(10),
            child: Text("My Decks",
              style: TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.w500,
                fontSize: SizeConfig.safeBlockHorizontal * 2.5,
              )
            ),
          ),
          
          gridView(width, height),
        
          
        ],
      )
    );
  }
  Widget gridView(double width, double height) {
    return ConstrainedBox(
      constraints: new BoxConstraints(
      //minHeight: ,
      maxHeight: SizeConfig.screenWidth,
      maxWidth: SizeConfig.screenWidth - SizeConfig._safeAreaVertical
    ),

    child: GridView.count(
      // Create a grid with 3 columns. If you change the scrollDirection to
      // horizontal, this produces 3 rows.
      crossAxisCount: 3,
      childAspectRatio: (width / height),
      // Generate allPacks.length amount widgets that display their index in the List.
      children: List.generate(allPacks.length, (index) {
        //left deck
        if (index % 3 == 0){
          print("left : $index");
          return Container(
            margin: EdgeInsets.only(top: 5, right: 5, left: SizeConfig._safeAreaVertical + 10, bottom: 5),
            child: FlatButton(
              child: FittedBox(
                fit: BoxFit.fitWidth,
                child: Text(allPacks[index].name,
                  style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 2, fontWeight: FontWeight.w500),
                    textAlign: TextAlign.center),
              ),
                color: Colors.white,
                textColor: Color(0xFF0342dc),
                shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10)),
                onPressed: (){
                  letterPackName = allPacks[index].name;
                  Navigator.push(
                    context,
                    FadeRoute(page: BoardScreen()),
                  );
                },
              ),
            );
          }
                //right deck
          else if ((index-2) % 3 == 0){
            print("right $index");
            return Container(
              margin: EdgeInsets.only(top: 5, right: SizeConfig._safeAreaVertical + 10, left: 5, bottom: 5),
              child: FlatButton(
                child: FittedBox(
                  fit: BoxFit.fitWidth,
                  child: Text(allPacks[index].name,
                    style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 2, fontWeight: FontWeight.w500),
                    textAlign: TextAlign.center),
                  ),
                  color: Colors.white,
                  textColor: Color(0xFF0342dc),
                  shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
                  onPressed: (){
                    letterPackName = allPacks[index].name;
                    Navigator.push(
                      context,
                      FadeRoute(page: BoardScreen()),
                    );
                  },
                ),
              );
            }
                //middle deck
                else{
                    print("middle: $index");
                  return Container(
                    //width: width,
                    //height: height,
                    margin: EdgeInsets.all(5),
                    child: FlatButton(
                      child: FittedBox(
                          fit: BoxFit.fitWidth,
                          child: Text(allPacks[index].name,
                        style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 2, fontWeight: FontWeight.w500),
                          textAlign: TextAlign.center),
                        ),
                      color: Colors.white,
                      textColor: Color(0xFF0342dc),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                      onPressed: (){
                        letterPackName = allPacks[index].name;
                        Navigator.push(
                            context,
                            FadeRoute(page: BoardScreen()),
                        );
                      },
                    ),
                  );
                }
                
              }),
            ),
     
    );
  }
}

class SaveScreen extends StatefulWidget {
  @override
  _SaveScreenState createState() => _SaveScreenState();
}

class _SaveScreenState extends State<SaveScreen> {
  final _controller = TextEditingController();
  
  _saveInt(int numValue) async {
        final prefs = await SharedPreferences.getInstance();
        final key = "numberOfKeys";
        final value = numValue;
        prefs.setInt(key, value);
        //print('saved $value');
  }
  _saveLetterPack(List<String> stringList, String keyName) async {
        LetterPack.encodeAll();
        final prefs = await SharedPreferences.getInstance();
        final key = keyName;
        final value = stringList;
        prefs.setStringList(key, value);
        //print('saved $value');
  }
  
  _saveAll() async {
        numberOfLetterPacks++;
        LetterPack.encodeAll();
        print("encode all success!");
        await _saveInt(numberOfLetterPacks);
        print("saveInt success!");
        //goes through allData (list of string lists), which saves each letter pack
        for(int i=0; i<numberOfLetterPacks; i++){
          await _saveLetterPack(allData[i], i.toString());
        }
        print('Saved All');
        print(numberOfLetterPacks);
  }
  final _formKey = GlobalKey<FormState>();
  
  @override
  void initState(){
    super.initState();
    SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeRight,
        DeviceOrientation.landscapeLeft,
    ]);
  }
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'SF-Pro-Rounded',
      ),
      home: Stack(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/water-blue-ocean.jpg"), 
                fit: BoxFit.cover
              )
            ),
            child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.4),
                  ),
                )
            )
        ),
        Scaffold(
          resizeToAvoidBottomPadding: false,
          backgroundColor: Colors.transparent,
          body: Column(
            children: <Widget>[
              Container( 
                margin: EdgeInsets.only(top: SizeConfig._safeAreaVertical + 20, bottom: 5),
                child: Text("Save Your Deck?",
                style: TextStyle(color: Color(0xFF1079c4), fontWeight: FontWeight.w700, fontSize: SizeConfig.safeBlockHorizontal * 4),
                ),
              ),
              textSaveRow(),
              skipSaveButton(), 
            ],
          )
        )
      ],
      )
    );
  }
  Widget textSaveRow(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
      Spacer(),
      textFormField(),
      Expanded(
          child: Padding(
          padding: EdgeInsets.only(right: 10),
          child: saveButton(),
        ),
      ),
        
        
        
    
      ],
    );
  }
  
  Widget textFormField(){
    return Container(
      width: SizeConfig.screenWidth * 0.4,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10)
      ),
      child: Form(
        key: _formKey,
        child: TextFormField(
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
          validator: (value) {
            if (value.isEmpty) {
              return 'Please enter some text';
            }
            return null;
          },
          textAlign: TextAlign.center,
          controller: _controller,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: SizeConfig.screenWidth * 0.02,),
            fillColor: Colors.white.withOpacity(0.3),
            filled: true,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide.none
            ),
            hintText: 'Deck Name',
            hintStyle: TextStyle(color: Color(0xFF373737), fontWeight: FontWeight.w500, fontSize: SizeConfig.safeBlockHorizontal * 2.5),
        ),
        )
      )
    );
  }
  Widget saveButton() {
    return Container(
      margin: EdgeInsets.all(20),
      child:IconButton(
          icon: Icon(SFSymbols.checkmark_circle_fill),
          iconSize: SizeConfig.screenWidth * 0.05,
        color: Colors.blue,
        onPressed: (){
 
          if (_formKey.currentState.validate()) {
          setState(() {
            allPacks.add(new LetterPack(_controller.text, _CreateDecksScreenState.tempBeginningSet, _CreateDecksScreenState.tempMiddleSet, _CreateDecksScreenState.tempEndSet));
            letterPackName = _controller.text;
            //put new letterPack into letterPackMap
            letterPackMap[allPacks.last.name] = allPacks.last;
            _saveAll();
            Navigator.push(
              context,
              FadeRoute(page: BoardScreen()),
          );
          }); 
          }
        },
      ),
    );
  }
  Widget skipSaveButton() {
    return Container(
      margin: EdgeInsets.all(20),
      child: FlatButton(
        child: Text("Skip, Don't Save Deck",
          style: TextStyle(decoration: TextDecoration.underline, color: Color(0xFF0094c8), fontWeight: FontWeight.w500, fontSize: SizeConfig.safeBlockHorizontal * 2),
        ),
        color: Colors.transparent,
        textColor: Colors.black,
        onPressed: ()async {
            //Load the discard pack to the blending board
            discardPack = LetterPack("discardPack", _CreateDecksScreenState.tempBeginningSet, _CreateDecksScreenState.tempMiddleSet, _CreateDecksScreenState.tempEndSet);
            letterPackName = "discardPack";
            letterPackMap["discardPack"] = discardPack;
            
            //Save the discard letter pack
            List <String> tempEncodedStringList = [];
            discardPack.dataEncode(tempEncodedStringList);
            await _saveLetterPack(tempEncodedStringList, "discardPackKey");
            print(tempEncodedStringList);
            Navigator.push(
              context,
              FadeRoute(page: BoardScreen()),
          );
        },
      ),
    );
  }
}
class BoardScreen extends StatefulWidget {
  @override
  _BoardScreenState createState() => _BoardScreenState();
}

class _BoardScreenState extends State<BoardScreen> {
  int counter1 = 0;
  int counter2 = 0;
  int counter3 = 0;
  String beginningCardName = letterPackMap[letterPackName].beginning.letters[0];
  String middleCardName = letterPackMap[letterPackName].middle.letters[0];
  String endCardName = letterPackMap[letterPackName].end.letters[0];
  bool isVowelBeginningBool;
  bool isVowelMiddleBool;
  bool isVowelEndBool;

  bool checkVowels(String letter, bool isVowelBoolean){
    if(letter.toLowerCase() == 'a'||letter.toLowerCase() == 'e'||letter.toLowerCase() == 'i'||letter.toLowerCase() == 'o'||letter.toLowerCase() == 'u'){
      isVowelBoolean = true;
    }
    else{
      return false;
    }
    return isVowelBoolean;
  }
  
  _saveLetterPackName(String stringValue) async {
    final prefs = await SharedPreferences.getInstance();
    final key = "currentLetterPackName";
    final value = stringValue;
    prefs.setString(key, value);
  }

  @override
  void initState(){
    super.initState();
    SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeRight,
        DeviceOrientation.landscapeLeft,
    ]);
    //save current letter pack name
    _saveLetterPackName(letterPackName);
    
  }
  Widget build(BuildContext context) {
    
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Stack(
          children: [
            Container(
                constraints: BoxConstraints.expand(),
                decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/water-blue-ocean.jpg"),
                fit: BoxFit.cover)
                ),
            ),
            Align(
              alignment: Alignment.center,
              child: cardBackgroundRow(),
            ),
            Align(
              alignment: Alignment.center,
              child: cardButtonRow(),
            ),
            
            Positioned(
              bottom: 20,
              left: 20,
              child: CircleAvatar(
                backgroundColor: Color(0xFF05334c),
                radius: (SizeConfig.screenHeight * 0.05),
                child: IconButton(
                icon: Icon(SFSymbols.house_fill),
                iconSize: SizeConfig.screenHeight * 0.05,
                color: Color(0xFF0690d4),
                onPressed: () {
                  Navigator.push(
                    context,
                    FadeRoute(page: MyApp()),
                  );
                },
              ),
              )
            ),
            Positioned(
              top: 20,
              right: 20,
              child: CircleAvatar(
                backgroundColor: Color(0xFF05334c),
                radius: (SizeConfig.screenHeight * 0.05),
                child: IconButton(
                icon: Icon(SFSymbols.qrcode),
                iconSize: SizeConfig.screenHeight * 0.05,
                color: Color(0xFF0690d4),
                onPressed: () {
                  Navigator.push(
                    context,
                    FadeRoute(page: Test1Screen()),
                  );
                },
              ),
              )
            )
          ]
        )
      )
    );
  }

  Widget beginningCardButton() {
    return Container( 
      margin: EdgeInsets.only(top: 20, right: 5, left: 20, bottom: 20),
      child: ButtonTheme(
        minWidth: SizeConfig.screenWidth * 0.27,
        height: SizeConfig.screenWidth * 0.27,
        child:  FlatButton(
          child: Text(beginningCardName,
            style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 10, fontFamily: "DidactGothic", fontWeight: FontWeight.w400),
          ),
            color: checkVowels(beginningCardName, isVowelBeginningBool) ? Color(0xFFfdf0b1) : Colors.white,
            textColor: checkVowels(beginningCardName, isVowelBeginningBool) ? Color(0xFFb46605) : Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10)),
            onPressed: (){  
              setState(() {
                counter1++;
                if(counter1 >= letterPackMap[letterPackName].beginning.letters.length){
                  counter1 = 0;
                }
                beginningCardName = letterPackMap[letterPackName].beginning.letters[counter1];
              });
            },
          ),
        )
      
      );
  }
  Widget beginningCardBackground() {
    return Container(
      width: SizeConfig.screenWidth * 0.27,
      height: SizeConfig.screenWidth * 0.27,
      margin: EdgeInsets.only(top: 20, right: 5, left: 20, bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10)
      )
    );
  }
  Widget middleCardButton() {
    return Container(
      margin: EdgeInsets.only(top: 20, right: 5, left: 5, bottom: 20),
      child: ButtonTheme(
        minWidth: SizeConfig.screenWidth * 0.27,
        height: SizeConfig.screenWidth * 0.27,
          child: FlatButton(
            child: Text(middleCardName,
              style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 10, fontFamily: "DidactGothic", fontWeight: FontWeight.w400),
            ),
            color: checkVowels(middleCardName, isVowelMiddleBool) ? Color(0xffF7CE46).withOpacity(0.4) : Colors.white,
            textColor: checkVowels(middleCardName, isVowelMiddleBool) ? Color(0xFFb46605) : Colors.black,
            shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
            onPressed: (){
              setState(() {
                counter2++;
                if(counter2 >= letterPackMap[letterPackName].middle.letters.length){
                  counter2 = 0;
                }
                middleCardName = letterPackMap[letterPackName].middle.letters[counter2];
              });
            },
          ),
        )
    );
  }
  Widget middleCardBackground() {
    return Container(
      width: SizeConfig.screenWidth * 0.27,
      height: SizeConfig.screenWidth * 0.27,
      margin: EdgeInsets.only(top: 20, right: 5, left: 5, bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10)
      )
    );
  }
  Widget endCardButton() {
    return Container(
      margin: EdgeInsets.only(top: 20, right: 20, left: 5, bottom: 20),
      child: ButtonTheme(
        minWidth: SizeConfig.screenWidth * 0.27,
        height: SizeConfig.screenWidth * 0.27,
        child: FlatButton(
          child: Text(endCardName,
            style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 10, fontFamily: "DidactGothic", fontWeight: FontWeight.w400),),
          color: checkVowels(endCardName, isVowelEndBool) ? Color(0xffF7CE46).withOpacity(0.4) : Colors.white,
          textColor: checkVowels(endCardName, isVowelEndBool) ? Color(0xFFb46605) : Colors.black,
          shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
          onPressed: (){
            setState(() {
              counter3++;
              if(counter3 >= letterPackMap[letterPackName].end.letters.length){
                counter3 = 0;
              }
              endCardName = letterPackMap[letterPackName].end.letters[counter3];
            });
            
            },
          )
        ),
      );
  }
  Widget endCardBackground() {
    return Container(
      width: SizeConfig.screenWidth * 0.27,
      height: SizeConfig.screenWidth * 0.27,
      margin: EdgeInsets.only(top: 20, right: 20, left: 5, bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10)
      )
    );
  }
  
  Widget cardButtonRow(){
    return Container(
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
        children: [
          beginningCardButton(),
          middleCardButton(),
          endCardButton(),
        ],
    )
   );
  }
  Widget cardBackgroundRow(){
    return Container(
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
        children: [
          beginningCardBackground(),
          middleCardBackground(),
          endCardBackground(),
        ],
    )
   );
  }

}
class Test1Screen extends StatefulWidget {
  @override
  _Test1ScreenState createState() => _Test1ScreenState();
}

class _Test1ScreenState extends State<Test1Screen> {


  @override
  void initState(){
    super.initState();
    SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeRight,
        DeviceOrientation.landscapeLeft,
    ]);
    //save current letter pack name
   
    
  }
  Widget build(BuildContext context) {
    
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Stack(
          children: [
            /*Center(
            child: QrImage(
  data: letterPackName,
  version: QrVersions.auto,
  size: 200.0,
),
        ),*/

            Positioned(
              bottom: 20,
              right: 20,
              child: CircleAvatar(
                backgroundColor: Color(0xFF05334c),
                radius: (SizeConfig.screenHeight * 0.05),
                child: IconButton(
                icon: Icon(SFSymbols.house_fill),
                iconSize: SizeConfig.screenHeight * 0.05,
                color: Color(0xFF0690d4),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              )
            )
          ]
        )
      )
    );
  }
  
  
}