var target : Transform;

var xSpeed = 250.0;
var ySpeed = 120.0;

var minY =-10;
var maxY = 10;


private var currentY;

function Start() {
	currentY = 0;
}

function LateUpdate () {
    if (target) {
		
    	var deltaX = Input.GetAxis("Mouse X") * xSpeed * 0.02;
        var deltaY = Input.GetAxis("Mouse Y") * ySpeed * 0.02;

		target.transform.RotateAround(target.position, target.transform.up, deltaX);
 		
		var newCurrentY = currentY + deltaY;
		//Debug.Log("currentY = " + currentY + " deltaY = " + deltaY);
		if ((newCurrentY < minY) || (newCurrentY > maxY)) {
			return;
		}
		currentY += deltaY;
		
		var yRotationAxis = Vector3.Cross(target.transform.up, transform.position - target.position);
		transform.RotateAround(target.position, yRotationAxis, deltaY);
		
		transform.position += transform.forward * deltaY * 0.15;
    }
}
