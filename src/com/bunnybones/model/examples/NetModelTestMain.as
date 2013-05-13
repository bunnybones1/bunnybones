package com.bunnybones.model.examples 
{
	import com.bunnybones.model.io.ModelIOAir;
	/**
	 * ...
	 * @author Tomasz Dysinski
	 */
	public class NetModelTestMain extends ModelTestMain 
	{
		
		public function NetModelTestMain() 
		{
			super();
		}
		
		override public function generateModel():void 
		{
			var model:DemoModel = new DemoModel();
			model.color = "red";
			model.addLeafModel(new DemoLeafModel());
			model.addLeafModel(new DemoLeafModel());
			model.addLeafModel(new DemoLeafModel());
			model.init("userModel/session.xml");
		}
		
	}

}