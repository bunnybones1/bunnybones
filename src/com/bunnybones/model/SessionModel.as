package com.bunnybones.model 
{
	/**
	 * ...
	 * @author Tomasz Dysinski
	 */
	public class SessionModel extends NetModel 
	{
		static public const SETTINGSFILENAME:String = "settings.xml";
		public var settingsFileName:String;
		public function SessionModel(tagName:String=null) 
		{
			super(tagName);
		}
		
	}

}