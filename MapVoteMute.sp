#pragma semicolon 1

#include <sourcemod>
#include <cstrike>
#include <sdkhooks>
#include <sdktools>
#include <basecomm>
#include <sourcecomms>
#include <mapchooser_extended>
#include <multicolors>

bool b_ShowHudBoolean = false;

#define PLUGIN_VERSION "1.0"

#pragma newdecls required

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
	b_ShowHudBoolean = false;
}

public void OnMapVoteStart()
{
	CreateTimer(2.5, ShowText, _, TIMER_REPEAT); 
	
	b_ShowHudBoolean = true;

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
	b_ShowHudBoolean = false;
	
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
	if(b_ShowHudBoolean)
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
	else
	{
		return Plugin_Stop;
	}
	return Plugin_Handled;
}