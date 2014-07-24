import UnityEngine
import System.Collections

class LingEat (MonoBehaviour): 
	
	_linger as Linger
	_meLing as Ling
	_predator as LingEat
	_prey as LingEat
	
	_fruitsLeft as int
	
	hunger:
		get:
			return _hunger
	_hunger as single
	
	isPeckish:
		get:
			if _meLing.peckishness == Mathf.Infinity:
				return false
			return hunger >= _meLing.peckishness
	
	def Awake ():
		_linger = GameObject.Find("Manager").GetComponent[of Linger]()
		_meLing = GetComponent(Ling)
	
	def onInit ():
		_fruitsLeft = _meLing.numFruits
		_hunger = Random.value * _meLing.peckishness
	
	def Update ():
		_hunger += Time.deltaTime
		if _hunger > _meLing.starvation and _meLing.state in [Ling.State.Moving, Ling.State.Multiplying, Ling.State.Eating]:
			starve()
		#~ if isPeckish:
			#~ GetComponentInChildren(ParticleEmitter).emit = true
	
	def suggestChase(preyLing as Ling):
		assert _meLing.state == Ling.State.Moving
		#abcd
		#~ hungerScore = hunger / _meLing.starvation / 5
		#~ if isPeckish:# and Random.value < hungerScore:
		if _hunger > Mathf.Max(_meLing.peckishness, preyLing.calories):
			StartCoroutine(chaseCo(preyLing))
	
	def chaseCo(preyLing as Ling) as IEnumerator:
		assert preyLing.edibleState
		assert preyLing.typeNum == _meLing.typeNum - 1
		_meLing.state = Ling.State.Chasing
		_prey = preyLing.GetComponent(LingEat)
		
		sm = GetComponent(SphereMove)
		while _meLing.state == Ling.State.Chasing and _prey:
			# turn towards object
			sqrDistance = (_prey.transform.position - transform.position).sqrMagnitude
			if sqrDistance > 1:
				sm.startLookingAt(_prey.transform)
			yield
		if _meLing.state == Ling.State.Chasing:
			# prey died
			_meLing.startMoving()
	
	def suggestFood(preyLing as Ling):
		if _hunger > Mathf.Max(_meLing.peckishness, preyLing.calories):
			eat(preyLing)
	
	def eat(preyLing as Ling):
		assert _meLing.state in (Ling.State.Moving, Ling.State.Chasing)
		assert preyLing.edibleState
		assert preyLing.typeNum == _meLing.typeNum - 1
		_prey = preyLing.GetComponent(LingEat)
		#~ Debug.DrawLine(transform.position, _prey.transform.position, Color.green)
		_meLing.state = Ling.State.Eating
		_meLing.stopMoving()
		_prey.eatenStart(self)
		_hunger -= _prey.GetComponent(Ling).calories
		_hunger = Mathf.Max(_hunger, 0)
		if not isPeckish:
			GetComponentInChildren(ParticleEmitter).emit = false
		StartCoroutine(eatCo())

	def eatCo () as IEnumerator:
		GetComponent(SphereMove).startLookingAt(_prey.transform)
		yield WaitForSeconds(1 + Random.value)
		if _meLing.state != Ling.State.Eating:
			return
		GetComponent(LingSound).playEatSound()
		# devour
		if _prey:
			_prey.eatenFinish()
			_meLing.startMoving()
	
	def eatenStart(predator as LingEat):
		_predator = predator
		_meLing.state = Ling.State.Eaten
		_meLing.stopMoving()
	
	def eatenFinish():
		_fruitsLeft -= 1
		if _fruitsLeft <= 0:
			_meLing.die('eaten')
		else:
			_predator = null
			_meLing.startMoving()
			StartCoroutine(shrinkCo())
	
	def shrinkCo() as IEnumerator:
		for i in range(10):
			transform.localScale *= 0.99
			yield WaitForSeconds(0.05)
	
	def onPredatorDead():
		_predator = null
		_meLing.startMoving()
	
	def onPreyDead():
		_prey = null
		_meLing.startMoving()
	
	def starve():
		_meLing.die('starved')
	
	def onDying():
		if _meLing.state == Ling.State.Eaten:
			if _predator:
				_predator.onPreyDead()
		if _meLing.state == Ling.State.Eating:
			if _prey:
				_prey.onPredatorDead()
