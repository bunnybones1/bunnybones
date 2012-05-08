package com.bunnybones.away3d
{
	import flash.display3D.Context3DBlendFactor;
	public class GLBlendmodePresets
	{
		private static var _blendFactors:Vector.<String> = null;
		
		public function GLBlendmodePresets()
		{
		}
		
		public static function random():Array
		{
			var src:String = blendFactors[int(Math.random() * blendFactors.length)];
			var dst:String = blendFactors[int(Math.random() * blendFactors.length)];
			return new Array(src, dst);
		}
		
		public static function indexed(index:int):Array
		{
			var totalBlendModes:int = blendFactors.length * blendFactors.length;
			index %= totalBlendModes;
			index += totalBlendModes;
			index %= totalBlendModes;
			var index_src:int = (index / blendFactors.length) % blendFactors.length;
			var index_dst:int = index % blendFactors.length;
			var src:String = blendFactors[index_src];
			var dst:String = blendFactors[index_dst];
			//trace(index_src);
			//trace(index_dst);
			return new Array(src, dst);
		}
		
		static public function indexOf(name:String):int 
		{
			for (var i:int = 0; i < blendFactors.length; i++)
			{
				if (_blendFactors[i] == name) return i;
			}
			return -1;
		}
		
		public static function get blendFactors():Vector.<String>
		{
			if(!_blendFactors)
			{
				_blendFactors = new Vector.<String>;
				_blendFactors.push(Context3DBlendFactor.DESTINATION_ALPHA);
				_blendFactors.push(Context3DBlendFactor.DESTINATION_COLOR);
				_blendFactors.push(Context3DBlendFactor.ONE);
				_blendFactors.push(Context3DBlendFactor.ONE_MINUS_DESTINATION_ALPHA);
				_blendFactors.push(Context3DBlendFactor.ONE_MINUS_DESTINATION_COLOR);
				_blendFactors.push(Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA);
				_blendFactors.push(Context3DBlendFactor.ONE_MINUS_SOURCE_COLOR);
				_blendFactors.push(Context3DBlendFactor.SOURCE_ALPHA);
				_blendFactors.push(Context3DBlendFactor.SOURCE_COLOR);
				_blendFactors.push(Context3DBlendFactor.ZERO);
			}
			return _blendFactors;
		}
		
	}
}