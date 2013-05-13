package com.bunnybones.model 
{
	/**
	 * ...
	 * @author Tomasz Dysinski
	 */
	public class DisplayObjectModel extends Model 
	{
		
		static public const FULLCLASSNAME:String = "flash.display::Sprite";
		static public const NAME:String = "DisplayObject";
		static public const X:Number = 0;
		static public const Y:Number = 0;
		public var fullClassName:String;
		public var x:Number;
		public var y:Number;
		public function DisplayObjectModel() 
		{
			super();
		}
		
		static public function fromXML(xml:XML):DisplayObjectModel 
		{
			var model:DisplayObjectModel = new DisplayObjectModel();
			model.parseXML(xml);
			return model;
		}
		
		override public function composeXML(omitDefaults:Boolean = true):XML 
		{
			x = Math.round(x);
			y = Math.round(y);
			return super.composeXML(omitDefaults);
		}
	}

}