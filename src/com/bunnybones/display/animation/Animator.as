package com.bunnybones.display.animation
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.utils.Dictionary;
	
	/**
	 * ...
	 * @author Tomasz Dysinski
	 */
	public class Animator
	{
		static public const CIRCLE:String = "circle";
		static private var animationByTarget:Dictionary = new Dictionary();
		
		public function Animator()
		{
		
		}
		
		static public function animate(target:DisplayObject):void
		{
			animationByTarget[target] = new AnimationCircle(target, Math.random() * 50 + 50, 0.0001 + Math.random() * .0005);
		}
		
	}

}
import com.bunnybones.time.Clock;
import flash.display.DisplayObject;
import flash.events.Event;

class AnimationCircle
{
	private var radius:Number;
	private var speed:Number;
	public var target:DisplayObject;
	private var originalX:Number;
	private var originalY:Number;
	
	public function AnimationCircle(target:DisplayObject, radius:Number = 100, speed:Number = .0001)
	{
		this.speed = speed;
		this.radius = radius;
		this.target = target;
		originalX = target.x;
		originalY = target.y;
		target.addEventListener(Event.ENTER_FRAME, onEnterFrame);
	}
	
	private function onEnterFrame(e:Event):void
	{
		target.x = originalX + Math.cos(Clock.time * speed) * radius;
		target.y = originalY + Math.sin(Clock.time * speed) * radius;
		//trace(target.x, target.y);
	}
}