import UnityEngine

class SpaceshipRotate (MonoBehaviour): 

	public sphereMove as SphereMove
	
	_targetDirection as Vector3 = Vector3.zero

	def Update ():
		if sphereMove.currentDirection != Vector3.zero:
			_targetDirection = sphereMove.currentDirection
		
		if _targetDirection != Vector3.zero:
			curAngle = GetYRotationAngle(sphereMove.transform.forward, transform.forward, transform)
			desiredAngle = Mathf.Atan2(_targetDirection.x, _targetDirection.z) * 180 / Mathf.PI
			diffAngle = desiredAngle - curAngle
			if diffAngle > 180:
				diffAngle -= 360
			if diffAngle < -180:
				diffAngle += 360
			transform.Rotate(Vector3(0, diffAngle * Time.deltaTime * 5, 0))

	def GetYRotationAngle(fromDirection as Vector3, toDirection as Vector3, space as Transform) as single:
		angle = Vector3.Angle(fromDirection, toDirection)
		cross = Vector3.Cross(fromDirection, toDirection)
		cross = space.InverseTransformDirection(cross)
		if cross.y > 0:
			return angle
		else:
			return 360 - angle
