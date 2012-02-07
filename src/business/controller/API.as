package business.controller {
	import business.controller.windows.Window;
	import business.controller.windows.WindowManager;
	import business.event.APIEvent;
	import com.adobe.crypto.MD5;
	import com.adobe.serialization.json.JSON;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.TimerEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.utils.Timer;
	
	/**
	 * @author virich
	 */
	public class API extends EventDispatcher {
		
		private static var count: int = 0;
		
		private var _stack: Array;
		private var _processing: Boolean;
		private var _method: String;
		
		private static var _instance : API;
		private static var _allowInstantiation : Boolean = false;

		public function get processing():Boolean {
			return _processing;
		}
		
		private var _timer: Timer;
		
		private var _urlLoader: URLLoader;

		public function API() {
			if (!_allowInstantiation) {
				throw new Error("Can't instantiate API class using new API(). Try API.getInstance().");
			}

			_stack = [];
			_processing = false;
			
			_timer = new Timer(45000, 1);
			_timer.addEventListener(TimerEvent.TIMER, handlePingTimeout);
		}
		
		public static function getInstance():API {
			if (!_instance) {
				_allowInstantiation = true;
				_instance = new API();
				_allowInstantiation = false;
			}
			return _instance;
		}
		
		
		public function sendRequest($method : String, $data: Object, $uid: String, $sn: String) : void {
			var request: URLRequest = new URLRequest(Settings.server_url+"/?n="+$uid+"_"+ (++count));
			var variables : URLVariables = new URLVariables();
			if (!$data) {
				$data = {};
			}
			$data.auth = {};
			$data.auth.uid = $uid;
			$data.auth.sn = $sn;
			$data.auth.sig = generateSig($data);
			variables["request"] = JSON.encode($data);
			request.data = variables;
			request.method = URLRequestMethod.POST;

			_stack.push([$method, request]);
			if (!_processing) {
				_method = $method;
				send(request);
			}
		}

		private function send(request : URLRequest, dataFormat: String = null):void {
			_processing = true;
			if (!_urlLoader) {
				_urlLoader = new URLLoader();
				_urlLoader.addEventListener(Event.COMPLETE, handleComplete);
				_urlLoader.addEventListener(IOErrorEvent.IO_ERROR, handleError);
			}
			if (dataFormat) {
				_urlLoader.dataFormat = dataFormat;
			}
			_urlLoader.load(request);
			
			_timer.start();
		}
		
		private function handlePingTimeout(e : TimerEvent) : void {
			trace(_method);
			dispatchEvent(new APIEvent(APIEvent.ERROR, _method));
		}

		private function handleError(e: IOErrorEvent) : void {
			trace(_method, e.text);
			dispatchEvent(new APIEvent(APIEvent.ERROR, _method));
		}

		private function handleComplete(e : Event):void {
			_timer.stop();
			
			trace(_method, _urlLoader.data);
			
			if (!_urlLoader.data) {
				dispatchEvent(new APIEvent(APIEvent.ERROR, _method, "Empty response"));
				return;
			}
			var response : Object = JSON.decode(_urlLoader.data);
			
			dispatchEvent(new APIEvent(APIEvent.DATA_RECIEVED, _method, response));
			
			_processing = false;
			_stack.shift();
			var reqest: Array = _stack[0];
			if (reqest) {
				_method = reqest[0];
				var df: String = reqest.length==3 ? reqest[2] : null;
				send(reqest[1], df);
			}
		}

		private function generateSig($object: Object):String {
			var key: String = getObjectSig($object);
			key = key.concat(Settings.server_key);
			return MD5.hash(key);
		}
		
		private function getObjectSig($object: Object, $isArray: Boolean = false):String {
			var key: String = "";
			var keys: Array = [];
			for (var k : * in $object) {
				keys.push(k);
			}
			var numeric: Boolean = true;
			for (var i : int = 0; i < keys.length; i++) {
				if (!(keys[i] is int)) {
					numeric = false;
					break;
				}
			}
			if (numeric) {
				keys.sort(Array.NUMERIC);
			} else {
				keys.sort();
			}
			for (i = 0; i < keys.length; i++) {
				var id: String = $isArray ? String(i) : keys[i];
				if ($object[keys[i]] is Number || $object[keys[i]] is String) {
					key = key.concat(id+"="+$object[keys[i]]);
				} else if ($object[keys[i]] is Array) {
					key = key.concat(id+"="+getObjectSig($object[keys[i]], true));
				} else {
					key = key.concat(id+"="+getObjectSig($object[keys[i]]));
				}
			}
			return key;
		}
	}
}
