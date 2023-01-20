This mod makes it possible to equip secondary weapons into utility slots. By default, only Swords and Pistols are allowed, and only for soldier classes that normally do not use them as primary or secondary weapons. 

More weapon categories can be allowed in Mod Config Menu, however, some of them cannot be used out of the box, and will need additional configuration in mod's config files.

[h1]WEAPON CATEGORIES THAT WORK OUT OF THE BOX[/h1]
[list][*] Pistol*
[*] Sword*
[*] Autopistol
[*] Grenade Launcher*
[*] Heavy Weapons
[*] Arc Thrower
[*] Combat Knife
[*] LW2 Gauntlet
[*] Holotargeter
[*] Sawed Off Shotgun[/list]
* - Ability to Slot Reassignment mod is required.

[h1]WEAPON CATEGORIES THAT REQUIRE ADDITIONAL CONFIGURATION[/h1]
[list][*] Ripjack
[*] GREMLIN
[*] BIT
[*] Psi Amp
[*] Claymore
[*] Shard Gauntlets[/list]

These weapons do not have any abilities attached to them, so even if you allow equipping them through this mod, they will be a dead weight in soldier's inventory, and will not do anything at all. In order for soldiers to be able to actually use them, you need to attach some abilities to them. 

The easiest way to do this is by adding configuration for [b]Ability to Slot Reassignment[/b], by designating specific abilities as mandatory for specific weapon categories. For example, adding Sword Slash and Grapple to Ripjacks.

However, this can cause unexpected consequences with specific mod setups. For example, the [b][url=https://steamcommunity.com/sharedfiles/filedetails/?id=1397425613]Valkyrie[/url][/b] class uses a GREMLIN secondary to heal and buff allies, but they normally cannot Hack with it.

So if you designate remote Hack as a mandatory ability for GREMLINs, so that utility GREMLINs have a purpose, then suddenly the Valkyrie will be able to remote Hack with their GREMLIN, which you may or may not be okay with.

As such, the mod includes some example config for Ability to Slot Reassignment, but it is commented out to prevent these compatibility issues.

[h1]DIFFERENCES FROM EXISTING MODS[/h1]

Unlike [b][url=https://steamcommunity.com/sharedfiles/filedetails/?id=1194081262]Utility Slot Sidearms WOTC[/url][/b] and [b][url=https://steamcommunity.com/sharedfiles/filedetails/?id=1217180517]Utility Slot Sidearms Extended[/url][/b], my mod does not create new weapons for the utility slot. It specifically allows using your existing weapons in utility slots by using new Highlander tech that was not available when USS/USSE were made.

This means my mod supports weapon upgrades, and works with limited stock weapons, such as Chosen Hunter's pistol, or while using a single-build system, such as [b][url=https://steamcommunity.com/sharedfiles/filedetails/?id=2567230602][WOTC] Prototype Armoury[/url][/b] in [b][url=https://steamcommunity.com/sharedfiles/filedetails/?id=2567230730][WOTC] Covert Infiltration[/url][/b].

[h1]REQUIREMENTS[/h1]
[list][*] [url=https://steamcommunity.com/workshop/filedetails/?id=1134256495][b]X2 WOTC Community Highlander[/b][/url]
[*][b][url=https://steamcommunity.com/sharedfiles/filedetails/?id=2133397762]Ability To Slot Reassignment[/url][/b] - required to attach abilities to secondary weapons so they are usable in utility slots, including Pistol and Sword, but otherwise not a hard requirement.
[*][b][url=https://steamcommunity.com/sharedfiles/filedetails/?id=2569592723][WOTC] Musashi's Mods Fixes[/url][/b] - required for AtSR to work right.
[*][b][url=https://steamcommunity.com/sharedfiles/filedetails/?id=2363075446][WOTC] Iridar's Template Master - Core[/url][/b] - required to enable some fixes for a utility Claymore.
[*][url=https://steamcommunity.com/sharedfiles/filedetails/?id=667104300][b][WotC] Mod Config Menu[/b][/url] - supported, but not a hard requirement.
[/list]
Safe to add or remove mid-campaign.

[h1]COMPATIBILITY[/h1]

SPARKs and MECs are excluded from being affected by this mod. Additional exclusions can be added through config.

The mod is compatible with [b][url=https://steamcommunity.com/sharedfiles/filedetails/?id=1140434643][WOTC] LW2 Secondary Weapons[/url][/b] out of the box. You still need to allow equipping these weapons into utility slots in Mod Config Menu.

In general, any secondary weapon that can be equipped by at least one soldier class will appear in the list of options in Mod Config Menu, but there's no guarantee it will work properly in the utility slot.

The exception to this rule are some weapon categories that are excluded through config, since they would be problematic if used in utility slots. For example, the "Empty" secondary from True Primary Secondaries, or Ballistic Shields, which don't get their shield animations when used in the utility slot.

Specific weapon categories can be force added to the list through config files. The mod already does so for Shard Gauntlets and Heavy Weapons, since they aren't even secondary weapons.

[h1]KNOWN ISSUES[/h1]
[list][*] Utility weapons are not visible in the Photobooth.
[*] The mod does not enable Dual Wielding with Utility slot weapons and it never will.
[*] Utility weapon animations may not work correctly depending on soldier's primary and secondary weapons. For example, utility pistol does not look right when fired by a soldier with primary sword + secondary ballistic shield.[/list]
In general, depending on configuration, this mod can allow you to do a lot of stuff, but that does not necessarily mean it's a good idea. For example, with this mod you can equip a Pistol and an Autopistol at the same time, but only one of them will work properly, since they both occupy the same visual slot on the soldier. Same goes for Swords and Combat Knives. The same may be true for other weapon categories.

[h1]CONFIGURATION[/h1]

Many aspects of this mod are configurable through configuration files in:
[code]..\steamapps\workshop\content\268500\2848089939\Config\[/code]

[h1]CREDITS[/h1]

Please [b][url=https://www.patreon.com/Iridar]support me on Patreon[/url][/b] if you require tech support, have a suggestion for a feature, or simply wish to help me create more awesome mods.
