package com.bunnybones.time 
{
	import flash.display.Stage;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	/**
	 * ...
	 * @author Tomasz Dysinski
	 */
	public class Clock extends Timer
	{
		static private var _time:Number = 0;
		static private var _singleton:Clock;
		
		public function Clock() 
		{
			super(20);
			addEventListener(TimerEvent.TIMER, onTimer);
			start();
			_singleton = this;
		}
		static public function init():void
		{
			new Clock();
		}
		
		static private function onTimer(e:TimerEvent):void 
		{
			_time = (new Date()).time;
		}
		
		static public function get time():Number 
		{
			return _time;
		}
		
		static public function get singleton():Clock 
		{
			return _singleton;
		}
	}

}