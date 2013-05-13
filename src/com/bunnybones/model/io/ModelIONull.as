package com.bunnybones.model.io 
{
	import flash.events.EventDispatcher;
	/**
	 * ...
	 * @author Tomasz Dysinski
	 */
	public class ModelIONull extends EventDispatcher implements IModelIO
	{
		
		public function ModelIONull() 
		{
			throw new Error("You didn't set the IO. For instance, for NetModel, io is a public static reference. It must be set to a valid ModelIO class before use.");
		}
		
		/* INTERFACE com.jam3media.xml.io.IModelIO */
		
		public function init(url:String):void 
		{
			
		}
		
		public function save(model:XML, url:String = null):void 
		{
			
		}
		
		public function load(url:String = null):void 
		{
			
		}
		
		public function get data():* 
		{
			return null;
		}
		
	}

}