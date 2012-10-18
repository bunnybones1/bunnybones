package com.bunnybones.scenegrapher.data 
{
	import com.bunnybones.scenegrapher.CircleHandle;
	import com.bunnybones.scenegrapher.ContentType;
	import com.jam3media.xml.Data;
	import flash.utils.getQualifiedClassName;
	/**
	 * ...
	 * @author Tomasz Dysinski
	 */
	public class BodyData extends Data 
	{
		static public const COLORLINE:uint = 0xff0000;
		static public const COLORFILL:uint = 0x00ff00;
		static public const X:Number = 0;
		static public const Y:Number = 0;
		static public const ANGLE:Number = 0;
		static public const LINEARDAMPING:Number = 1;
		static public const TYPE:int = 2;
		static public const CONTENTTYPE:String = ContentType.UNKNOWN;
		static public const USERDATACLASSNAME:String = getQualifiedClassName(new CircleHandle(null));
		
		public var colorLine:uint;
		public var colorFill:uint;
		public var x:Number;
		public var y:Number;
		public var angle:Number;
		public var linearDamping:Number;
		public var type:int;
		public var contentType:String;
		public var userDataClassName:String;
		
		public function BodyData(tagName:String="body") 
		{
			super(tagName);
			colorLine
		}
		
		static public function fromXML(xml:XML):BodyData
		{
			var data:BodyData = new BodyData();
			data.parseXML(xml);
			return data;
		}
	}

}