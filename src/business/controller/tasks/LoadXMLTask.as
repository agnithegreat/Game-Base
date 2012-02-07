package business.controller.tasks {
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import business.controller.tasks.Task;

	/**
	 * @author virich
	 */
	public class LoadXMLTask extends Task {
		
		private var _xmlURL: String;
		private var _callback: Function;
		
		private var _request: URLRequest;
		private var _loader: URLLoader;
		
		public function LoadXMLTask($url: String, $callback: Function) {
			_xmlURL = $url.search("http")!=-1 ? $url : Settings.server_url+$url;
			_callback = $callback;
			
			_request = new URLRequest(_xmlURL);
			_loader = new URLLoader();
			_loader.addEventListener(Event.COMPLETE, handleComplete);
		}
		
		override public function run():void {
			_loader.load(_request);
		}

		private function handleComplete(e: Event) : void {
			_loader.removeEventListener(Event.COMPLETE, handleComplete);
			var data: XML = XML(e.target.data);
			_callback(data);
			
			complete();
		}
	}
}
