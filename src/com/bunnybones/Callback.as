package com.bunnybones 
{
	/**
	 * ...
	 * @author Tomasz Dysinski
	 */
	public class Callback 
	{
		private var object:Object;
		private var property:String;
		
		public function Callback(object:Object, property:String) 
		{
			this.property = property;
			this.object = object;
		}
		
		public function getValue():Object
		{
			return object[property];
		}
		
		public function setValue(value:Object):void 
		{
			object[property] = value;
		}
		
		
	}

}