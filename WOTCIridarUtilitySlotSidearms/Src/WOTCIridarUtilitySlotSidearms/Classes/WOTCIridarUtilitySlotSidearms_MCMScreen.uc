class WOTCIridarUtilitySlotSidearms_MCMScreen extends Object config(WOTCIridarUtilitySlotSidearms);

var config int VERSION_CFG;

var localized string ModName;
var localized string PageTitle;
var localized string GroupHeader1;
var localized string GroupHeader2;
var localized string WeaponCatTooltip;

var localized string LabelEnd;
var localized string LabelEndTooltip;

// Cached in OPTC
var array<name> ValidWeaponCats;

var config array<name> GlobalAllowedWeaponCats;

var private X2ItemTemplateManager ItemMgr;

`include(WOTCIridarUtilitySlotSidearms\Src\ModConfigMenuAPI\MCM_API_Includes.uci)

//`MCM_API_AutoCheckBoxVars(DEBUG_LOGGING);
`MCM_API_AutoCheckBoxVars(DISALLOW_CLASS_WEAPONS);

`include(WOTCIridarUtilitySlotSidearms\Src\ModConfigMenuAPI\MCM_API_CfgHelpers.uci)

//`MCM_API_AutoCheckBoxFns(DEBUG_LOGGING, 1);
`MCM_API_AutoCheckBoxFns(DISALLOW_CLASS_WEAPONS, 1);

`define CAPS(VarName) class'UIUtilities_Text'.static.CapsCheckForGermanScharfesS(`VarName)


event OnInit(UIScreen Screen)
{
	`MCM_API_Register(Screen, ClientModCallback);
}

