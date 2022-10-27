package;

import api.GameJolt;
import flixel.FlxG;
import Achievements;

class TrophyAchieve {
	public static function CheckAchieve():Void {
		Achievements.loadAchievements();
		var UsernameGJ = FlxG.save.data.gJUser;
		var TokenGJ = FlxG.save.data.gJToken;
		var achieve1:Int = Achievements.getAchievementIndex('lust');
		var achieve2:Int = Achievements.getAchievementIndex('friday_night_play');

		if (FlxG.save.data.gJLogged != null) {
			if(Achievements.isAchievementUnlocked(Achievements.achievementsStuff[achieve1][2])) {
				GameJolt.addTrophy(UsernameGJ, TokenGJ, 171700, 'lust');
			}
			if(Achievements.isAchievementUnlocked(Achievements.achievementsStuff[achieve2][2])) {
				GameJolt.addTrophy(UsernameGJ, TokenGJ, 171715, 'gigaChad');
			}
		}
	}
}