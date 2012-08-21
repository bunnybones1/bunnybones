package com.bunnybones.freeflyer
{
	import away3d.cameras.Camera3D;
	import away3d.cameras.lenses.PerspectiveLens;
	import away3d.containers.View3D;
	import away3d.controllers.FirstPersonController;
	import away3d.core.render.RendererBase;
	import away3d.entities.Mesh;
	import away3d.lights.DirectionalLight;
	import away3d.lights.PointLight;
	import away3d.materials.DefaultMaterialBase;
	import away3d.materials.lightpickers.StaticLightPicker;
	import away3d.materials.methods.FresnelEnvMapMethod;
	import away3d.materials.methods.TripleFilteredShadowMapMethod;
	import away3d.primitives.PlaneGeometry;
	import away3d.primitives.SphereGeometry;
	import away3d.textures.BitmapCubeTexture;
	import awayphysics.collision.shapes.AWPSphereShape;
	import awayphysics.collision.shapes.AWPStaticPlaneShape;
	import awayphysics.debug.AWPDebugDraw;
	import awayphysics.dynamics.AWPDynamicsWorld;
	import awayphysics.dynamics.AWPRigidBody;
	import com.bunnybones.console.Console;
	import com.bunnybones.ui.keyboard.StageKeyBoard;
	import com.bunnybones.ui.mouse.StageMouse;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.geom.Vector3D;
	import flash.ui.Keyboard;
	
	/**
	 * ...
	 * @author Tomasz Dysinski
	 */
	public class Main extends Sprite 
	{
		static public const AREA_SIZE:Number = 30*64;
		static public const AREA_SIZE_HALF:Number = AREA_SIZE * .5;
		static public const LARGER_AREA_SIZE:Number = AREA_SIZE;// * 2;
		static public const EYE_HEIGHT:Number = 60;
		protected var view:View3D;
		private var world:AWPDynamicsWorld;
		private var timeStep:Number = 1 / 60;
		private var lightPicker:StaticLightPicker;
		protected var envMap:BitmapCubeTexture;
		protected var sun:PointLight;
		protected var groundMaterial:DefaultMaterialBase;
		protected var defaultRenderer:RendererBase;
		protected var ground:Mesh;
		
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
		
		protected function init():void 
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
			
			//away3d physics
			world = AWPDynamicsWorld.getInstance();
			world.initWithDbvtBroadphase();
			world.gravity = new Vector3D(0,-40,0);
			
			//away3d
			addChild(view = new View3D(null, new Camera3D(new PerspectiveLens(38)), defaultRenderer));
			view.stage3DProxy.configureBackBuffer(stage.stageWidth, stage.stageHeight, 1, true);
			view.backgroundColor = 0x000000;
			
			view.camera.y = EYE_HEIGHT;
			
			//var fps:FirstPersonController = new KeyedFirstPersonController(view.camera);
			
			sun = new PointLight();
			sun.ambient = .099;
			sun.specular = .5;
			//sun.shadowMapper = new DirectionalShadowMapper();
			//sun.castsShadows = true;
			sun.y = 300;
			//sun.lookAt(new Vector3D());
			lightPicker = new StaticLightPicker([sun]);
			
			var planeGeom:PlaneGeometry = new PlaneGeometry(LARGER_AREA_SIZE, LARGER_AREA_SIZE);
			groundMaterial = new DefaultMaterialBase();
			//groundMaterial.shadowMethod = new TripleFilteredShadowMapMethod(sun);
			//sun.shadowMapper.depthMapSize = 2048;
			groundMaterial.lightPicker = lightPicker;
			groundMaterial.ambient = 10;
			groundMaterial.ambientColor = Math.random() * 0xffffff;
			groundMaterial.specularColor = Math.random() * 0xffffff;
			groundMaterial.specular = Math.random() * 2;
			groundMaterial.gloss = Math.random() * 5;
			groundMaterial.diffuseMethod.diffuseColor = Math.random() * 0xffffff;
			ground = new Mesh(planeGeom, groundMaterial);
			view.scene.addChild(ground);
			ground.addChild(sun);
			
			var groundShape:AWPStaticPlaneShape = new AWPStaticPlaneShape();
			var groundBody:AWPRigidBody = new AWPRigidBody(groundShape, ground);
			groundBody.friction = 10.9;
			world.addRigidBody(groundBody);
			
			var awpDebug:AWPDebugDraw = new AWPDebugDraw(view, world);
			
			var totalBalls:int = 50;
			var geom:SphereGeometry = new SphereGeometry(290);
			var randomBitmapData:BitmapData = new BitmapData(64, 64);
			randomBitmapData.perlinNoise(16, 16, 4, 23, true, true);
			envMap = new BitmapCubeTexture(randomBitmapData, randomBitmapData, randomBitmapData, randomBitmapData, randomBitmapData, randomBitmapData)
			for (var i:int = 0; i < totalBalls; i++) 
			{
				var ballScale:Number = .2 + Math.random() * .8;
				var material:DefaultMaterialBase = newBallMaterial();
				var ballMesh:Mesh = new Mesh(geom, material);
				var pos:Vector3D = new Vector3D();
				pos.x = Math.random() * AREA_SIZE - AREA_SIZE_HALF;
				pos.y = ballScale * geom.radius + 1000 * Math.random();
				pos.z = Math.random() * AREA_SIZE - AREA_SIZE_HALF;
				ballMesh.scale(ballScale);
				ground.addChild(ballMesh);
				
				
				var ballShape:AWPSphereShape = new AWPSphereShape(ballScale * 290);
				var ballBody:AWPRigidBody = new AWPRigidBody(ballShape, ballMesh, ballScale * 290);
				ballBody.x = ballMesh.x = pos.x;
				ballBody.y = ballMesh.y = pos.y;
				ballBody.z = ballMesh.z = pos.z;
				//dtrace(groundBody.x, groundBody.y, groundBody.z);
				ballBody.friction = 5.9;
				world.addRigidBody(ballBody);
			}
			
			//stage.displayState = StageDisplayState.FULL_SCREEN_INTERACTIVE;
			
			onResize(null);
		}
		
		public function newBallMaterial():DefaultMaterialBase 
		{
				var material:DefaultMaterialBase = new DefaultMaterialBase();
				material.ambient = 10;
				material.ambientColor = Math.random() * 0xffffff;
				material.specularColor = Math.random() * 0xffffff;
				material.specular = Math.random() * 2;
				var reflMethod:FresnelEnvMapMethod = new FresnelEnvMapMethod(envMap);
				reflMethod.fresnelPower = .4;
				reflMethod.normalReflectance = .1;
				material.addMethod(reflMethod);
				//var mysteryMethod:RimLightMethod = new RimLightMethod(0x689abd,4);
				//material.addMethod(mysteryMethod);
				material.gloss = Math.random() * 5;
				material.diffuseMethod.diffuseColor = Math.random() * 0xffffff;
				//material.shadowMethod = new TripleFilteredShadowMapMethod(sun);
				//material.normalMap = new BitmapTexture(randomBitmapData);
				material.lightPicker = lightPicker;
				return material;
		}
		
		private function onResize(e:Event):void 
		{
			view.width = stage.stageWidth;
			view.height = stage.stageHeight;
		}
		
		protected function onEnterFrame(e:Event):void 
		{
			view.render();
			world.step(timeStep, 1, timeStep);
		}
		
	}
	
}