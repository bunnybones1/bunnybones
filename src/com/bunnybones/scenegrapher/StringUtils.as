package com.bunnybones.scenegrapher 
{
	/**
	 * ...
	 * @author Tomasz Dysinski
	 */
	public class StringUtils 
	{
		
		public function StringUtils() 
		{
			
		}
		
		static public function replaceAll(string:String, find:String, replacement:String):String
		{
			while (string.indexOf(find) != -1) string = string.replace(find, replacement);
			return string;
		}
		
		
		static public function nameToFileName(str:String):String 
		{
			str = replaceAll(str, " ", "_");
			str = replaceAll(str, "'", "");
			str = str.toLowerCase();
			return str;
		}
		
		static public function nameToTransitionName(str:String):String
		{
			str = nameToFileName(str);
			str = replaceAll(str, "_to_", "-to-");
			return str;
		}
		
		static public function nameToActionName(str:String):String 
		{
			str = nameToTransitionName(str);
			str = replaceAll(str, "-to-", "-action-");
			return str;
		}
		
	}

}