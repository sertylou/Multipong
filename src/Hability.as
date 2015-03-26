package 
{
	import starling.display.Sprite;
	
	public class Hability extends Sprite 
	{
		private var habFunction : String;
		
		public function Hability() 
		{
			super();
			
		}
		
		public function DoThing (ball:Ball) : void
		{
			switch (habFunction)
			{
				case "wall":
					MakeBallReboot();
					break;
				default:
					habFunction = "wall";
					DoThing();
					break;
			}
		}
		
		// Hability Functions --------------
		
		private function MakeBallReboot (ball:Ball) : void
		{
			ball.Chocar(true);
		}
		
	}

}