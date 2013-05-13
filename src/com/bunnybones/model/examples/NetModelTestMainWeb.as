package com.bunnybones.model.examples 
{
	import com.bunnybones.console.Console;
	import com.bunnybones.model.io.ModelIOAir;
	import com.bunnybones.model.io.ModelIOPHP;
	import com.bunnybones.model.NetModel;
	/**
	 * ...
	 * @author Tomasz Dysinski
	 */
	public class NetModelTestMainWeb extends NetModelTestMain 
	{
		
		public function NetModelTestMainWeb() 
		{
			NetModel.ioClass = ModelIOPHP;
			super();
		}
		
	}

}