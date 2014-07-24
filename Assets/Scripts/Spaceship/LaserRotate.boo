import UnityEngine

class LaserRotate (MonoBehaviour): 
	
	public angles as single = 30
	public time as single = 1
	
	origAngle as Vector3
	#~ curAngle as single = 0
	directionRight as bool = true
	duration as single = 0

	def Start ():
		origAngle = transform.eulerAngles
	
	def Update():
		angleDiff = Time.deltaTime / time * angles
		if directionRight:
			angleDiff = -angleDiff
		transform.Rotate(Vector3(0, angleDiff, 0))
			
		duration += Time.deltaTime
		
		# toggle direction
		if duration >= time:
			#~ curAngle = 0
			directionRight = not directionRight
			duration = 0
