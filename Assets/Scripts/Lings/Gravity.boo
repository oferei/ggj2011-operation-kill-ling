import UnityEngine

class Gravity (MonoBehaviour):
	
	public gravity as single = 9.8
	
	_planet as Transform
	_planetLayerMask as int
	_verticalSpeed as single = 0
	
	def Awake ():
		_planet = GameObject.FindWithTag("Planet").transform
		_planetLayerMask = 1 << LayerMask.NameToLayer("Planet")
		#~ stickToGround()
	
	def FixedUpdate ():
		hitInfo as RaycastHit
		meFromPlanet = transform.position - _planet.position
		if Physics.Raycast(transform.position, -meFromPlanet, hitInfo, Mathf.Infinity, _planetLayerMask):
			_verticalSpeed += gravity * Time.deltaTime
			distance = _verticalSpeed * Time.deltaTime
			if distance >= hitInfo.distance:
				# hit ground
				transform.position = hitInfo.point
				_verticalSpeed = 0
			else:
				# fall
				transform.Translate(Vector3(0, -distance, 0))
		else:
			# underground
			stickToGround()
	
	def stickToGround():
		hitInfo as RaycastHit
		meFromPlanet = transform.position - _planet.position
		if Physics.Raycast(transform.position + meFromPlanet, -meFromPlanet * 2, hitInfo, Mathf.Infinity, _planetLayerMask):
			transform.position = hitInfo.point
		else:
			Debug.LogWarning("There is no ground!")
		_verticalSpeed = 0
