package com.bunnybones.time 
{
	import flash.display.Stage;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	/**
	 * ...
	 * @author Tomasz Dysinski
	 */
	public class Clock 
	{
		static private var _time:Number = 0;
		
		public function Clock() 
		{
			
		}
		static public function bind(stage:Stage):void
		{
			var timer:Timer = new Timer(20);
			timer.addEventListener(TimerEvent.TIMER, onTimer);
			timer.start();
		}
		
		static private function onTimer(e:TimerEvent):void 
		{
			_time = (new Date()).time;
		}
		
		static public function get time():Number 
		{
			return _time;
		}
	}

}