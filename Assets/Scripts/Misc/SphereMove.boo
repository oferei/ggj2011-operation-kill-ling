import UnityEngine

class SphereMove (MonoBehaviour): 
	
	public planet as Transform
	
	public currentDirection = Vector3.zero
	
	_lookTarget as Vector3 = Vector3.zero

	def Start ():
		assert planet
	
	def FixedUpdate ():
		FU(Time.deltaTime)
	
	def FU(deltaTime as single):
		# move
		meFromPlanet = transform.position - planet.position
		rotateAxis = Vector3.Cross(meFromPlanet, transform.TransformDirection(currentDirection))
		circumference = meFromPlanet.magnitude * 2 * Mathf.PI
		angle = currentDirection.magnitude / circumference * 2 * Mathf.PI
		#angle = Mathf.Atan2(currentDirection.magnitude, meFromPlanet.magnitude)
		transform.RotateAround(planet.position, rotateAxis, angle * deltaTime)
		
	def RotateRight(angle as single):
		transform.Rotate(Vector3(0, angle, 0))
	
	def startLookingAt(target as Transform):
		_lookTarget = target.position
	
	def stopLooking():
		_lookTarget = Vector3.zero
	
	def Update ():
		if _lookTarget != Vector3.zero:
			# direct line to target
			direction = _lookTarget - transform.position
			Debug.DrawRay(transform.position, direction, Color.red)
			# tangent to planet
			direction = projectVectorOnPlane(direction, transform.up)
			Debug.DrawRay(transform.position, direction, Color.green)
			# calculate rotation
			rotation = Quaternion.LookRotation(direction, transform.up)
			# rotate
			if direction.sqrMagnitude > 0.5:
				transform.rotation = Quaternion.Slerp(transform.rotation, rotation, Time.deltaTime * 3)
			else:
				stopLooking()
				transform.rotation = rotation
	
	def projectVectorOnPlane(v as Vector3, normalUnit as Vector3):
		return v - (Vector3.Dot(v, normalUnit)) * normalUnit
