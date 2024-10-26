GLOBAL.setfenv(1, GLOBAL)

local cooking = require("cooking")
local Bundler = require("components/bundler")

local function handle_cook_gift(self)
	local ingredient_prefabs = {}
	for slot, item in pairs(self.bundlinginst.components.container.slots) do
		table.insert(ingredient_prefabs, item.prefab)
	end

	local emulating_cookware_prefab = self.inst:HasTag("masterchef") and "portablecookpot" or "cookpot"
	local keepspoilage = emulating_cookware_prefab == "portablecookpot" --default refreshes spoilage by half, set to true will not
	local product_prefab = cooking.CalculateRecipe(emulating_cookware_prefab, ingredient_prefabs)
	if product_prefab == "batnosehat" then
		return
	end

	local product_spoilage
	local productperishtime = cooking.GetRecipe(emulating_cookware_prefab, product_prefab).perishtime or 0
	if productperishtime > 0 then
		local spoilage_total = 0
		local spoilage_n = 0
		for slot, item in pairs(self.bundlinginst.components.container.slots) do
			if item.components.perishable then
				spoilage_n = spoilage_n + 1
				spoilage_total = spoilage_total + item.components.perishable:GetPercent()
			end
		end
		product_spoilage =
			(spoilage_n <= 0 and 1)
			or (keepspoilage and spoilage_total / spoilage_n)
			or 1 - (1 - spoilage_total / spoilage_n) * .5
	end

	local lowest_stack
	-- local lowest_stack_item
	for slot, item in pairs(self.bundlinginst.components.container.slots) do
		local stack = item.components.stackable and item.components.stackable:StackSize() or 1
		if lowest_stack == nil or stack < lowest_stack then
			lowest_stack = stack
			-- lowest_stack_item = item
		end
	end

	for slot, item in pairs(self.bundlinginst.components.container.slots) do
		if item.components.stackable then
			item.components.stackable:Get(lowest_stack):Remove()
		else
			item:Remove()
		end
	end

	local product = SpawnPrefab(product_prefab)
	if product.components.stackable then
		-- Needs to handle non stackable products better
		product.components.stackable:SetStackSize(lowest_stack)
	end
	if product.components.perishable then
		product.components.perishable:SetPercent(product_spoilage)
	end
	-- Not the best, but good enough
	self.bundlinginst.components.container.finishing_bundling = true
	self.bundlinginst.components.container:GiveItem(product)
end

local on_finish_bundling = Bundler.OnFinishBundling
function Bundler:OnFinishBundling(...)
	if self.bundlinginst
		and self.bundlinginst.components.container
		and self.bundlinginst.components.container:IsFull()
		and self.wrappedprefab
	then
		if self.bundlinginst.prefab == "cookpackage_container" then
			handle_cook_gift(self)
		end
	end
	return on_finish_bundling(self, ...)
end
