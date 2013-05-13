package com.bunnybones.panoPainter 
{
	import away3d.cameras.Camera3D;
	import away3d.cameras.lenses.PerspectiveLens;
	import away3d.containers.Scene3D;
	import away3d.containers.View3D;
	import com.bunnybones.away3d.pano.LayerManager;
	import com.bunnybones.away3d.pano.ParalaxPanoCamera;
	import com.bunnybones.away3d.pano.tools.Brush;
	import com.bunnybones.away3d.pano.tools.ColorPicker;
	import com.bunnybones.model.io.ModelIOAir;
	import com.bunnybones.model.io.ModelIOEvent;
	import com.bunnybones.model.NetModel;
	import com.bunnybones.MouseToolTip;
	import com.bunnybones.panoPainter.model.PanoramaModel;
	import com.bunnybones.panoPainter.model.SettingsModel;
	import com.bunnybones.ui.keyboard.StageKeyBoard;
	import com.bunnybones.ui.wacom.StageWacom;
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
		private var panoramaModel:PanoramaModel;
		private var settings:SettingsModel;
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
			
			//init UI
			StageKeyBoard.bind(stage);
			MouseToolTip.bind(stage);
			
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
			
			
			//implement UI like hotkeys
			stage.addEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);
			stage.addEventListener(Event.MOUSE_LEAVE, onMouseLeave);
			
			
			StageKeyBoard.bindKey("New Pano", Keyboard.N, newPano, null, true);
			StageKeyBoard.bindKey("Save", Keyboard.S, save, null, true);
			StageKeyBoard.bindKey("SaveAs", Keyboard.S, saveAs, null, true, true);
			
			StageKeyBoard.bindKey("Open", Keyboard.O, loadAs, null, true);
			
			StageWacom.instance.bind(stage, this);
			StageWacom.instance.bindPressureValue(Brush, "pressure");
			
			//io
			NetModel.ioClass = ModelIOAir;
			settings = new SettingsModel();
			settings.addEventListener(Event.COMPLETE, onSettingsFileComplete);
			settings.init("settings.xml");
			
			//new panorama
			newPano();
		}
		
		private function onSettingsFileComplete(e:Event):void 
		{
			dtrace("!");
		}
		
		private function newPano():void 
		{
			resetPanorama();
		}
		
		private function resetPanorama():void 
		{
			layerManager.reset();
			panoramaModel = layerManager.model = new PanoramaModel();
//			panoramaModel.
		}
		
		private function save():void 
		{
			panoramaModel.addEventListener(ModelIOEvent.CANCEL, onPanoramaSaveCancelled);
			panoramaModel.addEventListener(ModelIOEvent.SAVE_COMPLETE, onPanoramaSaveComplete);
			panoramaModel.save();
		}
		
		private function onPanoramaSaveCancelled(e:ModelIOEvent):void 
		{
			deinitPanoramaSave();
		}
		
		private function onPanoramaSaveComplete(e:ModelIOEvent):void 
		{
			deinitPanoramaSave();
			settings.lastPanoramaURL = panoramaModel.url;
			settings.save();
		}
		
		private function deinitPanoramaSave():void 
		{
			panoramaModel.removeEventListener(ModelIOEvent.SAVE_COMPLETE, onPanoramaSaveComplete);
			panoramaModel.removeEventListener(ModelIOEvent.CANCEL, onPanoramaSaveCancelled);
		}
		
		private function saveAs():void 
		{
			//file reference stuff
			panoramaModel.saveAs();
		}
		
		private function load():void 
		{
			panoramaModel.load();
		}
		
		private function loadAs():void
		{
			panoramaModel.loadAs();
		}
		
		private function onMouseLeave(e:Event):void 
		{
			mouseActive = false;
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