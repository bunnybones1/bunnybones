package com.bunnybones.panoPainter 
{
	import away3d.core.base.Object3D;
	import com.jam3media.xml.NetData;
	
	/**
	 * ...
	 * @author Tomasz Dysinski
	 */
	public class PanoramaData extends NetData 
	{
		
		public function PanoramaData() 
		{
			scene = new Vector.<Object3D>;
		}
		
	}

}