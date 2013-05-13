package com.bunnybones.model.examples 
{
	import com.bunnybones.model.NetModel;
	/**
	 * ...
	 * @author Tomasz Dysinski
	 */
	public class DemoModel extends NetModel
	{
		static public const COLOR:String = "BROWN";
		public var color:String;
		public var leaves:Vector.<DemoLeafModel>;
		public function DemoModel() 
		{
			super();
			leaves = new Vector.<DemoLeafModel>;
		}
		
		override public function parseXML(xml:XML):void
		{
			super.parseXML(xml);
			for each(var demoLeafModelXML:XML in xml.DemoLeafModel)
			{
				addLeafModel(DemoLeafModel.fromXML(demoLeafModelXML));
			}
		}
		
		public function addLeafModel(leafModel:DemoLeafModel):void 
		{
			leaves.push(leafModel);
		}
		
		static public function fromXML(xml:XML):DemoModel 
		{
			var model:DemoModel = new DemoModel();
			model.parseXML(xml);
			return model;
		}
		
	}

}