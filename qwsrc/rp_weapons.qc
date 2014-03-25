// *******
// LIGHT ROLEPLAY WEAPONS
// *******
//
// Feel free to edit these!

float(entity player) RP_SetCurrentAmmo =
{
	if (player.weapon == IT_KEYS)
	{
		player.currentammo = 0;
		player.weaponmodel = "";
		player.weaponframe = 0;
	}
	else
		return 0;
	
	return 1;
};

float() RP_WeaponAttack =
{

	if (self.weapon == IT_KEYS)
	{
		local	vector	source;

		makevectors (self.v_angle);
		source = self.origin + '0 0 16';
		traceline (source, source + v_forward*124, FALSE, self);

		if (trace_ent.classname == "door")
		{
			if(trace_ent.rp_owner == self)
			{
				if(trace_ent.rp_locked)
				{
					centerprint(self, "Your door is now unlocked.");
					self.rp_menutime = time + 2;
					trace_ent.rp_locked = 0;
					sound (self, CHAN_AUTO, "weapons/lstart.wav", 1, ATTN_NORM);
				}
				else
				{
					centerprint(self, "Your door is now locked.");
					self.rp_menutime = time + 2;
					trace_ent.rp_locked = 1;
					sound (self, CHAN_AUTO, "weapons/lstart.wav", 1, ATTN_NORM);
				}
				RP_Anim_Key_Use10();
			}
			else
			{
				centerprint(self, "Knock. Knock.");
				self.rp_menutime = time + 2;
				sound (self, CHAN_WEAPON, "player/axhit2.wav", 1, ATTN_NORM);
				RP_Anim_Key_Knock1();
			}
		}
		
		self.attack_finished = time + 1;
	}
	else
		return 0;
	
	return 1;
};
