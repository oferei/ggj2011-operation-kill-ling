import UnityEngine

class LingSound (MonoBehaviour): 
	
	static aliveSounds = ('', '', '', 'baseling_alive', 'twoling_alive', 'grizling_alive', 'grizling_alive')
	static eatSounds = ('', '', '', 'veg_eat', 'veg_eat', 'grizling_eat', 'bigling_eat')
	static deathSounds = ('', '', '', 'veg_death', 'veg_death', 'toref death', 'toref death')
	
	_aliveSoundName as string
	_eatSoundName as string
	_deathSoundName as string
	
	def Start ():
		level = GetComponent(Ling).level
		_aliveSoundName = aliveSounds[level]
		_eatSoundName = eatSounds[level]
		_deathSoundName = deathSounds[level]
		
		StartCoroutine(makeAliveSound())
	
	def makeAliveSound() as IEnumerator:
		while true:
			yield WaitForSeconds(Random.value * 20)
			playAliveSound()
		
	def playAliveSound():
		if audio.isPlaying:
			return
		
		if _aliveSoundName:
			audio.clip = Resources.Load("Sounds/${_aliveSoundName}")
			audio.loop = false
			audio.Play()
	
	def playEatSound():
		if audio.isPlaying:
			audio.Stop()
		
		if _eatSoundName:
			audio.clip = Resources.Load("Sounds/${_eatSoundName}")
			audio.loop = false#true
			audio.Play()
	
	#~ def stopEatSound():
		#~ if audio.isPlaying:
			#~ audio.Stop()
	
	def playDeathSound():
		if audio.isPlaying:
			audio.Stop()
		
		if _deathSoundName:
			audio.clip = Resources.Load("Sounds/${_deathSoundName}")
			audio.loop = false
			audio.Play()
		