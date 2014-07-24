import UnityEngine

[RequireComponent(GUIText)]

class FPSCounter (MonoBehaviour): 

	public updateInterval as single = 0.5
	
	_show = true

	_lastUpdateTime as single = 0.0
	_frameCount = 0

	def Awake ():
		if updateInterval <= 0:
			Debug.LogError("Update interval is too small (${updateInterval})")
			enabled = false

	def Update ():
		if Input.GetKeyDown("0"):
			_show = not _show
		
		++_frameCount
		now = Time.realtimeSinceStartup
		timeSinceLastUpdate = now - _lastUpdateTime
		if timeSinceLastUpdate >= updateInterval:
			fps as int = _frameCount / timeSinceLastUpdate
			if _show:
				guiText.text = "${fps.ToString()}"
			else:
				guiText.text = ""
			_lastUpdateTime = now
			_frameCount = 0
