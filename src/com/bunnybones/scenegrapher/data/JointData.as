package com.bunnybones.scenegrapher.data 
{
	import com.jam3media.xml.Data;
	
	/**
	 * ...
	 * @author Tomasz Dysinski
	 */
	public class JointData extends Data 
	{
		
		public function JointData(tagName:String="joint") 
		{
			super(tagName);
			
		}
		
		static public function fromXML(xml:XML):JointData
		{
			var data:JointData = new JointData();
			data.parseXML(xml);
			return data;
		}
	}

}