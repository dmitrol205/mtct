table={{name='nearestVehicleTemperatures',value='F30F109B78020000440F28C3'}
{name='userVehicleFuels',value='F3410F108F90080000'},--dead
{name='nearestVehicleFuels',value='F30F118690080000'},--dead
{name='seatVehicleProbably',value='48891CF0488B742438F6435B10'},--seat unseat several times(track when car spawns)
{name='humanid?',value='F30F118734090000'},
{name='userDriverInVehicle',value='488B8B500200004885C974??4885F6',regsf='RBX+592'},
{name='vehicleWeights',value='488B8820030000F30F100491F30F5905'}--next instruction
{name='someVehArray',value='660F1F840000000000498B06488D3CF0488B04F0483B05'}--next 2 instruction
{name='garageVehNamePlacing',value='4C8B00498BD4488BC841FF5030'}--next 3 instruction
{name='someOuterGarageVehNamePlacing',value='F3440F114C2420448BC7488BCEE8'}--next 3 instruction
}
	local ms=createMemScan()
	ms.newScan()
	ms.OnlyOneResult=true
	ms.firstScan(soExactValue,vtByteArray,rtTruncated,value,'','0','00007fffffffffff','+X-W-C',fsmNotAligned,'',true,false,false,false)
	ms.waitTillDone()
	ms.Result

	--scan for humans in vehicle
	local ms=createMemScan()--valuescan for value in first address of seat[0x200]
	ms.newScan()
	ms.firstScan(soExactValue,vtDword,rtTruncated,'42D5A9A0','','0','7fffffffffffffff','-X+W-C',fsmAligned,'4',true,false,false,false)
	ms.waitTillDone()
	local fl=createFoundList(ms)
	fl.initialize()
	--_G['fl']=fl
	print('Addresses found',fl.Count)
	for i=1,fl.Count do
	    print(writeInteger(tonumber(fl.Address[i],16)+256,0))
	end
	fl.destroy()
	ms.destroy()

	---????
	_G['l']=aOBScan('48 * * 29 50 60 C3','+X-W-C',fsmAligned,'1')
	print(l.Count)
	print(l.String[0])
	l.destroy()
