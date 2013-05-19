package com.bunnybones.color 
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	
	/**
	 * ...
	 * @author Tomasz Dysinski
	 */
	public class Color3D extends EventDispatcher
	{
		static private var staticInitd:Boolean;
		static private var hueMatrix:Matrix3D;
		static private var hueMatrixInv:Matrix3D;
		static private var saturationMatrix:Matrix3D;
		static private var saturationMatrixInv:Matrix3D;
		static private var valueMatrix:Matrix3D;
		static private var valueMatrixInv:Matrix3D;
		
		static private var redMatrix:Matrix3D;
		static private var redMatrixInv:Matrix3D;
		static private var greenMatrix:Matrix3D;
		static private var greenMatrixInv:Matrix3D;
		static private var blueMatrix:Matrix3D;
		static private var blueMatrixInv:Matrix3D;
		
		private var colorVector:Vector3D;
		private var colorCache:Color;
		private var safe:Boolean;
		private var _parent:Color3D;
		private var _children:Vector.<Color3D>;
		private var _transform:Matrix3D;
		private var useAlpha:Boolean;
		
		public function Color3D(hex:uint, useAlpha:Boolean = false, safe:Boolean = true) 
		{
			this.useAlpha = useAlpha;
			this.safe = safe;
			staticInit();
			_children = new Vector.<Color3D>;
			colorCache = new Color(hex, useAlpha, safe);
			colorVector = new Vector3D(colorCache.r, colorCache.g, colorCache.b);
			colorVector.x = colorCache.r;
			colorVector.y = colorCache.g;
			colorVector.z = colorCache.b;
		}
		
		public function giveBirth(colorMatrix:Matrix3D = null):Color3D
		{
			dtrace("birth");
			var child:Color3D = clone();
			addChild(child);
			child.transform = colorMatrix;
			return child;
		}
		
		public function clone():Color3D
		{
			var clone:Color3D = new Color3D(hex, useAlpha, safe);
			return clone;
		}
		
		private function addChild(child:Color3D):Color3D
		{
			child.parent = this;
			var index:int = _children.indexOf(child);
			if (index == -1) {
				_children = _children.splice(index, 1);
			}
			_children.push(child);
			return child;
		}
		
		public function set parent(value:Color3D):void 
		{
			if (_parent) _parent.removeEventListener(Event.CHANGE, onParentChange);
			_parent = value;
			if (_parent) _parent.addEventListener(Event.CHANGE, onParentChange);
		}
		
		private function onParentChange(e:Event):void 
		{
			updateFromParent();
		}
		
		private function updateFromParent():void 
		{
			var temp:Vector3D = parent.getTransformed();
			colorVector.x = temp.x;
			colorVector.y = temp.y;
			colorVector.z = temp.z;
			a = parent.getTransformedA();
			updateCacheFromVector();
		}
		
		private function getTransformedA():Number
		{
			//TODO: transform a, with a 1 dimensional matrix
			return a;
		}
		
		public function getTransformed():Vector3D
		{
			//dtag(transform, colorVector);
			if (transform) {
				return transform.transformVector(colorVector);
			} else {
				return colorVector;
			}
		}
		
		static public function staticInit():void 
		{
			if (staticInitd) return;
			staticInitd = true;
			var alignToHSVAxis:Matrix3D = new Matrix3D();
			alignToHSVAxis.appendRotation(45, Vector3D.X_AXIS);
			alignToHSVAxis.appendRotation(-36, Vector3D.Y_AXIS);
			var alignToHSVAxisInv:Matrix3D = alignToHSVAxis.clone();
			alignToHSVAxisInv.invert();
			
			hueMatrix = new Matrix3D();
			hueMatrix.append(alignToHSVAxis);
			hueMatrix.appendRotation(2, Vector3D.Z_AXIS);
			hueMatrix.append(alignToHSVAxisInv);
			hueMatrixInv = hueMatrix.clone();
			hueMatrixInv.invert();
			
			saturationMatrix = new Matrix3D();
			saturationMatrix.append(alignToHSVAxis);
			saturationMatrix.appendScale(1.05, 1.05, 1);
			saturationMatrix.append(alignToHSVAxisInv);
			saturationMatrixInv = saturationMatrix.clone();
			saturationMatrixInv.invert();
			
			valueMatrix = new Matrix3D();
			valueMatrix.append(alignToHSVAxis);
			valueMatrix.appendTranslation(0, 0, 5);
			valueMatrix.append(alignToHSVAxisInv);
			valueMatrixInv = valueMatrix.clone();
			valueMatrixInv.invert();
			
			redMatrix = new Matrix3D();
			redMatrix.appendTranslation(-1, 0, 0);
			redMatrixInv = redMatrix.clone();
			redMatrix.invert();
			
			greenMatrix = new Matrix3D();
			greenMatrix.appendTranslation(0, -1, 0);
			greenMatrixInv = greenMatrix.clone();
			greenMatrix.invert();
			
			blueMatrix = new Matrix3D();
			blueMatrix.appendTranslation(0, 0, -1);
			blueMatrixInv = blueMatrix.clone();
			blueMatrix.invert();
			
		}
		
		static public function getHueMatrix(amt:Number):Matrix3D
		{
			var temp:Matrix3D = new Matrix3D();
			appendMatrixStep(temp, hueMatrix, hueMatrixInv, amt);
			return temp;
		}
		
		static private function appendMatrixStep(destMatrix:Matrix3D, srcMatrix:Matrix3D, srcMatrixInv:Matrix3D, amt:Number):void 
		{
			while (amt >= 1) {
				amt--;
				destMatrix.append(srcMatrix);
			}
			while (amt <= -1) {
				amt++;
				destMatrix.append(srcMatrixInv);
			}
		}
		
		static public function getSaturationMatrix(amt:Number):Matrix3D
		{
			var temp:Matrix3D = new Matrix3D();
			appendMatrixStep(temp, saturationMatrix, saturationMatrixInv, amt);
			return temp;
		}
		
		static public function getValueMatrix(amt:Number):Matrix3D
		{
			var temp:Matrix3D = new Matrix3D();
			appendMatrixStep(temp, valueMatrix, valueMatrixInv, amt);
			return temp;
		}
		
		static public function getRedMatrix(amt:Number):Matrix3D
		{
			var temp:Matrix3D = new Matrix3D();
			appendMatrixStep(temp, redMatrix, redMatrixInv, amt);
			return temp;
		}
		
		static public function getGreenMatrix(amt:Number):Matrix3D
		{
			var temp:Matrix3D = new Matrix3D();
			appendMatrixStep(temp, greenMatrix, greenMatrixInv, amt);
			return temp;
		}
		
		static public function getBlueMatrix(amt:Number):Matrix3D
		{
			var temp:Matrix3D = new Matrix3D();
			appendMatrixStep(temp, blueMatrix, blueMatrixInv, amt);
			return temp;
		}
		
		public function rotateHue(degrees:Number = 1):void 
		{
			while (degrees >= 1)
			{
				degrees--;
				colorVector = hueMatrix.transformVector(colorVector);
			}
			while (degrees <= -1) 
			{
				degrees++;
				colorVector = hueMatrixInv.transformVector(colorVector);
			}
			updateCacheFromVector();
		}
		
		public function saturate(amt:Number = 1):void 
		{
			while (amt >= 1)
			{
				amt--;
				colorVector = saturationMatrix.transformVector(colorVector);
			}
			while (amt <= -1)
			{
				amt++;
				colorVector = saturationMatrixInv.transformVector(colorVector);
			}
			updateCacheFromVector();
		}
		
		public function brighten(amt:Number = 1):void 
		{
			while (amt >= 1) 
			{
				amt--;
				colorVector = valueMatrix.transformVector(colorVector);
			}
			while (amt <= -1)
			{
				amt++;
				colorVector = valueMatrixInv.transformVector(colorVector);
			}
			updateCacheFromVector();
		}
		
		private function updateCacheFromVector():void 
		{
			var temp:Vector3D = transform ? transform.transformVector(colorVector) : colorVector;
			if (safe) {
				colorCache.r = Math.max(Math.min(temp.x, 255), 0);
				colorCache.g = Math.max(Math.min(temp.y, 255), 0);
				colorCache.b = Math.max(Math.min(temp.z, 255), 0);
			} else {
				colorCache.r = temp.x;
				colorCache.g = temp.y;
				colorCache.b = temp.z;
			}
			
			dispatchEvent(new Event(Event.CHANGE));
			//dtrace(colorCache);
		}
		
		public function clamp():void 
		{
			colorVector.x = Math.max(Math.min(colorVector.x, 255), 0);
			colorVector.y = Math.max(Math.min(colorVector.y, 255), 0);
			colorVector.z = Math.max(Math.min(colorVector.z, 255), 0);
		}
		
		public function get hex():uint
		{
			return useAlpha ? colorCache.hexARGB : colorCache.hexRGB;
		}
		
		public function get r():int 
		{
			return colorCache.r;
		}
		
		public function set r(value:int):void 
		{
			colorVector.x = value;
			if(safe) colorCache.r = Math.max(Math.min(colorVector.x, 255), 0);
			else colorCache.r = colorVector.x;
			dispatchEvent(new Event(Event.CHANGE));
		}
		
		
		public function get g():int 
		{
			return colorCache.g;
		}
		
		public function set g(value:int):void 
		{
			colorVector.y = value;
			if (safe) colorCache.g = Math.max(Math.min(colorVector.y, 255), 0);
			else colorCache.g = colorVector.y;
			dispatchEvent(new Event(Event.CHANGE));
		}
		
		
		public function get b():int 
		{
			return colorCache.b;
		}
		
		public function set b(value:int):void 
		{
			colorVector.z = value;
			if(safe) colorCache.b = Math.max(Math.min(colorVector.z, 255), 0);
			else colorCache.b = colorVector.z;
			dispatchEvent(new Event(Event.CHANGE));
		}
		
		
		public function get a():int 
		{
			return colorCache.a;
		}
		
		public function set a(value:int):void 
		{
			if(safe) colorCache.a = Math.max(Math.min(value, 255), 0);
			else colorCache.a = value;
			dispatchEvent(new Event(Event.CHANGE));
		}
		
		public function get alpha():Number 
		{
			return colorCache.alpha;
		}
		
		public function set alpha(value:Number):void 
		{
			colorCache.alpha = value;
			dispatchEvent(new Event(Event.CHANGE));
		}
		
		public function get parent():Color3D 
		{
			return _parent;
		}
		
		public function get transform():Matrix3D 
		{
			return _transform;
		}
		
		public function set transform(value:Matrix3D):void 
		{
			_transform = value;
		}
		
		override public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void 
		{
			//dtag("adding");
			super.addEventListener(type, listener, useCapture, priority, useWeakReference);
		}
	}

}