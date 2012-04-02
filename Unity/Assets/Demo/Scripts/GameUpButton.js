#pragma strict

private var sokoban : SokobanController;

function Awake()
{
  sokoban = GameObject.Find("Sokoban").GetComponent(SokobanController);
}

function OnMouseDown()
{
  sokoban.isTouchingUp = true;
}

function OnMouseUp()
{
  sokoban.isTouchingUp = false;
}
