import UnityEngine

class Snap2d3d (MonoBehaviour): 
	
	public target as Transform
	public activeCamera as Camera
	#~ public anchor as TextAnchor = TextAnchor.MiddleCenter

	def Start ():
		if not activeCamera:
			if len(Camera.allCameras) == 1:
				activeCamera = Camera.allCameras[0]
			else:
				Debug.LogError("Camera is not set")
				return
		
		point = activeCamera.WorldToViewportPoint(target.position)
		#~ Debug.Log("point: ${point}")
		transform.position.x = point.x
		transform.position.y = point.y
	
	def Update ():
		pass
