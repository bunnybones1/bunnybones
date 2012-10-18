package com.bunnybones.scenegrapher.data 
{
	import com.jam3media.xml.Data;
	
	/**
	 * ...
	 * @author Tomasz Dysinski
	 */
	public class HandleData extends Data 
	{
		
		public function HandleData() 
		{
			
		}
		
		static public function fromXML(xml:XML):HandleData
		{
			var data:HandleData = new HandleData();
			data.parseXML(xml);
			return data;
		}
		
	}

}