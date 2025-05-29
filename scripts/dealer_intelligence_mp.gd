class_name DealerIntelligenceMP extends DealerIntelligence
func DealerCheckHandCuffs():
	var brokeFree = false
	camera.BeginLerp("enemy cuffs close")
	if (!dealerAboutToBreakFree):
		await get_tree().create_timer(.3, false).timeout
		speaker_checkHandcuffs.play()
		animator_dealerHands.play("dealer check handcuffs")
		await get_tree().create_timer(.7, false).timeout
		brokeFree = false
	else:
		await get_tree().create_timer(.3, false).timeout
		animator_dealerHands.play("dealer break cuffs") #replace with broke free anim
		speaker_breakHandcuffs.play()
		#await get_tree().create_timer(.7, false).timeout
		brokeFree = true
		roundManager.dealerCuffed = false
		dealerAboutToBreakFree = false
	dealerAboutToBreakFree = true
	roundManager.ReturnFromCuffCheck(brokeFree)

func Animator_CheckHandcuffs():
	speaker_checkHandcuffs.play()

func Animator_GiveHandcuffs():
	speaker_giveHandcuffs.play()

func BeginDealerTurn():
	mainLoopFinished = false
	usingHandsaw = false
	usingMedicine = false
	DealerChoice()

func DealerChoice():
	print('Enemy is making a choice')
	return
	var dealerWantsToUse:= ""
	var dealerFinishedUsingItems = false
	var hasHandsaw = false
	var hasCigs = false
	if (roundManager.requestedWireCut):
		await(roundManager.defibCutter.CutWire(roundManager.wireToCut))
	if (shellSpawner.sequenceArray.size() == 0):
		roundManager.StartRound(true)
		return

	if (roundManager.endless && !dealerKnowsShell):
		dealerKnowsShell = FigureOutShell()
		if (dealerKnowsShell):
			if (roundManager.shellSpawner.sequenceArray[0] == "blank"): 
				knownShell = "blank"
				dealerTarget = "self"
			else: 
				knownShell = "live"
				dealerTarget = "player"

	if (roundManager.shellSpawner.sequenceArray.size() == 1):
		knownShell = shellSpawner.sequenceArray[0]
		if (shellSpawner.sequenceArray[0] == "live"): knownShell = "live" 
		else: knownShell = "blank"
		if (knownShell == "live"): dealerTarget = "player"
		else: dealerTarget = "self"
		dealerKnowsShell = true
	for i in range(itemManager.itemArray_dealer.size()):
		if (itemManager.itemArray_dealer[i] == "cigarettes"):
			hasCigs = true
			break
	
	inv_playerside = []
	inv_dealerside = []
	itemManager.itemArray_dealer = []
	itemManager.itemArray_instances_dealer = []
	var usingAdrenaline = false
	var ch = itemManager.itemSpawnParent.get_children()
	for c in ch.size():
		if(ch[c].get_child(0) is PickupIndicator):
			var temp_interaction : InteractionBranch = ch[c].get_child(1)
			if (temp_interaction.itemName == "adrenaline" && !temp_interaction.isPlayerSide):
				usingAdrenaline = true
				adrenalineSetup	= true
	for c in ch.size():
		if(ch[c].get_child(0) is PickupIndicator):
			var temp_indicator : PickupIndicator = ch[c].get_child(0)
			var temp_interaction : InteractionBranch = ch[c].get_child(1)
			if (ch[c].transform.origin.z > 0): temp_indicator.whichSide = "right"
			else: temp_indicator.whichSide= "left"
			if (!temp_interaction.isPlayerSide):
				inv_dealerside.append(temp_interaction.itemName)
				itemManager.itemArray_dealer.append(temp_interaction.itemName)
				itemManager.itemArray_instances_dealer.append(ch[c])
	for c in ch.size():
		if(ch[c].get_child(0) is PickupIndicator):
			var temp_indicator : PickupIndicator = ch[c].get_child(0)
			var temp_interaction : InteractionBranch = ch[c].get_child(1)
			if (ch[c].transform.origin.z > 0): temp_indicator.whichSide = "right"
			else: temp_indicator.whichSide= "left"
			if (temp_interaction.isPlayerSide && usingAdrenaline): 
				itemManager.itemArray_dealer.append(temp_interaction.itemName)
				itemManager.itemArray_instances_dealer.append(ch[c])
				inv_playerside.append(temp_interaction.itemName)
	
	for i in range(itemManager.itemArray_dealer.size()):
		if (itemManager.itemArray_dealer[i] == "magnifying glass" && !dealerKnowsShell && shellSpawner.sequenceArray.size() != 1):
			dealerWantsToUse = "magnifying glass"
			if (shellSpawner.sequenceArray[0] == "live"): knownShell = "live" 
			else: knownShell = "blank"
			if (knownShell == "live"): dealerTarget = "player"
			else: dealerTarget = "self"
			dealerKnowsShell = true
			break
		if (itemManager.itemArray_dealer[i] == "cigarettes"):
			if (roundManager.health_opponent < roundManager.roundArray[0].startingHealth):
				dealerWantsToUse = "cigarettes"
				hasCigs = false
				break
		if (itemManager.itemArray_dealer[i] == "expired medicine" && roundManager.health_opponent < (roundManager.roundArray[0].startingHealth) && !hasCigs && !usingMedicine):
			if (roundManager.health_opponent != 1): 
				dealerWantsToUse = "expired medicine"
				usingMedicine = true
				break
		if (itemManager.itemArray_dealer[i] == "beer" && knownShell != "live" && shellSpawner.sequenceArray.size() != 1):
			dealerWantsToUse = "beer"
			shellEject_dealer.FadeOutShell()
			if (roundManager.endless):
				dealerKnowsShell = false
				knownShell = ""
			break
		if (itemManager.itemArray_dealer[i] == "handcuffs" && roundManager.playerCuffed == false && shellSpawner.sequenceArray.size() != 1):
			dealerWantsToUse = "handcuffs"
			roundManager.playerCuffed = true
			break
		if (itemManager.itemArray_dealer[i] == "handsaw" && !roundManager.barrelSawedOff && knownShell == "live"):
			dealerWantsToUse = "handsaw"
			usingHandsaw = true
			roundManager.barrelSawedOff = true
			roundManager.currentShotgunDamage = 2
			break
		if (itemManager.itemArray_dealer[i] == "burner phone" && roundManager.shellSpawner.sequenceArray.size() > 2):
			var sequence:= roundManager.shellSpawner.sequenceArray
			var _len:= sequence.size()
			var randindex:=  randi_range(1, _len - 1)
			if(randindex == 8): randindex -= 1
			sequenceArray_knownShell[randindex] = true
			dealerWantsToUse = "burner phone"
			break
		if (itemManager.itemArray_dealer[i] == "inverter" && dealerKnowsShell && knownShell == "blank"):
			dealerWantsToUse = "inverter"
			knownShell = "live"
			dealerKnowsShell = true
			roundManager.shellSpawner.sequenceArray[0] = "live"
			dealerTarget = "player"
			break
	
	if (dealerWantsToUse == ""): mainLoopFinished = true
	for i in range(itemManager.itemArray_dealer.size()):
		if (itemManager.itemArray_dealer[i] == "handsaw"): hasHandsaw = true
	if (mainLoopFinished && !usingHandsaw && hasHandsaw && !roundManager.barrelSawedOff && knownShell != "blank"):
		var decision = CoinFlip()
		if (decision == 0): dealerTarget = "self"
		else: 
			dealerUsedItem = true
			dealerTarget = "player"
			dealerWantsToUse = "handsaw"
			usingHandsaw = true
			roundManager.barrelSawedOff = true
			roundManager.currentShotgunDamage = 2
		
	if (dealerWantsToUse != ""): 
		# 使用道具
		await use_item(dealerWantsToUse)
		return
	if (dealerWantsToUse == ""): dealerFinishedUsingItems = true
	if (roundManager.waitingForDealerReturn):
		await get_tree().create_timer(1.8, false).timeout
	if (!dealerHoldingShotgun && dealerFinishedUsingItems):
		await pick_up_shotgun()
		await get_tree().create_timer(1.4 + .5 - 1, false).timeout
	await get_tree().create_timer(1, false).timeout
	if (dealerTarget == ""): ChooseWhoToShootRandomly()
	else: Shoot(dealerTarget)
	dealerTarget = ""
	knownShell = ""
	dealerKnowsShell = false
	pass

