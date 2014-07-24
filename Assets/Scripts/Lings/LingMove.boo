import UnityEngine
import System.Collections

class LingMove (MonoBehaviour):
	
	_sm as SphereMove
	_meLing as Ling
	
	def Awake ():
		_sm = GetComponent(SphereMove)
		_meLing = GetComponent(Ling)
	
	def FixedUpdate ():
		# rotate
		if _meLing.state == Ling.State.Moving and Random.value < _meLing.rotateChance:
			StartCoroutine(rotateCo((Random.value - 0.5) * 60))
	
	def rotateCo(angle as single) as IEnumerator:
		for i in range(10):
			_sm.RotateRight(angle / 10)
			yield WaitForSeconds(0.03)
