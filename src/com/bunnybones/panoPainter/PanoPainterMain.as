package com.bunnybones.panoPainter 
{
	import away3d.cameras.Camera3D;
	import away3d.cameras.lenses.PerspectiveLens;
	import away3d.containers.Scene3D;
	import away3d.containers.View3D;
	import away3d.tools.serialize.Serialize;
	import away3d.tools.serialize.TraceSerializer;
	import com.bunnybones.away3d.pano.LayerManager;
	import com.bunnybones.away3d.pano.ParalaxPanoCamera;
	import com.bunnybones.away3d.pano.tools.Brush;
	import com.bunnybones.away3d.pano.tools.ColorPicker;
	import com.bunnybones.MouseToolTip;
	import com.bunnybones.ui.keyboard.StageKeyBoard;
	import com.bunnybones.ui.wacom.StageWacom;
	import com.greensock.TweenLite;
	import com.bunnybones.ui.wacom.StageWacom;
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Vector3D;
	import flash.ui.Keyboard;
	
	/**
	 * ...
	 * @author Tomasz Dysinski
	 */
	public class PanoPainterMain extends Sprite 
	{
		private var scene:Scene3D;
		private var view:View3D;
		private var camera:ParalaxPanoCamera;
		private var mouseDelta:Point = new Point();
		private var cameraSpeed:Number = 3;
		private var mouseActive:Boolean;
		protected var drawable:Boolean = false;
		protected var images:Array;
		protected var imageIndex:int = 0;
		protected var targetRotation:Vector3D = new Vector3D();
		
		protected var layerManager:LayerManager;
		
		public function PanoPainterMain() 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onAddedToStage(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			init();
		}
		
		private function init():void 
		{
			//graphics
			scene = new Scene3D();
			var lens:PerspectiveLens = new PerspectiveLens(70);
			camera = new ParalaxPanoCamera(new Camera3D(lens));
			camera.rotationY = 180;
			view = new View3D(scene, camera.camera);
			scene.addChild(camera);
			addChild(view);
			view.stage3DProxy.configureBackBuffer(stage.stageWidth, stage.stageHeight, 4, true);
			view.width = stage.stageWidth;
			view.height = stage.stageHeight;
			view.x = 100;
			//camera.z = 0;
			view.mouse3DManager.forceMouseMove = true;
			
			//layers
			layerManager = new LayerManager(scene);
			
			//paint
			Brush.bind(scene);
			ColorPicker.bind(layerManager);
			
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			stage.addEventListener(Event.RESIZE, onResizeStage);
			
			//scene.addChild(layer);
			//view.addEventListener(MouseEvent3D.CLICK, 
			//var t:TriangleCollider = new TriangleCollider();
			//t.evaluate
			//mouseManager = new Mouse3DManager(view);
			
			newPano();
			
			//UI
			StageKeyBoard.bind(stage);
			MouseToolTip.bind(stage);
			stage.addEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);
			stage.addEventListener(Event.MOUSE_LEAVE, onMouseLeave);
			
			StageKeyBoard.bindKey(Keyboard.N, newPano, null, true);
			StageKeyBoard.bindKey(Keyboard.S, save, null, true);
			StageKeyBoard.bindKey(Keyboard.S, saveAs, null, true, true);
			
			StageKeyBoard.bindKey(Keyboard.L, layerManager.newLayer, null, true);
			
			StageWacom.instance.bind(stage, this);
			StageWacom.instance.bindPressureValue(Brush, "pressure");
		}
		
		private function newPano():void 
		{
			scene = new Scene3D();
			view.scene = scene;
			layerManager.scene = scene;
			scene.addChild(camera);
			//var valid:Boolean = AWDParser.supportsData(data);
			//pano = new Panorama(new PanoramaData());
		}
		
		private function save():void 
		{
			Serialize.serializeScene(scene, new TraceSerializer());
			
		}
		
		private function saveAs():void 
		{
			//file reference stuff
			save();
		}
		
		private function onMouseLeave(e:Event):void 
		{
			mouseActive = false;
		}
		
		private function delayedAdd():void 
		{
			trace("adding", imageIndex);
			var image:Array = images[imageIndex];
			layerManager.newLayer((new (image[1] as Class)() as Bitmap).bitmapData, image[0], image[0]=="base render", image[0]=="highlights", image[0]!="base render" && drawable);
			
			imageIndex++;
			trace("?", imageIndex, images.length);
			if (imageIndex < images.length) 
			{
				trace("!", imageIndex, images.length);
				TweenLite.delayedCall(.4, delayedAdd);
			}
		}
		
		private function onMouseWheel(e:MouseEvent):void 
		{
			with (camera.camera.lens as PerspectiveLens)
			{
				fieldOfView *= 1 - e.delta * .02;
				fieldOfView = Math.max(25, Math.min(fieldOfView, 80));
			}
		}
		
		private function onResizeStage(e:Event):void 
		{
			view.width = stage.stageWidth;
			view.height = stage.stageHeight;
		}
		
		private function onMouseMove(e:MouseEvent):void 
		{
			
			mouseActive = true;
			mouseDelta.x = e.stageX / stage.stageWidth - .5;
			mouseDelta.y = e.stageY / stage.stageHeight - .5;
			mouseDelta.x *= mouseDelta.x * (mouseDelta.x > 0 ? 1 : -1) * 3;
			//mouseDelta.x *= .1;
			mouseDelta.y *= mouseDelta.y * (mouseDelta.y > 0 ? 1 : -1) * 3;
			//mouseDelta.y *= .1;
		}
		
		private function onEnterFrame(e:Event):void 
		{
			view.render();
			var zoomFactor:Number = (camera.camera.lens as PerspectiveLens).fieldOfView / 60;
			if (mouseActive)
			{
				targetRotation.x += mouseDelta.y * cameraSpeed * zoomFactor;
				targetRotation.x = Math.max(-90, Math.min(90, targetRotation.x));
				targetRotation.y += mouseDelta.x * cameraSpeed * zoomFactor;
			}
			
			camera.rotationX -= -(targetRotation.x - camera.rotationX) * .2;
			camera.rotationY -= -(targetRotation.y - camera.rotationY) * .2;
		}
	}

}