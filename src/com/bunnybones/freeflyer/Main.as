package com.bunnybones.freeflyer
{
	import away3d.containers.View3D;
	import away3d.controllers.FirstPersonController;
	import away3d.entities.Mesh;
	import away3d.lights.DirectionalLight;
	import away3d.lights.shadowmaps.DirectionalShadowMapper;
	import away3d.materials.ColorMaterial;
	import away3d.materials.DefaultMaterialBase;
	import away3d.materials.lightpickers.StaticLightPicker;
	import away3d.materials.methods.DitheredShadowMapMethod;
	import away3d.materials.methods.FilteredShadowMapMethod;
	import away3d.materials.methods.FogMethod;
	import away3d.materials.methods.FresnelEnvMapMethod;
	import away3d.materials.methods.FresnelSpecularMethod;
	import away3d.materials.methods.HardShadowMapMethod;
	import away3d.materials.methods.RimLightMethod;
	import away3d.materials.methods.SoftShadowMapMethod;
	import away3d.materials.methods.TripleFilteredShadowMapMethod;
	import away3d.primitives.PlaneGeometry;
	import away3d.primitives.SphereGeometry;
	import away3d.textures.BitmapCubeTexture;
	import away3d.textures.BitmapTexture;
	import com.bunnybones.console.Console;
	import com.bunnybones.ui.keyboard.StageKeyBoard;
	import com.bunnybones.ui.mouse.StageMouse;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageDisplayState;
	import flash.display.StageScaleMode;
	import flash.display3D.textures.CubeTexture;
	import flash.events.Event;
	import flash.geom.Vector3D;
	import flash.ui.Keyboard;
	
	/**
	 * ...
	 * @author Tomasz Dysinski
	 */
	public class Main extends Sprite 
	{
		static public const AREA_SIZE:Number = 2000;
		static public const AREA_SIZE_HALF:Number = AREA_SIZE * .5;
		static public const LARGER_AREA_SIZE:Number = AREA_SIZE * 2;
		static public const EYE_HEIGHT:Number = 60;
		private var view:View3D;
		
		public function Main():void 
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
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			addChild(new Console(this));
			StageKeyBoard.bind(stage);
			StageKeyBoard.bindKey(Keyboard.BACKQUOTE, Console.singleton.toggle);
			Console.singleton.toggle();
			StageMouse.bind(stage);
			
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
			stage.addEventListener(Event.RESIZE, onResize);
			
			addChild(view = new View3D());
			view.stage3DProxy.configureBackBuffer(stage.stageWidth, stage.stageHeight, 1, true);
			view.backgroundColor = 0x689abd;
			
			view.camera.y = EYE_HEIGHT;
			
			var fps:FirstPersonController = new KeyedFirstPersonController(view.camera);
			
			var sun:DirectionalLight = new DirectionalLight();
			sun.ambient = .099;
			sun.specular = .5;
			view.scene.addChild(sun);
			sun.shadowMapper = new DirectionalShadowMapper();
			sun.castsShadows = true;
			sun.y = 1000;
			//sun.lookAt(new Vector3D());
			var lightPicker:StaticLightPicker = new StaticLightPicker([sun]);
			
			var planeGeom:PlaneGeometry = new PlaneGeometry(LARGER_AREA_SIZE, LARGER_AREA_SIZE);
			var groundMaterial:DefaultMaterialBase = new DefaultMaterialBase();
			groundMaterial.shadowMethod = new TripleFilteredShadowMapMethod(sun);
			sun.shadowMapper.depthMapSize = 2048;
			groundMaterial.lightPicker = lightPicker;
			groundMaterial.ambient = 10;
			groundMaterial.ambientColor = Math.random() * 0xffffff;
			groundMaterial.specularColor = Math.random() * 0xffffff;
			groundMaterial.specular = Math.random() * 2;
			groundMaterial.gloss = Math.random() * 5;
			groundMaterial.diffuseMethod.diffuseColor = Math.random() * 0xffffff;
			var ground:Mesh = new Mesh(planeGeom, groundMaterial);
			view.scene.addChild(ground);
			
			var totalBalls:int = 400;
			var geom:SphereGeometry = new SphereGeometry(30);
			var randomBitmapData:BitmapData = new BitmapData(64, 64);
			randomBitmapData.perlinNoise(16, 16, 4, 23, true, true);
			var envMap:BitmapCubeTexture = new BitmapCubeTexture(randomBitmapData, randomBitmapData, randomBitmapData, randomBitmapData, randomBitmapData, randomBitmapData)
			for (var i:int = 0; i < totalBalls; i++) 
			{
				var ballScale:Number = .2 + Math.random() * .8;
				var material:DefaultMaterialBase = new DefaultMaterialBase();
				material.ambient = 10;
				material.ambientColor = Math.random() * 0xffffff;
				material.specularColor = Math.random() * 0xffffff;
				material.specular = Math.random() * 2;
				var reflMethod:FresnelEnvMapMethod = new FresnelEnvMapMethod(envMap);
				reflMethod.fresnelPower = .4;
				reflMethod.normalReflectance = .1;
				material.addMethod(reflMethod);
				var mysteryMethod:RimLightMethod = new RimLightMethod(0x689abd,4);
				material.addMethod(mysteryMethod);
				material.gloss = Math.random() * 5;
				material.diffuseMethod.diffuseColor = Math.random() * 0xffffff;
				material.shadowMethod = new TripleFilteredShadowMapMethod(sun);
				//material.normalMap = new BitmapTexture(randomBitmapData);
				material.lightPicker = lightPicker;
				var ballMesh:Mesh = new Mesh(geom, material);
				ballMesh.x = Math.random() * AREA_SIZE - AREA_SIZE_HALF;
				ballMesh.y = ballScale * geom.radius + 1000 * Math.random();
				ballMesh.scale(ballScale);
				ballMesh.z = Math.random() * AREA_SIZE - AREA_SIZE_HALF;
				view.scene.addChild(ballMesh);
			}
			
			stage.displayState = StageDisplayState.FULL_SCREEN_INTERACTIVE;
			
			onResize(null);
		}
		
		private function onResize(e:Event):void 
		{
			view.width = stage.stageWidth;
			view.height = stage.stageHeight;
		}
		
		private function onEnterFrame(e:Event):void 
		{
			view.render();
		}
		
	}
	
}