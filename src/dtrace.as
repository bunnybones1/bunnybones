package 
{
	import com.bunnybones.console.Console;
	/**
	 * ...
	 * @author Tomasz Dysinski
	 */
	public function dtrace(...rest):String
	{
		try
		{
			throw new Error("tag");
		}
		catch (e:Error)
		{
			try
			{
				var lines:Array = e.getStackTrace().split("\n");
				var line:String = lines[2];
				var importantPart:String = line.substring(line.lastIndexOf("\\") + 1, line.length-1);
				var str:String = "[" + importantPart + "] " + rest;
				trace(str);
				if (Console.singleton)
				{
					Console.singleton.addLine(str);
				}
				return str;
			}
			catch (e2:Error)
			{
				//oh alright, forget it then!
				if (Console.singleton) Console.singleton.print(rest);
			}
		}
		return "internal error: check dtrace";
	}
}