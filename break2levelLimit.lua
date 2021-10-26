detachIfPossible()
openProcess("MotorTown-Win64-Shipping.exe")
local fixT={184,80,80,0,0}
local fix={
{base='498B85480300008BCF',offset=17,replace=fixT},
{base='488B81480300008BCA',offset=26,replace=fixT}
}
pause()
for i=1,#fix do
	local x=aOBScan(fix[i].base,'+X-W-C',fsmAligned,'1')
	print(x.Count)
	if x.Count==1 then
		print(x.String[0])
		writeBytes(tonumber(x.String[0],16)+fix[i].offset,fix[i].replace)
		x.destroy()
	else
		print('non unique address')
	end
end
unpause()