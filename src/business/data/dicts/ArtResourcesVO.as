package business.data.dicts {
	import business.event.ResourceEvent;
	import flash.events.EventDispatcher;
	
	/**
	 * @author virich
	 */
	public class ArtResourcesVO extends EventDispatcher {
		
		public static const ID: String = "flashResources";
		
		public var id: int;
		public var name: String;
		public var className: String;
		public var path: String;
		public var version: int;
		
		public function get url():String {
			return Settings.resources_url+path+"?_"+version;
		}
		
		public var loading: Boolean = false;
		public var ResourceClass: Class;
		
		public function completeLoad($resourceClass : Class) : void {
			ResourceClass = $resourceClass;
			dispatchEvent(new ResourceEvent(ResourceEvent.RESOURCE_LOADED));
		}
		
		override public function toString():String {
			return "{name: "+name+", className: "+className+"}";
		}
	}
}
