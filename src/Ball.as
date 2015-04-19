package 
{
	import screens.GameScreen;
	
	import com.greensock.plugins.TintPlugin;
	import flash.desktop.ClipboardFormats;
	import flash.events.TimerEvent;
	import flash.utils.Dictionary;
	import flash.utils.Timer;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.EnterFrameEvent;
	import starling.events.Event;
	import starling.textures.Texture;
	
	public class Ball extends Sprite 
	{
		//******** ATRIBUTOS ****************
		
		// Velocidad de la pelota
		public var Speed : Number;
		// Refraccion: (explicar un poco mas)
		public var Refraction : Number = 0.5;
		// Movimiento permitido?
		public var MovementEnabled : Boolean = true;
		
		// Movimiento en X
		private var movementX : Number;
		// Obtener el sentido en X: 1:Derecha -1:Izquierda
		private function get senseX () : int
		{
			if (movementX > 0) return 1;
			if (movementX < 0) return -1;
			return 0;
		}
		// Movimiento en Y
		private var movementY : Number;
		// Obtener el sentido en X: 1:Abajo, -1: Arriba
		private function get senseY () : int
		{
			if (movementY > 0) return 1;
			if (movementY < 0) return -1;
			return 0;
		}
		
		// Imagen de la pelota
		private var picture: Image;
		// Obtener la imagen (solo lectura)
		public function set Picture (pic:Texture) : void { picture.texture = pic; }
		
		// Tiempo que tiene que pasar para incrementar la velocidad
		private var timeToIncrease : Number = 3;
		// Temporizador que se incrementa para comparar con timeToIncrease
		private var timer : Number = 0;
		// Incremento en la velocidad cada vez que aumenta
		private var speedIncrease : Number = 0.05;
		
		// *********** CONSTRUCTOR *****************************
		
		public function Ball(posX : int, posY : int, width : int, height : int, pic : Texture) 
		{
			super();
			
			movementX = 1;
			movementY = 1;
			Speed = 2;
						
			picture = new Image(pic);
			this.x = posX;
			this.y = posY;
			picture.width = width;
			picture.height = height;
			this.addChild(picture);
			
			this.addEventListener(starling.events.Event.ENTER_FRAME, Move);
		}
		
		
		//********* COLISIONES *************************
		
		// old coordenates
		private var oldX : int;
		private var oldY : int;
		
		// Objeto con el que está colisionando la pelota
		private var collisionObject : Sprite = null;
		
		// Empezar colision con el objeto especificado
		public function StartCollisionWith (other:Sprite) : void
		{
			collisionObject = other;
			this.addEventListener(starling.events.Event.ENTER_FRAME, waitToEndCollision);
		} 
		// Terminar colision con el objeto con el que esté colisionando
		public function EndCollision () : void
		{
			collisionObject = null;
			this.removeEventListener(Event.ENTER_FRAME, waitToEndCollision);
		}
		// Está colisionando con algo?
		public function IsColliding () : Boolean
		{
			return collisionObject != null;
		}
		
		// Chocar y empezar colision con un objeto
		public function CollideWith (other:Sprite) : void
		{
			
			var OldX : int = oldX;
			var OldY : int = oldY;
			var NewX : int = x;
			var NewY : int = y;
			
			GameScreen.debugg += "iep";
			
			if (senseX == 1)
			{
				OldX += width;
				NewX += width;
			}
			if (senseY == 1)
			{
				OldY += height;
				NewY += height;
			}
			
			if (OldX > NewX && OldY > NewY)
			{
				var aux : int;
				
				aux = NewX;
				NewX = OldX;
				OldX = aux;
				
				aux = NewY;
				NewY = OldY;
				OldY = aux;
			}
			
			Chocar (getCollisionType(OldX, OldY, NewX, NewY, other));
			/*var colType : String = getCollisionType(OldX, OldY, NewX, NewY, other);
			if (colType != "none") GameScreen.debugg = "";
			Chocar (colType);*/
			
			StartCollisionWith(other);
		}
		
		// mirar si aun estamos colisionando con el objeto
		private function waitToEndCollision () : void
		{
			if (collisionObject != null && !MyFunctions.imageCollision (this, collisionObject)) 
				EndCollision();
		}
		
		private function getCollisionType (minX:int, minY:int, maxX:int, maxY:int, pic:Sprite) : String
		{		
			if (minX >= maxX && minY >= maxY) return "none"; //*
			
			var xx : int = (minX + maxX) / 2;
			var yy : int = (minY + maxY) / 2;
			
			if (xx == pic.x || xx == pic.x + pic.width) return "side";
			if (yy == pic.y || yy == pic.y + pic.height) return "plane";
			
			if (minX == pic.x || minX == pic.x + pic.width) return "side";
			if (minY == pic.y || minY == pic.y + pic.height) return "plane";
			
			if (maxX == pic.x || maxX == pic.x + pic.width) return "side";
			if (maxY == pic.y || maxY == pic.y + pic.height) return "plane";
			
			if (MyFunctions.Abs(maxX - minX) <= 1 && MyFunctions.Abs(maxY - minY) <= 1) return "none"; //*
			
			if (!MyFunctions.pointIn(xx, yy, pic))
				return getCollisionType(xx, yy, maxX, maxY, pic);

			return getCollisionType (minX, minY, xx, yy, pic);
		}
		
		// ************ COMPORTAMIENTO DE LA PELOTA ***************************
		
		// Mover pelota
		public function Move(event:Event) : void
		{
			if (MovementEnabled)
			{
				oldX = x;
				oldY = y;
				x += movementX * Speed;
				y += movementY * Speed;
				
				timer += 0.1;
				if (timer >= timeToIncrease)
				{
					timer = 0;
					Speed += speedIncrease;
				}
			}
		}
		
		// Colisionar
		public function Chocar(Sense : String) : void
		{
			if (Sense == "none")
			{
				//MovementEnabled = false;
				return;
			}
			if (Sense == "side") {	
				movementX = 2 * (1 - Refraction) * (-senseX);
				movementY = 2 * Refraction * senseY;
			}
			else {
				movementX = 2 * Refraction * senseX;
				movementY = 2 * (1 - Refraction) * ( -senseY);
			}
		}
		
		
		// CONTROL DE HABILIDADES
		
		// Habilidades activas (se identifican por nombre)
		private var activeHabs : Vector.<String> = new <String>[];
		// temporizador de cada habilidad activa
		private var habsTimers : Vector.<Number> = new <Number>[];
		// tiempo para acabar una habilidad
		private var timeHability : Number = 0.5;
		
		// Añadir nueva habilidad activa
		public function AddHability (hab:String) : void
		{
			activeHabs.push (hab);
			habsTimers.push (0);
		}
		
		
		// Manejar habilidades activas
		private function ControlHabilities () : void
		{
			var l : int = activeHabs.length;
			for (var i : int = 0; i < l; ++i)
			{
				habsTimers[i] += 0.016;
				if (habsTimers[i] > timeHability)
				{
					var hab : String = activeHabs[i];
					switch (hab)
					{
						case "speed":
							Speed /= 1.5;
							break;
					}
					
					activeHabs.splice (i, 1);
					habsTimers.splice (i, 1);
					--i;
					l = activeHabs.length;
				}
			}
		}
		
		//**********************************
	}

}