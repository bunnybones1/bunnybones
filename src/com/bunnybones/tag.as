package com.bunnybones 
{
	/**
	 * ...
	 * @author Tomasz Dysinski
	 */
	public function tag(...rest):String
	{
		try
		{
			throw new Error("tag");
		}
		catch (e:Error)
		{
			var lines:Array = e.getStackTrace().split("\n");
			var line:String = lines[2];
			var importantPart:String = line.substring(line.lastIndexOf("\\") + 1, line.length-1);
			var str:String = "[" + importantPart + "] " + rest;
			trace(str);
			return str;
		}
		return "internal error: check tag";
	}
}