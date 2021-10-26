detachIfPossible()
openProcess("MotorTown-Win64-Shipping.exe")
debugProcess()
--debug_removeBreakpoint(address)
--debug_setBreakpoint(address,func)
local vall=tonumber('97216A00',16)
local graspValues=function ()
	if RAX~=vall then
		return true
	end
	print('out')
	for i=1,3 do
		local address=string.format('%X',readQword(RSP+i*8))
		local value=string.format('%X',readQword(address))
		print(address,value)
	end
end
debug_setBreakpoint('VCRUNTIME140.memcpy+426',graspValues)