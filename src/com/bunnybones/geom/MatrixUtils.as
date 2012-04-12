package com.bunnybones.geom 
{
	import com.bunnybones.console.Console;
	import flash.display.DisplayObject;
	import flash.geom.Matrix;
	/**
	 * ...
	 * @author Tomasz Dysinski
	 */
	public class MatrixUtils 
	{
		
		public function MatrixUtils() 
		{
			
		}
		
		static public function getMatrixDown(fromChild:DisplayObject, toParent:DisplayObject):Matrix
		{
			var matrices:Vector.<Matrix> = getMatrixStack(fromChild, toParent);
			//Console.singleton.print("down", matrices.length);
			var matrix:Matrix = new Matrix();
			for (var i:int = 0; i < matrices.length; i++) 
			{
				matrix.concat(matrices[i]);	
			}
			return matrix;
		}
		
		static private function getMatrixStack(fromChild:DisplayObject, toParent:DisplayObject):Vector.<Matrix>
		{
			var matrices:Vector.<Matrix> = new Vector.<Matrix>;
			if (fromChild === toParent) return matrices;
			var child:DisplayObject = fromChild;
			while (true)
			{
				if (child === toParent) return matrices;
				matrices.push(child.transform.matrix);
				child = child.parent;
			}
			return null;
		}
		
		static public function getMatrixUp(fromParent:DisplayObject, toChild:DisplayObject):Matrix
		{
			var matrices:Vector.<Matrix> = getMatrixStack(toChild, fromParent);
			//Console.singleton.print("up", matrices.length);
			var matrix:Matrix = new Matrix();
			for (var i:int = matrices.length - 1; i >= 0; i--) 
			{
				matrix.concat(matrices[i]);	
			}
			return matrix;
		}
	}

}