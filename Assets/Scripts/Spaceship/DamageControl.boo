import UnityEngine

class DamageControl (MonoBehaviour): 

	public damageActive as bool
	public damageRate as single
	

	def Start ():
		Physics.IgnoreCollision(collider, GameObject.FindWithTag("Planet").collider)


	def OnTriggerStay(other as Collider):
		#Debug.Log("Triggered")
		if not damageActive:
			return
			
		if (not Input.GetMouseButton(0)) :
			return
		
		otherLing as LingHealth
		otherLing = other.gameObject.GetComponent('LingHealth')

		
		if (otherLing == null) :
			#Debug.Log("${other.gameObject.name}")
			#Debug.Break()
			return
		
		otherLing.DoDamage(Time.deltaTime * damageRate)
		


