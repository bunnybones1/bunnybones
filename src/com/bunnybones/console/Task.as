package com.bunnybones.console 
{
	/**
	 * ...
	 * @author Tomasz Dysinski
	 */
	public class Task 
	{
		private var methodName:String;
		private var args:Array;
		static public const STRINGHUNTER:String = "stringhunter";
		static public const ARGUMENTHUNTER:String = "argumenthunter";
		public function Task(methodName:String, args:Array)
		{
			this.args = args;
			this.methodName = methodName;
		}
		
		public function execute(from:Object):Object
		{
			var method:Function = from[methodName];
			var executedArgs:Array = new Array();
			for (var i:int = 0; i < args.length; i++) 
			{
				if (args[i] is Task) executedArgs[i] = (args[i] as Task).execute(from);
				else if (args[i] is ObjectReference) executedArgs[i] = (args[i] as ObjectReference).resolve(from);
				else executedArgs[i] = args[i];
			} 
			return method.apply(from, executedArgs);
		}
		
		static public function parse(input:String):Object
		{
			var object:Object = null;
			object = detectTask(input);
			if (!object) object = detectObject(input);
			if (!object) object = detectNumber(input);
			if (!object) object = detectString(input);
			dtrace(input, "became", object);
			return object
		}
		
		static private function detectString(input:String):String 
		{
			if(input.charAt(0) == "\"" && input.charAt(input.length-1) == "\"") return input.substring(1, input.length-1);
			return null;
		}
		
		static private function detectNumber(input:String):Number 
		{
			var index:int = 0;
			var validChars:String = "0123456789.+-*/";
			for (var i:int = 0; i < input.length; i++) 
			{
				if (validChars.indexOf(input.charAt(i)) == -1) return null;
			}
			return Number(input);
		}
		
		static private function detectObject(input:String):ObjectReference
		{
			if (input.indexOf("\"") == -1) return new ObjectReference(input);
			return null;
		}
		
		static public function detectTask(input:String):Task
		{
			dtrace(input);
			var index:int = 0;
			var mode:String;
			var indexIn:int;
			var indexOut:int;
			var bracketDepth:int = 0;
			//detect method
			var isTask:Boolean = false;
			while (index < input.length)
			{
				switch(input.charAt(index))
				{
					case "(":
						if (!mode)
						{
							mode = ARGUMENTHUNTER;
							indexIn = index;
						}
						else if (mode == ARGUMENTHUNTER)
						{
							bracketDepth++;
						}
						break;
					case ")":
						if (mode == ARGUMENTHUNTER)
						{
							if (bracketDepth > 0)
							{
								bracketDepth--;
							}
							else
							{
								mode = null;
								indexOut = index;
								isTask = true;
							}
						}
						break;
				}
				index++;
			}
			
			if (isTask)
			{
				var methodName:String = input.substring(0, indexIn);
				var args:Array = new Array();
				var argsString:String = input.substring(indexIn + 1, indexOut);
				index = 0;
				mode = null;
				indexIn = 0;
				indexOut = 0;
				if (argsString.length > 0)
				{
					while (index < argsString.length)
					{
						switch(argsString.charAt(index))
						{
							case ",":
								if (!mode)
								{
									dtrace("!");
									args.push(parse(trim(argsString.substring(indexIn, index))));
									indexIn = index + 1;
								}
								break;
							case "(":
								if (!mode)
								{
									mode = ARGUMENTHUNTER;
								}
								else if (mode == ARGUMENTHUNTER)
								{
									bracketDepth++;
								}
								break;
							case ")":
								if (mode == ARGUMENTHUNTER)
								{
									if (bracketDepth > 0)
									{
										bracketDepth--;
									}
									else
									{
										mode = null;
										isTask = true;
									}
								}
								break;
						}
						index++;
					}
					args.push(parse(trim(argsString.substring(indexIn, index))));
					dtrace(methodName);
					dtrace(argsString);
					for each (var arg:String in args) 
					{
						dtrace(arg);
					}
				}
				return new Task(methodName, args);
			}
			return null;
		}
		
		static private function trim(string:String):String 
		{
			if (string.charAt(0) == " ") return string.substring(1, string.length);
			return string;
		}
		
	}
	

}