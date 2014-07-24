import UnityEngine
import System.Collections

class Ling (MonoBehaviour):
	
	enum Type:
		Undefined
		Plant
		Vegetarian
		Carnivore
	
	level:
		get:
			return _level
		set:
			_level = value
			init()
	_level as int = -1
	
	static _typeNumsByLevel as (int) = (0, 0, 0, 1, 1, 2, 2)
	public typeNum:
		get:
			return _typeNumsByLevel[_level]
	
	static _typesByTypeNum = (Type.Plant, Type.Vegetarian, Type.Carnivore)
	public type:
		get:
			return _typesByTypeNum[typeNum]
	
	enum State:
		Born
		Moving
		Multiplying
		Chasing
		Eating
		Eaten
		Dying
	
	public state as State
	
	static def genValue(params) as single:
		# scalar
		if params.GetType() in (int, single, double):
			return params
		# range
		min as single, max as single = params as IList
		return Random.Range(min, max)
	
	static _numFruits as (int) = (8, 11, 14, 1, 1, 1, 1)
	public numFruits:
		get:
			return _numFruits[_level]
	
	static _longevities = ((135, 215), (45, 75), (90, 150))
	_timeToLive as single
	
	edibleState:
		get:
			return state in (State.Moving, State.Chasing, State.Eating)
	
	static _speeds = (0, (50, 100), (100, 200))
	
	static _rotateChances = (0, 0.05, 0.05)
	rotateChance:
		get:
			return _rotateChances[typeNum]
	
	static _spawnDistances = (200, 20, 30)
	spawnPosition:
		get:
			if type == Type.Plant:
				threshold = 0.3
			else:
				threshold = 0.05
			if Random.value < threshold:
				return Random.insideUnitCircle.normalized * 10000
			else:
				return Random.insideUnitCircle.normalized * _spawnDistances[typeNum]
	
	static _calories = (7, 20, 0)
	calories:
		get:
			return _calories[typeNum]
	
	static _peckishnessLevels = (Mathf.Infinity, (12, 18), (20, 30))
	peckishness:
		get:
			return _peckishness
	_peckishness as single
	
	static _starvationLevels = (Mathf.Infinity, (20, 30), (40, 45))
	starvation:
		get:
			return _starvation
	_starvation as single
	
	static _spotFoodDistances = (0, 7, 13)
	spotFoodDistance:
		get:
			return _spotFoodDistances[typeNum]
	
	static _eatReachs = (0, 2, 2)
	eatReach:
		get:
			return _eatReachs[typeNum]
	
	public static _multiplyIntervals = ((30, 60), (10, 30), (20, 150))
	multiplyInterval:
		get:
			return _multiplyInterval
	_multiplyInterval as single
	
	def init() :
		transform.localScale = Vector3.one
		_timeToLive = genValue(_longevities[typeNum])
		_peckishness = genValue(_peckishnessLevels[typeNum])
		_starvation = genValue(_starvationLevels[typeNum])
		_multiplyInterval = genValue(_multiplyIntervals[typeNum])
		
		if type == Type.Plant:
			Destroy(GetComponent(LingMeet))
		state = State.Born
		stopMoving()
		BroadcastMessage("onInit", null)
	
	def Update():
		_timeToLive -= Time.deltaTime
		if _timeToLive <= 0:
			die('old age')
	
	def startMoving():
		state = State.Moving
		sm = GetComponent(SphereMove)
		speed = genValue(_speeds[typeNum])
		sm.currentDirection = Vector3(0, 0, speed)
		sm.stopLooking()
	
	def stopMoving():
		sm = GetComponent(SphereMove)
		sm.currentDirection = Vector3.zero
	
	def expand():
		transform.localScale = Vector3(0.05, 0.05, 0.05)
		StartCoroutine(expandCo())
	
	def expandCo() as IEnumerator:
		while transform.localScale.x < 0.91:
			transform.localScale *= 1.1
			yield WaitForSeconds(0.05)
		transform.localScale = Vector3.one
		startMoving()
	
	#~ def burn():
		#~ GetComponentInChildren(ParticleEmitter).emit = true
	
	def die(reason as string):
		if state == State.Dying:
			return
		#~ if type == Type.Carnivore:
			#~ Debug.Log("DEAD (${reason})")
		BroadcastMessage("onDying", null)
		state = State.Dying
		StopAllCoroutines()
		StartCoroutine(dieCo())
	
	def onDying():
		#~ Debug.Log("ling.ondying")
		stopMoving()
	
	def dieCo() as IEnumerator:
		GetComponent(LingSound).playDeathSound()
		# shrivel
		for i in range(30):
			transform.localScale *= 0.90
			yield WaitForSeconds(0.05)
		# expire
		linger = GameObject.Find("Manager").GetComponent[of Linger]()
		linger.RemoveLing(transform)
		Object.Destroy(gameObject)
