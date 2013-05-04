----------------------------------------------------------------------------
-- This script overrides Entity.SetParent and adds a GetChildren function
-- which returns a table of all props that are parented to it.
----------------------------------------------------------------------------

if CLIENT then return end

local meta = FindMetaTable( "Entity" )

meta.SetParentEngine = meta.SetParent

function meta:SetParent( parent )
	
	local oldparent = self:GetParent()
	self:SetParentEngine( parent )
	
	-- If we're unparenting or changing parent, remove the ent from the previous parent's childtable
	if IsValid( oldparent ) and oldparent ~= parent and oldparent._children then
		oldparent._children[ self ] = nil
	end
	
	-- If we're parenting to a new/different ent, insert the ent into the parent's childtable
	if IsValid( parent ) then
		parent._children = parent._children or {}
		parent._children[ self ] = self
		self:CallOnRemove( "UnparentOnRemove", function( ent ) ent:SetParent( nil ) end )
	end
	
end

function meta:GetChildren()
	
	return self._children or {}
	
end