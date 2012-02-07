package business.utils.animationCache {
	import flash.text.TextField;
	import flash.display.DisplayObjectContainer;
	import flash.geom.Rectangle;
	import flash.events.Event;
	import flash.display.DisplayObject;
	import flash.geom.Matrix;
	import flash.display.MovieClip;

	import business.event.ResourceEvent;

	import flash.display.Bitmap;
	import flash.display.BitmapData;

	import business.controller.windows.ResourceContainer;

	/**
	 * @author virich
	 */
	public class AnimationCache extends ResourceContainer {
		
		public static const INSTANCES : Object = {};
		public static function getInstance($id: String, $source: String = null, $text: Object = null, $useIdAsInner: Boolean = true, $speed: Number = 1, $loop: Boolean = true, $autodestroy: Boolean = true):AnimationCache {
			if ($text) {
				$id += "."+$text.text;
			}
			
			var caches : Array = INSTANCES[$id];
			if (caches && caches.length > 0) {
				var animation: AnimationCache = caches.pop();
				animation.used = true;
				animation.gotoAndPlay(0);
				return animation;
			}
			return new AnimationCache($id, $source, $text, $useIdAsInner, $speed, $loop, $autodestroy);
		}
		
		public static const ANIMATION_LOOP : String = "animation_loop";
		
		protected var _source : ResourceContainer;
		protected var _text: Object;
		protected var _useIdAsInner: Boolean;
		
		protected var _sequence : AnimationSequence;
		
		public function get isCached():Boolean {
			return _sequence.completed;
		}
		
		protected var _bitmap : Bitmap;
		protected var _clips : Vector.<BitmapData>;
		
		protected var _currentFrame : Number = 0;
		protected var _speed: Number;
		
		protected var _loop : Boolean;
		protected var _autodestroy : Boolean;
		
		protected var _used: Boolean;
		public function set used($used: Boolean):void {
			_used = $used;
		}

		public function AnimationCache($id : String, $source : String, $text: Object = null, $useIdAsInner : Boolean = true, $speed: Number = 1, $loop: Boolean = true, $autodestroy: Boolean = true) {
			_source = $source ? new ResourceContainer($source) : null;
			_text = $text;
			_useIdAsInner = $useIdAsInner;
			
			_speed = $speed;
			_loop = $loop;
			_autodestroy = $autodestroy;

			_sequence = AnimationSequence.getAnimationSequence($id);
			_used = true;
			
			mouseEnabled = mouseChildren = false;
			
			if (!INSTANCES[$id]) {
				INSTANCES[$id] = [];
			}
			
			if (!_source) {
				return;
			}
			
			if (_source.loaded) {
				startCache(_source.asset);
			} else {
				_source.addEventListener(ResourceEvent.RESOURCE_LOADED, handleLoaded);
			}
		}

		private function handleLoaded(e : ResourceEvent) : void {
			_source.removeEventListener(ResourceEvent.RESOURCE_LOADED, handleLoaded);
			startCache(_source.asset);
		}

		public function startCache($mc: MovieClip, $scale: Number = 1) : void {
			if (!_sequence.completed) {
				var child : DisplayObject = $mc;
				if (_useIdAsInner) {
					(child as MovieClip).gotoAndStop(_sequence.id);
					child = $mc.getChildAt(0);
				}
				if (_text) {
					getTextField(_text.id, child).text = _text.text;
				}
				var frames : int = child is MovieClip ? (child as MovieClip).totalFrames : 1;
				_sequence.bounds = frames>1 ? getChildBounds(child as MovieClip) : child.getBounds(child);

				for (var i: int = 1; i <= frames; i++) {
					var bitmapData : BitmapData = new BitmapData(_sequence.bounds.width, _sequence.bounds.height, true, 0x00000000);
					if (child is MovieClip) {
						setAllToClip(child as MovieClip, i);
					}
					var m : Matrix = new Matrix();
					m.translate(-_sequence.bounds.x, -_sequence.bounds.y);
					m.scale(child.scaleX, child.scaleY);
					bitmapData.draw(child, m, null, null, null, true);
					_sequence.sequence.push(bitmapData);
				}
				_sequence.completed = true;
			}
			_bitmap = new Bitmap();
			_bitmap.x = _sequence.bounds.x;
			_bitmap.y = _sequence.bounds.y;
			addChild(_bitmap);
			
			_clips = _sequence.sequence;
			if (_clips.length<=1) {
				cacheAsBitmap = true;
			}

			gotoAndPlay(0);
			
			if (_source) {
				_source.destroy();
				_source = null;
			}
		}
		
		private function getTextField($id: String, $parent: DisplayObject):TextField {
			var hierarchy: Array = $id.split(".");
			var object: Object = $parent;
			for (var i : int = 0; i < hierarchy.length; i++) {
				object = object.getChildByName(hierarchy[i]);
			}
			return object as TextField;
		}
		
		private function setAllToClip($parent: DisplayObjectContainer, $clip: int):void {
			if ($parent is MovieClip) {
				($parent as MovieClip).gotoAndStop($clip);
			}
			for (var i : int = 0; i < $parent.numChildren; i++) {
				var child: MovieClip = $parent.getChildAt(i) as MovieClip;
				if (child) {
					setAllToClip(child, $clip);
				}
			}
		}
		
		private function getChildBounds($child: MovieClip):Rectangle {
			var bounds: Rectangle = new Rectangle();
			for (var i : int = 1; i <= $child.totalFrames; i++) {
				$child.gotoAndStop(i);
				var rect: Rectangle = $child.getBounds($child);
				bounds.x = Math.min(bounds.x, rect.x);
				bounds.y = Math.min(bounds.y, rect.y);
				bounds.width = Math.max(bounds.width, rect.width);
				bounds.height = Math.max(bounds.height, rect.height);
			}
			return bounds;
		}

		public function play() : void {
			if (_sequence.sequence.length > 1) {
				addEventListener(Event.ENTER_FRAME, handleTimer);
			}
		}

		public function gotoAndPlay($frame : int) : void {
			updateFrame($frame);
			play();
		}

		public function gotoAndStop($frame : int) : void {
			updateFrame($frame);
			stop();
		}

		public function stop() : void {
			removeEventListener(Event.ENTER_FRAME, handleTimer);
		}

		private function handleTimer(e : Event) : void {
			if (_sequence.sequence.length > 1) {
				updateFrame(_currentFrame+_speed);
			}
		}

		private function updateFrame($frame : Number) : void {
			var length: int = _clips.length;
			_currentFrame = $frame % length;
			if (length > 0) {
				_bitmap.bitmapData = _clips[int(_currentFrame)];
				
				if ($frame+1 >= length) {
					dispatchEvent(new Event(ANIMATION_LOOP));
					if (!_loop && length>1) {
						stop();
						if (_autodestroy) {
							destroy();
						}
					}
				}
			}
		}

		override public function destroy() : void {
			if (_used) {
				if (parent) {
					parent.removeChild(this);
				}
				
				stop();
				INSTANCES[_sequence.id].push(this);
				_used = false;
			}
		}
	}
}
