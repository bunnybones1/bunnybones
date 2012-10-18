package com.bunnybones.scenegrapher 
{
	import com.jam3.mars.floorSim.MaRSConnection;
	/**
	 * ...
	 * @author Tomasz Dysinski
	 */
	public class GlobalSettings 
	{
		public var defaultCircleHandleClass:Class = LabelledCircleHandle;
		public var defaultConnectionClass:Class = Connection;
		public var defaultConnectionSecondaryClass:Class = ConnectionLoop;
		public var mouseTools:Array = new Array();
		static private var _instance:GlobalSettings;
		
		public function GlobalSettings() 
		{
			
		}
		
		static public function get instance():GlobalSettings 
		{
			if (!_instance) _instance = new GlobalSettings();
			return _instance;
		}
		
	}

}