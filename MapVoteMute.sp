#pragma semicolon 1

#include <sourcemod>
#include <cstrike>
#include <sdkhooks>
#include <sdktools>
#include <basecomm>
#include <sourcecomms>
#include <mapchooser_extended>
#include <multicolors>

Handle g_hTimer;

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

public void OnMapVoteStart()
{
	g_hTimer = CreateTimer(2.5, ShowText, _, TIMER_REPEAT); 

	for (int i = 1; i <= MaxClients; i++)
	{
		if (IsClientInGame(i) && !GetUserAdmin(i).HasFlag(Admin_Ban) && !BaseComm_IsClientMuted(i))
		{
			CPrintToChatAll("{green}[VM]{default} You'll be muted until the {darkred}vote ends!");
			CPrintToChatAll("{green}[VM]{default} Please, take it easy, and don't speak on the mic yet.");
			SetClientListeningFlags(i, VOICE_MUTED);
		}
	}
}

public void OnMapVoteEnd()
{
	delete g_hTimer;
	
	for (int i = 1; i <= MaxClients; i++)
	{
		if (IsClientInGame(i) && !GetUserAdmin(i).HasFlag(Admin_Ban) && !BaseComm_IsClientMuted(i))
		{
			CPrintToChatAll("{green}[VM]{default} The vote has ended, you can now {lightblue}speak properly!");
			SetClientListeningFlags(i, VOICE_NORMAL);
		}
	}
}

public Action ShowText(Handle timer)    
{    
    for (int i = 1; i <= MaxClients; i++)   
    {    
        if (IsClientInGame(i))    
        {    
            SetHudTextParams(-1.0, 0.1, 5.0, 0, 255, 255, 255, 0, 0.1, 0.1, 0.1);    
            ShowHudText(i, 5, "YOU WERE MUTED UNTIL THE VOTE ENDS!");    
        }    
    }    
}