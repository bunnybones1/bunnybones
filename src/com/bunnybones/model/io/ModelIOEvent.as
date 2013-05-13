package com.bunnybones.model.io 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Tomasz Dysinski
	 */
	public class ModelIOEvent extends Event 
	{
		static public const MODEL_READY:String = "modelReady";
		static public const LOAD_COMPLETE:String = "loadComplete";
		static public const IO_ERROR:String = "ioError";
		
		public function ModelIOEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) 
		{
			super(type, bubbles, cancelable);
		}
		
	}

}