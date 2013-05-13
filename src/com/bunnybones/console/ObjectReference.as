package com.bunnybones.console 
{
	/**
	 * ...
	 * @author Tomasz Dysinski
	 */
	public class ObjectReference 
	{
		private var name:String;
		
		public function ObjectReference(name:String) 
		{
			this.name = name;
			
		}
		
		public function resolve(from:Object):Object 
		{
			var i:int;
			try {
				var temp:String = name.split("[").join(".").split("]").join("");
				var stack:Array = temp.split(".");
				var current:Object = from;
				for (i = 0; i < stack.length; i++) {
					var isInt:Boolean = stack[i] == String(int(stack[i]));
					if(isInt) {
						current = current[stack[int(i)]];
					} else {
						current = current[stack[i]];
					}
				}
				return current;
			}catch (e:Error) {
				return e.message;
			}
			return "unknown";
		}
		
	}

}