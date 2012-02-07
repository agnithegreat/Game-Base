package business.controller.windows {
    import business.utils.IDestroyable;
    import business.data.dicts.ArtResourcesVO;
    import business.event.ResourceEvent;
    import flash.display.DisplayObject;
    import flash.display.DisplayObjectContainer;
    import flash.display.MovieClip;
    import flash.display.Sprite;

	/**
	 * @author agnithegreat
	 */
	public class ResourceContainer extends Sprite implements IDestroyable {
		
		protected var _id: String;
        protected var _resource: ArtResourcesVO;
        protected var _assetContainer: Sprite;
        protected var _loaded: Boolean = false;
        protected var _asset: MovieClip;
        protected var _enabled: Boolean;

		public function get id():String {
			return _id;
		}

		public function get resource() : ArtResourcesVO {
			return _resource;
		}

		public function get asset():MovieClip {
			return _asset;
		}

		public function get loaded():Boolean {
			return _loaded;
		}

		public function get enabled():Boolean {
			return _enabled;
		}

		public function set enabled($enabled: Boolean):void {
			_enabled = $enabled;
			if (_enabled) {
				alpha = 1;
				mouseEnabled = mouseChildren = true;
			} else {
				alpha = 0.5;
				mouseEnabled = mouseChildren = false;
			}
		}
		
		public function ResourceContainer($id: String = null) {
			_assetContainer = new Sprite();
			addChild(_assetContainer);
			
			_id = $id;
			if (!_resource) {
				_resource = ResourceManager.getResource(_id);
			}
			if (!_resource) {
				return;
			}
			_resource.addEventListener(ResourceEvent.RESOURCE_LOADED, handleComplete);
			
			tabEnabled = false;
			tabChildren = false;
			
			if (_resource.ResourceClass) {
				create();
			} else if (!_resource.loading) {
				ResourceManager.sendRequest(_resource);
			}
		}
		
		protected function create() : void {
			_asset = new _resource.ResourceClass();
			_assetContainer.addChild(_asset);
			_loaded = true;
			_enabled = true;
			init();
		}
		
		protected function init():void {
			
		}
		
		private function handleComplete(e: ResourceEvent) : void {
			var res: ArtResourcesVO = e.currentTarget as ArtResourcesVO;
			res.removeEventListener(ResourceEvent.RESOURCE_LOADED, handleComplete);
			create();
			res = null;
		}
		
		public function destroy():void {
			_id = null;
			_resource = null;
			
			removeFromStage(_asset);
			_asset = null;
			removeFromStage(_assetContainer);
			_assetContainer = null;
			
			removeFromStage(this);
		}
		
		public function removeFromStage($child: DisplayObject):void {
			if (!$child) {
				return;
			}
			var par: DisplayObjectContainer = $child.parent;
			if (par) {
				par.removeChild($child);
			}
			$child = null;
		}
		
		override public function toString():String {
			return "resource: "+_id;
		}
	}
}
