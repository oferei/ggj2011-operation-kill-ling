import UnityEngine

class God():
	
	static Inst as God:
	""" Calls upon God """
		get:
			God() unless _instance
			return _instance
	static _instance as God
	
	Hermes:
	""" The messenger """
		get:
			return _hermes
	_hermes as Messenger
	
	SoundVolume:
	""" Master sound volume """
		get:
			return _soundVolume
		set:
			_soundVolume = value
	_soundVolume as single = 1
	
	private def constructor ():
	""" Wakes up God """
	
		Debug.Log("Beware, I live!")
		_instance = self
		_hermes = Messenger()
