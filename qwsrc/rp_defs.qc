// *******
// LIGHT ROLEPLAY DEFINITONS
// *******
//
// Feel free to add extra jobs and weapon definitions!

// Jobs:
float   JOB_CITIZEN		= 1001;
float   JOB_POLICEFORCE	= 1002;
float   JOB_MOBSTER		= 1004;
float   JOB_GUNDEALER	= 1005;
float   JOB_MEDIC		= 1006;
float   JOB_MERCHANT		= 1007;
float   JOB_MAYOR		= 1008;
//float   JOB_EXTRA		= 1009;

// Weapons (continued from Line 321)
float   IT_KEYS			= 8388608;
float   IT_LOCKPICK		= 16777216;
float   IT_MEDKIT		= 33554432;
//float   IT_EXTRA_TOOL	= 67108864;

// Player Definitions:
.float	rp_job;
.float	rp_money;
.float	rp_salary;
.float	rp_inmenu;
.float	rp_infmenu;
.float	rp_menutime;
.string	rp_title;

// Entity definitions:
.entity	rp_owner;
.float rp_locked;

//QuakeWorld Shit
.float rp_menutime;

