import UnityEngine

[RequireComponent(GUIText)]

class EnergyUpdate (MonoBehaviour): 
	public spaceship as SpacehipController
	
	_maxSize as single
	
	def Awake ():
		_maxSize = transform.localScale.y

	def Update ():
		energy as single = spaceship.energy / spaceship.maxEnergy
		transform.localScale.y = _maxSize * energy
		renderer.material.color = Color(1- energy, energy, 0, 1)
