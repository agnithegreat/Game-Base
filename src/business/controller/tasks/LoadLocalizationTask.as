package business.controller.tasks {
	import business.controller.tasks.LoadXMLTask;

	/**
	 * @author virich
	 */
	public class LoadLocalizationTask extends LoadXMLTask {
		
		public function LoadLocalizationTask($url: String, $callback : Function) {
			super($url, $callback);
		}
	}
}
