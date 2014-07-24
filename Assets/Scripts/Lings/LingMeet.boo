import UnityEngine
import System.Collections

class LingMeet (MonoBehaviour): 
	
	planetLayerMask as int
	_linger as Linger
	
	def Start ():
		_linger = GameObject.Find("Manager").GetComponent[of Linger]()
		planetLayerMask = ~(1 << LayerMask.NameToLayer("Planet"))

		StartCoroutine(CheckAround())
	
	def CheckAround () as IEnumerator:
		yield WaitForSeconds(0.3 + Random.value)
		meLing as Ling = GetComponent(Ling)
		meLingEat as LingEat = GetComponent(LingEat)
		assert meLing.typeNum > 0
		
		while true:
			if meLing.state in (Ling.State.Moving, Ling.State.Chasing):
				ling as Transform
				for ling in _linger.lings[meLing.typeNum - 1]:
					#~ if ling.gameObject == gameObject:
						#~ continue
					lingLing as Ling = ling.GetComponent(Ling)
					if not lingLing.edibleState:
						continue
					v = ling.transform.position - transform.position
					sqrDist = v.sqrMagnitude
					somePrey as Ling
					if sqrDist < Mathf.Pow(meLing.spotFoodDistance, 2):
						# in range for chasing
						if sqrDist < Mathf.Pow(meLing.eatReach, 2):
							# in range for eating
							meLingEat.suggestFood(lingLing)
							break
						# too far for eating
						somePrey = lingLing
					# still not eating?
					if meLing.state == Ling.State.Moving:
						# try chasing
						if somePrey:
							meLingEat.suggestChase(somePrey)
			yield WaitForSeconds(1)
