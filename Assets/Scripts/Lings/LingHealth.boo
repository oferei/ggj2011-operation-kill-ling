import UnityEngine

class LingHealth (MonoBehaviour): 
	
	public maxHealth as single
	
	_currentHealth as single
	
	def Start ():
		_currentHealth = maxHealth

	def DoDamage(damage as single):
		_currentHealth -= damage
		if (_currentHealth < 0) :
			#~ if (GetComponent(Ling) as Ling).state != Ling.State.Dying:
				#~ Debug.Log("killed state: ${GetComponent(Ling).state}")
			#~ GetComponent(Ling).burn()
			GetComponent(Ling).die('zapped')
