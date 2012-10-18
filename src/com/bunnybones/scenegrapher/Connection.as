package com.bunnybones.scenegrapher 
{
	import Box2D.Collision.Shapes.b2CircleShape;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.Joints.b2DistanceJoint;
	import Box2D.Dynamics.Joints.b2Joint;
	import com.bunnybones.MouseToolTip;
	import flash.display.CapsStyle;
	import flash.display.LineScaleMode;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.BlurFilter;
	import flash.filters.GlowFilter;
	
	/**
	 * ...
	 * @author Tomasz Dysinski
	 */
	public class Connection extends Handle 
	{
		public var dirty:Boolean = true;
		protected var joint:b2DistanceJoint;
		
		public function Connection(joint:b2DistanceJoint, id:int = -1) 
		{
			super(id);
			this.joint = joint;
			//posA.x / SceneGrapherMain.WORLDSCALE, posA.y / SceneGrapherMain.WORLDSCALE);
			//graphics.lineTo(posB.x / SceneGrapherMain.WORLDSCALE, posB.y / SceneGrapherMain.WORLDSCALE);
			contentType = ContentType.TRANSITION;
		}
		
		override protected function onAddedToStage(e:Event):void 
		{
			super.onAddedToStage(e);
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
			addEventListener(MouseEvent.ROLL_OVER, onRollOver);
			addEventListener(MouseEvent.ROLL_OUT, onRollOut);
		}
		
		protected function draw():void
		{
			graphics.clear();
			graphics.lineStyle(6, _colorLine, 1, true, LineScaleMode.NORMAL, CapsStyle.ROUND);
			drawShape();
			dirty = false;
		}
		
		protected function drawShape():void 
		{
			graphics.moveTo(0, 0);
			graphics.curveTo(50, -20, 100, 0);
			graphics.moveTo(93, -13);
			graphics.lineTo(100, 0);
			graphics.lineTo(87, 7);
		}
		
		protected function onEnterFrame(e:Event):void 
		{
			var posA:b2Vec2 = joint.GetBodyA().GetPosition();
			var posB:b2Vec2 = joint.GetBodyB().GetPosition();
			var delta:b2Vec2 = posA.Copy();
			delta.Subtract(posB);
			
			var radiusA:Number = (joint.GetBodyA().GetFixtureList().GetShape() as b2CircleShape).GetRadius();
			var radiusB:Number = (joint.GetBodyB().GetFixtureList().GetShape() as b2CircleShape).GetRadius();
			var radiusDeltaA:b2Vec2 = posA.Copy();
			radiusDeltaA.Subtract(posB);
			radiusDeltaA.Normalize();
			radiusDeltaA.Multiply(radiusA);
			
			x = (posA.x - radiusDeltaA.x) / SceneGrapherMain.WORLDSCALE;
			y = (posA.y - radiusDeltaA.y) / SceneGrapherMain.WORLDSCALE;
			scaleX = delta.Length() - radiusA - radiusB;
			//scaleY = scaleX;
			rotation = Math.atan2(delta.y, delta.x) / Math.PI / 2 * 360 + 180;
			
			if (dirty) draw();
		}
		
		override protected function onRemovedFromStage(e:Event):void 
		{
			removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			removeEventListener(MouseEvent.ROLL_OVER, onRollOver);
			removeEventListener(MouseEvent.ROLL_OUT, onRollOut);
			joint.GetBodyA().GetWorld().DestroyJoint(joint);
			joint = null;
			super.onRemovedFromStage(e);
		}
		
		protected function onRollOver(e:MouseEvent):void 
		{
			MouseToolTip.show(description);
		}
		
		private function onRollOut(e:MouseEvent):void 
		{
			MouseToolTip.hide();
		}
		
		override public function get description():String
		{
			return StringUtils.nameToTransitionName(name);
		}
		
		override public function get name():String
		{
			return (joint.GetBodyA().GetUserData() as Handle).name + " to " + (joint.GetBodyB().GetUserData() as Handle).name;
		}
	}
}