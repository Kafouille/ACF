local Damaged = {
	CreateMaterial("ACF_Damaged1", "VertexLitGeneric", {["$basetexture"] = "damaged/damaged1"}),
	CreateMaterial("ACF_Damaged2", "VertexLitGeneric", {["$basetexture"] = "damaged/damaged2"}),
	CreateMaterial("ACF_Damaged3", "VertexLitGeneric", {["$basetexture"] = "damaged/damaged3"})
}

--local DrawModel = FindMetaTable("Entity").DrawModel
hook.Add("PostDrawOpaqueRenderables", "ACF_RenderDamage", function()
	if not ACF_HealthRenderList then return end
    cam.Start3D( EyePos(), EyeAngles() )
		for k,ent in pairs( ACF_HealthRenderList ) do
			if IsValid(ent) then
				local Percent = ent.ACF_HelathPercent
				render.ModelMaterialOverride( ent.ACF_Material )
				render.SetBlend(1-Percent)
				ent:DrawModel()
				render.ModelMaterialOverride()
				render.SetBlend(1)
			elseif ACF_HealthRenderList then
				table.remove(ACF_HealthRenderList,k)
			end
		end
	cam.End3D()
end)

net.Receive("ACF_RenderDamage", function()
	local ent, Health, MaxHealth = ents.GetByIndex(net.ReadFloat()), net.ReadFloat(), net.ReadFloat()
	if not IsValid(ent) then return end
	if Health != MaxHealth then
		ent.ACF_Health = Health
		ent.ACF_MaxHealth = MaxHealth
		ent.ACF_HelathPercent = (Health/MaxHealth)
		if ent.ACF_HelathPercent > 0.7 then
			ent.ACF_Material = Damaged[1]
		elseif ent.ACF_HelathPercent > 0.3 then
			ent.ACF_Material = Damaged[2]
		elseif ent.ACF_HelathPercent <= 0.3 then
			ent.ACF_Material = Damaged[3]
		end
		ACF_HealthRenderList = ACF_HealthRenderList or {}
		ACF_HealthRenderList[ent:EntIndex()] = ent
	else
		if ACF_HealthRenderList then
			if #ACF_HealthRenderList<=1 then
				ACF_HealthRenderList = nil
			else
				table.remove(ACF_HealthRenderList,ent:EntIndex())
			end
			if ent.ACF then
				ent.ACF.Health = nil
				ent.ACF.MaxHealth = nil
			end
		end
	end
end)