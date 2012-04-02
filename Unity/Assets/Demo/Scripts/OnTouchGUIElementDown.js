#pragma strict

var phases : TouchPhase[] = [TouchPhase.Began];

private var _guiElement : GUIElement;

function Awake()
{
  _guiElement = gameObject.GetComponent(GUIElement);
}

function Update()
{
  for (var touch : Touch in Input.touches)
  {
    for (var phase : TouchPhase in phases)
    {
      if (touch.phase == phase)
      {
        if (_guiElement.HitTest(touch.position, Camera.main))
        {
          if ((phase == TouchPhase.Ended) || (phase == TouchPhase.Canceled))
          {
            gameObject.SendMessage("OnMouseUp");
          }
          else
          {
            gameObject.SendMessage("OnMouseDown");
          }
        }
      }
    }
  }
}
