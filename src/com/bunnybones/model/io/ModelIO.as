package com.bunnybones.model.io 
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	/**
	 * ...
	 * @author Tomasz Dysinski
	 */
	public class ModelIO extends EventDispatcher implements IModelIO 
	{
		
		protected var _data:*;
		protected var url:String = null;
		
		public function ModelIO() 
		{
			
		}
		
		public function load(url:String = null):void
		{
			this.url = url;
			var loader:URLLoader = new URLLoader(new URLRequest(url));
			loader.addEventListener(IOErrorEvent.IO_ERROR, onLoadIOError);
			loader.addEventListener(Event.COMPLETE, onLoadComplete);
		}
		
		private function onLoadComplete(e:Event):void 
		{
			var loader:URLLoader = e.target as URLLoader;
			deinitLoader(loader);
			_data = loader.data;
			dispatchEvent(e);
		}
		
		protected function onLoadIOError(e:IOErrorEvent):void 
		{
			var loader:URLLoader = e.target as URLLoader;
			deinitLoader(loader);
			dispatchEvent(e);
		}
		
		private function deinitLoader(loader:URLLoader):void 
		{
			loader.removeEventListener(Event.COMPLETE, onLoadComplete);
			loader.removeEventListener(IOErrorEvent.IO_ERROR, onLoadIOError);
		}
		
		/* INTERFACE com.jam3media.xml.io.IModelIO */
		
		public function save(model:XML, url:String = null):void 
		{
			throw new Error("This is a base class that cannot save. Use the appropriate subclass (e.g. ModelIOAir or ModelIOPHP)");
		}
		
		public function get data():* 
		{
			return _data;
		}
	}

}