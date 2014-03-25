void() RP_Payday_Update =
{
	local entity pl;
	string pls;
	
	pl = findradius (self.origin, 10000);
    while(pl)
    {
		if(pl.classname == "player") 
        {
			pls = ftos(pl.rp_salary);
			pl.rp_money = pl.rp_money + pl.rp_salary;
			centerprint (pl, "Payday! You received $", pls, "!\n");
		}
        pl = pl.chain;
    }
	
	self.nextthink = time + 160;
};

void() RP_Main =
{
	local entity rp_payday;
	
	RP_SetPrecaches();
	
	rp_payday = spawn();
	rp_payday.think = RP_Payday_Update;
	rp_payday.nextthink = time + 5;
};

float(float value) RP_CheckMoney =
{
	if(self.rp_money >= value)
		return TRUE;
	else
		return FALSE;
};

float(float id, entity player) RP_CheckJob =
{
	if(player.rp_job == id)
		return TRUE;
	else
		return FALSE;
};

float(float id, entity player) RP_CheckInventory =
{
	if(player.items & id)
		return TRUE;
	else
		return FALSE;
};

void() RP_BuyDoor =
{
	local	vector	source;

	makevectors (self.v_angle);
	source = self.origin + '0 0 16';
	traceline (source, source + v_forward*124, FALSE, self);

	if (trace_ent.classname == "door")
	{
		if(trace_ent.rp_owner == self)
		{
			centerprint(self, "You already own this door.");
			self.rp_menutime = time + 2;
		}
		else if (trace_ent.rp_owner == world)
		{
			if(!RP_CheckMoney(20))
			{
				centerprint(self, "You don't have enough money to buy this.");
				self.rp_menutime = time + 2;
				return;
			}
			
			centerprint(self, "You bought this door for $20!");
			self.rp_menutime = time + 2;
			self.rp_money = self.rp_money - 20;
			trace_ent.rp_owner = self;
		}
	}
};

void() RP_SellDoor =
{
	local	vector	source;

	makevectors (self.v_angle);
	source = self.origin + '0 0 16';
	traceline (source, source + v_forward*124, FALSE, self);

	if (trace_ent.classname == "door")
	{
		if(trace_ent.rp_owner == self)
		{
			centerprint(self, "You sold this door for $10!");
			self.rp_menutime = time + 2;
			self.rp_money = self.rp_money + 10;
			trace_ent.rp_owner = world;
		}
		else
		{
			centerprint(self, "You don't own this door");
			self.rp_menutime = time + 2;
		}
	}
};

void() RP_Arrest =
{
	local	vector	source;
		
	if(!RP_CheckJob(JOB_POLICEFORCE, self))
		return;
		

	makevectors (self.v_angle);
	source = self.origin + '0 0 16';
	traceline (source, source + v_forward*124, FALSE, self);

	if (trace_ent.classname == "player")
	{
		trace_ent.items = 0;
		trace_ent.weapon = 0;
		trace_ent.currentammo = 0;
		trace_ent.weaponmodel = "";
		trace_ent.weaponframe = 0;
		bprint (PRINT_LOW, trace_ent.netname);
		bprint (PRINT_LOW, " has been arrested.\n");
	}
	
};

void() RP_Unarrest =
{
	local	vector	source;
		
	if(!RP_CheckJob(JOB_POLICEFORCE, self))
		return;
		

	makevectors (self.v_angle);
	source = self.origin + '0 0 16';
	traceline (source, source + v_forward*124, FALSE, self);

	if (trace_ent.classname == "player")
	{
		trace_ent.items		= IT_AXE | IT_KEYS;
		trace_ent.weapon 	= IT_KEYS;
		RP_SetCurrentAmmo(trace_ent);
		
		bprint (PRINT_LOW, trace_ent.netname);
		bprint (PRINT_LOW, " has been unarrested.\n");
	}
};

void() RP_SellShotgun =
{
	local	vector	source;
	
	if(!RP_CheckJob(JOB_GUNDEALER, self))
		return;

	if(!RP_CheckMoney(150))
	{
		centerprint(self, "You don't have enough money to buy a shotgun.");
		self.rp_menutime = time + 2;
		return;
	}

	makevectors (self.v_angle);
	source = self.origin + '0 0 16';
	traceline (source, source + v_forward*124, FALSE, self);

	if (trace_ent.classname == "player")
	{
		if(RP_CheckInventory(IT_SHOTGUN, trace_ent))
		{
			centerprint(self, "This player already has a shotgun.");
			self.rp_menutime = time + 2;
			return;
		}
			
		trace_ent.items = trace_ent.items | IT_SHOTGUN;
		trace_ent.ammo_shells = trace_ent.ammo_shells + 25;
		self.rp_money = self.rp_money - 150;
	}
};

void() RP_SellShells =
{
	local	vector	source;
	if(!RP_CheckJob(JOB_GUNDEALER, self))
		return;
		
	if(!RP_CheckMoney(50))
	{
		centerprint(self, "You don't have enough money to buy shotgun shells.");
		self.rp_menutime = time + 2;
		return;
	}

	makevectors (self.v_angle);
	source = self.origin + '0 0 16';
	traceline (source, source + v_forward*124, FALSE, self);

	if (trace_ent.classname == "player")
	{
		trace_ent.ammo_shells = trace_ent.ammo_shells + 25;
		self.rp_money = self.rp_money - 50;
	}
};

void() RP_HealPlayer =
{
	local	vector	source;
	if(!RP_CheckJob(JOB_MEDIC, self))
		return;

	makevectors (self.v_angle);
	source = self.origin + '0 0 16';
	traceline (source, source + v_forward*124, FALSE, self);

	if (trace_ent.classname == "player")
	{
		if(trace_ent.health >= 100)
		{
			centerprint(self, "This player already is at full health.");
			self.rp_menutime = time + 2;
			return;
		}
		
		trace_ent.health = 100;
	}
};

void() RP_SwitchLockdown =
{
	centerprint(self, "Not yet implemented.");
};

void() RP_DropMoney_Touch =
{
	local	string money;
	
	if(!other.classname == "player")
		return;
	
	money = ftos(self.health);
	centerprint(other, "You have found $", money, "!\n");
	other.rp_menutime = time + 2;
	
	other.rp_money = other.rp_money + self.health;
	remove(self);
};

void(float amount) RP_DropMoney =
{
	local	vector	source;
	local	vector	org;
	local	entity 	new;
	local	string money;
	
	if(!RP_CheckMoney(amount))
	{
		centerprint(self, "You don't have enough money to drop.");
		self.rp_menutime = time + 2;
		return;
	}
	
	makevectors (self.v_angle);
	source = self.origin + '0 0 16';
	traceline (source, source + v_forward*64, FALSE, self);
	
	new = spawn();
	new.origin = trace_endpos;
	setmodel (new, "progs/rp_money.mdl");
	new.classname = "money";
	new.solid = SOLID_TRIGGER;
	new.touch = RP_DropMoney_Touch;
	new.health = amount;
	new.rp_owner = self;
	new.movetype = MOVETYPE_BOUNCE;
	setsize (new, '-9 -12 0', '9 12 7');
	
	money = ftos(amount);
	centerprint(self, "You have dropped $", money, "!\n");
	self.rp_menutime = time + 1;
	self.rp_money = self.rp_money - amount;
};