func FigureOutShell():
	if (sequenceArray_knownShell[0] == true): return true
	
	var seq = shellSpawner.sequenceArray
	var mem = sequenceArray_knownShell
	
	var c_live = 0
	var c_blank = 0
	for shell in seq:
		if (shell == "blank"): c_blank += 1
		if (shell == "live"): c_live += 1
	if (c_live == 0): return true
	if (c_blank == 0): return true
	
	for c in mem.size():
		if (mem[c] == true): 
			if(seq[c] == "live"): c_live -= 1
			else:  c_blank -= 1
	if (c_live == 0): return true
	if (c_blank == 0): return true
	
	return false

func EndDealerTurn(canDealerGoAgain : bool):
	dealerCanGoAgain = canDealerGoAgain
	#USINGITEMS: ASSIGN DEALER CAN GO AGAIN FROM ITEMS HERE
	#CHECK IF OUT OF HEALTH
	var outOfHealth_player = roundManager.health_player == 0
	var outOfHealth_enemy = roundManager.health_opponent == 0
	var outOfHealth = outOfHealth_player or outOfHealth_enemy
	if (outOfHealth):
		#if (outOfHealth_player): roundManager.OutOfHealth("player")
		if (outOfHealth_enemy):	roundManager.OutOfHealth("dealer")
		return

	if (!dealerCanGoAgain):
		EndTurnMain()
	else:
		if (shellSpawner.sequenceArray.size()):
			BeginDealerTurn()
		else:
			EndTurnMain()
	pass

