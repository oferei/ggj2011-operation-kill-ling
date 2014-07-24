import UnityEngine
import System.Collections

class LingMultiply (MonoBehaviour):
	
	_meLing as Ling
	_meEater as LingEat
	_linger as Linger

	_timeSinceMultiply as single = 0
	
	def Awake ():
		_meLing = GetComponent(Ling)
		_meEater = GetComponent(LingEat)
		_linger = GameObject.Find("Manager").GetComponent[of Linger]()
	
	def Update ():
		_timeSinceMultiply += Time.deltaTime
		if _meLing.state == Ling.State.Moving and _timeSinceMultiply > _meLing.multiplyInterval and not _meEater.isPeckish:
			multiply(false)
	
	def multiply(instant as bool):
		if _linger.canAddLing(_meLing):
			_meLing.state = Ling.State.Multiplying
			_meLing.stopMoving()
			_timeSinceMultiply = 0
			StartCoroutine(multiplyCo(instant))
	
	def multiplyCo(instant as bool) as IEnumerator:
		if not instant:
			yield WaitForSeconds(1 + Random.value)
		if _meLing.state != Ling.State.Multiplying:
			return
		_meLing.startMoving()
		if _linger.canAddLing(_meLing):
			newLing = Instantiate(gameObject, transform.position, transform.rotation)
			newLingLing as Ling = newLing.GetComponent(Ling)
			newLingLing.level = _meLing.level
			if instant:
				newLingLing.startMoving()
			else:
				GetComponent(LingSound).playAliveSound()
				newLingLing.expand()
			_linger.AddLing(newLingLing, newLingLing.spawnPosition)
