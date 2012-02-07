package business.controller.tasks {
	import business.controller.sound.SoundContainer;
	import business.controller.sound.SoundManager;
	import flash.events.Event;

	/**
	 * @author virich
	 */
	public class LoadSoundTask extends Task {
		
		private var _id: String;
		private var _sound: SoundContainer;
		
		public function LoadSoundTask($id: String) {
			_id = $id;
		}
		
		override public function run():void {
			_sound = SoundManager.addSound(_id);
			_sound.addEventListener(Event.COMPLETE, handleComplete);
			_sound.load();
		}

		private function handleComplete(e : Event) : void {
			_sound.removeEventListener(Event.COMPLETE, handleComplete);
			complete();
		}
	}
}
