using UnityEngine;
using System.Collections;

using System;
using System.Net;
using System.Net.Sockets;
using System.Text;
using System.Threading;
using System.Collections.Generic;

using JsonFx.Json;

using System.Runtime.InteropServices;

public class CukunityServer : MonoBehaviour
{
  public string ip = "127.0.0.1";
  public int port = 9921;
  public bool excludeSelfFromScene = true;

  private TcpListener listener = null;
  private List<CukunityRequest> requests;

  public static CukunityServer instance = null;

  void Awake()
  {
    if (instance != null)
    {
      Destroy(gameObject);
      return;
    }
    instance = this;
    // prevent ourselves being removed from the scene when loading new levels
    DontDestroyOnLoad(gameObject);
    // start server
    requests = new List<CukunityRequest>();
    StartCoroutine(Listen());
  }

  private IEnumerator Listen()
  {
    yield return new WaitForEndOfFrame();

    Debug.LogWarning("Cukunity: Listening on " + ip + ":" + port.ToString());

    IPAddress localAddr = IPAddress.Parse(ip);
    listener = new TcpListener(localAddr, port);

    // start listening
    listener.Start();

    // wait for our first client
    listener.BeginAcceptTcpClient(OnAcceptTcpClientComplete, this);
    StartCoroutine(MainLoop());
  }

  private IEnumerator MainLoop()
  {
    List<CukunityRequest> pendingRequests;

    while (true)
    {
      pendingRequests = null;
      lock(requests)
      {
        if (requests.Count > 0)
        {
          pendingRequests = new List<CukunityRequest>(requests);
          requests.Clear();
        }
      }
      if (pendingRequests != null)
      {
        pendingRequests.ForEach(ProcessRequest);
        yield return new WaitForEndOfFrame();
      }
      else
      {
        yield return new WaitForSeconds(0.1f);
      }
    }
  }

  private void ProcessRequest(CukunityRequest req)
  {
    Hashtable res = new Hashtable();
    try
    {
      // read data from client as a JSON dictionary
      Hashtable jsonReq = JsonReader.Deserialize<Hashtable>(req.Request);

      string cmdName = GetJsonString(jsonReq, "command");

      if ((cmdName == null) || (cmdName.Length == 0))
      {
        Debug.LogError("Cukunity: missing command in client's request (" + req.Request + ")");
        res["error"] = "MissingCommandError";
        req.OnProcessed(JsonWriter.Serialize(res));
        return;
      }

      CukunityCommand cmd;

      switch (cmdName)
      {
        case "get_screen":
          cmd = new CukunityGetScreenCommand();
          break;

        case "get_scene":
          cmd = new CukunityGetSceneCommand();
          break;

        case "get_level":
          cmd = new CukunityGetLevelCommand();
          break;

        case "load_level":
          cmd = new CukunityLoadLevelCommand();
          break;

#if UNITY_IPHONE 
        case "touch_screen":
          cmd = new CukunityTouchScreenCommand();
          break;
#endif

        default:
          Debug.LogError("Cukunity: unknown command in client's request (" + req.Request + ")");
          res["error"] = "UnknownCommandError";
          req.OnProcessed(JsonWriter.Serialize(res));
          return;
      }

      cmd.Process(jsonReq, res);
    }
    catch (Exception e)
    {
      Debug.LogError("Cukunity: exception while processing client's request (" + e + ")");
      res["error"] = "ServerError";
    }
    // reply to client
    req.OnProcessed(JsonWriter.Serialize(res));
  }

  private static string GetJsonString(Hashtable data, string key)
  {
    if ((data == null) ||
        (!data.Contains(key)) ||
        (data[key].GetType() != typeof(string)))
    {
      return null;
    }
    return data[key] as string;
  }

  private static bool GetJsonInt(Hashtable data, string key, ref int value)
  {
    if ((data == null) ||
        (!data.Contains(key)) ||
        (data[key].GetType() != typeof(int)))
    {
      return false;
    }
    value = (int)data[key];
    return true;
  }

  void OnDestroy()
  {
    try
    {
      if (listener != null)
      {
        listener.Stop();
      }
    }
    catch (SocketException)
    {
    }
  }

  public void EnqueueRequest(CukunityRequest req)
  {
    lock(requests)
    {
      requests.Add(req);
    }
  }

  static private void OnAcceptTcpClientComplete(IAsyncResult result) 
  {
    CukunityServer server = result.AsyncState as CukunityServer;
    TcpClient client = server.listener.EndAcceptTcpClient(result);

    Debug.LogWarning("Cukunity: client connected");

    CukunityClient cukieClient = new CukunityClient(client, server);
    
    // ready for a new client
    server.listener.BeginAcceptTcpClient(OnAcceptTcpClientComplete, server);

    // start  client
    cukieClient.SendAck();
  }

