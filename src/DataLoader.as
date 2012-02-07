package {
	import business.controller.tasks.LoadXMLTask;
	import business.data.dicts.LibsLinksVO;
	import business.controller.localization.LocalizationManager;
	import business.controller.tasks.LoadLibTask;
	import business.controller.tasks.LoadSoundTask;
	import business.controller.tasks.Task;
	import business.controller.tasks.TaskManager;
	import business.controller.windows.ResourceManager;
	import business.controller.windows.Window;
	import business.controller.windows.WindowManager;
	import business.data.dicts.ArtResourcesVO;
	import business.data.dicts.SoundVO;
	import business.view.Preloader;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	
	/**
	 * @author virich
	 */
	public class DataLoader {
		
		private var _taskManager: TaskManager;
		private var _callback: Function;
		
		public function DataLoader() {
			_taskManager = TaskManager.getInstance(true);
		}
		
		public function loadLibsLinks($url: String, $callback: Function = null):void {
			_callback = $callback;
			_taskManager.addEventListener(Task.TASK_COMPLETE, handleTasksComplete);
			_taskManager.addTask(new LoadLibTask($url, LibsLinksVO.parse));
		}
		
		public function loadLibs($classes: Array, $callback: Function = null):void {
			_callback = $callback;
			_taskManager.addEventListener(Task.TASK_COMPLETE, handleTasksComplete);
			
			_taskManager.addTask(new LoadXMLTask(Settings.locale_ru_url, LocalizationManager.parseXML));
			_taskManager.addTask(new LoadLibTask(LibsLinksVO.LINKS[ArtResourcesVO.ID], ResourceManager.parseResources));
			
			for (var i : int = 0; i < $classes.length; i++) {
				_taskManager.addTask(new LoadLibTask(LibsLinksVO.LINKS[$classes[i].ID], $classes[i].parse));
			}
		}
		
		public function loadResources($classes: Array, $callback: Function = null):void {
			_callback = $callback;
			
			ResourceManager.addEventListener(ProgressEvent.PROGRESS, handleShowResourceProgress);
			_taskManager.addEventListener(Task.TASK_COMPLETE, handleTasksComplete);
			
			for (var i : int = 0; i < $classes.length; i++) {
				new $classes[i]();
			}
		}
		
		public function loadSounds($callback: Function = null):void {
			_callback = $callback;
			_taskManager.addEventListener(Task.NEXT_TASK, handleShowProgress);
			_taskManager.addEventListener(Task.TASK_COMPLETE, handleTasksComplete);
			
			_taskManager.clearCount();
			
			setPreloaderLabel("loading.sounds");
			
			for (var i : int = 0; i < SoundVO.SOUNDS_ARRAY.length; i++) {
				_taskManager.addTask(new LoadSoundTask(SoundVO.SOUNDS_ARRAY[i].sound_id));
			}
		}
		
		private function setPreloaderLabel($label: String, $replaces: Object = null):void {
			var preloader: Preloader = WindowManager.getWindow(Window.PRELOADER) as Preloader;
			if (preloader) {
//				preloader.setLabel($label, $replaces);
			}
		}
		
		private function handleShowResourceProgress(e: ProgressEvent) : void {
			var preloader: Preloader = WindowManager.getWindow(Window.PRELOADER) as Preloader;
			if (preloader) {
				setPreloaderLabel("loading.arts", {loaded: ResourceManager.swfsLoaded, total: ResourceManager.swfsTotal});
				preloader.showProgress((ResourceManager.swfsLoaded+e.bytesLoaded/e.bytesTotal)/ResourceManager.swfsTotal);
			}
		}
		
		private function handleShowProgress(e: Event) : void {
			var preloader: Preloader = WindowManager.getWindow(Window.PRELOADER) as Preloader;
			if (preloader) {
				preloader.showProgress(ResourceManager.swfsLoaded/ResourceManager.swfsTotal);
			}
		}
		
		private function handleTasksComplete(e : Event) : void {
			ResourceManager.removeEventListener(ProgressEvent.PROGRESS, handleShowResourceProgress);
			_taskManager.removeEventListener(Task.NEXT_TASK, handleShowProgress);
			_taskManager.removeEventListener(Task.TASK_COMPLETE, handleTasksComplete);
			
			if (_callback is Function) {
				var fn: Function = _callback;
				_callback = null;
				fn();
			}
		}
	}
}
