package 
{
	import com.greensock.plugins.TintPlugin;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.EnterFrameEvent;
	import starling.events.Event;
	import starling.textures.Texture;
	
	public class Ball extends Sprite 
	{

		public var Speed : Number;
		public var Refraction : Number =0.5;
		
		private var movementX : Number;
		private function get senseX () : int
		{
			if (movementX > 0) return 1;
			if (movementX < 0) return -1;
			return 0;
		}
		private var movementY : Number;
		private function get senseY () : int
		{
			if (movementY > 0) return 1;
			if (movementY < 0) return -1;
			return 0;
		}
		
		private var picture: Image;
		public function set Picture (pic:Texture) : void { picture.texture = pic; }
		
		private var timer : Number = 0;
		private var timeToIncrease : Number = 3;
		private var speedIncrease : Number = 0.05;
		private var initialSpeed : Number = 2;
		public function ResetSpeed () : void{ Speed = initialSpeed; }
		
		// Collisions
		private var collisions : Vector.<Sprite> = new <Sprite>[];
		public function InCollisionWith (other:Sprite) : Boolean
		{
			if (collisions.indexOf(other) == -1) return false;
			return true;
		}
		public function StartCollisionWith (other:Sprite) : void
		{
			if (!InCollisionWith(other))
				collisions.push(other);
		} 
		public function EndCollisionWith (other:Sprite) : void
		{
			for (var i:int = 0; i < collisions.length; ++i)
			{
				if (collisions[i] == other)
				{
					collisions.splice (i, 1);
					break;
				}
			}
		}
		
		public function Ball(posX : int, posY : int, width : int, height : int, pic : Texture) 
		{
			super();
			
			movementX = 1;
			movementY = 1;
			Speed = initialSpeed;
						
			picture = new Image(pic);
			this.x = posX;
			this.y = posY;
			picture.width = width;
			picture.height = height;
			this.addChild(picture);
			
			this.addEventListener(starling.events.Event.ENTER_FRAME, Move);
		}
		
		public function Move(event:Event) : void
		{
			x += movementX * Speed;
			y += movementY * Speed;
			
			timer += 0.1;
			if (timer >= timeToIncrease)
			{
				timer = 0;
				Speed += speedIncrease;
			}
		}
		
		public function Chocar(Sense : String) : void
		{
			if (Sense == "side") {	
				movementX = 2 * (1 - Refraction) * (-senseX);
				movementY = 2 * Refraction * senseY;
			}
			else {
				movementX = 2 * Refraction * senseX;
				movementY = 2 * (1 - Refraction) * ( -senseY);
			}
		}
		
		
		public function CollideWith (other:Sprite) : void
		{
			if (!InCollisionWith (other))
			{
				if (senseX == 1)
				{
					var suposedY : int = int(Abs(x - other.x) * (movementY / movementX) * senseY + y);
					if (suposedY > other.y && suposedY < other.y + other.height) Chocar ("side");
					else Chocar("plane");
				}
				else
				{
					var suposedY : int = int(Abs(x - other.x + other.width) * (movementY / movementX) * senseY + y);
					if (suposedY > other.y && suposedY < other.y + other.height) Chocar("side");
					else Chocar("plane");
				}
				
				StartCollisionWith (other);
			}
		}
		
		private function Abs (numero:Number) : Number
		{
			if (numero >= 0) return numero;
			else return -numero;
		}
		
		private function existsCollision (object : Sprite) : Boolean
		{
			for (var i:int = 0; i < collisions.length; ++i)
				if (collisions[i] == object) return true;
			return false;
		}
	}

}