  public class CukunityCommand
  {
    public delegate object GameObjectVisitor(GameObject obj, object context);

    public virtual void Process(Hashtable req, Hashtable res)
    {
      throw new System.Exception("Not implemented");
    }

    protected void Traverse(GameObject obj, GameObjectVisitor visitor, object context)
    {
      context = visitor(obj, context);
      foreach (Transform child in obj.transform)
      {
        Traverse(child.gameObject, visitor, context);
      }
    }
  }

  public class CukunityGetSceneCommand : CukunityCommand
  {
    public delegate void SerializerMethod(Component c, Hashtable h);

    public override void Process(Hashtable req, Hashtable res)
    {
      List<GameObject> objs = new List<GameObject>();

      // get all objects on the root
      foreach (GameObject obj in UnityEngine.Object.FindObjectsOfType(typeof(GameObject)))
      {
        if ((obj.transform.parent == null) &&
            // exclude this game object?
            ((!CukunityServer.instance.excludeSelfFromScene) ||
             ((CukunityServer.instance.excludeSelfFromScene) &&
              (obj != CukunityServer.instance.gameObject))))
        {
          objs.Add(obj);
        }
      }

      // traverse all objects recursively
      List<Hashtable> rootObjects = new List<Hashtable>();
      res["gameObjects"] = rootObjects;
      foreach (GameObject obj in objs)
      {
        Traverse(obj, SerializeGameObject, rootObjects);
      }
    }

    private object SerializeGameObject(GameObject obj, object context)
    {
      Hashtable objHash = new Hashtable();
      objHash["instanceID"] = obj.GetInstanceID();
      objHash["name"] = obj.name;
      objHash["tag"] = obj.tag;
      objHash["active"] = obj.active;

      Hashtable layerHash = new Hashtable();
      layerHash["name"] = LayerMask.LayerToName(obj.layer);
      layerHash["value"] = obj.layer;
      objHash["layer"] = layerHash;

      objHash["children"] = new List<Hashtable>();
      objHash["components"] = SerializeComponents(obj);

      List<Hashtable> objs = context as List<Hashtable>;
      if (objs != null)
      {
        objs.Add(objHash);
      }

      return objHash["children"];
    }

    private List<Hashtable> SerializeComponents(GameObject obj)
    {
      List<Hashtable> components = new List<Hashtable>();
      Component[] comps = obj.GetComponents<Component>();

      foreach (Component comp in comps)
      {
        Hashtable compHash = new Hashtable();

        compHash["instanceID"] = comp.GetInstanceID();
        compHash["type"] = GetComponentTypeString(comp);

        Behaviour behaviour = null;
        // is this Component a Behaviour?
        if (typeof(Behaviour).IsAssignableFrom(comp.GetType()))
        {
          behaviour = comp as Behaviour;
          compHash["enabled"] = behaviour.enabled;
        }
        // serialize component
        SerializeComponent(comp, compHash);

        // add it to the list of components
        components.Add(compHash);
      }
      return components;
    }

    public static string GetComponentTypeString(Component comp, Type t = null)
    {
      if (t == null)
      {
        t = comp.GetType();
      }
      string compType = t.ToString();

      // I have seen this happen for a Camera's FlareLayer
      if (compType == "UnityEngine.Behaviour")
      {
        // extract type while aavoiding reflection
        int pos = comp.ToString().LastIndexOf("(UnityEngine.");
        if (pos >= 0)
        {
          string compType2 = comp.ToString().Substring(pos);
          if ((compType2.Length >= "(UnityEngine.x)".Length) &&
              (compType2.EndsWith(")")))
          {
            // fix type
            compType = compType2.Substring(1, compType2.Length - 2);
          }
        }
      }

      if (compType.StartsWith("UnityEngine."))
      {
        compType = compType.Remove(0, "UnityEngine.".Length);
      }
      return compType;
    }

    public static void SerializeComponent(Component comp, Hashtable compHash)
    {
      Type compType = comp.GetType();
      Dictionary<Type, SerializerMethod> methods = new Dictionary<Type, SerializerMethod>()
      {
        { typeof(Transform), SerializeTransform },
        { typeof(Camera), SerializeCamera },
        { typeof(GUIElement), SerializeGUIElement },
        { typeof(GUITexture), SerializeGUITexture },
        { typeof(GUIText), SerializeGUIText }
      };
      
      // serialize subclasses first
      foreach (KeyValuePair<Type, SerializerMethod> pair in methods)
      {
        if (compType.IsSubclassOf(pair.Key))
        {
          pair.Value(comp, compHash);
        }
      }
      // serialize main classes after
      foreach (KeyValuePair<Type, SerializerMethod> pair in methods)
      {
        if (compType == pair.Key)
        {
          pair.Value(comp, compHash);
        }
      }
    }

