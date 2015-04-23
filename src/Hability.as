package 
{
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.textures.Texture;
	
	public class Hability extends Sprite 
	{
		//********** ATRIBUTOS ****************************
		
		// Funcion de la habilidad / objeto. Cada numero representa una función
		private var habFunction : int;
		
		// Imagen del objeto
		private var picture : Image;
		
		//********** CONSTRUCTOR ************************************
		public function Hability(funcion : int, x:int, y:int, width:int, height:int) 
		{
			super();
			habFunction = funcion;
			this.x = x;
			this.y = y;
			
			picture = new Image(GetTexture());
			picture.width = width;
			picture.height = height;
			this.addChild (picture);
		}
		
		//****** FUNCTIONS ********************
		
		// Conseguir la imagen del objeto correspondiente
		private function GetTexture () : Texture
		{
			switch (habFunction)
			{
				case 0:   // Wall
					return Assets.getTexture("BloquePic");
				case 1:   // SpeedRay
					return Assets.getTexture("SpeedRayPic");
				default:
					habFunction = 0;
					return GetTexture();
			}
			return null;
		}
		
		// Hacer su cosa
		public function DoThing (ball:Ball) : void
		{
			switch (habFunction)
			{
				case 0: // Wall effect
					MakeBallReboot(ball);
					break;
				case 1: // Speed effect
					SpeedRay (ball);
					break;
				default:
					habFunction = 0;
					DoThing(ball);
					break;
			}
		}
		
		// Hability Functions --------------
		
		// 0: Rebotar
		private function MakeBallReboot (ball:Ball) : void
		{
			ball.CollideWith(this);
			ball.EndCollision ();
		}
		
		// 1: Aumentar velocidad
		private function SpeedRay (ball:Ball) : void
		{
			ball.Speed *= 1.5;
			ball.AddHability ("speed");
		}
		
	}

}