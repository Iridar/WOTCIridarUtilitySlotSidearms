class X2DLCInfo_USS extends X2DownloadableContentInfo;

var config(WOTCIridarUtilitySlotSidearms_DEFAULT) array<name> NonSecondaryWeaponCategories;
var config(WOTCIridarUtilitySlotSidearms_DEFAULT) array<name> ExcludedWeaponCategories;

static function bool CanAddItemToInventory_CH_Improved(out int bCanAddItem, const EInventorySlot Slot, const X2ItemTemplate ItemTemplate, int Quantity, XComGameState_Unit UnitState, optional XComGameState CheckGameState, optional out string DisabledReason, optional XComGameState_Item ItemState)
{
	local X2WeaponTemplate			WeaponTemplate;
	local array<XComGameState_Item>	UtilityItems;
	local array<name>				GlobalAllowedWeaponCats;
	
	if (Slot != eInvSlot_Utility)
		return CheckGameState == none; //	Do not override normal behavior.

	WeaponTemplate = X2WeaponTemplate(ItemTemplate);
	if (WeaponTemplate == none)
		return CheckGameState == none; //	Do not override normal behavior.

	if (class'X2EventListener_USS'.static.IsUnitExcluded(UnitState))
		return CheckGameState == none; //	Do not override normal behavior.
	
	GlobalAllowedWeaponCats = class'WOTCIridarUtilitySlotSidearms_MCMScreen'.static.GetGlobalAllowedWeaponCats();
	if (GlobalAllowedWeaponCats.Find(WeaponTemplate.WeaponCat) == INDEX_NONE)
		return CheckGameState == none; //	Do not override normal behavior.
	
	if (CheckGameState != none)
	{
		// Check if there's at least one utility slot empty
		UtilityItems = UnitState.GetAllItemsInSlot(eInvSlot_Utility, CheckGameState,, true);
		if (UtilityItems.Length < UnitState.RealizeItemSlotsCount(CheckGameState))
		{
			bCanAddItem = 1;
			return CheckGameState != none; // Override normal behavior
		}
	}

	DisabledReason = "";
	return CheckGameState != none; // Override normal behavior
}

static event OnPostTemplatesCreated()
{
	local CHHelpers	CHHelpersObj;
	//local X2ItemTemplateManager		ItemMgr;
	//local X2WeaponTemplate WeaponTemplate;

	CHHelpersObj = class'CHHelpers'.static.GetCDO();
	if (CHHelpersObj != none)
	{
		CHHelpersObj.AddShouldDisplayMultiSlotItemInStrategyCallback(ShouldDisplayMultiSlotItemInStrategyDelegate, 50);
		CHHelpersObj.AddShouldDisplayMultiSlotItemInTacticalCallback(ShouldDisplayMultiSlotItemInTacticalDelegate, 50);
	}

	//ItemMgr = class'X2ItemTemplateManager'.static.GetItemTemplateManager();
	//WeaponTemplate = X2WeaponTemplate(ItemMgr.FindItemTemplate('ShardGauntletLeft_CV'));
	//WeaponTemplate.Abilities.AddItem('Rend');

	CacheValidWeaponCats();
	PatchCharacterMatinees();
}

static private function PatchCharacterMatinees()
{
    local X2CharacterTemplateManager    CharMgr;
    local X2CharacterTemplate           CharTemplate;
	local array<X2DataTemplate>			DifficultyVariants;
	local X2DataTemplate				DifficultyVariant;
	local X2DataTemplate				DataTemplate;
	
    CharMgr = class'X2CharacterTemplateManager'.static.GetCharacterTemplateManager();

	//	Cycle through all "humanoid" character templates that are used by the game to create player-controllable soldiers
	foreach CharMgr.IterateTemplates(DataTemplate, none)
	{
		// Cycling through diff. templates isn't necessary for this but eh well, can't fox them all
		CharMgr.FindDataTemplateAllDifficulties(DataTemplate.DataName, DifficultyVariants);
		foreach DifficultyVariants(DifficultyVariant)
		{
			CharTemplate = X2CharacterTemplate(DifficultyVariant);

			if (CharTemplate != none && CharTemplate.bIsSoldier && CharTemplate.UnitHeight == 2 && CharTemplate.UnitSize == 1)
			{
				//	This will let regular soldiers use BIT Hack matinee even if there's no SPARK on the mission.
				CharTemplate.strMatineePackages.AddItem("CIN_Spark");
			}
		}
	}
}

static private function CacheValidWeaponCats()
{
	local WOTCIridarUtilitySlotSidearms_MCMScreen CDO;
	local name WeaponCat;

	CDO = WOTCIridarUtilitySlotSidearms_MCMScreen(class'XComEngine'.static.GetClassDefaultObject(class'WOTCIridarUtilitySlotSidearms.WOTCIridarUtilitySlotSidearms_MCMScreen'));
	CDO.ValidWeaponCats = GetValidWeaponCats();

	foreach default.NonSecondaryWeaponCategories(WeaponCat)
	{
		CDO.ValidWeaponCats.AddItem(WeaponCat);
	}
}