    public static void SerializeTransform(Component comp, Hashtable h)
    {
      Transform t = comp as Transform;
      h["position"] = SerializeVector3(t.position);
      h["rotation"] = SerializeQuaternion(t.rotation);
      h["localScale"] = SerializeVector3(t.localScale);
    }

    public static void SerializeCamera(Component comp, Hashtable h)
    {
      Camera c = comp as Camera;
      h["fieldOfView"] = c.fieldOfView;
      h["nearClipPlane"] = c.nearClipPlane;
      h["farClipPlane"] = c.farClipPlane;
      h["renderingPath"] = c.renderingPath.ToString();
      h["actualRenderingPath"] = c.actualRenderingPath.ToString();
      h["orthographicSize"] = c.orthographicSize;
      h["orthographic"] = c.orthographic;
      h["depth"] = c.depth;
      h["aspect"] = c.aspect;
      h["cullingMask"] = c.cullingMask;
      h["backgroundColor"] = SerializeColor(c.backgroundColor);
      h["rect"] = SerializeRect(c.rect);
      h["pixelRect"] = SerializeRect(c.pixelRect);
      // FIXME: render texture
      //h["targetTexture"] = SerializeTexture(c.targetTexture);
      h["pixelWidth"] = c.pixelWidth;
      h["pixelHeight"] = c.pixelHeight;
      h["cameraToWorldMatrix"] = SerializeMatrix4x4(c.cameraToWorldMatrix);
      h["worldToCameraMatrix"] = SerializeMatrix4x4(c.worldToCameraMatrix);
      h["projectionMatrix"] = SerializeMatrix4x4(c.projectionMatrix);
      h["velocity"] = SerializeVector3(c.velocity);
      h["clearFlags"] = c.clearFlags.ToString();
      h["layerCullDistances"] = c.layerCullDistances;
      h["depthTextureMode"] = c.depthTextureMode.ToString();
    }

    public static void SerializeGUIElement(Component comp, Hashtable h)
    {
      GUIElement e = comp as GUIElement;
      AppendHint<Hashtable>(h, "screen", SerializeRect(e.GetScreenRect()));
    }

    public static void SerializeGUITexture(Component comp, Hashtable h)
    {
      GUITexture t = comp as GUITexture;
      h["color"] = SerializeColor(t.color);
      h["pixelInset"] = SerializeRect(t.pixelInset);
      // FIXME: render texture
      //h["texture"] = SerializeTexture(t.texture);
    }

    public static void SerializeGUIText(Component comp, Hashtable h)
    {
      GUIText t = comp as GUIText;
      h["text"] = t.text;
      // FIXME: serialize Material
      //h["material"] = ...
      h["pixelOffset"] = SerializeVector2(t.pixelOffset);
      // FIXME: serialize Material
      //h["font"] = ...
      h["alignment"] = t.alignment.ToString();
      h["anchor"] = t.anchor.ToString();
      h["lineSpacing"] = t.lineSpacing;
      h["tabSize"] = t.tabSize;
      h["fontSize"] = t.fontSize;
      h["fontStyle"] = t.fontStyle.ToString();
      AppendHint<string>(h, "text", t.text);
    }

    public static Hashtable AppendHint<T>(Hashtable h, string name, T hint)
    {
      Hashtable hints = h[".hints"] as Hashtable;
      if (hints == null)
      {
        hints = new Hashtable();
        h[".hints"] = hints;
      }
      List<T> hintsList;
      if (hints.Contains(name))
      {
        hintsList = hints[name] as List<T>;
      }
      else
      {
        hintsList = new List<T>();
        hints[name] = hintsList;
      }
      hintsList.Add(hint);
      return hints;
    }

    public static Hashtable SerializeColor(Color c)
    {
      Hashtable h = new Hashtable();
      h["r"] = c.r;
      h["g"] = c.g;
      h["b"] = c.b;
      h["a"] = c.a;
      h["grayscale"] = c.grayscale;
      return h;
    }

    public static Hashtable SerializeRect(Rect r)
    {
      Hashtable h = new Hashtable();
      h["x"] = r.x;
      h["y"] = r.y;
      h["width"] = r.width;
      h["height"] = r.height;
      return h;
    }

