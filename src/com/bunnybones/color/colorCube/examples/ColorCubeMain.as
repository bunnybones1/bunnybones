package com.bunnybones.color.colorCube.examples 
{
	import away3d.cameras.Camera3D;
	import away3d.cameras.lenses.OrthographicLens;
	import away3d.containers.ObjectContainer3D;
	import away3d.containers.Scene3D;
	import away3d.containers.View3D;
	import away3d.entities.Sprite3D;
	import away3d.materials.ColorMaterial;
	import com.bunnybones.color.Color;
	import com.bunnybones.color.Color3D;
	import com.bunnybones.display.graphics.Circle;
	import com.bunnybones.display.MainSprite;
	import com.bunnybones.time.Clock;
	import flash.display.Shape;
	import flash.events.Event;
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	
	/**
	 * ...
	 * @author Tomasz Dysinski
	 */
	public class ColorCubeMain extends MainSprite 
	{
		private var view:View3D;
		private var color:Color3D;
		private var colorCube:ObjectContainer3D;
		private var camera:Camera3D;
		static private const DISTANCE_FROM_CENTER:Number = 500;
		private var spin:Boolean = true;
		private var materials:Vector.<ColorMaterial>;
		private var crossHair:CrossHair;
		private var circle:Shape;
		
		private var size:Number = 255;
		private var sizeHalf:Number = size * .5;
		private var step:Number = 16;
		
		private var voxels:Vector.<Sprite3D>;
		private var hueMatrix:Matrix3D;
		private var hueMatrixInv:Matrix3D;
		private var saturationMatrix:Matrix3D;
		private var saturationMatrixInv:Matrix3D;
		private var valueMatrix:Matrix3D;
		private var valueMatrixInv:Matrix3D;
		private var testMatrix:Matrix3D;
		private var crossSection:Boolean = true;
		
		public function ColorCubeMain() 
		{
		}
		override protected function init():void 
		{
			super.init();
			var alignToHSVAxis:Matrix3D = new Matrix3D();
			alignToHSVAxis.appendRotation(45, Vector3D.X_AXIS);
			alignToHSVAxis.appendRotation(-36, Vector3D.Y_AXIS);
			var alignToHSVAxisInv:Matrix3D = alignToHSVAxis.clone();
			alignToHSVAxisInv.invert();
			
			hueMatrix = new Matrix3D();
			hueMatrix.append(alignToHSVAxis);
			hueMatrix.appendRotation(1, Vector3D.Z_AXIS);
			hueMatrix.append(alignToHSVAxisInv);
			hueMatrixInv = hueMatrix.clone();
			hueMatrixInv.invert();
			
			saturationMatrix = new Matrix3D();
			saturationMatrix.append(alignToHSVAxis);
			saturationMatrix.appendScale(1.01, 1.01, 1);
			saturationMatrix.append(alignToHSVAxisInv);
			saturationMatrixInv = saturationMatrix.clone();
			saturationMatrixInv.invert();
			
			valueMatrix = new Matrix3D();
			valueMatrix.append(alignToHSVAxis);
			valueMatrix.appendTranslation(0, 0, .01);
			valueMatrix.append(alignToHSVAxisInv);
			valueMatrixInv = valueMatrix.clone();
			valueMatrixInv.invert();
			
			
			Clock.init();
			
			//away3D
			var scene:Scene3D = new Scene3D();
			var lens:OrthographicLens = new OrthographicLens(1000);
			camera = new Camera3D(lens);
			view = new View3D(scene, camera);
			addChild(view);
			colorCube = new ObjectContainer3D();
			materials = new Vector.<ColorMaterial>;
			voxels = new Vector.<Sprite3D>;
			for (var ix:int = 0; ix <= size; ix+=step) 
			{
				for (var iy:int = 0; iy <= size; iy+=step) 
				{
					for (var iz:int = 0; iz <= size; iz+=step) 
					{
						var voxelMaterial:ColorMaterial = new ColorMaterial(Color.fromRGBFloat(ix/size, iy/size, iz/size).hexRGB);
						materials.push(voxelMaterial);
						//m.blendMode = BlendMode.ADD;
						var voxel:Sprite3D = new Sprite3D(voxelMaterial, step, step);
						voxels.push(voxel);
						voxel.x = ix;
						voxel.y = iy;
						voxel.z = iz;
						colorCube.addChild(voxel);
					}
				}
			}
			scene.addChild(colorCube);
			colorCube.x = colorCube.y = colorCube.z = -sizeHalf;
			camera.x = -DISTANCE_FROM_CENTER;
			camera.y = -DISTANCE_FROM_CENTER;
			camera.z = -DISTANCE_FROM_CENTER;
			camera.lookAt(new Vector3D());
			crossHair = new CrossHair(size * 2, step / 8);
			scene.addChild(crossHair);
			color = new Color3D(0xdf3377);
			//color = new Color(0x7f7f7f);
			crossHair.x = color.r / 255 * size;
			crossHair.y = color.g / 255 * size;
			crossHair.z = color.b / 255 * size;
			crossHair.updateColor(color.hex);
			circle = new Shape();
			addChild(circle);
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
			stage.addEventListener(Event.RESIZE, onResize);
			onResize(null);
		}
		
		private function onResize(e:Event):void 
		{
			view.width = stage.stageWidth;
			view.height = stage.stageHeight;
			circle.x = stage.stageWidth * .5;
			circle.y = stage.stageHeight * .5;
			circle.scaleX = circle.scaleY = stage.stageHeight / 120;
		}
		
		private function onEnterFrame(e:Event):void 
		{
			//colorVector = saturationMatrix.transformVector(colorVector);
			//color.saturate();
			//colorVector = valueMatrixInv.transformVector(colorVector);
			//color.brighten(3);
			//colorVector = hueMatrix.transformVector(colorVector);
			color.rotateHue(1);
			color.clamp();
			crossHair.x = color.r / 255 * size - sizeHalf;
			crossHair.y = color.g / 255 * size - sizeHalf;
			crossHair.z = color.b / 255 * size - sizeHalf;
			crossHair.updateColor(color.hex);
			
			var val:Number = Clock.time * .0002;
			if (spin)
			{
				camera.x = Math.cos(val) * DISTANCE_FROM_CENTER;
				camera.y = Math.cos(val*.5) * DISTANCE_FROM_CENTER;
				camera.z = Math.sin(val) * DISTANCE_FROM_CENTER;
				camera.lookAt(new Vector3D());
			}
			
			if (crossSection)
			{
				var crossHairPosition:Vector3D = camera.inverseSceneTransform.transformVector(crossHair.position);
				for each(var s:Sprite3D in voxels)
				{
					var m:ColorMaterial = s.material as ColorMaterial;
					var voxelPosition:Vector3D = camera.inverseSceneTransform.transformVector(s.scenePosition);
					s.visible = crossHairPosition.z < voxelPosition.z+step ? (crossHairPosition.z > voxelPosition.z - step ? 1 : 0) : 0;
					//m.alpha = 1-Math.max(Math.abs(s.x/sizeHalf),Math.abs(s.y/sizeHalf), Math.abs(s.z/sizeHalf));
					//m.alpha = Math.pow(Math.random(), 3);
				}
			}
			view.render();
			
			circle.graphics.clear();
			Circle.drawHoop(circle.graphics, 50, 40, color.hex, 1);
		}
		
	}

}
import away3d.containers.ObjectContainer3D;
import away3d.entities.Mesh;
import away3d.materials.ColorMaterial;
import away3d.primitives.CubeGeometry;
import com.bunnybones.color.Color;

