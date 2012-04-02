#pragma strict

var moves : int = 0;
var movesText : GUIText;
var sokoban : SokobanController;

function Awake()
{
  sokoban = GameObject.Find("Sokoban").GetComponent(SokobanController);
  movesText = gameObject.GetComponent(GUIText);
  UpdateMoves(sokoban.moves);
}

function Update()
{
  if (sokoban.moves != moves)
  {
    UpdateMoves(sokoban.moves);
  }
}

private function UpdateMoves(_moves : int)
{
  moves = _moves;
  movesText.text = moves.ToString();
}
