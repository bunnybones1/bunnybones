package com.bunnybones.model.examples 
{
	import com.bunnybones.model.Model;
	/**
	 * ...
	 * @author Tomasz Dysinski
	 */
	public class DemoLeafModel extends Model 
	{
		
		static public const COLOR:String = "BROWN";
		public var color:String;
		
		public function DemoLeafModel() 
		{
			
		}
		
		static public function fromXML(xml:XML):DemoLeafModel 
		{
			var model:DemoLeafModel = new DemoLeafModel();
			model.parseXML(xml);
			return model;
		}
		
	}

}