static private function array<name> GetValidWeaponCats()
{
	local X2ItemTemplateManager		ItemMgr;
	local name						WeaponCat;
	local array<name>				SecondaryWeaponCats;
	local array<X2WeaponTemplate>	WeaponTemplates;
	local X2WeaponTemplate			WeaponTemplate;

	ItemMgr = class'X2ItemTemplateManager'.static.GetItemTemplateManager();
	WeaponTemplates = ItemMgr.GetAllWeaponTemplates();

	foreach ItemMgr.WeaponCategories(WeaponCat)
	{
		if (default.ExcludedWeaponCategories.Find(WeaponCat) != INDEX_NONE)
			continue;

		foreach WeaponTemplates(WeaponTemplate)
		{
			if (WeaponTemplate.WeaponCat == WeaponCat && WeaponTemplate.InventorySlot == eInvSlot_SecondaryWeapon) 
			{
				if (class'UIUtilities_Strategy'.static.GetAllowedClassForWeapon(WeaponTemplate) != none) // Ensure that at least one soldier can use this weapon.
				{
					SecondaryWeaponCats.AddItem(WeaponCat);
					break;
				}
			}
		}
	}
	return SecondaryWeaponCats;
}

static private function EHLDelegateReturn ShouldDisplayMultiSlotItemInStrategyDelegate(XComGameState_Unit UnitState, XComGameState_Item ItemState, out int bDisplayItem, XComUnitPawn UnitPawn, optional XComGameState CheckGameState)
{
	ShouldDisplayUtilitySlotItem(ItemState, bDisplayItem);
	return EHLDR_NoInterrupt;
}

static private function EHLDelegateReturn ShouldDisplayMultiSlotItemInTacticalDelegate(XComGameState_Unit UnitState, XComGameState_Item ItemState, out int bDisplayItem, XGUnit UnitVisualizer, optional XComGameState CheckGameState)
{
	ShouldDisplayUtilitySlotItem(ItemState, bDisplayItem);
	return EHLDR_NoInterrupt;
}

static private function bool ShouldDisplayUtilitySlotItem(XComGameState_Item ItemState, out int bDisplayItem)
{
	local X2WeaponTemplate	WeaponTemplate;
	local array<name>		GlobalAllowedWeaponCats;

	if (ItemState.InventorySlot == eInvSlot_Utility)
	{
		WeaponTemplate = X2WeaponTemplate(ItemState.GetMyTemplate());
		if (WeaponTemplate != none && WeaponTemplate.iItemSize > 0)
		{
			GlobalAllowedWeaponCats = class'WOTCIridarUtilitySlotSidearms_MCMScreen'.static.GetGlobalAllowedWeaponCats();
			if (GlobalAllowedWeaponCats.Find(WeaponTemplate.WeaponCat) != INDEX_NONE)
			{
				bDisplayItem = 1;
			}
		}
	}
	//	Return false to allow following Delegates to override the output of this delegate.
	return false;
}


//static function GetNumUtilitySlotsOverride(out int NumUtilitySlots, XComGameState_Item EquippedArmor, XComGameState_Unit UnitState, XComGameState CheckGameState)
//{
//	NumUtilitySlots = 30;
//}

/*
static function DLCAppendWeaponSockets(out array<SkeletalMeshSocket> NewSockets, XComWeapon Weapon, XComGameState_Item ItemState)
{
	local array<SkeletalMeshSocket> Sockets;
    local SkeletalMeshSocket    Socket;
	local SkeletalMeshSocket    NewSocket;
    local vector                RelativeLocation;
    local rotator               RelativeRotation;
    local vector                RelativeScale;

    if (ItemState != none && HasSuppressorEquipped(ItemState))
    {
		Sockets = SkeletalMeshComponent(Weapon.Mesh).Sockets;
		foreach Sockets(Socket)
		{
			if (Socket.SocketName != 'gun_fire')
				continue;

			NewSocket = new class'SkeletalMeshSocket';

			NewSocket.SocketName = Socket.SocketName;
			NewSocket.BoneName = Socket.BoneName;
			NewSocket.RelativeLocation = Socket.RelativeLocation;
			NewSocket.RelativeRotation = Socket.RelativeRotation;
			NewSocket.RelativeScale = Socket.RelativeScale;

			//  Location offsets are in Unreal Units; 1 unit is roughly equal to a centimeter.
			Socket.RelativeLocation.X += GetSuppressorOffsetForWeapon(ItemState);

			NewSockets.AddItem(Socket);
			return;
		}		
    }
}

static final function bool HasSuppressorEquipped(const XComGameState_Item ItemState)
{
	// TODO: Write this
	return true;
}

static final function int GetSuppressorOffsetForWeapon(const XComGameState_Item ItemState)
{
	// TODO: Write this
	return 5;
}*/