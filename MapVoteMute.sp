#pragma semicolon 1

#include <sourcemod>
#include <cstrike>
#include <sdkhooks>
#include <sdktools>
#include <basecomm>
#include <sourcecomms>
#include <mapchooser_extended>
#include <multicolors>

#define PLUGIN_VERSION "1.1.1"

#pragma newdecls required

float timer_duration;

public Plugin myinfo 	=
{
	name				= 		"Mute non-admins on mapvote",
	description			= 		"",
	author				= 		"Nano",
	version				= 		PLUGIN_VERSION,
	url					= 		"http://steamcommunity.com/id/nano2k06"
}

public void OnMapStart()
{
	timer_duration = GetConVarFloat(FindConVar("mce_voteduration"));
}

public void OnMapVoteStart()
{
	CreateTimer(timer_duration, ShowText);

	for (int i = 1; i <= MaxClients; i++)
	{
		if (IsClientInGame(i) && !GetUserAdmin(i).HasFlag(Admin_Ban) && !BaseComm_IsClientMuted(i))
		{
			CPrintToChat(i, "{green}[MVM]{default} You were muted until {darkred}the vote ends!");
			CPrintToChat(i, "{green}[MVM]{default} Please, take it easy and {darkred}don't speak on the mic yet!");
			SetClientListeningFlags(i, VOICE_MUTED);
		}
	}
}

public void OnMapVoteEnd()
{
	for (int i = 1; i <= MaxClients; i++)
	{
		if (IsClientInGame(i) && !GetUserAdmin(i).HasFlag(Admin_Ban) && !BaseComm_IsClientMuted(i))
		{
			CPrintToChat(i, "{green}[MVM]{default} The vote has been ended, {lightblue}you can now speak properly!");
			SetClientListeningFlags(i, VOICE_NORMAL);
		}
	}
}

public Action ShowText(Handle timer)    
{
	for (int i = 1; i <= MaxClients; i++)   
	{    
		if (IsClientInGame(i) && !BaseComm_IsClientMuted(i))   
		{    
			SetHudTextParams(-1.0, 0.1, 5.0, 0, 255, 255, 255, 0, 0.1, 0.1, 0.1);    
			ShowHudText(i, 5, "YOU WERE MUTED UNTIL THE VOTE ENDS!");    
		}    
	}
}
