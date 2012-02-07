package business.controller.tasks {
	import business.data.dicts.ArtResourcesVO;
	import flash.events.Event;
	import business.controller.windows.ResourceManager;
	import business.controller.tasks.Task;

	/**
	 * @author virich
	 */
	public class LoadResourceTask extends Task {
		
		private var _resource: ArtResourcesVO;
		
		public function LoadResourceTask($resource: ArtResourcesVO) {
			_resource = $resource;
		}
		
		override public function run():void {
			ResourceManager.addEventListener(Event.COMPLETE, handleComplete);
			ResourceManager.send(_resource);
		}
		
		private function handleComplete(e: Event):void {
			ResourceManager.removeEventListener(Event.COMPLETE, handleComplete);
			complete();
		}
	}
}
