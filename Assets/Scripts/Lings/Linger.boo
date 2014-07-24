import UnityEngine

class Linger (MonoBehaviour): 
	public ling as Transform
	public startNumbers as (int) = (50, 50, 15)
	public startHerds as (int) = (5, 3, 1)
	public maxNumbers as (int) = (100, 100, 30)
	public prefabs as (GameObject)
	public countGUIs as (GUIText)
	public bars as (Transform)
	
	_spawnChances = ((9, 6, 5), (1, 1), (1, 1))
	
	_barMaxSizes = []
	
	lings:
		get:
			return _lings
	_lings = [[], [], []]
	
	_lastSpawnedLing as Transform
	
	def Awake ():
		#~ Time.timeScale = 2
		
		for bar in bars:
			_barMaxSizes.Add(bar.localScale.y)
		
		# spawn
		_lastSpawnedLing = ling
		for typeNum in range(3):
			spawn(typeNum)
			runHeadStart(typeNum)
		# break the mold
		ling.gameObject.active = false
		Object.Destroy(ling.gameObject)
		
		updateBars()
	
	def spawn(typeNum):
		for i in range(Mathf.CeilToInt(cast(single, startNumbers[typeNum]) / startHerds[typeNum])):
			if not canAddLingType(typeNum):
				continue
			_lastSpawnedLing = Instantiate(ling, _lastSpawnedLing.transform.position, _lastSpawnedLing.transform.rotation)
			lingLing = _lastSpawnedLing.gameObject.GetComponent(Ling)
			lingLing.level = randomLingLevel(typeNum)
			pf = Instantiate(prefabs[lingLing.level], _lastSpawnedLing.transform.position, _lastSpawnedLing.transform.rotation)
			pf.transform.parent = _lastSpawnedLing.transform
			lingLing.startMoving()
			AddLing(lingLing, Random.insideUnitCircle.normalized * 10000)
	
	def runHeadStart(typeNum):
		assert startHerds[typeNum] >= 1
		for ling as Transform in _lings[typeNum] as List + []: # force list copy
			for i in range(startHerds[typeNum] - 1):
				ling.GetComponent[of LingMultiply]().multiply(true)
	
	def randomLingLevel(typeNum as int) as int:
		# count number of levels of lesser types
		baseLevel = 0
		for tn in range(typeNum):
			baseLevel += len(_spawnChances[tn])
		
		# prepare totals
		totals = []
		running_total as int = 0
		for w in _spawnChances[typeNum]:
			running_total += w
			totals.Add(running_total)
		
		# generate
		rnd as int = Random.value * running_total
		for i as int, total as int in enumerate(totals):
			if rnd < total:
				return baseLevel + i
	
	def canAddLingType(typeNum as int):
		return len(_lings[typeNum]) < maxNumbers[typeNum]
	
	def canAddLing(ling as Ling):
		return canAddLingType(ling.typeNum)
	
	def AddLing(ling as Ling, offset as Vector2):
		ling.transform.parent = transform
		sm = ling.gameObject.GetComponent(SphereMove)
		savedDirection = sm.currentDirection
		sm.currentDirection = Vector3(offset.x, 0, offset.y)
		sm.FU(1)
		ling.GetComponent(Gravity).stickToGround()
		sm.currentDirection = savedDirection
		(_lings[ling.GetComponent(Ling).typeNum] as List).Add(ling.transform)
		updateBars()
	
	def RemoveLing(ling as Transform):
		(_lings[ling.GetComponent(Ling).typeNum] as List).Remove(ling)
		updateBars()
		
		if len(_lings[1]) + len(_lings[2]) == 0:
			Invoke("win", 3)
	
	def updateBars():
		#~ if gui:
			#~ gui.text = "${len(_lings[0]).ToString()} ${len(_lings[1]).ToString()} ${len(_lings[2]).ToString()}"
		for typeNum in range(3):
			if maxNumbers[typeNum]:
				maxSize as single = _barMaxSizes[typeNum]
				scale = maxSize * len(_lings[typeNum]) / maxNumbers[typeNum]
			else:
				scale = 0
			bars[typeNum].localScale.y = scale
			if len(_lings[typeNum]) <= 10:
				countGUIs[typeNum].text = len(_lings[typeNum]).ToString()
			else:
				countGUIs[typeNum].text = ""
	
	def win():
		Application.LoadLevel("credits")
