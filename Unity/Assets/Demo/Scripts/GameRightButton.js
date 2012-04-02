#pragma strict

private var sokoban : SokobanController;

function Awake()
{
  sokoban = GameObject.Find("Sokoban").GetComponent(SokobanController);
}

function OnMouseDown()
{
  sokoban.isTouchingRight = true;
}

function OnMouseUp()
{
  sokoban.isTouchingRight = false;
}
