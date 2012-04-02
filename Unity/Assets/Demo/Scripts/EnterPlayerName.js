#pragma strict

function OnMouseDown()
{
  ReadPlayerName();
}

function ReadPlayerName()
{
  var keyboard : iPhoneKeyboard;
  keyboard = iPhoneKeyboard.Open(PlayerData.nickname);
  if (keyboard != null)
  {
    while (keyboard.done == false)
    {
      yield WaitForEndOfFrame();
    }
    PlayerData.nickname = keyboard.text;
    keyboard = null;
  }
}
