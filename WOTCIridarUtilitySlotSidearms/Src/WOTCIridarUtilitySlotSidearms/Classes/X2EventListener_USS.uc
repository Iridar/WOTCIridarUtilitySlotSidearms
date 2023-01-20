class X2EventListener_USS extends X2EventListener config(ClassData);

`include(WOTCIridarUtilitySlotSidearms/Src/ModConfigMenuAPI/MCM_API_CfgHelpers.uci)

var config array<name> ExcludedCharacters;
var config array<name> ExcludedClasses;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;

	Templates.AddItem(Create_OverrideShowItemInLockerList_ListenerTemplate());

	return Templates;
}

static function CHEventListenerTemplate Create_OverrideShowItemInLockerList_ListenerTemplate()
{
	local CHEventListenerTemplate Template;

	`CREATE_X2TEMPLATE(class'CHEventListenerTemplate', Template, 'IRI_X2EventListener_USSW_LockerList');

	Template.RegisterInTactical = false;
	Template.RegisterInStrategy = true;

	Template.AddCHEvent('OverrideShowItemInLockerList', OnOverrideShowItemInLockerList, ELD_Immediate);

	return Template;
}

static final function bool IsUnitExcluded(const XComGameState_Unit UnitState)
{
	return default.ExcludedCharacters.Find(UnitState.GetMyTemplateName()) != INDEX_NONE || default.ExcludedClasses.Find(UnitState.GetSoldierClassTemplateName()) != INDEX_NONE;
}

static private function EventListenerReturn OnOverrideShowItemInLockerList(Object EventData, Object EventSource, XComGameState NewGameState, Name Event, Object CallbackData)
{
	local XComGameState_Item		ItemState;
	local XComLWTuple				Tuple;
	local EInventorySlot			Slot;
	local X2WeaponTemplate			WeaponTemplate;
	local array<name>				GlobalAllowedWeaponCats;
	local XComGameState_Unit		UnitState;
	local X2SoldierClassTemplate	SoldierClassTemplate;	
	
	Tuple = XComLWTuple(EventData);
	Slot = EInventorySlot(Tuple.Data[1].i);
	if (Slot != eInvSlot_Utility)
		return ELR_NoInterrupt;

	UnitState = XComGameState_Unit(Tuple.Data[2].o);
	if (UnitState == none || IsUnitExcluded(UnitState))
		return ELR_NoInterrupt;

	ItemState = XComGameState_Item(EventSource);
	if (ItemState == none)
		return ELR_NoInterrupt;
		
	WeaponTemplate = X2WeaponTemplate(ItemState.GetMyTemplate());
	if (WeaponTemplate == none)
		return ELR_NoInterrupt;
	
	GlobalAllowedWeaponCats = class'WOTCIridarUtilitySlotSidearms_MCMScreen'.static.GetGlobalAllowedWeaponCats();
	if (GlobalAllowedWeaponCats.Find(WeaponTemplate.WeaponCat) != INDEX_NONE)
	{
		// Don't check restrictions for heavy weapons.
		if (WeaponTemplate.InventorySlot != eInvSlot_HeavyWeapon && `GETMCMVAR(DISALLOW_CLASS_WEAPONS))
		{
			SoldierClassTemplate = UnitState.GetSoldierClassTemplate();
			if (SoldierClassTemplate != none && !SoldierClassTemplate.IsWeaponAllowedByClass(WeaponTemplate))
			{
				Tuple.Data[0].b = true;
			}
		}
		else
		{
			Tuple.Data[0].b = true;
		}
	}
	
	return ELR_NoInterrupt;
}
