package com.bunnybones.scenegrapher.data 
{
	import com.jam3media.xml.NetData;
	/**
	 * ...
	 * @author Tomasz Dysinski
	 */
	public class SceneData extends NetData
	{
		public var bodies:Vector.<HandleData> = new Vector.<HandleData>;
		public var joints:Vector.<ConnectionData> = new Vector.<ConnectionData>;
		public function SceneData() 
		{
			super("graph");
		}
		
		override public function parseXML(xml:XML):void
		{
			super.parseXML(xml);
			xml.HandleData.length;
			xml.HandleData.length();
			
			var itemXML:XML;
			for each(itemXML in xml.body) bodies.push(BodyData.fromXML(itemXML));
			for each(itemXML in xml.joint) joints.push(JointData.fromXML(itemXML));
		}
		
		static public function fromXML(xml:XML):SceneData
		{
			var data:SceneData = new SceneData();
			data.parseXML(xml);
			return data;
		}
		
	}

}