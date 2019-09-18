# glua_filestruct unfinished


Parse files using structs


```Lua
local fileStruct = { -- i had to do this ugly shit to conserv the order
	{HEADER = "DATA_LENSTRING4"},
	{Version = DATA_BYTE},
	{SteamID_Unused = "DATA_SKIP8"},
	{TimeStamp = DATA_64BITSDOUBLE},
	{Junk = "DATA_SKIP1"},
	{Title = DATA_STRING},
	{Description = DATA_STRING},
	{Author_string = DATA_STRING},
	{Addon_version = DATA_4BYTES},
}


local tbl = parseFile("data/test.gma", fileStruct)
PrintTable(tbl)
```

```


HEADER	=	GMAD
TimeStamp	=	6.9054530972928e-315
Title	=	BATTLEFIELD 4 HUD
Version	=	3
Addon_version	=	1
Author_string	=	author
Description	=	[url=https://twitter.com/residualgrub]My Twitter[/url]
				[url=http://www.youtube.com/user/residualgrubc]My Youtube[/url]

				A recreation of the Battlefeild 4 HUD in Garry's Mod  With a functioning minimap!
				The minimap has basic functions at the moment, I am planing on doing alot more with it.

				Note: 
				The reload icon and the firemode switch indicator will not work for default HL2 weapons because of how they are setup
				Credits:
				Main Code: KatBug (ResidualGrub)
				Base Mini Map Code: Danny
				Amazing Art: lavadeeto


HEADER	=	GMAD
TimeStamp	=	6.9054530972928e-315
Title	=	BATTLEFIELD 4 HUD
Version	=	3

```
