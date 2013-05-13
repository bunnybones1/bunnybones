package com.bunnybones.model.examples 
{
	import com.bunnybones.model.io.ModelIOAir;
	import com.bunnybones.model.NetModel;
	/**
	 * ...
	 * @author Tomasz Dysinski
	 */
	public class NetModelTestMainAir extends NetModelTestMain 
	{
		
		public function NetModelTestMainAir() 
		{
			NetModel.ioClass = ModelIOAir;
			super();
		}
		
	}

}