#pragma strict

function Awake()
{
  Update();
}

function Update()
{
  if (PlayerData.nickname != guiText.text)
  {
    guiText.text = PlayerData.nickname;
  }
}