func ChooseWhoToShootRandomly():
	var decision = CoinFlip()
	if (decision == 0): Shoot("self")
	else: Shoot("player")

func GrabShotgun():
	#await get_tree().create_timer(1, false).timeout
	#camera.BeginLerp("enemy")
	#await get_tree().create_timer(.8, false).timeout
	await(shellLoader.DealerHandsGrabShotgun())
	await get_tree().create_timer(.2, false).timeout
	animator_shotgun.play("grab shotgun_pointing enemy")
	dealerHoldingShotgun = true
	pass

func put_down_shotgun():
	print("Putting down shotgun")
	if dealerHoldingShotgun:
		animator_shotgun.play("enemy put down shotgun")
		shellLoader.DealerHandsDropShotgun()
		dealerHoldingShotgun = false

func EndTurnMain():
	await get_tree().create_timer(.5, false).timeout
	camera.BeginLerp("home")
	put_down_shotgun()
	roundManager.EndTurn(true)

func use_item(item_name: String) -> void:
	print('Enemy is using item: ', item_name)
	
	if (dealerHoldingShotgun):
		put_down_shotgun()
		await get_tree().create_timer(.45, false).timeout
	
	dealerUsedItem = true
	if (roundManager.waitingForDealerReturn):
		await get_tree().create_timer(1.8, false).timeout
		roundManager.waitingForDealerReturn = false

	var returning = false
	
	if (item_name == "expired medicine"):
		var medicine_outcome = randf_range(0.0, 1.0)
		var dying = medicine_outcome < .5
		medicine.dealerDying = dying
		returning = true
	
	var amountArray : Array[AmountResource] = amounts.array_amounts
	for res in amountArray:
		if (item_name == res.itemName):
			res.amount_dealer -= 1
			break
	
	var stealingFromPlayer = true
	for i in range(inv_dealerside.size()):
		if (inv_dealerside[i] == item_name): 
			stealingFromPlayer = false
	
	var subtracting = true
	var temp_stealing = false
	for i in range(itemManager.itemArray_instances_dealer.size()):
		if (itemManager.itemArray_instances_dealer[i].get_child(1).itemName == item_name && 
			itemManager.itemArray_instances_dealer[i].get_child(1).isPlayerSide && 
			item_name != "adrenaline" && adrenalineSetup && stealingFromPlayer):
				temp_stealing = true
				await(hands.PickupItemFromTable("adrenaline"))
				itemManager.numberOfItemsGrabbed_enemy -= 1
				subtracting = false
				adrenalineSetup = false
				break
	
	if (temp_stealing): hands.stealing = true
	await(hands.PickupItemFromTable(item_name))
	
	if (item_name == "cigarettes"): 
		await get_tree().create_timer(1.1, false).timeout
	
	itemManager.itemArray_dealer.erase(item_name)
	if (subtracting): itemManager.numberOfItemsGrabbed_enemy -= 1
	
	if (returning): return
	
	DealerChoice()

func pick_up_shotgun():
	if (!dealerHoldingShotgun):
		await(shellLoader.DealerHandsGrabShotgun())
		await get_tree().create_timer(.2, false).timeout
		animator_shotgun.play("grab shotgun_pointing enemy")
		dealerHoldingShotgun = true

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed('debug_n4'): pick_up_shotgun()
	if Input.is_action_just_pressed('debug_n6'): put_down_shotgun()
	if Input.is_action_just_pressed('debug_n8'): Shoot('self')
	if Input.is_action_just_pressed('debug_n2'): Shoot('player')
	if Input.is_action_just_pressed('debug_n5'):
		if itemManager.itemArray_dealer.size() >= 1:
			use_item(itemManager.itemArray_dealer[0])
	
	if Input.is_action_just_pressed('debug_]'): print(roundManager.shellSpawner.sequenceArray)
	if Input.is_action_just_pressed('debug_;'): roundManager.shellSpawner.sequenceArray = ['blank', 'blank', 'blank', 'blank', 'blank', 'blank', 'blank', 'blank', 'blank', 'blank', 'blank', 'blank', 'blank', 'blank', 'blank', 'blank', 'blank', 'blank', 'blank', 'blank', 'blank', 'blank', 'blank', 'blank', 'blank', 'blank', 'blank', 'blank', 'blank', 'blank', 'blank', 'blank', 'blank', 'blank']
	if Input.is_action_just_pressed('debug_.'): roundManager.shellSpawner.sequenceArray = ['live']
