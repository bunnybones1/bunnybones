package com.bunnybones.model.io 
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	
	/**
	 * ...
	 * @author Tomasz Dysinski
	 */
	public class ModelIOPHP extends ModelIO implements IModelIO 
	{
		private var phpPath:String;
		private var initing:Boolean;
		
		public function ModelIOPHP(phpPath:String = "save_settings.php") 
		{
			this.phpPath = phpPath;
			super();
		}
		
		override public function save(model:XML, url:String = null):void
		{
			dtrace(url + " saving via " + phpPath);
			var saver : URLLoader = new URLLoader();
			var request : URLRequest = new URLRequest(phpPath);
			
			request.method = URLRequestMethod.POST;
			request.data = model.toXMLString();
			
			//  Handlers
			saver.addEventListener(Event.COMPLETE, onSaveComplete);
			saver.addEventListener(IOErrorEvent.IO_ERROR, onSaveIOError);
			saver.load(request);
		}
		
		private function onSaveIOError(e:IOErrorEvent):void 
		{
			var saver:URLLoader = e.target as URLLoader;
			deinitSaver(e.target as URLLoader);
			dtrace("3:save failed via " + phpPath);
			dispatchEvent(e);
		}
		
		private function onSaveComplete(e:Event):void
		{
			deinitSaver(e.target as URLLoader);
			dtrace("PHP save complete");
		}
		
		private function deinitSaver(saver:URLLoader):void 
		{
			saver.removeEventListener(Event.COMPLETE, onSaveComplete);
			saver.removeEventListener(IOErrorEvent.IO_ERROR, onSaveIOError);
		}
		
	}

}