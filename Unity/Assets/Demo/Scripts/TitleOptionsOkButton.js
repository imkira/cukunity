#pragma strict

function OnMouseDown()
{
  var menu : GameObject = Instantiate(Resources.Load("MainMenu"));
  menu.name = "MainMenu";
  Destroy(GameObject.Find("OptionsMenu"));
}
