package 
{
	import starling.display.Sprite;
	
	public class MyFunctions 
	{
		
		public function MyFunctions() 
		{
			
		}
		
		// Comprueba si dos objetos colisionan
		public static function imageCollision (pic1:Sprite, pic2:Sprite) : Boolean
		{
			if (pic1.x > pic2.x + pic2.width)
				return false;
			if (pic1.x + pic1.width < pic2.x)
				return false;
			if (pic1.y > pic2.y + pic2.width)
				return false;
			if (pic1.y + pic1.height < pic2.y)
				return false;
			
			return true;
		}
		
		/*public static function imaginaryCollision (x:int, y:int, width:int, height:int, pic:Sprite) : Boolean
		{
			if (x > pic.x + pic.width)
				return false;
			if (x + width < pic.x)
				return false;
			if (y > pic.y + pic.width)
				return false;
			if (y + height < pic.y)
				return false;
			
			return true;
		}*/
		
		public static function imaginaryCollision (x:int, y:int, width:int, height:int, pic:Sprite) : Boolean
		{
			if (x < pic.x && x + width > pic.x && y < pic.y && y + height > pic.y)
				return true;
			if (x > pic.x && x < pic.x + width && y < pic.y && y + height > pic.y)
				return true;
			if (x < pic.x && x + width > pic.x && y > pic.y && y < pic.y + height)
				return true;
			if (x > pic.x && x < pic.x + width && y > pic.y && y < pic.y + height)
				return true;	
				
			return false;
		}
		
		public static function pointIn (x : int, y : int, pic:Sprite) : Boolean
		{
			if (x >= pic.x && x <= pic.x + pic.width && y >= pic.y && y <= pic.y + pic.height)
				return true;
			return false;
		}
		
		public static function Random(min:Number, max:Number):Number 
		{
			var randomNum:Number = Math.floor(Math.random() * (max - min + 1)) + min;
			return randomNum;
		}
		
		public static function Abs (numero:Number) : Number
		{
			if (numero >= 0) return numero;
			else return -numero;
		}
	}

}