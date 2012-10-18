package com.bunnybones.scenegrapher 
{
	import Box2D.Collision.Shapes.b2CircleShape;
	import Box2D.Collision.Shapes.b2Shape;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2DestructionListener;
	import Box2D.Dynamics.b2Fixture;
	import Box2D.Dynamics.Joints.b2Joint;
	import Box2D.Dynamics.Joints.b2JointEdge;
	import Box2D.Dynamics.Joints.b2RevoluteJoint;
	import com.bunnybones.NavigableSprite;
	import com.bunnybones.scenegrapher.tools.Selection;
	import com.jam3media.graph.easing.EasingKernel;
	import flash.display.CapsStyle;
	import flash.display.LineScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2BodyDef;
	import Box2D.Dynamics.Joints.b2DistanceJoint;
	import Box2D.Dynamics.Joints.b2DistanceJointDef;
	import Box2D.Dynamics.Joints.b2JointEdge;
	import Box2D.Dynamics.Joints.b2WeldJointDef;
	import com.bunnybones.scenegrapher.tools.Destroyer;
	import com.bunnybones.MouseToolTip;
	import com.bunnybones.scenegrapher.tools.Selection;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import flash.ui.Keyboard;
	
	/**
	 * ...
	 * @author Tomasz Dysinski
	 */
	public class CircleHandle extends Handle 
	{
		
		static private var tagOnMouseDown:CircleHandle;
		private var mouseBody:b2Body;
		public var dirty:Boolean = true;
		private var _body:b2Body;
		private var resizeJoints:Boolean = false;
		private var animate:Boolean;
		public function CircleHandle(body:b2Body, id:int = -2, animate:Boolean = true) 
		{
			this.animate = animate;
			_body = body;
			super(id)
			easing = EasingKernel.OUT_QUINTIC;
			addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
		}
		
		override protected function onEasedAnimationValueChange():void 
		{
			super.onEasedAnimationValueChange();
			if(animate) draw();
		}
		
		private function onMouseDown(e:MouseEvent):void 
		{
			resizeJoints = !e.shiftKey;
			if (e.ctrlKey)
			{
				tagOnMouseDown = this;
			}
			else
			{
				var inverseMatrix:Matrix = parent.transform.matrix.clone();
				inverseMatrix.invert()
				var localPos:Point = NavigableSprite.singleton.lastMouseMovePositionLocal;
				var tempBodyDef:b2BodyDef = new b2BodyDef();
				tempBodyDef.position.x = localPos.x * SceneGrapherMain.WORLDSCALE;
				tempBodyDef.position.y = localPos.y * SceneGrapherMain.WORLDSCALE;
				mouseBody = body.GetWorld().CreateBody(tempBodyDef);
				var mouseJointDef:b2WeldJointDef = new b2WeldJointDef();
				mouseJointDef.Initialize(mouseBody, body, new b2Vec2(localPos.x * SceneGrapherMain.WORLDSCALE, localPos.y * SceneGrapherMain.WORLDSCALE));
				body.GetWorld().CreateJoint(mouseJointDef);
				stage.addEventListener(MouseEvent.MOUSE_MOVE, onDrag);
				stage.addEventListener(MouseEvent.MOUSE_UP, onDragStop);
			}
		}
		
		private function onMouseUp(e:MouseEvent):void 
		{
			trace("UP");
			if (tagOnMouseDown is CircleHandle && tagOnMouseDown != this)
			{
				var alreadyConnectedThisWay:Boolean = false;
				var joint:b2DistanceJoint;
				for (var jointList:b2JointEdge = tagOnMouseDown.body.GetJointList(); jointList; jointList = jointList.next)
				{
					if (jointList.joint is b2DistanceJoint)
					{
						joint = jointList.joint as b2DistanceJoint;
						if (joint.GetBodyA() === tagOnMouseDown.body && joint.GetBodyB() === body)
						{
							alreadyConnectedThisWay = true;
						}
						if(e.shiftKey && joint.GetBodyB() === tagOnMouseDown.body && joint.GetBodyA() === body)
						{
							alreadyConnectedThisWay = true;
						}
					}
				}
				if (!alreadyConnectedThisWay)
				{
					var jointDef:b2DistanceJointDef = new b2DistanceJointDef();
					jointDef.bodyB = body;
					jointDef.bodyA = tagOnMouseDown.body;
					var delta:b2Vec2 = jointDef.bodyA.GetPosition().Copy();
					delta.Subtract(jointDef.bodyB.GetPosition());
					jointDef.length = delta.Length();
					jointDef.frequencyHz = 5;
					jointDef.dampingRatio = .7;
					joint = body.GetWorld().CreateJoint(jointDef) as b2DistanceJoint;
					(parent as SceneGrapherMain).createHandle(joint, e.shiftKey ? GlobalSettings.instance.defaultConnectionSecondaryClass : GlobalSettings.instance.defaultConnectionClass, e.shiftKey?-2:-1);
				}
			}
			tagOnMouseDown = null;
		}
		
		private function onDrag(e:MouseEvent):void 
		{
			if (e.ctrlKey) return;
			var inverseMatrix:Matrix = parent.transform.matrix.clone();
			inverseMatrix.invert();
			var localPos:Point = NavigableSprite.singleton.lastMouseMovePositionLocal;
			mouseBody.SetPosition(new b2Vec2(localPos.x * SceneGrapherMain.WORLDSCALE, localPos.y * SceneGrapherMain.WORLDSCALE));
			if (resizeJoints)
			{
				var bodyA:b2Body = mouseBody.GetJointList().other;
				for (var jointList:b2JointEdge = bodyA.GetJointList(); jointList; jointList = jointList.next)
				{
					if(jointList.joint is b2DistanceJoint && jointList.joint.GetUserData().contentType != ContentType.ACTION)
					{
						var bodyB:b2Body = jointList.other;
						var joint:b2DistanceJoint = jointList.joint as b2DistanceJoint;
						var delta:b2Vec2 = bodyA.GetPosition().Copy();
						delta.Subtract(bodyB.GetPosition());
						joint.SetLength(delta.Length());
					}
				}
			}
		}
		
		private function onDragStop(e:MouseEvent):void 
		{
			mouseBody.GetWorld().DestroyJoint(mouseBody.GetJointList().joint);
			mouseBody.GetWorld().DestroyBody(mouseBody);
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, onDrag);
			stage.removeEventListener(MouseEvent.MOUSE_UP, onDragStop);
		}
		
		override protected function onAddedToStage(e:Event):void 
		{
			super.onAddedToStage(e);
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
			animateIn(1);
		}
		
		private function onFillColorChange(e:Event):void 
		{
			dirty = true;
		}
		
		override protected function onClick(e:MouseEvent):void 
		{
			super.onClick(e);
			for (var joint:b2JointEdge = body.GetJointList(); joint; joint = joint.next)
			{
				trace(joint.joint);
				if (joint.joint.GetUserData() is GlobalSettings.instance.defaultConnectionSecondaryClass && joint.joint.GetBodyB() == body) 
				{
					if (Selection.isSelected(this))
					{
						Selection.select(joint.joint.GetUserData());
					}
					else
					{
						Selection.deselect(joint.joint.GetUserData());
					}
				}
			}
		}
		
		protected function draw():void 
		{
			graphics.clear();
			for (var fixture:b2Fixture = body.GetFixtureList(); fixture; fixture = fixture.GetNext())
			{
				graphics.lineStyle(6, _colorLine, 1, true, LineScaleMode.NONE, CapsStyle.SQUARE);
				graphics.beginFill(_colorFill, 1);
				var shape:b2Shape = fixture.GetShape();
				if (shape is b2CircleShape)
				{
					var radius:Number = (shape as b2CircleShape).GetRadius() / SceneGrapherMain.WORLDSCALE;
					if (animate) radius *= easedAnimationValue;
					graphics.drawCircle(0, 0, radius);
				}
				graphics.endFill();
			}
			dirty = false;
		}
		
		protected function onEnterFrame(e:Event):void 
		{
			x = body.GetPosition().x / SceneGrapherMain.WORLDSCALE;
			y = body.GetPosition().y / SceneGrapherMain.WORLDSCALE;
			if (dirty) draw();
		}
		
		public function get body():b2Body 
		{
			return _body;
		}
		
		override protected function onRemovedFromStage(e:Event):void 
		{
			removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			_body.GetWorld().DestroyBody(_body);
			_body.SetUserData(null);
			_body = null;
			super.onRemovedFromStage(e);
		}
		
		public function get radius():Number 
		{
			for (var fixture:b2Fixture = body.GetFixtureList(); fixture; fixture = fixture.GetNext())
			{
				var shape:b2Shape = fixture.GetShape();
				if (shape is b2CircleShape)
				{
					return (shape as b2CircleShape).GetRadius();
				}
			}
			return 10;
		}
		
		override public function set colorFill(value:uint):void 
		{
			if (value == _colorFill) return;
			super.colorFill = value;
			dirty = true;
		}
		
		override public function set colorLine(value:uint):void 
		{
			if (value == _colorLine) return;
			super.colorLine = value;
			dirty = true;
		}
	}

}