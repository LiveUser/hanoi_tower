import 'dart:io';

class HanoiTower{
  HanoiTower({
    required this.A,
    required this.B,
    required this.C,
  });
  final List<int> A;
  final List<int> B;
  final List<int> C;
}
bool canStack(int diskNumber, String targetTower, List<int> A, List<int> B, List<int> C){
    if(diskNumber == 0){
        return false;
    }else{
        if(targetTower == "A"){
            //If there are no elements return true else check the number of the disk that is on top
            if(A.isEmpty){
                return true;
            }else{
                if(A.last > diskNumber){
                    return true;
                }else{
                    return false;
                }
            }
        }else if(targetTower == "B"){
            //If there are no elements return true else check the number of the disk that is on top
            if(B.isEmpty){
                return true;
            }else{
                if(B.last > diskNumber){
                    return true;
                }else{
                    return false;
                }
            }
        }else{
            //If there are no elements return true else check the number of the disk that is on top
            if(C.isEmpty){
                return true;
            }else{
                if(C.last > diskNumber){
                    return true;
                }else{
                    return false;
                }
            }
        }
    }
}

HanoiTower moveDisk(String fromColumn, String toColumn, List<int> A, List<int> B, List<int> C){
    int disk = 0;
    //Extract value and remove element
    if(fromColumn == "A"){
        disk = A.last;
        //Remove from list
        A.removeLast();
    }else if(fromColumn == "B"){
        disk = B.last;
        //Remove from list
        B.removeLast();
    }else{
        disk = C.last;
        //Remove from list
        C.removeLast();
    }
    //Add element to the other List/Column
    if(toColumn == "A"){
        A.add(disk);
    }else if(toColumn == "B"){
        B.add(disk);
    }else{
        C.add(disk);
    }
    //Print movement
    print("$disk$fromColumn -> $disk$toColumn");
    return HanoiTower(A: A, B: B, C: C);
}

int? getDiskOnTop(String column, List<int> A, List<int> B, List<int> C){
    if(column == "A"){
        return A.lastOrNull;
    }else if(column == "B"){
        return B.lastOrNull;
    }else{
        return C.lastOrNull;
    }
}
//https://www.freecodecamp.org/news/analyzing-the-algorithm-to-solve-the-tower-of-hanoi-problem-686685f032e3/
HanoiTower solveRecursively({
    required String startingTower,
    required String targetTower,
    required String auxTower,
    required int numberOfDisks,
    required HanoiTower hanoiTower,
}){
    //int stepsToSolve = (pow(2, numberOfDisks) - 1).round();
    if(numberOfDisks == 1){
      HanoiTower moveBottomDisk = moveDisk(startingTower, targetTower, hanoiTower.A, hanoiTower.B, hanoiTower.C);
      hanoiTower = moveBottomDisk;
    }else{
      HanoiTower solvedSection = solveRecursively(
          startingTower: startingTower, 
          targetTower: auxTower, 
          numberOfDisks: numberOfDisks - 1,
          auxTower: targetTower,
          hanoiTower: hanoiTower,
      );
      hanoiTower = solvedSection;
      HanoiTower moveBottomDisk = moveDisk(startingTower, targetTower, hanoiTower.A, hanoiTower.B, hanoiTower.C);
      hanoiTower = moveBottomDisk;
      HanoiTower solvedSection2 = solveRecursively(
          startingTower: auxTower,
          targetTower: targetTower, 
          numberOfDisks: numberOfDisks - 1,
          auxTower: startingTower,
          hanoiTower: hanoiTower,
      );
      hanoiTower = solvedSection2;
    }

    return hanoiTower;
}
void generateAndSolve({
    required String startingTower,
    required String targetTower,
    required int numberOfDisks,
}){
    String auxTower = "";
    List<int> A = [];
    List<int> B = [];
    List<int> C = [];
    //Stack disks on the starting tower
    if(startingTower == "A"){
        for(int i = 1; i <= numberOfDisks; i++){
            A.insert(0, i);
        }
        if(targetTower == "B"){
            auxTower = "C";
        }else{
            //Is C
            auxTower = "B";
        }
    }else if(startingTower == "B"){
        for(int i = 1; i <= numberOfDisks; i++){
            B.insert(0, i);
        }
        if(targetTower == "A"){
            auxTower = "C";
        }else{
            //Is C
            auxTower = "A";
        }
    }else{
        for(int i = 1; i <= numberOfDisks; i++){
            C.insert(0, i);
        }
        if(targetTower == "B"){
            auxTower = "A";
        }else{
            //Is A
            auxTower = "B";
        }
    }
    //Solve the tower
    solveRecursively(
      startingTower: startingTower, 
      targetTower: targetTower, 
      numberOfDisks: numberOfDisks,
      auxTower: auxTower,
      hanoiTower: HanoiTower(
        A: A, 
        B: B, 
        C: C,
      ),
    );
}

String getTowerName(){
    bool validResponse = false;
    String response = "";
    while (!validResponse) {
      response = stdin.readLineSync() ?? "";
      response = response.toUpperCase();
      if(response == "A" || response == "B" || response == "C"){
        validResponse = true;
      }
    }
    return response;
}

int getInt(){
    bool validResponse = false;
    String response = "";
    int parsedResponse = 0;
    while(!validResponse){
        print("Please enter an integer:");
        response = stdin.readLineSync() ?? "";
        try{
            parsedResponse = int.parse(response);
            validResponse = true;
        }catch(error){
            //Do nothing
            print("only integers are allowed");
        }
    }
    return parsedResponse;
}

void runSolver(){
    String startingTower = "";
    String targetTower = "";
    int numberOfDisks = 0;
    //Get user input
    print("Please enter starting tower(A, B or C):");
    startingTower = getTowerName();
    print("Please enter target tower(A, B or C): (cannot be the same as starting tower)");
    do{
        targetTower = getTowerName();
        if(targetTower == startingTower){
            print("Target tower cannot be the same as starting tower");
        }
    }while(targetTower == startingTower);
    //Get number of disks
    print("Enter number of disks for the hanoi tower(must be greater than 3):");
    do{
        numberOfDisks = getInt();
        if(numberOfDisks < 3){
            print("Must contain at least 3 disks");
        }
    }while(numberOfDisks < 3);
    //Generate the tower and solve it
    generateAndSolve(
        startingTower: startingTower, 
        targetTower: targetTower, 
        numberOfDisks: numberOfDisks,
    );
}
void main() async {
    runSolver();
    //Pause the app to prevent exit
    await Process.start("PAUSE", [], runInShell: true);
}