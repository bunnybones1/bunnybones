package com.bunnybones.model.io 
{
	import flash.events.IEventDispatcher;
	
	/**
	 * ...
	 * @author Tomasz Dysinski
	 */
	public interface IModelIO extends IEventDispatcher
	{
		function save(model:XML, url:String = null):void;
		function load(url:String = null):void;
		function get data():*;
	}
	
}