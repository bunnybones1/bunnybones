package com.bunnybones.away3d.entities 
{
	import away3d.cameras.Camera3D;
	import away3d.containers.ObjectContainer3D;
	import away3d.core.base.Geometry;
	import away3d.entities.Mesh;
	import away3d.materials.ColorMaterial;
	import away3d.materials.MaterialBase;
	import away3d.primitives.SphereGeometry;
	import awayphysics.collision.dispatch.AWPGhostObject;
	import awayphysics.collision.shapes.AWPCapsuleShape;
	import awayphysics.collision.shapes.AWPSphereShape;
	import away3d.primitives.CapsuleGeometry;
	import awayphysics.data.AWPCollisionFlags;
	import awayphysics.dynamics.AWPDynamicsWorld;
	import awayphysics.dynamics.AWPRigidBody;
	import awayphysics.events.AWPEvent;
	import com.bunnybones.away3d.controllers.AWPXboxKinematicCharacterController;
	import com.bunnybones.away3d.entities.guns.GunBase;
	import com.bunnybones.Callback;
	import com.bunnybones.color.Color;
	import com.bunnybones.ui.mouse.StageMouse;
	import com.jam3.krumpBallet.GlobalReferences;
	import flash.events.Event;
	import flash.geom.Vector3D;
	import awayphysics.collision.dispatch.AWPCollisionObject;
	/**
	 * ...
	 * @author Tomasz Dysinski
	 */
	public class Creature extends ObjectContainer3D 
	{
		static public const RADIUS:Number = .3;
		static public const HEIGHT:Number = 1.82;
		static public const HEAD_EYE_OFFSET:Number = -.2;
		private var _camera:Camera3D;
		private var gun:GunBase;
		private var controller:AWPXboxKinematicCharacterController;
		private var startingPosition:Vector3D;
		public function Creature(camera:Camera3D = null, startingPosition:Vector3D = null) 
		{
			_camera = camera;
			if (!startingPosition) startingPosition = new Vector3D();
			this.startingPosition = startingPosition;
			super();
			if (camera)
			{
				addChild(camera);
				camera.y = HEIGHT * .5 + HEAD_EYE_OFFSET;
			}
		}
		
		public function init():void 
		{
			
			
			var testMesh:Mesh = new Mesh(new CapsuleGeometry (RADIUS, HEIGHT), generateMaterial());
			addChild(testMesh);
			// create character shape and controller
			var shape : AWPCapsuleShape = new AWPCapsuleShape(RADIUS, HEIGHT);
			var ghostObject : AWPGhostObject = new AWPGhostObject(shape, this);
			ghostObject.collisionFlags = AWPCollisionFlags.CF_CHARACTER_OBJECT;
			ghostObject.addEventListener(AWPEvent.COLLISION_ADDED, characterCollisionAdded);
			controller = new AWPXboxKinematicCharacterController(ghostObject, shape, 0.05);
			AWPDynamicsWorld.getInstance().addCharacter(controller);
			controller.warp(startingPosition);
			
			addChild(gun = new GunBase());
			gun.x = .3;
			gun.y = .3;
			gun.z = .3;
			
			for (var i:int = 0; i < 16; i++) 
			{
				controller.joystick.setButtonCallback(i, new Callback(gun, "button"+i));
			}
			//var cameraController:FirstPersonController = new GlobalSettings.instance.playerOneCameraControllerClass(this, 1.5, body);
		}
		
		public function onEnterFrame(e:Event):void 
		{
			controller.update();
			//var lookAtTarget:Vector3D = _targetObject.scenePosition.add(_targetObject.forwardVector);
			//_targetObject.lookAt(lookAtTarget);
			//notifyUpdate();
		}
		
		private function characterCollisionAdded(event : AWPEvent) : void 
		{
			var force : Vector3D;
			dtrace(event.collisionObject);
			var awpScaling:Number = 10;
			if (event.collisionObject.collisionFlags & AWPCollisionFlags.CF_CHARACTER_OBJECT) 
			{
				var otherGhostObject : AWPGhostObject = AWPGhostObject (event.collisionObject);
				var objectDelta:Vector3D = otherGhostObject.position.subtract(controller.ghostObject.position);
				var overlap:Number = objectDelta.length - RADIUS * 2;
				if (overlap > 0)
				{
					force = event.manifoldPoint.normalWorldOnB.clone();
					force.scaleBy(overlap);
					otherGhostObject.position = otherGhostObject.position.subtract(force);
					dtrace(controller.ghostObject.position, otherGhostObject.position);
					dtrace(overlap, objectDelta.length);
				}
			}
			/*
			if (!(event.collisionObject.collisionFlags & AWPCollisionFlags.CF_STATIC_OBJECT)) 
			{
				dtrace("hi");
				var body : AWPRigidBody = AWPRigidBody(event.collisionObject);
				force = event.manifoldPoint.normalWorldOnB.clone();
				force.scaleBy( -30);
				body.applyForce(force, event.manifoldPoint.localPointB);
			}
			*/
		}
		
		private function generateMaterial():MaterialBase
		{
			var material:ColorMaterial =  new ColorMaterial(0xff0000);
			material.lightPicker = GlobalReferences.instance.lightPicker;
			return material;
		}
		
		public function get camera():Camera3D 
		{
			return _camera;
		}
	}

}