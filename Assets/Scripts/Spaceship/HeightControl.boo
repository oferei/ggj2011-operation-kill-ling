import UnityEngine

class HeightControl (MonoBehaviour): 

	public height as single = 1
	_planetLayerMask as int
	
	def Start ():
		_planetLayerMask = 1 << LayerMask.NameToLayer("Planet")
	
	def Update ():
		hit as RaycastHit
		if Physics.Raycast(transform.position, -transform.up, hit, 1000, _planetLayerMask):
			distanceToGround = Vector3.Distance(transform.position, hit.point)
			transform.Translate(Vector3(0, (height - distanceToGround) * Time.deltaTime * 3, 0))
			
