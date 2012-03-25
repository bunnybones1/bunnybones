package com.bunnybones.console 
{
	/**
	 * ...
	 * @author Tomasz Dysinski
	 */
	public class ObjectReference 
	{
		private var name:String;
		
		public function ObjectReference(name:String) 
		{
			this.name = name;
			
		}
		
		public function resolve(from:Object):Object 
		{
			return from[name];
		}
		
	}

}