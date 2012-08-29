package com.bunnybones.away3d.renderers 
{
	import com.as3nui.nativeExtensions.air.kinect.events.CameraImageEvent;
	import com.bunnybones.away3d.kinect.KinectCurtainBuffer;
	import flash.display.BitmapData;
	import flash.display3D.textures.TextureBase;
	import away3d.core.render.DefaultRenderer;
	import away3d.core.traverse.EntityCollector;
	import away3d.containers.View3D;
	import com.bunnybones.aruco.ARucoANE;
	import com.bunnybones.away3d.renderers.KinectOcclusionRenderer;
	import com.bunnybones.kinect.KinectModule;
	import flash.desktop.NativeApplication;
	import flash.events.Event;
	import flash.geom.Matrix3D;
	import flash.geom.Orientation3D;
	import flash.geom.Vector3D;
	/**
	
	/**
	 * ...
	 * @author Tomasz Dysinski
	 */
	public class KinectOcclusionRenderer extends DefaultRenderer 
	{
		
		private var _kinectModule:KinectModule;
		private var kinectCurtainBuffer:KinectCurtainBuffer;
		private var freshestDepthMap:BitmapData;
		public function KinectOcclusionRenderer() 
		{
			super();
			_kinectModule = new KinectModule();
			readyTheKinectCurtain();
		}
		
		private function readyTheKinectCurtain():void 
		{
			kinectCurtainBuffer = new KinectCurtainBuffer();
			_kinectModule.addEventListener(CameraImageEvent.DEPTH_IMAGE_UPDATE, onKinectDepthMap);
		}
		
		private function onKinectDepthMap(e:CameraImageEvent):void 
		{
			freshestDepthMap = e.imageData;
		}
		
		override protected function draw(entityCollector:EntityCollector, target:TextureBase):void 
		{
			kinectCurtainBuffer.render(_stage3DProxy.context3D);
			
			_stage3DProxy..setTextureAt(0, null);
			_stage3DProxy.setTextureAt(1, null);
			_stage3DProxy.setTextureAt(2, null);

			super.draw(entityCollector, target);
			
			_stage3DProxy.setTextureAt(0, null);
			_stage3DProxy.setTextureAt(1, null);
			_stage3DProxy.setTextureAt(2, null);
			
			if (freshestDepthMap)
			{
				kinectCurtainBuffer.update(_stage3DProxy.context3D, freshestDepthMap);
			}
		}
		
		public function get kinectModule():KinectModule 
		{
			return _kinectModule;
		}
	}

}