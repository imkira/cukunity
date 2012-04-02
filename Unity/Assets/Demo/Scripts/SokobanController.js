//
// source code adapted from:
//
// http://www.emanueleferonato.com/2011/03/09/3d-sokoban-prototype-with-unity/
//
private var initialLevels=[[1,1,1,1,0,0,0,0],[1,0,0,1,1,1,1,1],[1,0,2,0,0,3,0,1],[1,0,3,0,0,2,4,1],[1,1,1,0,0,1,1,1],[0,0,1,1,1,1,0,0]];		
private var blocks : Transform;

private var levels = [[0]];
var moves : int = 0;
var wallCube : Transform;
var floorCube : Transform;
var goalCube: Transform;
var crateCube: Transform;
var playerCube:Transform;
private var isMoving:boolean;
private var isRotating:boolean;
private var rotationDir:int;
private var movingSteps:int;
private var dRow:int;
private var dCol:int;
private var playerRow:int;
private var playerCol:int;
private var movingCrate:String;
private var gameClearTexture : GUITexture;
function Awake () {
  gameClearTexture = GameObject.Find("GameClear").GetComponent(GUITexture);
  var blocksObj : GameObject = GameObject.Find("Blocks");
  if (blocksObj == null) {
    blocksObj = new GameObject("Blocks");
  }
  blocks = blocksObj.transform;
  moves=0;
	isMoving=false;
	isRotating=false;
	var crate:GameObject;
  levels = initialLevels.Clone();
    for (var i = 0; i < levels.length; i++) {
        levels[i] = new int[initialLevels[i].Length];
        for (var j = 0; j < levels[i].length; j++) {
          levels[i][j] = initialLevels[i][j];
          switch (levels[i][j]) {
            case 0:
              Instantiate(floorCube, Vector3 (i, -0.6, j), Quaternion.identity).parent = blocks;
              break;
            case 1:
              Instantiate(floorCube, Vector3 (i, -0.6, j), Quaternion.identity).parent = blocks;
              Instantiate(wallCube, Vector3 (i, 0, j), Quaternion.identity).parent = blocks;
              break;
            case 2:
              Instantiate(goalCube, Vector3 (i, -0.6, j), Quaternion.identity).parent = blocks;
              break;
            case 3:
              Instantiate(floorCube, Vector3 (i, -0.6, j), Quaternion.identity).parent = blocks;
              var crateCube=Instantiate(crateCube, Vector3 (i, 0, j), Quaternion.identity);
              crateCube.name="crate_"+i+"_"+j;
              crateCube.parent = blocks;
              break;
            case 4:
              Instantiate(floorCube, Vector3 (i, -0.6, j), Quaternion.identity).parent = blocks;
              Instantiate(playerCube, Vector3 (i,0, j), Quaternion.identity).parent = blocks;
              playerRow=i;
              playerCol=j;
              break;
          }
        }
    }
    IsGameClear();
} 

@System.NonSerialized
var isTouchingLeft : boolean = false;
@System.NonSerialized
var isTouchingRight : boolean = false;
@System.NonSerialized
var isTouchingUp : boolean = false;

private function IsGameClear() : boolean
{
  for (var i = 0; i < levels.length; ++i)
  {
    for (var j = 0; j < levels[i].length; ++j)
    {
      // there is no crate in the goal cube?
      if ((initialLevels[i][j] == 2) && (levels[i][j] != 5))
      {
        return false;
      }
    }
  }
  return true;
}

private function IsPressingLeft() : boolean
{
  if (Input.GetKeyDown(KeyCode.LeftArrow))
  {
    return true;
  }
  if (isTouchingLeft)
  {
    isTouchingLeft = false;
    return true;
  }
  return false;
}

private function IsPressingRight() : boolean
{
  if (Input.GetKeyDown(KeyCode.RightArrow))
  {
    return true;
  }
  if (isTouchingRight)
  {
    isTouchingRight = false;
    return true;
  }
  return false;
}

private function IsPressingUp() : boolean
{
  if (Input.GetKeyDown(KeyCode.UpArrow))
  {
    return true;
  }
  if (isTouchingUp)
  {
    isTouchingUp = false;
    return true;
  }
  return false;
}

function Update() {
  var gameClear : boolean = IsGameClear();
  gameClearTexture.enabled = gameClear;
  if (gameClear)
  {
    return;
  }
	var thePlayer:GameObject=GameObject.FindWithTag("Player");
	if(!isMoving && !isRotating){
		if (IsPressingUp()) {
			switch(Mathf.Round(thePlayer.transform.eulerAngles.y)){
				case 0 :
					dRow=0;
					dCol=-1;
					break;
				case 90 :
					dRow=-1;
					dCol=0;
					break;
				case 180 :
					dRow=0;
					dCol=1;
					break;
				case 270 :
					dRow=1;
					dCol=0;
					break;
			}
			if (levels[playerRow+dRow][playerCol+dCol]==0 ||levels[playerRow+dRow][playerCol+dCol]==2){
        ++moves;
				isMoving=true;
				movingSteps=0;
			}
			else{
					if (levels[playerRow+dRow][playerCol+dCol]==3||levels[playerRow+dRow][playerCol+dCol]==5) {
						if (levels[playerRow+2*dRow][playerCol+2*dCol]==0||levels[playerRow+2*dRow][playerCol+2*dCol]==2) {
              ++moves;
							movingCrate="crate_"+(playerRow+dRow)+"_"+(playerCol+dCol);
							isMoving=true;
							movingSteps=0;
						}
					}						
			}
		}
		else{
			if(IsPressingRight()){
				isRotating=true;
				rotationDir=5;
			}
			else{
				if(IsPressingLeft()){
					isRotating=true;
					rotationDir=-5;
				}
			}
		}
	}
	if(isMoving==true){
		thePlayer.transform.Translate(Vector3.forward *-0.1);
		if(movingCrate){
			var theCrate:GameObject=GameObject.Find(movingCrate);
			switch(Mathf.Round(thePlayer.transform.eulerAngles.y)){
				case 0 :
					theCrate.transform.Translate(Vector3.forward *-0.1);
					break;
				case 90 :
					theCrate.transform.Translate(Vector3.right *-0.1);
					break;
				case 180 :
					theCrate.transform.Translate(Vector3.forward *0.1);
					break;
				case 270 :
					theCrate.transform.Translate(Vector3.right *0.1);
					break;
			}
		}
		movingSteps++;
		if(movingSteps==10){
			isMoving=false;
			levels[playerRow+dRow][playerCol+dCol]+=4;
			levels[playerRow][playerCol]-=4;
			if(movingCrate){
				levels[playerRow+2*dRow][playerCol+2*dCol]+=3;
				levels[playerRow+dRow][playerCol+dCol]-=3;
				theCrate.name="crate_"+(playerRow+2*dRow)+"_"+(playerCol+2*dCol);
				movingCrate="";
			}
			playerRow+=dRow;
			playerCol+=dCol;
 
		}
	}
	if(isRotating==true){
		thePlayer.transform.Rotate(0,rotationDir,0);	
		if(Mathf.Round(thePlayer.transform.eulerAngles.y)%90==0){
			isRotating=false;
		}
	}
}
function Retry()
{
  blocks.gameObject.name = "_Blocks";
  Destroy(blocks.gameObject);
  Awake();
}
