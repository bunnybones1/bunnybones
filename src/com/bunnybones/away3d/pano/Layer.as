package com.bunnybones.away3d.pano 
{
	import away3d.core.raycast.MouseHitMethod;
	import away3d.entities.Mesh;
	import away3d.materials.TextureMaterial;
	import away3d.primitives.SphereGeometry;
	import away3d.textures.BitmapTexture;
	import away3d.tools.helpers.MeshHelper;
	import com.bunnybones.away3d.pano.Layer;
	import com.bunnybones.panoPainter.model.PanoramaLayerModel;
	import com.greensock.TweenLite;
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	import flash.geom.Point;
	/**
	 * ...
	 * @author Tomasz Dysinski
	 */
	public class Layer extends Mesh 
	{
		static public const WIDTH:int= 2048;
		static public const HEIGHT:int= 1024;
		
		public var texture:BitmapTexture;
		private var sphereGeometry:SphereGeometry;
		private var blink:Boolean;
		private var sphereMaterial:TextureMaterial;
		public var drawable:Boolean;
		public var model:PanoramaLayerModel;
		public function Layer(model:PanoramaLayerModel = null, source:BitmapData = null, name:String = "new layer", flip:Boolean = true, blink:Boolean = false, drawable:Boolean = false) 
		{
			this.model = model || new PanoramaLayerModel();
			this.drawable = drawable;
			this.blink = blink;
			var sphereBitmapData:BitmapData;
			if (source)
			{
				var m:Matrix = new Matrix();
				if (flip)
				{
					m.scale(-1, 1);
					m.translate(source.width, 0);
				}
				sphereBitmapData = new BitmapData(source.width, source.height, true, 0x0000ffff);
				sphereBitmapData.draw(source, m);
			}
			else
			{
				sphereBitmapData = new BitmapData(WIDTH, HEIGHT, true, 0x0000ffff);
			}
			texture = new BitmapTexture(sphereBitmapData);
			sphereMaterial = new TextureMaterial(texture);
			//sphereMaterial.bothSides = true;
			sphereMaterial.alphaBlending = true;
			sphereGeometry = new SphereGeometry(500, 64, 32);
			super(sphereGeometry, sphereMaterial);
			MeshHelper.invertFaces(this);
			mouseHitMethod = MouseHitMethod.MESH_CLOSEST_HIT;
			this.name = name;
			if (blink)
			{
				sphereMaterial.alpha = 0;
				fadeIn();
			}
		}
		
		public function sampleAtUV(uv:Point):uint
		{
			var bmd:BitmapData = texture.bitmapData;
			return bmd.getPixel32(uv.x * bmd.width, uv.y * bmd.height);
		}
		
		private function fadeIn():void 
		{
			TweenLite.to(sphereMaterial, 1, { alpha:1, delay:2, onComplete:fadeOut} );
		}
		
		private function fadeOut():void 
		{
			TweenLite.to(sphereMaterial, 1, { alpha:0, onComplete:fadeIn} );
		}
	}

}