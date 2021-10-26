local ms=createMemScan()--driver search
	ms.newScan()
	ms.firstScan(soExactValue,vtDword,rtTruncated,'751A01C0','','0','7fffffffffffffff','-X+W-C',fsmAligned,'4',true,false,false,false)
	ms.waitTillDone()
	local fl=createFoundList(ms)
	fl.initialize()
	--_G['fl']=fl
	print('Addresses found',fl.Count)
	for i=1,fl.Count do
		local x=readInteger(tonumber(fl.Address[i],16)-8)
		if x~= nil then
			x=readInteger(x+256)
			if x~=nil and x~=0 then
				local mymemrec=AddressList.createMemoryRecord()
				mymemrec.Description='test driver record'
				mymemrec.ShowAsHex=true
				mymemrec.Address=string.format('%X',x)
			end
		end
	end
	fl.destroy()
	ms.destroy()