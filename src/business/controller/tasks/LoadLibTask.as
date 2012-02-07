package business.controller.tasks {
	import com.adobe.serialization.json.JSON;
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;

	/**
	 * @author virich
	 */
	public class LoadLibTask extends Task {
		
		private var _libURL: String;
		private var _callback: Function;
		
		private var _request: URLRequest;
		private var _loader: URLLoader;
		
		public function LoadLibTask($url: String, $callback: Function) {
			_callback = $callback;
			
			if (!$url) {
				return;
			}
			
			_libURL = $url.search("http")!=-1 ? $url : Settings.server_url+"/libs/json/"+$url;
			
			_request = new URLRequest(_libURL+"?"+new Date().time);
			_loader = new URLLoader();
			_loader.addEventListener(Event.COMPLETE, handleComplete);
		}
		
		override public function run():void {
			if (_loader) {
				_loader.load(_request);
			} else {
				_callback(null);
				complete();
			}
		}

		private function handleComplete(e: Event) : void {
			_loader.removeEventListener(Event.COMPLETE, handleComplete);
			var data: Object = JSON.decode((e.currentTarget as URLLoader).data);
			_callback(data);
			
			complete();
		}
	}
}
