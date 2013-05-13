package com.bunnybones.scenegrapher 
{
	import com.bunnybones.scenegrapher.tools.MouseToolNewCircle;
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
		static public const PERSON_ALPHA:Number = 0;
		static private var _instance:GlobalSettings;
		
		public function GlobalSettings() 
		{
			mouseTools.push(MouseToolNewCircle);
		}
		
		static public function get instance():GlobalSettings 
		{
			if (!_instance) _instance = new GlobalSettings();
			return _instance;
		}
		
	}

}