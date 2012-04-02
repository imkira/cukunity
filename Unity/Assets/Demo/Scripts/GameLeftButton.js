#pragma strict

private var sokoban : SokobanController;

function Awake()
{
  sokoban = GameObject.Find("Sokoban").GetComponent(SokobanController);
}

function OnMouseDown()
{
  sokoban.isTouchingLeft = true;
}

function OnMouseUp()
{
  sokoban.isTouchingLeft = false;
}