class CrossHair extends ObjectContainer3D
{
	private var geometry:CubeGeometry;
	private var rg:Mesh;
	private var gb:Mesh;
	private var rb:Mesh;
	public function CrossHair(size:Number, thickness:Number)
	{
		geometry = new CubeGeometry(size, thickness, thickness);
		gb = makeNewBar(0, 0, 0, 0x00ffff);
		rg = makeNewBar(0, 90, 0, 0xffff00);
		rb = makeNewBar(0, 0, 90, 0xff00ff);
	}
	
	public function updateColor(colorHex:uint)
	{
		var color:Color = new Color(colorHex);
		(rg.material as ColorMaterial).color = Color.fromRGBFloat(color.r / 255, color.g / 255, 0).hexRGB;
		(gb.material as ColorMaterial).color = Color.fromRGBFloat(0, color.g / 255, color.b / 255).hexRGB;
		(rb.material as ColorMaterial).color = Color.fromRGBFloat(color.r / 255, 0, color.b / 255).hexRGB;
	}
	
	private function makeNewBar(rotX:Number = 0,rotY:Number = 0,rotZ:Number = 0, color:uint = 0xffffff):Mesh
	{
		var material:ColorMaterial = new ColorMaterial(color);
		var bar:Mesh = new Mesh(geometry, material);
		bar.rotationX = rotX;
		bar.rotationY = rotY;
		bar.rotationZ = rotZ;
		addChild(bar);
		return bar;
	}
}