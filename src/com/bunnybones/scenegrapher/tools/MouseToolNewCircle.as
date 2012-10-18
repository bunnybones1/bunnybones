package com.bunnybones.scenegrapher.tools 
{
	/**
	 * ...
	 * @author Tomasz Dysinski
	 */
	import com.bunnybones.scenegrapher.GlobalSettings;
	import Box2D.Collision.Shapes.b2CircleShape;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2BodyDef;
	import Box2D.Dynamics.b2FixtureDef;
	import com.bunnybones.scenegrapher.CursorCircleHandle;
	import com.bunnybones.scenegrapher.Handle;
	import com.bunnybones.scenegrapher.LabelledCircleHandle;
	import com.bunnybones.scenegrapher.SceneGrapherMain;
	import com.bunnybones.scenegrapher.tools.Destroyer;
	import com.bunnybones.scenegrapher.tools.MouseTool;
	import com.bunnybones.scenegrapher.tools.MouseToolNewCircle;
	import flash.display.Stage;
	import flash.events.MouseEvent;
	public class MouseToolNewCircle extends MouseTool
	{
		
		private var tempCursorHandle:CursorCircleHandle;
		public function MouseToolNewCircle() 
		{
			super();
		}
		
		override public function init():void 
		{
			super.init();
			sceneGrapher.stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
		}
		
		private function onMouseDown(e:MouseEvent):void 
		{
			if (e.target is Stage)
			{
				if (e.ctrlKey)
				{
					//trace("new handle start");
					sceneGrapher.stage.addEventListener(MouseEvent.MOUSE_MOVE, onNewHandleDrag);
					sceneGrapher.stage.addEventListener(MouseEvent.MOUSE_UP, onNewHandleStop);
					var bodyDef:b2BodyDef = new b2BodyDef();
					bodyDef.position.x = sceneGrapher.lastMouseMovePositionLocal.x * SceneGrapherMain.WORLDSCALE;
					bodyDef.position.y = sceneGrapher.lastMouseMovePositionLocal.y * SceneGrapherMain.WORLDSCALE;
					var tempBody:b2Body = sceneGrapher.graph.CreateBody(bodyDef);
					var fixtureDef:b2FixtureDef = new b2FixtureDef();
					fixtureDef.friction = .5;
					fixtureDef.density = 1;
					fixtureDef.restitution = .5;
					fixtureDef.shape = new b2CircleShape(0);
					tempBody.CreateFixture(fixtureDef);
					tempBody.SetType(b2Body.b2_staticBody);
					tempCursorHandle = sceneGrapher.createHandle(tempBody, CursorCircleHandle, -2) as CursorCircleHandle;
				}
			}
		}
		
		private function onNewHandleDrag(e:MouseEvent):void 
		{
			//trace("new handle drag");
		}
		
		private function onNewHandleStop(e:MouseEvent):void 
		{
			//trace("new handle stop");
			sceneGrapher.stage.removeEventListener(MouseEvent.MOUSE_MOVE, onNewHandleDrag);
			sceneGrapher.stage.removeEventListener(MouseEvent.MOUSE_UP, onNewHandleStop);
			var bodyDef:b2BodyDef = new b2BodyDef();
			bodyDef.position.x = tempCursorHandle.body.GetPosition().x;
			bodyDef.position.y = tempCursorHandle.body.GetPosition().y;
			bodyDef.linearDamping = 1;
			var body:b2Body = sceneGrapher.graph.CreateBody(bodyDef);
			var fixtureDef:b2FixtureDef = new b2FixtureDef();
			fixtureDef.friction = .5;
			fixtureDef.density = 1;
			fixtureDef.restitution = .5;
			fixtureDef.shape = new b2CircleShape(tempCursorHandle.radius);
			Destroyer.destroy(tempCursorHandle);
			body.CreateFixture(fixtureDef);
			body.SetType(b2Body.b2_dynamicBody);
			var handle:Handle = sceneGrapher.createHandle(body, GlobalSettings.instance.defaultCircleHandleClass);
			handle.initRename();
			sceneGrapher.atmosphere.AddBody(body);
			sceneGrapher.waterline.AddBody(body);
		}
		
		override public function deinit():void 
		{
			super.deinit();
			sceneGrapher.stage.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
		}
	}

}