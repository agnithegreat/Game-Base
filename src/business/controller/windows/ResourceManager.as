package business.controller.windows {
	import flash.events.ProgressEvent;
	import business.controller.tasks.LoadResourceTask;
	import business.controller.tasks.TaskManager;
	import flash.events.EventDispatcher;
	import business.data.dicts.ArtResourcesVO;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.system.SecurityDomain;
	
	/**
	 * @author agnithegreat
	 */
	public class ResourceManager {
		
		public static var swfsLoaded: int;
		public static var swfsTotal: int;		
		private static var _resources: Object;
		private static var _swfs: Object;
		
		private static var _currentResource: ArtResourcesVO;
		static public function get processing() : Boolean {
			return Boolean(_currentResource);
		}
		
		private static var _dispatcher: EventDispatcher;
		
		private static var _initiated: Boolean = false;
		public static function init() : void {
			_resources = {};			_swfs = {};
			
			_dispatcher = new EventDispatcher();

			swfsLoaded = 0;			swfsTotal = 0;
			
			_initiated = true;
		}
		
		public static function parseResources($data: Object):void {
			if (_initiated) {
				for (var i : String in $data) {
					var res: ArtResourcesVO = new ArtResourcesVO();
					res.id = $data[i].id;
					res.name = $data[i].name;
					res.className = $data[i].class_name;
					res.path = $data[i].path;
					res.version = $data[i].version;
					addResource(res);
				}
			}
		}
		
		public static function addResource($resource : ArtResourcesVO) : void {
			if (_initiated) {
				_resources[$resource.name] = $resource;
			}
		}
		
		public static function getResource($id: String):ArtResourcesVO {
			if (!_initiated) {
				throw new Error("ResourceManager isn't initiated");
			}
			return _resources[$id];
		}
		
		public static function sendRequest($resource : ArtResourcesVO) : void {
			if (!_swfs[$resource.url]) {
				swfsTotal++;
				_swfs[$resource.url] = true;
			}
			$resource.loading = true;
			TaskManager.getInstance(true).addTask(new LoadResourceTask($resource));
		}
		
		public static function load($url: String, $callback: Function):void {
			var req : URLRequest = new URLRequest($url);
			var loader : Loader = new Loader();
			var loaderInfo: LoaderInfo = loader.contentLoaderInfo;			loaderInfo.addEventListener(Event.COMPLETE, $callback);
			loaderInfo.addEventListener(ProgressEvent.PROGRESS, handleProgress);			var security: SecurityDomain;
			if ($url.search("swf")>0){
				if (!Settings.local) {
					security = SecurityDomain.currentDomain;
				}
			}
			loader.load(req, new LoaderContext(true, ApplicationDomain.currentDomain, security));
		}

		private static function handleProgress(e : ProgressEvent) : void {
			dispatch(e);
		}
		
		public static function send($resource : ArtResourcesVO) : void {
			_currentResource = $resource;
			if (_swfs[$resource.url] is ApplicationDomain) {
				handleComplete(null);
			} else {
				load(getLastVersionResource($resource).url, handleComplete);
			}
		}

		private static function handleComplete(e : Event) : void {
			if (e) {
				var loaderInfo: LoaderInfo = e.currentTarget as LoaderInfo;
				loaderInfo.removeEventListener(Event.COMPLETE, handleComplete);
				_swfs[_currentResource.url] = loaderInfo.applicationDomain;
				swfsLoaded++;
			}
			afterLoad(_currentResource);
			dispatch(new Event(Event.COMPLETE));
		}
		
		private static function afterLoad($resource : ArtResourcesVO) : void {
			var appDomain: ApplicationDomain = _swfs[$resource.url] as ApplicationDomain;
			var resourceClass: Class = appDomain.getDefinition($resource.className) as Class;
			$resource.completeLoad(resourceClass);
			_currentResource = null;
		}
		
		private static function getLastVersionResource($resource: ArtResourcesVO):ArtResourcesVO {
			var last : ArtResourcesVO = $resource;
			for (var i : String in _resources) {
				var res: ArtResourcesVO = _resources[i];
				if (res.path == last.path && res.version>last.version) {
					last = res;
				}
				i = null;
			}
			return last;
		}
		
		public static function addEventListener(type: String, listener: Function):void {
			_dispatcher.addEventListener(type, listener);
		}
		
		public static function removeEventListener(type: String, listener: Function):void {
			_dispatcher.removeEventListener(type, listener);
		}
		
		private static function dispatch(event: Event):void {
			_dispatcher.dispatchEvent(event);
		}
	}
}
