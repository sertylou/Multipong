package 
{
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.textures.Texture;
	
	public class Hability extends Sprite 
	{
		private var habFunction : int;
		
		private var picture : Image;
		
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
		
		private function GetTexture () : Texture
		{
			switch (habFunction)
			{
				case 0:
					return Assets.getTexture("BallPic");
				default:
					return Assets.getTexture("BallPic");
			}
			return null;
		}
		
		public function DoThing (ball:Ball) : void
		{
			switch (habFunction)
			{
				case 0: // Wall effect
					MakeBallReboot(ball);
					break;
				default:
					habFunction = 0;
					DoThing(ball);
					break;
			}
		}
		
		// Hability Functions --------------
		
		private function MakeBallReboot (ball:Ball) : void
		{
			ball.CollideWith(this);
		}
		
	}

}