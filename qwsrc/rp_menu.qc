// *******
// LIGHT ROLEPLAY MENU
// *******
void() RP_SpawnMoneyPrinter;
void() RP_Watermelon_Spawn;
void() RP_Basketball_Spawn;
				
void() RP_FuncMenu_Draw =
{
	local string menu;
	if(!self.rp_infmenu)
		return;
	
	RP_Job_Menu();
};

void() RP_Menu_Draw =
{
	RP_PlayerID();
	RP_FuncMenu_Draw();
	
	if(!self.rp_inmenu)
		return;
		
	centerprint(self,"|-----------------------|\n|LIGHT ROLEPLAY Job Menu|\n|-----------------------|\n|1: Citizen             |\n|2: Police Force        |\n|3: Mobster             |\n|4: Gun Dealer          |\n|5: Medic               |\n|6: Merchant            |\n|7: Mayor               |\n|-----------------------|\n");

};
void() RP_InfoMenu_Draw =
{
	string money;
	
	money = ftos(self.rp_money);
	centerprint (self, "|-----------------------|\n|     LIGHT RP STATS    |\n|-----------------------|\n\nName: ", self.netname,"\nJob: ", self.rp_title,"\nMoney: $", money,"\n");
};

void() RP_Menu_Switch =
{
	if(self.rp_inmenu)
		self.rp_inmenu = FALSE;
	else
		self.rp_inmenu = TRUE;
		
	self.rp_infmenu = FALSE;
};

void() RP_FuncMenu_Switch =
{
	if(self.rp_infmenu)
		self.rp_infmenu = FALSE;
	else
		self.rp_infmenu = TRUE;
		
	self.rp_inmenu = FALSE;
};

float() RP_Menu_Input =
{
	if(self.impulse == 20)
		RP_Menu_Switch();
	if(self.impulse == 21)
		RP_InfoMenu_Draw();
	if(self.impulse == 22)
		RP_FuncMenu_Switch();
	
	
	if(self.rp_infmenu)
	{
		if(self.impulse == 1)
			RP_BuyDoor();
		else if(self.impulse == 2)
			RP_SellDoor();
		else if(self.impulse == 7)
			RP_DropMoney(10);
		else if(self.impulse == 8)
			RP_DropMoney(100);
		else if(self.impulse == 9)
			RP_SpawnMoneyPrinter();
		else if(self.impulse == 19)
		{
			if(self.items)
			{
				self.weapon = IT_KEYS;
				RP_SetCurrentAmmo(self);
			}
		}
		else if(self.rp_job == JOB_POLICEFORCE)
		{
			if(self.impulse == 3)
				RP_Arrest();
			else if(self.impulse == 4)
				RP_Unarrest();
			else
				return 0;
		}
		else if (self.rp_job == JOB_GUNDEALER)
		{
			if(self.impulse == 3)
				RP_SellShotgun();
			else if(self.impulse == 4)
				RP_SellShells();
			else
				return 0;
		}
		else if (self.rp_job == JOB_MEDIC)
		{
			if(self.impulse == 3)
				RP_HealPlayer();
			else
				return 0;
		}
		else if (self.rp_job == JOB_MERCHANT)
		{
			if(self.impulse == 3)
				RP_Watermelon_Spawn();
			else if(self.impulse == 4)
				RP_Basketball_Spawn();
			else
				return 0;
		}
		else if (self.rp_job == JOB_MAYOR)
		{
			if(self.impulse == 3)
				RP_SwitchLockdown();
			else
				return 0;
		}	
		else
			return 0;
	}
	else if (self.rp_inmenu)
	{
	if(self.impulse == 1)
		RP_SetJob(JOB_CITIZEN);
	else if(self.impulse == 2)
		RP_SetJob(JOB_POLICEFORCE);
	else if(self.impulse == 3)
		RP_SetJob(JOB_MOBSTER);
	else if(self.impulse == 4)
		RP_SetJob(JOB_GUNDEALER);
	else if(self.impulse == 5)
		RP_SetJob(JOB_MEDIC);
	else if(self.impulse == 6)
		RP_SetJob(JOB_MERCHANT);
	else if(self.impulse == 7)
		RP_SetJob(JOB_MAYOR);
	else
	{
		return 0;
	}
	
	}
	else
	{
		return 0;
	}

	self.rp_inmenu = FALSE;
	self.rp_infmenu = FALSE;
	self.impulse = 0;
	return 1;
};