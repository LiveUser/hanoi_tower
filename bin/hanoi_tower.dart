import 'dart:io';
import 'dart:math';

List<int> A = [];
List<int> B = [];
List<int> C = [];

bool canStack(int diskNumber, String targetTower){
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

void moveDisk(String fromColumn, String toColumn){
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
}

int? getDiskOnTop(String column){
    if(column == "A"){
        return A.lastOrNull;
    }else if(column == "B"){
        return B.lastOrNull;
    }else{
        return C.lastOrNull;
    }
}
void solveRecursively({
    required String startingTower,
    required String targetTower,
    required String auxTower,
    required int numberOfDisks,
}){
    int stepsToSolve = (pow(2, numberOfDisks) - 1).round();
    bool lastPiecePlaced = false;
    for(int i = 0; i < stepsToSolve; i++){
        int diskOnStartingTower = getDiskOnTop(startingTower) ?? 0;
        int diskOnTargetTower = getDiskOnTop(targetTower) ?? 0;
        int diskOnAuxTower = getDiskOnTop(auxTower) ?? 0;
        bool invertOperation = !((numberOfDisks % 3) == 0);
        if(diskOnStartingTower == 0){
            lastPiecePlaced = true;
        }
        if(invertOperation == false){
            if(canStack(diskOnStartingTower, targetTower) && !lastPiecePlaced){
                moveDisk(startingTower, targetTower);
            }else if(canStack(diskOnStartingTower, auxTower) && !lastPiecePlaced){
                moveDisk(startingTower, auxTower);
            }else{
                if(canStack(diskOnTargetTower, auxTower) && !lastPiecePlaced){
                    moveDisk(targetTower, auxTower);
                }else if(canStack(diskOnAuxTower, startingTower)){
                    moveDisk(auxTower, startingTower);
                }else if(diskOnAuxTower != 0){
                    moveDisk(auxTower, targetTower);
                }else{
                    moveDisk(startingTower, targetTower);
                }
            }
        }else{

        }
    }
}
void generateAndSolve({
    required String startingTower,
    required String targetTower,
    required int numberOfDisks,
}){
    String auxTower = "";
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
void main() {
    runSolver();
}