    public static Hashtable SerializeVector3(Vector3 v)
    {
      Hashtable h = new Hashtable();
      h["x"] = v.x;
      h["y"] = v.y;
      h["z"] = v.z;
      return h;
    }

    public static Hashtable SerializeVector2(Vector2 v)
    {
      Hashtable h = new Hashtable();
      h["x"] = v.x;
      h["y"] = v.y;
      return h;
    }

    public static Hashtable SerializeQuaternion(Quaternion q)
    {
      Hashtable h = new Hashtable();
      h["x"] = q.x;
      h["y"] = q.y;
      h["z"] = q.z;
      h["w"] = q.w;
      return h;
    }

    public static float[] SerializeMatrix4x4(Matrix4x4 m)
    {
      float[] matrix = new float[16];
      for (int index = 0; index < matrix.Length; ++index)
      {
        matrix[index] = m[index];
      }
      return matrix;
    }
  }

  public class CukunityGetScreenCommand : CukunityCommand
  {
    public override void Process(Hashtable req, Hashtable res)
    {
      res["width"] = Screen.width;
      res["height"] = Screen.height;
    }
  }

  public class CukunityGetLevelCommand : CukunityCommand
  {
    public override void Process(Hashtable req, Hashtable res)
    {
      res["number"] = Application.loadedLevel;
      res["name"] = Application.loadedLevelName;
      res["count"] = Application.levelCount;
    }
  }

  public class CukunityLoadLevelCommand : CukunityCommand
  {
    public override void Process(Hashtable req, Hashtable res)
    {
      int levelNumber = -1;
      string levelName = GetJsonString(req, "name");
      string methodName = GetJsonString(req, "method");
      bool hasLevelNumber = GetJsonInt(req, "number", ref levelNumber);

      if ((hasLevelNumber) && (levelName != null))
      {
        Debug.LogError("Cukunity: cannot specify both level name and number");
        res["error"] = "BothLevelNameOrNumberError";
        return;
      }

      if (((levelNumber < 0) || (levelNumber >= Application.levelCount)) &&
          ((levelName == null) || (levelName.Length == 0)))
      {
        Debug.LogError("Cukunity: missing level name/number");
        res["error"] = "MissingLevelNameOrNumberError";
        return;
      }

      if (methodName == null)
      {
        methodName = "sync";
      }

      switch (methodName.ToLower())
      {
        case "sync":
          try
          {
            if (hasLevelNumber)
            {
              Application.LoadLevel(levelNumber);
            }
            else
            {
              Application.LoadLevel(levelName);
            }
          }
          catch (Exception)
          {
            throw new System.Exception("Load level failed");
          }
          break;

        case "async":
          try
          {
            if (hasLevelNumber)
            {
              Application.LoadLevelAsync(levelNumber);
            }
            else
            {
              Application.LoadLevelAsync(levelName);
            }
          }
          catch (Exception)
          {
            throw new System.Exception("Load level failed");
          }
          break;

        case "additive":
          try
          {
            if (hasLevelNumber)
            {
              Application.LoadLevelAdditive(levelNumber);
            }
            else
            {
              Application.LoadLevelAdditive(levelName);
            }
          }
          catch (Exception)
          {
            throw new System.Exception("Load level failed");
          }
          break;

        case "additiveasync":
          try
          {
            if (hasLevelNumber)
            {
              Application.LoadLevelAdditiveAsync(levelNumber);
            }
            else
            {
              Application.LoadLevelAdditiveAsync(levelName);
            }
          }
          catch (Exception)
          {
            throw new System.Exception("Load level failed");
          }
          break;

        default:
          Debug.LogError("Cukunity: unknown load level method in client's request");
          res["error"] = "UnknownLoadLevelMethodError";
          return;
      }
    }
  }

#if UNITY_IPHONE 
  public class CukunityIOS
  {
    [DllImport("__Internal")]
    extern static public int CukunityScreenInstantTap(int x, int y, int tapCount);
  } 

  public class CukunityTouchScreenCommand : CukunityCommand
  {
    public override void Process(Hashtable req, Hashtable res)
    {
      int x = 0, y = 0, tapCount = 1;
      string methodName = GetJsonString(req, "method");

      if ((!GetJsonInt(req, "x", ref x)) ||
          (!GetJsonInt(req, "y", ref y)))
      {
        Debug.LogError("Cukunity: must specify x and y for position to touch");
        res["error"] = "MissingCoordinateError";
        return;
      }

      GetJsonInt(req, "tapCount", ref tapCount);
      if (tapCount <= 0)
      {
        Debug.LogError("Cukunity: must specify a tap count greater than 0");
        res["error"] = "InvalidTapCountError";
        return;
      }

      if (methodName == null)
      {
        methodName = "tap";
      }

      switch (methodName.ToLower())
      {
        case "tap":
          CukunityIOS.CukunityScreenInstantTap(x, y, tapCount);
          break;

        default:
          Debug.LogError("Cukunity: unknown touch method in client's request");
          res["error"] = "UnknownTouchMethodError";
          return;
      }
    }
  }
#endif

