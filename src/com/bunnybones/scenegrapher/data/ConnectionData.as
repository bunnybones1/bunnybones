package com.bunnybones.scenegrapher.data 
{
	import com.jam3media.xml.Data;
	
	/**
	 * ...
	 * @author Tomasz Dysinski
	 */
	public class ConnectionData extends Data 
	{
		
		public function ConnectionData() 
		{
			
		}
		
		static public function fromXML(xml:XML):ConnectionData
		{
			var data:ConnectionData = new ConnectionData();
			data.parseXML(xml);
			return data;
		}
		
	}

}