//Simple one group framework code
simulated function ClientModCallback(MCM_API_Instance ConfigAPI, int GameMode)
{
	local MCM_API_SettingsPage	Page;
	local MCM_API_SettingsGroup	Group;
	local name					WeaponCat;
	local string				Tooltip;
	local string				LocCat;
	local bool					bChecked;

	LoadSavedSettings();
	Page = ConfigAPI.NewSettingsPage(ModName);
	Page.SetPageTitle(PageTitle);
	Page.SetSaveHandler(SaveButtonClicked);
	Page.EnableResetButton(ResetButtonClicked);

	Group = Page.AddGroup('Group1', GroupHeader1);

	ItemMgr = class'X2ItemTemplateManager'.static.GetItemTemplateManager();

	foreach ValidWeaponCats(WeaponCat)
	{
		LocCat = GetLocWeaponCat(WeaponCat);
		Tooltip = Repl(WeaponCatTooltip, "%WeaponCat%", Locs(LocCat));
		bChecked = GlobalAllowedWeaponCats.Find(WeaponCat) != INDEX_NONE;

		Group.AddCheckbox(WeaponCat, `CAPS(LocCat), Tooltip, bChecked, WeaponCat_SaveHandler, WeaponCat_ChangeHandler);
	}

	Group = Page.AddGroup('Group2', GroupHeader2);

	`MCM_API_AutoAddCheckBox(Group, DISALLOW_CLASS_WEAPONS);
	//`MCM_API_AutoAddCheckBox(Group, DEBUG_LOGGING); // Nothing to log lol

	Group.AddLabel('Label_End', LabelEnd, LabelEndTooltip);

	Page.ShowSettings();
}

static final function array<name> GetGlobalAllowedWeaponCats()
{
	if (class'WOTCIridarUtilitySlotSidearms_Defaults'.default.VERSION_CFG > class'WOTCIridarUtilitySlotSidearms_MCMScreen'.default.VERSION_CFG)
	{
		return class'WOTCIridarUtilitySlotSidearms_Defaults'.default.GlobalAllowedWeaponCats;
	}
	return default.GlobalAllowedWeaponCats;
}

private function WeaponCat_SaveHandler(MCM_API_Setting Setting, bool SettingValue)
{
}

private function WeaponCat_ChangeHandler(MCM_API_Setting Setting, bool SettingValue)
{
	local name WeaponCat;

	WeaponCat = Setting.GetName();
	if (SettingValue)
	{
		GlobalAllowedWeaponCats.AddItem(WeaponCat);
	}
	else
	{
		GlobalAllowedWeaponCats.RemoveItem(WeaponCat);
	}
}

private function string GetLocWeaponCat(const name WeaponCat)
{
	local X2WeaponTemplate			WeaponTemplate;
	local X2DataTemplate			DataTemplate;
	local X2ItemTemplate			ItemTemplate;
	local string					LocCat;

	// Use in-game item localization for unlocalized base game weapon cats.
	switch (WeaponCat)
	{
		case 'utility':
			return class'UIArmory_Loadout'.default.m_strInventoryLabels[eInvSlot_Utility];
		case 'heavy':
			return class'UIArmory_Loadout'.default.m_strInventoryLabels[eInvSlot_HeavyWeapon];
		case 'grenade_launcher':
			ItemTemplate = ItemMgr.FindItemTemplate('GrenadeLauncher_CV');
			if (ItemTemplate != none)
				return ItemTemplate.FriendlyName;
			break;
		case 'gremlin':
			ItemTemplate = ItemMgr.FindItemTemplate('Gremlin_CV');
			if (ItemTemplate != none)
				return ItemTemplate.FriendlyName;
			break;
		case 'vektor_rifle':
			ItemTemplate = ItemMgr.FindItemTemplate('VektorRifle_CV');
			if (ItemTemplate != none)
				return ItemTemplate.FriendlyName;
			break;
		//case 'bullpup':
		//	ItemTemplate = ItemMgr.FindItemTemplate('Bullpup_CV'); 
		//	if (ItemTemplate != none)
		//		return ItemTemplate.FriendlyName; "Kal-7 Bullpup" ugh
		//	break;
		case 'sparkrifle':
			ItemTemplate = ItemMgr.FindItemTemplate('SparkRifle_CV');
			if (ItemTemplate != none)
				return ItemTemplate.FriendlyName; // "Heavy Autocannon"
			break;
		case 'claymore':
			ItemTemplate = ItemMgr.FindItemTemplate('Reaper_Claymore');
			if (ItemTemplate != none)
				return ItemTemplate.FriendlyName;
			break;
		case 'rifle':
			ItemTemplate = ItemMgr.FindItemTemplate('AssaultRifle_CV');
			if (ItemTemplate != none)
				return ItemTemplate.FriendlyName;
			break;
		case 'shotgun':
			ItemTemplate = ItemMgr.FindItemTemplate('Shotgun_CV');
			if (ItemTemplate != none)
				return ItemTemplate.FriendlyName;
			break;
		case 'pistol':
			ItemTemplate = ItemMgr.FindItemTemplate('Pistol_CV');
			if (ItemTemplate != none)
				return ItemTemplate.FriendlyName;
			break;
		case 'cannon':
			ItemTemplate = ItemMgr.FindItemTemplate('Cannon_CV');
			if (ItemTemplate != none)
				return ItemTemplate.FriendlyName;
			break;
		case 'sword':
			ItemTemplate = ItemMgr.FindItemTemplate('Sword_CV');
			if (ItemTemplate != none)
				return ItemTemplate.FriendlyName;
			break;
		case 'sniper_rifle':
			ItemTemplate = ItemMgr.FindItemTemplate('SniperRifle_CV');
			if (ItemTemplate != none)
				return ItemTemplate.FriendlyName;
			break;
		case 'wristblade':
			ItemTemplate = ItemMgr.FindItemTemplate('WristBlade_CV');
			if (ItemTemplate != none)
				return ItemTemplate.FriendlyName;
			break;
		case 'gauntlet':
			ItemTemplate = ItemMgr.FindItemTemplate('ShardGauntlet_CV');
			if (ItemTemplate != none)
				return ItemTemplate.FriendlyName; // "Shard Gauntlets"
			break;
		case 'sparkbit':
			ItemTemplate = ItemMgr.FindItemTemplate('SparkBit_CV');
			if (ItemTemplate != none)
				return ItemTemplate.FriendlyName; // "SPARK BIT"
			break;
		case 'psiamp':
			ItemTemplate = ItemMgr.FindItemTemplate('PsiAmp_CV');
			if (ItemTemplate != none)
				return ItemTemplate.FriendlyName; // "Psi Amp"
			break;
		case 'sidearm':
			ItemTemplate = ItemMgr.FindItemTemplate('Sidearm_CV');
			if (ItemTemplate != none)
				return ItemTemplate.FriendlyName; // "Psi Amp"
			break;
		case 'heavy':
			return class'UIArmory_Loadout'.default.m_strInventoryLabels[eInvSlot_HeavyWeapon];
			break;
		default:
			break;
	}

	// For mod-added categories, search for the first weapon template with that category,
	// and use its GetLocalizedCategoryMethod, which will trigger a CHL event.
	foreach ItemMgr.IterateTemplates(DataTemplate)
	{
		WeaponTemplate = X2WeaponTemplate(DataTemplate);
		if (WeaponTemplate != none && WeaponTemplate.WeaponCat == WeaponCat)
		{
			LocCat = WeaponTemplate.GetLocalizedCategory();
			break;
		}
	}
	// If all else fails, default to weapon category itself.
	if (LocCat == class'XGLocalizedData'.default.WeaponCatUnknown)
	{	
		return Repl(string(WeaponCat), "_", " ");
	}
	return LocCat;
}

simulated function LoadSavedSettings()
{
	GlobalAllowedWeaponCats = GetGlobalAllowedWeaponCats();

	//DEBUG_LOGGING = `GETMCMVAR(DEBUG_LOGGING);
	DISALLOW_CLASS_WEAPONS = `GETMCMVAR(DISALLOW_CLASS_WEAPONS);
}

simulated function ResetButtonClicked(MCM_API_SettingsPage Page)
{
	GlobalAllowedWeaponCats = class'WOTCIridarUtilitySlotSidearms_Defaults'.default.GlobalAllowedWeaponCats;

	//`MCM_API_AutoReset(DEBUG_LOGGING);
	`MCM_API_AutoReset(DISALLOW_CLASS_WEAPONS);
}

simulated function SaveButtonClicked(MCM_API_SettingsPage Page)
{
	VERSION_CFG = `MCM_CH_GetCompositeVersion();
	SaveConfig();
}


