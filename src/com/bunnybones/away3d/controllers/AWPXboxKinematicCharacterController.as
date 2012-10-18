package com.bunnybones.away3d.controllers 
{
	import awayphysics.collision.dispatch.AWPGhostObject;
	import awayphysics.collision.shapes.AWPCollisionShape;
	import awayphysics.dynamics.AWPDynamicsWorld;
	import awayphysics.dynamics.character.AWPKinematicCharacterController;
	import com.bunnybones.Callback;
	import com.bunnybones.ui.joystick.JoystickBind;
	import flash.geom.Vector3D;
	
	/**
	 * ...
	 * @author Tomasz Dysinski
	 */
	public class AWPXboxKinematicCharacterController extends AWPKinematicCharacterController 
	{
		static public const WALK_SPEED:Number = .02;
		
		private var _joystick:JoystickBind;
		private var _walkIncrement:Number = 0;
		private var _strafeIncrement:Number = 0;
		private var _ascendIncrement:Number = 0;
		private var _panIncrement:Number = 0;
		private var _tiltIncrement:Number = 0;
		private var tempWalkDirection:Vector3D;
		public function AWPXboxKinematicCharacterController(ghostObject:AWPGhostObject, shape:AWPCollisionShape, stepHeight:Number) 
		{
			super(ghostObject, shape, stepHeight);
			_joystick = new JoystickBind();
			_joystick.setAxisCallback(0, new Callback(this, "immediateStrafe"));
			_joystick.setAxisCallback(1, new Callback(this, "immediateWalk"));
			_joystick.setAxisCallback(2, new Callback(this, "immediateAscend"));
			_joystick.setAxisCallback(3, new Callback(this, "immediateTilt"));
			_joystick.setAxisCallback(4, new Callback(this, "immediatePan"));
		}
		
		public function get joystick():JoystickBind 
		{
			return _joystick;
		}
		
		public function update():void
		{
			joystick.update();
			updateRotations();
			updateMoves();
		}
		
		protected function updateRotations():void 
		{
			if (_tiltIncrement > 90) _tiltIncrement = 90;
			else if (_tiltIncrement < -90) _tiltIncrement = -90;
			
			var tempRotation:Vector3D = new Vector3D();
			tempRotation = tempRotation.add(new Vector3D(_tiltIncrement, 0, 0));
			tempRotation = tempRotation.add(new Vector3D(0, _panIncrement, 0));
			ghostObject.rotation = tempRotation;
		}
		
		protected function updateMoves():void 
		{
			var tempWalkDirection:Vector3D = new Vector3D();
			var tempAxisSpeed:Vector3D;
			var awpScaling:Number = AWPDynamicsWorld.getInstance().scaling;
			if (_walkIncrement != 0)
			{
				tempAxisSpeed = ghostObject.front.clone();
				tempAxisSpeed.scaleBy(_walkIncrement * WALK_SPEED * awpScaling);
				tempWalkDirection = tempWalkDirection.add(tempAxisSpeed);
				_walkIncrement = 0;
			}
			
			if (_strafeIncrement != 0)
			{
				tempAxisSpeed = ghostObject.right.clone();
				tempAxisSpeed.scaleBy(_strafeIncrement * WALK_SPEED * awpScaling);
				tempWalkDirection = tempWalkDirection.add(tempAxisSpeed);
				_strafeIncrement = 0;
			}
			
			if (_ascendIncrement != 0)
			{
				tempAxisSpeed = ghostObject.up.clone();
				tempAxisSpeed.scaleBy(_ascendIncrement * WALK_SPEED * awpScaling);
				tempWalkDirection = tempWalkDirection.add (tempAxisSpeed);
				_ascendIncrement = 0;
			}
			setWalkDirection(tempWalkDirection);
			//if (!isNaN(forceHeight)) _targetObject.y = forceHeight;
		}
		
		public function incrementWalk(val:Number):void
		{
			if (val == 0)
				return;
			
			_walkIncrement += val;
		}
		
		public function incrementStrafe(val:Number):void
		{
			if (val == 0)
				return;
			
			_strafeIncrement += val;
		}
		
		public function incrementAscend(val:Number):void
		{
			if (val == 0)
				return;
			
			_ascendIncrement += val;
		}
		
		public function incrementTilt(val:Number):void
		{
			if (val == 0)
				return;
			
			_tiltIncrement += val;
		}
		
		public function incrementPan(val:Number):void
		{
			if (val == 0)
				return;
			
			_panIncrement += val;
		}
		
		public function set immediateWalk(value:Number):void
		{
			incrementWalk(value);
		}
		
		public function set immediateStrafe(value:Number):void
		{
			incrementStrafe(value);
		}
		
		public function set immediateAscend(value:Number):void
		{
			incrementAscend(value);
		}
		
		public function set immediateTilt(value:Number):void
		{
			incrementTilt(value);
		}
		
		public function set immediatePan(value:Number):void
		{
			incrementPan(value);
		}
	}

}