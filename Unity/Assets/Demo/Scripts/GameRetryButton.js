#pragma strict

function OnMouseDown()
{
  var sokoban : SokobanController = GameObject.Find("Sokoban").GetComponent(SokobanController);
  sokoban.Retry();
}
