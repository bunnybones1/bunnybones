package com.bunnybones.away3d.pano 
{
	import away3d.cameras.Camera3D;
	import away3d.containers.ObjectContainer3D;
	
	/**
	 * ...
	 * @author Tomasz Dysinski
	 */
	public class ParalaxPanoCamera extends ObjectContainer3D 
	{
		public var camera:Camera3D;
		
		public function ParalaxPanoCamera(camera:Camera3D = null) 
		{
			this.camera = camera;
			if (camera)
			{
				addChild(camera);
				camera.z = 10;
				//camera.x = 80;
			}
		}
		
	}

}