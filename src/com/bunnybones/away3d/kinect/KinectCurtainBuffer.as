package com.bunnybones.away3d.kinect 
{
	import com.adobe.utils.AGALMiniAssembler;
	import flash.display.BitmapData;
	import flash.display3D.Context3D;
	import flash.display3D.Context3DBlendFactor;
	import flash.display3D.Context3DCompareMode;
	import flash.display3D.Context3DProgramType;
	import flash.display3D.Context3DVertexBufferFormat;
	import flash.display3D.IndexBuffer3D;
	import flash.display3D.Program3D;
	import flash.display3D.VertexBuffer3D;
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	/**
	 * ...
	 * @author Tomasz Dysinski
	 */
	public class KinectCurtainBuffer 
	{
		private var hasData:Boolean;
		private var indexBuffer:IndexBuffer3D;
		private var vertexCoordBuffer:VertexBuffer3D;
		private var vertexDepthBuffer:VertexBuffer3D;
		private var width:int;
		private var height:int;
		private var numVertices:int;
		private var programBuffer:Program3D;
		private var programConstants:Vector.<Number>;
		
		public function KinectCurtainBuffer(width:int = 160, height:int = 120) 
		{
			this.width = width;
			this.height = height;
			numVertices = width * height;
		}
		
		private function init(context3D:Context3D, depthMap:BitmapData):void 
		{
			var ix:int;
			//context3D.enableErrorChecking = true;
			var iy:int;
			dtrace("new buffer", numVertices, numVertices * 3);
			vertexCoordBuffer = context3D.createVertexBuffer(numVertices, 3);
			var coordBufferData:ByteArray = new ByteArray();
			coordBufferData.endian = Endian.LITTLE_ENDIAN;
			var halfWidth:int = width * .5;
			var halfHeight:int = height * .5;
			for (iy = 0; iy < height; iy++) 
			{
				for (ix = 0; ix < width; ix++) 
				{
					coordBufferData.writeFloat((2-ix/halfWidth)-1);
					coordBufferData.writeFloat((2-iy/halfHeight)-1);
					coordBufferData.writeFloat(0);
				}
			}
			vertexCoordBuffer.uploadFromByteArray(coordBufferData, 0, 0, numVertices);
			vertexDepthBuffer = context3D.createVertexBuffer(numVertices, 1);
			var indexData:ByteArray = new ByteArray();
			indexData.endian = Endian.LITTLE_ENDIAN;
			for (iy = 1; iy < height; iy++) 
			{
				for (ix = 1; ix < width; ix++) 
				{
					indexData.writeShort((iy - 1) * width + ix);
					indexData.writeShort((iy) * width + ix);
					indexData.writeShort((iy - 1) * width + ix - 1);
					
					indexData.writeShort((iy - 1) * width + ix - 1);
					indexData.writeShort((iy) * width + ix);
					indexData.writeShort((iy) * width + ix - 1);
				}
			}
			var indexCount:int = (height-1) * (width-1) * 6;
			dtrace("new index buffer", indexCount);
			indexBuffer = context3D.createIndexBuffer(indexCount);
			indexBuffer.uploadFromByteArray(indexData, 0, 0, indexCount);
			
			programBuffer = context3D.createProgram();
			
			var vertexSource:String = 	"mov vt0, va0\n" +
										"mov vt0.z, va1.x\n" +
										"mul vt0.z, vt0.z, vc0.x\n" +
										"mov op, vt0\n" +
										"mov vt1, va1\n" +
										"sub vt1, vc0.w, vt1\n" +
										"mul vt1, vt1, vc0.y\n" +
										"mov vt1, vt1.x\n" +
										"mov v0, vt1\n";
			
			var fragmentSource:String = "mov oc, v0\n";
			
			var agal:AGALMiniAssembler = new AGALMiniAssembler(true);
			var vertexProgram:ByteArray = agal.assemble(Context3DProgramType.VERTEX, vertexSource, true);
			var fragmentProgram:ByteArray = agal.assemble(Context3DProgramType.FRAGMENT, fragmentSource, true);
			programBuffer.upload(vertexProgram, fragmentProgram);
			
			programConstants = new Vector.<Number>;
			programConstants.push(0, .01, 1, 255);
			
			hasData = true;
		}
		
		public function update(context3D:Context3D, depthMap:BitmapData):void 
		{
			dtrace("update");
			if (!hasData) init(context3D, depthMap);
			var imageData:ByteArray = depthMap.getPixels(depthMap.rect);
			imageData.position = 0;
			var depthData:ByteArray = new ByteArray();
			depthData.endian = Endian.LITTLE_ENDIAN;
			while (imageData.bytesAvailable > 0)
			{
				imageData.position += 2;
				depthData.writeFloat(imageData.readUnsignedByte());
				imageData.position += 1;
			}
			vertexDepthBuffer.uploadFromByteArray(depthData, 0, 0, numVertices);
		}
		
		public function render(context3D:Context3D):void 
		{
			if (hasData)
			{
				dtrace("render");
				
				//context3D.setDepthTest(false, Context3DCompareMode.ALWAYS);
				context3D.setBlendFactors(Context3DBlendFactor.ONE, Context3DBlendFactor.ONE);
				context3D.setProgram(programBuffer);
				context3D.setProgramConstantsFromVector(Context3DProgramType.VERTEX, 0, programConstants, 1);
				context3D.setVertexBufferAt(0, vertexCoordBuffer, 0, Context3DVertexBufferFormat.FLOAT_3);
				context3D.setVertexBufferAt(1, vertexDepthBuffer, 0, Context3DVertexBufferFormat.FLOAT_1);
				context3D.drawTriangles(indexBuffer);
				//context3D.present();
			}
		}
		
	}

}