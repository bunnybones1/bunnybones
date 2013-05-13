package com.bunnybones.model 
{
	/**
	 * ...
	 * @author Tomasz Dysinski
	 */
	public class ModelSelecter 
	{
		static public var data:Model;
		
		public function ModelSelecter() 
		{
		}
		
		static public function select(data:Model):void 
		{
			ModelSelecter.data = data;
		}
		
	}

}