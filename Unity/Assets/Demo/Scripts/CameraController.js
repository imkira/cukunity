function Start()
{
  InterpolateCamera(1.0);
}

function Update() {
  InterpolateCamera(Time.deltaTime);
}

private function InterpolateCamera(t : float)
{
	var target : Transform = GameObject.FindWithTag("Player").transform;
	var angleToReach:float = Mathf.LerpAngle(transform.eulerAngles.y,target.eulerAngles.y-180,4*t);
	var currentRotation:Quaternion = Quaternion.Euler(0,angleToReach,0);
	transform.position = target.position+Vector3(0,9,0);
	transform.position -= currentRotation*Vector3.forward*4;
	transform.LookAt(target.position+Vector3(0,3,0));
}
