package com.bunnybones.away3d.pano 
{
	import com.bunnybones.Dialog;
	import com.bunnybones.DialogArg;
	import flash.display.BitmapData;
	import flash.utils.describeType;
	import flash.utils.getDefinitionByName;
	/**
	 * ...
	 * @author Tomasz Dysinski
	 */
	public class LayerMaker 
	{
		static private var args:Array;
		static private var types:Vector.<Class>;
		static private var index:int;
		static private var target:Object;
		static private var property:String;
		public function LayerMaker():void
		{
		}
		static public function visit(target:Object, property:String):void
		{
			if (LayerMaker.target) return;
			LayerMaker.property = property;
			LayerMaker.target = target;
			args = new Array();
			types = new Vector.<Class>;
			index = 0;
			var description:XML = describeType(target);
			for each(var method:XML in description.method)
			{
				if (method.@name == property)
				{
					//trace(method);
					for each(var parameter:XML in method.parameter)
					{
						var type:Class = getDefinitionByName(parameter.@type) as Class;
						types.push(type);
						//trace(parameter.@index, parameter.@name, type);
					}
				}
			}
			new DialogArg(collect, types[0]);
		}
		
		static public function collect(input:Object):void
		{
			//trace("collected");
			var success:Boolean = true;
			switch(types[index])
			{
				case String:
					if (input == null) success = false;
					else args.push(String(input));
					break;
				case Number:
					args.push(Number(input));
					break;
				case int:
					args.push(int(input));
					break;
				default:
					args.push(null);
			}
			if(success)	index++;
			if (index < types.length) new DialogArg(collect, types[index]);
			else
			{
				(target[property] as Function).apply(target, args);
				target = null;
			}
		}
		
	}

}