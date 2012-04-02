#pragma strict

function OnMouseDown()
{
  var menu : GameObject = Instantiate(Resources.Load("OptionsMenu"));
  menu.name = "OptionsMenu";
  Destroy(GameObject.Find("MainMenu"));
}
