package com.bunnybones.color 
{
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	
	/**
	 * ...
	 * @author Tomasz Dysinski
	 */
	public class Color3D
	{
		static private var staticInitd:Boolean;
		static private var hueMatrix:Matrix3D;
		static private var hueMatrixInv:Matrix3D;
		static private var saturationMatrix:Matrix3D;
		static private var saturationMatrixInv:Matrix3D;
		static private var valueMatrix:Matrix3D;
		static private var valueMatrixInv:Matrix3D;
		private var colorVector:Vector3D;
		private var colorCache:Color;
		
		public function Color3D(hex:uint, useAlpha:Boolean = false) 
		{
			staticInit();
			colorCache = new Color(hex, useAlpha);
			colorVector = new Vector3D(colorCache.r, colorCache.g, colorCache.b);
			colorVector.x = colorCache.r;
			colorVector.y = colorCache.g;
			colorVector.z = colorCache.b;
		}
		
		static private function staticInit():void 
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
			colorCache.r = Math.max(Math.min(colorVector.x, 255), 0);
			colorCache.g = Math.max(Math.min(colorVector.y, 255), 0);
			colorCache.b = Math.max(Math.min(colorVector.z, 255), 0);
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
			return colorCache.hexRGB;
		}
		
		public function get r():int 
		{
			return colorCache.r;
		}
		
		public function set r(value:int):void 
		{
			colorVector.x = value;
			colorCache.r = Math.max(Math.min(colorVector.x, 255), 0);
		}
		
		
		public function get g():int 
		{
			return colorCache.g;
		}
		
		public function set g(value:int):void 
		{
			colorVector.y = value;
			colorCache.g = Math.max(Math.min(colorVector.y, 255), 0);
		}
		
		
		public function get b():int 
		{
			return colorCache.b;
		}
		
		public function set b(value:int):void 
		{
			colorVector.z = value;
			colorCache.b = Math.max(Math.min(colorVector.z, 255), 0);
		}
		
		
		public function get a():int 
		{
			return colorCache.a;
		}
		
		public function set a(value:int):void 
		{
			colorCache.a = value;
		}
		
		public function get alpha():int 
		{
			return colorCache.alpha;
		}
		
		public function set alpha(value:int):void 
		{
			colorCache.alpha = value;
		}
		
	}

}