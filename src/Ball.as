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
		public var PutoAlberto : String = "Puto jefe";		

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
		public function set Picture (pic:Texture) { picture.texture = pic; }
		
		private var timer : Number = 0;
		private var timeToIncrease : Number = 3;
		private var speedIncrease : Number = 0.05;
		private var initialSpeed : Number = 2;
		public function ResetSpeed () { Speed = initialSpeed; }
		
		// Security timers
		/* One problem we may have is the ball collisioning more than once. When the ball touches the stick, the collision detection
		 * may be faster than the time the ball requires to reboot. So we set some timers which will activate themselves when the ball
		 * bumps, in the X axis or Y axis, and will give some time to the ball to detect collision in that axis again. */
		private var timerX : int;
		private var timerY : int;
		private var securityTime : int = 10;
		private var securityX : Boolean;
		private var securityY : Boolean;
		
		// Collisions
		private var collisions : Vector.<Sprite>;
		
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
			this.addEventListener(starling.events.Event.ENTER_FRAME, securityTimers);
		}
		
		private function securityTimers () : void
		{
			if (timerX >= securityTime)
			{
				timerX = 0;
				securityX = false;
			}
			if (securityX)
				++timerX;
				
			if (timerY >= securityTime)
			{
				timerY = 0;
				securityY = false;
			}
			if (securityY)
				++timerY;
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
			if (Sense == "side" && !securityX) {	
				movementX = 2 * (1 - Refraction) * (-senseX);
				movementY = 2 * Refraction * senseY;
				securityX = true;
			}
			else if (!securityY){
				movementX = 2 * Refraction * senseX;
				movementY = 2 * (1 - Refraction) * ( -senseY);
				securityY = true;
			}
		}
		
		
		public function CollidesWith (other:Sprite) : String
		{
			if (senseX == 1)
			{
				var suposedY : int = int(Abs(x - other.x) * (movementY / movementX) * senseY + y);
				if (suposedY > other.y && suposedY < other.y + other.height) return "side";
				return "plane";
			}
			else
			{
				var suposedY : int = int(Abs(x - other.x + other.width) * (movementY / movementX) * senseY + y);
				if (suposedY > other.y && suposedY < other.y + other.height) return "side";
				return "plane";
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