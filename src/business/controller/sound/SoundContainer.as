package business.controller.sound {
	import flash.media.SoundTransform;
	import flash.events.EventDispatcher;
	import flash.media.SoundChannel;
	import flash.media.Sound;
	import business.data.dicts.SoundVO;
	import flash.events.Event;
	import flash.net.URLRequest;
	
	/**
	 * @author virich
	 */
	public class SoundContainer extends EventDispatcher {
		
		private var _data: SoundVO;
		public function get sound():SoundVO {
			return _data;
		}
		
		private var _sound: Sound;
		private var _channels: Vector.<SoundChannel>;
		
		private var _loading: Boolean;
		private var _playing: Boolean;
		
		public function SoundContainer($id: String) {
			_data = SoundVO.getSoundByID($id);
			_channels = new Vector.<SoundChannel>();
		}
		
		public function play():void {
			_playing = true;
			if (_sound) {
				if (_loading) {
					return;
				}
				if (_channels.length>0 && _data.isMusic) {
					return;
				}
				if (_data.isSound && SoundManager.controller.sound && checkLastSound() || _data.isMusic && SoundManager.controller.music) {
					var channel: SoundChannel = _sound.play(0, _data.isMusic ? 1000 : 0, new SoundTransform(_data.volume/100));
					if (channel) {
						_channels.push(channel);
						channel.addEventListener(Event.SOUND_COMPLETE, handleStopped);
					}
				}
			} else {
				load();
			}
		}
		
		private function checkLastSound():Boolean {
			if (_channels.length>0) {
				var last: SoundChannel = _channels[_channels.length-1];
				if (last.position==0) {
					return false;
				}
			}
			return true;
		}
		
		public function stop($channel: SoundChannel = null):void {
			if ($channel) {
				$channel.removeEventListener(Event.SOUND_COMPLETE, handleStopped);
				$channel.stop();
				$channel = null;
			} else {
				while (_channels.length>0) {
					stop(_channels.shift());
				}
			}
		}

		private function handleStopped(e : Event) : void {
			for (var i : int = 0; i < _channels.length; i++) {
				if (_channels[i]==e.currentTarget) {
					stop(_channels.splice(i,1)[0]);
					return;
				}
			}
		}
		
		public function load():void {
			_loading = true;
			_sound = new Sound(new URLRequest(Settings.sounds_url+_data.file_name));
			_sound.addEventListener(Event.COMPLETE, handleLoad);
		}
		
		private function handleLoad(e: Event):void {
			_loading = false;
			dispatchEvent(new Event(Event.COMPLETE));
			if (_playing) {
				play();
			}
		}
	}
}
