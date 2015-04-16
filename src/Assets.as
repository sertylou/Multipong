package 
{
	import flash.display.Bitmap;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.utils.Dictionary;
	import starling.textures.Texture;
	public class Assets 
	{
		[Embed(source = "../media/pictures/ball.png")]
		public static const BallPic:Class;
		
		[Embed(source = "../media/pictures/Black.jpg")]
		public static const StickPic:Class;
		
		[Embed(source = "../media/pictures/Block.png")]
		public static const BloquePic:Class;
		
		[Embed(source = "../media/pictures/SpeedRay.jpg")]
		public static const SpeedRayPic:Class;
		
		[Embed(source = "../media/pictures/FireBall.jpg")]
		public static const FireballPic:Class;
		
		private static var gameTextures:Dictionary = new Dictionary();
		                   
		public static function getTexture (name:String):Texture
		{
			if (gameTextures[name] == undefined)
			{
				var bitmap:Bitmap = new Assets[name]();
				gameTextures[name] = Texture.fromBitmap(bitmap);
			}
			return gameTextures[name];
		}
		
		// Sonidos-------------------------------
		/*
		[Embed(source = "../media/sounds/A.wav")]
		public static const Do:Class;
		
		[Embed(source = "../media/sounds/B.wav")]
		public static const Re:Class;
		
		[Embed(source = "../media/sounds/C.wav")]
		public static const Mi:Class;
		
		[Embed(source = "../media/sounds/D.wav")]
		public static const Fa:Class;
		
		[Embed(source = "../media/sounds/E.wav")]
		public static const Fa:Class;
		
		[Embed(source = "../media/sounds/F.wav")]
		public static const La:Class;
		
		[Embed(source = "../media/sounds/G.wav")]
		public static const Si:Class;
		
		private static var gameSounds:Dictionary = new Dictionary();
		
		public static function GetSound (name:String):Sound
		{
			if (gameSounds[name] == undefined)
			{
				var sonido:Sound = new Assets[name]();
				gameSounds[name] = Texture.fromBitmap(bitmap);
			}
			return gameSounds[name];
		}*/
		
	}

}