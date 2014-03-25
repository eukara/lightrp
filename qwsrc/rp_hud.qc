// *******
// LIGHT ROLEPLAY HUD
// *******
// Based off http://www.quake-1.com/docs/quakesrc.org/49.html

void() RP_PlayerID =
{
	local	vector	src;
	string	trackp;
	
	if(self.rp_menutime > time)
	return;

	src = self.origin + v_forward*10;
	src_z = self.absmin_z + self.size_z * 0.7;
	traceline (src, src + v_forward*124, FALSE, self);
	
		if (trace_ent.classname == "player" && trace_ent.health > 0)
		{
				trackp = ftos(trace_ent.health);
				centerprint(self, "Name: ",trace_ent.netname, "\nHealth: ", trackp, "\nJob: ",trace_ent.rp_title, "\n");
		}
		else if (trace_ent.classname == "door")
		{
			if(trace_ent.rp_owner == world)
				centerprint(self, "Unowned Door\n-Buy for 20$-\n");
			else
				centerprint(self, "Owned by ",trace_ent.rp_owner.netname, "\n");
		}
		
	self.rp_menutime = time + 1;
};