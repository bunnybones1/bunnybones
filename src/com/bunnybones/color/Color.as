package com.bunnybones.color 
{
	/**
	 * ...
	 * @author Tomasz Dysinski
	 */
	public class Color
	{
		private var _r:int;
		private var _g:int;
		private var _b:int;
		private var _a:int;
		private var safe:Boolean;
		
		public function Color(hex:uint, useAlpha:Boolean = false, safe:Boolean = true) 
		{
			this.safe = safe;
			_a = useAlpha ? (hex >> 24) & 0xFF : 255;
			_r = (hex >> 16) & 0xFF;
			_g = (hex >> 8) & 0xFF;
			_b = hex & 0xFF;
		}
		
		public function scale(value:Number):Color 
		{
			_r *= value;
			_g *= value;
			_b *= value;
			return this;
		}
		
		public function clone():Color 
		{
			return new Color(hexARGB, true, safe);
		}
		
		public function blend(other:Color, amt:Number, useOtherAlpha:Boolean = false):Color 
		{
			if (useOtherAlpha) amt *= other.alpha;
			var amtInv:Number = 1 - amt;
			_r = _r * amtInv + other.r * amt;
			_g = _g * amtInv + other.g * amt;
			_b = _b * amtInv + other.b * amt;
			return this;
		}
		
		public function get a():int 
		{
			return _a;
		}
		public function get r():int
		{
			return _r;
		}
		public function get g():int
		{
			return _g;
		}
		public function get b():int
		{
			return _b;
		}
		
		public function set a(value:int):void 
		{
			if(safe) _a = Math.max(0, Math.min(255, value));
			else _a = value;
		}
		public function set r(value:int):void
		{
			if(safe) _r = Math.max(0, Math.min(255, value));
			else _r = value;
		}
		public function set g(value:int):void
		{
			if(safe) _g = Math.max(0, Math.min(255, value));
			else _g = value;
		}
		public function set b(value:int):void
		{
			if(safe) _b = Math.max(0, Math.min(255, value));
			else _b = value;
		}
		
		public function get hexARGB():uint
		{
			return ( uint(a) << 24 ) | ( uint(r) << 16 ) | ( uint(g) << 8 ) | uint(b) ;
		}
		
		public function get hexRGB():uint
		{
			return ( uint(r) << 16 ) | ( uint(g) << 8 ) | uint(b) ;
		}
		
		public function get alpha():Number 
		{
			return _a / 255;
		}
		
		public function set alpha(value:Number):void 
		{
			_a = value * 255;
		}
		
		static public function fromRGBFloat(r:Number, g:Number, b:Number):Color
		{
			var color:Color = new Color(0);
			color.r = Math.max(0, Math.min(1, r)) * 255;
			color.g = Math.max(0, Math.min(1, g)) * 255;
			color.b = Math.max(0, Math.min(1, b)) * 255;
			return color;
		}
		
		public function toString():String
		{
			var str:String = "[Color hex:%HEX, A:%A, R:%R, G:%G, B:%B]";
			str = str.replace("%HEX", hexARGB.toString(16));
			str = str.replace("%A", a);
			str = str.replace("%R", r);
			str = str.replace("%G", g);
			str = str.replace("%B", b);
			return str;
		}
	}

}