class MessageSoundVolumeChanged (Message):

	soundVolume:
		get:
			return _soundVolume
	_soundVolume as single

	def constructor (soundVolume):
		_soundVolume = soundVolume

		# send the message
		super()