  public class CukunityRequest
  {
    private string request;
    private ManualResetEvent signal;
    private string response;

    public CukunityRequest(string request, ManualResetEvent signal)
    {
      this.request = request;
      this.signal = signal;
      response = "";
    }

    public string Request
    {
      get
      {
        return request;
      }
    }

    public string Response
    {
      get
      {
        return response;
      }
    }

    public void OnProcessed(string response)
    {
      this.response = response;
      // fire signal
      signal.Set();
    }
  }

  public class CukunityClient
  {
    private TcpClient client;
    private NetworkStream stream;
    private byte[] buffer;
    private int bufferUsedCount;
    private string bufferedString;
    private CukunityServer server;
    public ManualResetEvent signal;

    private static readonly int BufferIncrease = 1024;
    private static readonly Encoding enc = Encoding.UTF8;

    public CukunityClient(TcpClient client, CukunityServer server)
    {
      this.client = client;
      this.server = server;
      stream = client.GetStream();
      buffer = new byte[BufferIncrease];
      bufferUsedCount = 0;
      bufferedString = "";
      signal = new ManualResetEvent(false);
    }

    public void SendAck()
    {
      Hashtable ack = new Hashtable();
      byte[] ackBytes = enc.GetBytes(JsonWriter.Serialize(ack) + "\n");
      stream.BeginWrite(ackBytes, 0, ackBytes.Length, OnSendAckComplete, this); 
    }

    static private void OnSendAckComplete(IAsyncResult result)
    {
      CukunityClient cukieClient = result.AsyncState as CukunityClient;
      cukieClient.stream.EndWrite(result);
      cukieClient.BeginRead();
    }

    private void BeginRead()
    {
      // resize required?
      if (bufferUsedCount >= buffer.Length)
      {
        byte[] newBuffer = new byte[bufferUsedCount + BufferIncrease];
        Array.Copy(buffer, newBuffer, buffer.Length);
        buffer = newBuffer;
      }
      stream.BeginRead(buffer, bufferUsedCount, buffer.Length - bufferUsedCount, OnReadComplete, this);
    }

    public void Close()
    {
      Debug.LogWarning("Cukunity: client disconnected");
      try
      {
        stream.Close();
        client.Close();
      }
      catch (Exception)
      {
      }
    }

    static private void OnReadComplete(IAsyncResult result)
    {
      CukunityClient cukieClient = result.AsyncState as CukunityClient;
      int byteCount = cukieClient.stream.EndRead(result);
      string line;

      // nothing received?
      if (byteCount <= 0)
      {
        cukieClient.Close();
        return;
      }

      // append read data to internal buffer
      cukieClient.bufferedString += enc.GetString(cukieClient.buffer, cukieClient.bufferUsedCount, byteCount);
      cukieClient.bufferUsedCount += byteCount;

      // can we extract a line from this buffer?
      while ((line = cukieClient.ExtractLine(cukieClient.bufferedString)) != null)
      {
        int lineByteCount = enc.GetByteCount(line);
        cukieClient.bufferedString = cukieClient.bufferedString.Remove(0, lineByteCount);
        cukieClient.bufferUsedCount -= lineByteCount;

        // process received line
        string response = cukieClient.ProcessLineRequest(line);
        if (response.Length > 0)
        {
          // respond to client
          byte[] responseBytes = enc.GetBytes(response + "\n");
          cukieClient.stream.BeginWrite(responseBytes, 0, responseBytes.Length, null, null); 
        }
        else
        {
          cukieClient.Close();
          return;
        }
      }

      // next read
      cukieClient.BeginRead();
    }

    private string ExtractLine(string data)
    {
      int newLine = data.IndexOf("\n");

      if (newLine < 0)
      {
        return null;
      }
      return data.Substring(0, newLine + 1);
    }

    private string ProcessLineRequest(string line)
    {
      string request = line.TrimEnd('\r', '\n');
      CukunityRequest req = new CukunityRequest(request, signal);

      // reset signal
      signal.Reset();
      // add request to que
      server.EnqueueRequest(req);
      // wait for completion
      signal.WaitOne();
      return req.Response;
    }
  }
}
