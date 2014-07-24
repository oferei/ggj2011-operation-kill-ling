import UnityEngine

class SoundAgent (MonoBehaviour): 
	
	_origVolume as single
	
	def Awake ():
		_origVolume = audio.volume
	
	def Start ():
		setVolume(God.Inst.SoundVolume)
	
	def OnEnable ():
		God.Inst.Hermes.Listen(MessageSoundVolumeChanged, self)
	
	def OnDisable ():
		God.Inst.Hermes.StopListening(MessageSoundVolumeChanged, self)
	
	def OnMsgSoundVolumeChanged(msg as MessageSoundVolumeChanged):
		setVolume(msg.soundVolume)
	
	def setVolume(volume as single):
		audio.volume = _origVolume * volume
