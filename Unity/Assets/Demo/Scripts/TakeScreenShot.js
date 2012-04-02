import System;
import System.IO;

function Update() 
{ 
   if (Input.GetKeyDown ("k")) 
   { 
     var resWidth : int = Screen.width; 
     var resHeight : int = Screen.height; 
	   var rt = new RenderTexture(resWidth, resHeight, 24);    
	   camera.targetTexture = rt; 
	   var screenShot = new Texture2D(resWidth, resHeight, TextureFormat.RGB24, false); 
	   camera.Render(); 
	   RenderTexture.active = rt;
	   screenShot.ReadPixels(Rect(0, 0, resWidth, resHeight), 0, 0); 
	   RenderTexture.active = null; // JC: added to avoid errors 
	   camera.targetTexture = null;
	   Destroy(rt);
	   var bytes = screenShot.EncodeToPNG();
	   var dir : String = Path.Combine(Application.persistentDataPath, "screenshots");
     var output = Path.Combine(dir, "screen" + DateTime.Now.ToString("dd-MM-yyyy_HH-mm-ss") + ".png");
     Directory.CreateDirectory(dir);
     Debug.Log("Saving screenshot: " + output);
	   File.WriteAllBytes(output, bytes); 
   }    
}
