import UnityEngine

class JukeboxCtlr (MonoBehaviour):
	
	public keyCode as KeyCode = KeyCode.M
	
	_index as int = 0
	_volumes = (1, 0, 0.5)
	_names = ('on', 'off', 'low')
	
	_texts as (GUIText)
	
	_origVolume as single
	
	def Awake():
		_origVolume = audio.volume
	
	def Start():
		_texts = gameObject.GetComponentsInChildren[of GUIText]()
		applyVolume()
	
	def applyVolume():
		for text in _texts:
			text.text = "Music ${_names[_index]}"
		
		audio.volume = _origVolume * _volumes[_index]
	
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
	
