
void() path_corner = {};

void() item_key1 = {remove(self);};
void() item_key2 = {remove(self);};
void() item_sigil = {remove(self);};

void() monster_army = {remove(self);};
void() monster_boss = {remove(self);};
void() monster_demon1 = {remove(self);};
void() monster_dog = {remove(self);};
void() monster_enforcer = {remove(self);};
void() monster_fish = {remove(self);};
void() monster_hell_knight = {remove(self);};
void() monster_knight = {remove(self);};
void() monster_ogre = {remove(self);};
void() monster_oldone = {remove(self);};
void() monster_shalrath = {remove(self);};
void() monster_shambler = {remove(self);};
void() monster_tarbaby = {remove(self);};
void() monster_wizard = {remove(self);};
void() monster_zombie = {remove(self);};

void() weapon_supershotgun = {remove(self);};
void() weapon_nailgun = {remove(self);};
void() weapon_supernailgun = {remove(self);};
void() weapon_rocketlauncher = {remove(self);};
void() weapon_grenadelauncher = {remove(self);};
void() weapon_lightning = {remove(self);};

void() Laser_Touch =
{
	local vector org;

	if (other == self.owner)
		return;		// don't explode on owner

	if (pointcontents(self.origin) == CONTENT_SKY)
	{
		remove(self);
		return;
	}

	sound (self, CHAN_WEAPON, "enforcer/enfstop.wav", 1, ATTN_STATIC);
	org = self.origin - 8*normalize(self.velocity);

	if (other.health)
	{
		SpawnBlood (org, self.velocity*0.2, 15);
		T_Damage (other, self, self.owner, 15);
	}
	else
	{
		WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
		WriteByte (MSG_BROADCAST, TE_GUNSHOT);
		WriteCoord (MSG_BROADCAST, org_x);
		WriteCoord (MSG_BROADCAST, org_y);
		WriteCoord (MSG_BROADCAST, org_z);
	}

	remove(self);
};

void(vector org, vector vec) LaunchLaser =
{
	if (self.classname == "monster_enforcer")
		sound (self, CHAN_WEAPON, "enforcer/enfire.wav", 1, ATTN_NORM);

	vec = normalize(vec);

	newmis = spawn();
	newmis.owner = self;
	newmis.movetype = MOVETYPE_FLY;
	newmis.solid = SOLID_BBOX;
	newmis.effects = EF_DIMLIGHT;

	setmodel (newmis, "progs/laser.mdl");
	setsize (newmis, '0 0 0', '0 0 0');

	setorigin (newmis, org);

	newmis.velocity = vec * 600;
	newmis.angles = vectoangles(newmis.velocity);

	newmis.nextthink = time + 5;
	newmis.think = SUB_Remove;
	newmis.touch = Laser_Touch;
};

entity	le1, le2;
float	lightning_end;

void() lightning_fire =
{
	local vector p1, p2;

	if (time >= lightning_end)
	{	// done here, put the terminals back up
		self = le1;
		door_go_down ();
		self = le2;
		door_go_down ();
		return;
	}

	p1 = (le1.mins + le1.maxs) * 0.5;
	p1_z = le1.absmin_z - 16;

	p2 = (le2.mins + le2.maxs) * 0.5;
	p2_z = le2.absmin_z - 16;

	// compensate for length of bolt
	p2 = p2 - normalize(p2-p1)*100;

	self.nextthink = time + 0.1;
	self.think = lightning_fire;

	WriteByte (MSG_ALL, SVC_TEMPENTITY);
	WriteByte (MSG_ALL, TE_LIGHTNING3);
	WriteEntity (MSG_ALL, world);
	WriteCoord (MSG_ALL, p1_x);
	WriteCoord (MSG_ALL, p1_y);
	WriteCoord (MSG_ALL, p1_z);
	WriteCoord (MSG_ALL, p2_x);
	WriteCoord (MSG_ALL, p2_y);
	WriteCoord (MSG_ALL, p2_z);
};

void() lightning_use =
{
	if (lightning_end >= time + 1)
		return;

	le1 = find( world, target, "lightning");
	le2 = find( le1, target, "lightning");
	if (!le1 || !le2)
	{
		dprint ("missing lightning targets\n");
		return;
	}

	if (
	 (le1.state != STATE_TOP && le1.state != STATE_BOTTOM)
	|| (le2.state != STATE_TOP && le2.state != STATE_BOTTOM)
	|| (le1.state != le2.state) )
	{
//		dprint ("not aligned\n");
		return;
	}

// don't let the electrodes go back up until the bolt is done
	le1.nextthink = -1;
	le2.nextthink = -1;
	lightning_end = time + 1;

	sound (self, CHAN_VOICE, "misc/power.wav", 1, ATTN_NORM);
	lightning_fire ();
};


/*QUAKED event_lightning (0 1 1) (-16 -16 -16) (16 16 16)
Just for boss level.
*/
void() event_lightning =
{
	self.use = lightning_use;
};

