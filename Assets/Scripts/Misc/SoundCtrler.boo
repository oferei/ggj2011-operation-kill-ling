import UnityEngine

class SoundCtrler (MonoBehaviour): 
	
	public keyCode as KeyCode = KeyCode.N
	
	_index as int = 0
	_volumes = (1, 0, 0.5)
	_names = ('on', 'off', 'low')
	
	_texts as (GUIText)
	
	def Awake ():
		_texts = gameObject.GetComponentsInChildren[of GUIText]()
		applyVolume()
	
	def applyVolume():
		for text in _texts:
			text.text = "Sound ${_names[_index]}"
		
		God.Inst.SoundVolume = _volumes[_index]
		MessageSoundVolumeChanged(_volumes[_index])
	
	def Update ():
		if Input.GetKeyDown(keyCode):
			stepUp()
	
	def OnMouseDown ():
		MessageCaughtMouse()
		stepUp()
	
	def stepUp():
		_index += 1
		if _index >= len(_volumes):
			_index = 0
		applyVolume()
