--resetLuaState()
detachIfPossible()
--openProcess("MotorTown.exe")
openProcess("MotorTown-Win64-Shipping.exe")
--sleep(2000)--wait till connect correctly
--[[]]_G['mtype']=function(a)
	if type(a)=='userdata' then
		return 'class:'..a.ClassName
	else
		return type(a)
	end
end--]]
local loadMyArray=function(baseAddress,offset,names,value,freeze)
	for i=2,#names do
		--messageDialog('add ['..i..']: '..names[i])
		local mymemrec=AddressList.createMemoryRecord()
		mymemrec.Address=string.format('%X',baseAddress+offset*(i-1))
		mymemrec.Description=names[i]
		--sleep(100)
		mymemrec.Active=freeze and true or false
		--sleep(100)
		if type(value)=='number' then
			mymemrec.Value=value..''
			--writeInteger(baseAddress+offset*(i-1),value)
		end
		--mymemrec.Value='69'
	end
end
local freezeProgress=function(driverProgressAddress)
	loadMyArray(driverProgressAddress,8,{'driverProgress','taxiProgress','busProgress','truckProgress','racerProgress'},69,true)
end
local freezeLevel=function(baseAddress)
	loadMyArray(baseAddress,4,{'driverLevel','taxiLevel','busLevel','truckLevel','racerLevel'},1,true)--not working now(have protection)
end
local freezeVisualLevel=function(baseAddress)
	loadMyArray(baseAddress,4,{'driverVisualLevel','taxiVisualLevel','busVisualLevel','truckVisualLevel','racerVisualLevel'},1,true)
end
local parseAccessInstruction=function(address)
	local myregs=disassemble(string.format('%X',_G['maa'..key])):gmatch('%[[^%]]*%]')()
	myregs=myregs:sub(2,#myregs-1):upper()
	print(myregs,mtype(myregs))
	local myAddress=load('return '..myregs)()
end--TODO if calculation of address will be required.
local addRecordUnder=function(memrecto,address,hex,desc,offset,type,sign)
	local m=AddressList.createMemoryRecord()
	m.Address=address
	m.ShowAsHex=hex
	m.Description=desc
	if memrecto~=nil then
		m.appendToEntry(memrecto)
	end
	if offset~=nil then
		m.OffsetCount=#offset
		for i=1,#offset do
			m.Offset[i-1]=offset[i]
		end
	end
	if type~=nil then
		m.Type=type
	end
	if sign~=nil then
		m.ShowAsSigned=sign
	end
	return m
end
local vehicleStructFill=function(baseAddress)
	local myad=AddressList.getMemoryRecordByDescription('userDriverInVehicle')
	--myad.Type=vtGrouped
	local vehparts='39:Transmission\n*:undeclared'
	myad.ShowAsHex=true
	local m0=addRecordUnder(myad,'+0',true,'vehicle',{0})
	local m1=addRecordUnder(m0,'+1058',true,'driverStructurePointer',{0})
	local m2=addRecordUnder(m1,'+200',true,'driverID',{})
		m2=addRecordUnder(m1,'+20',true,'checkVehID',{})--not necessary
	m1=addRecordUnder(m0,'+1050',true,'passengerStructurePointer',{0})
	m2=addRecordUnder(m1,'+200',true,'passengerID',{})
		m2=addRecordUnder(m1,'+20',true,'checkVehID',{})--not necessary
	m1=addRecordUnder(m0,'+1030',true,'passenger2StructurePointer',{0})
	m2=addRecordUnder(m1,'+200',true,'passenger2ID',{})
		m2=addRecordUnder(m1,'+20',true,'checkVehID',{})--not necessary
	m1=addRecordUnder(m0,'+ED8',false,'cruiseControl',{},vtSingle)
	m1=addRecordUnder(m0,'+468',false,'heating',{632},vtSingle)
	m1=addRecordUnder(m0,'+8A0',false,'fuel',{},vtSingle)
	m1=addRecordUnder(m0,'+520',false,'gear',{248})
	m1=addRecordUnder(m0,'+538',true,'seatBaseAddress',{},vtQword)
	m2=addRecordUnder(m1,'+8',false,'seatAmount',{})
	m2=addRecordUnder(m1,'+0',true,'seat',{0,0})
	local m3=addRecordUnder(m2,'+200',true,'humanID',{})
	m3=addRecordUnder(m2,'+20',true,'checkVehID',{})
	m2=addRecordUnder(m1,'+0',true,'seat',{0,8})
	m3=addRecordUnder(m2,'+200',true,'humanID',{})
	m3=addRecordUnder(m2,'+20',true,'checkVehID',{})
	m1=addRecordUnder(m0,'+C48',true,'parts',{})
	m2=addRecordUnder(m1,'+8',false,'amount',{})
	m2=addRecordUnder(m1,'+0',false,'part',{0})
	m3=addRecordUnder(m2,'+14',false,'damage',{},vtSingle)
end
local relParams=function(base)
	local m=addRecordUnder(AddressList.getMemoryRecordByDescription('Money'),'+10',false,'vehiclesAmountInGarage',{})
end
local valueTable={
{name='Money',value='488B86A8000000498987A800000049636C2408',freeze=true,setValue='666777888',additionalf=relParams,regsf='RSI+168'},
{name='driverProgress',value='4A8B14C048B8CFF753E3A59BC420',freeze=true,setValue='69',additionalf=freezeProgress,regsf='RAX'},
--{name='driverLevel',value='8B0490C333C0C3CCCCCC4053',freeze=true,setValue='80',additionalf=freezeLevel,regsf='RAX'},--unavailable(changed)--old
{name='driverLevel',value='488B81480300008BCA',freeze=true,setValue='1',additionalf=freezeLevel,regsf='readInteger(RCX+840)'},--don't work properly have protection(like old see break2levelLimit.lua(cmp,cmov))
{name='driverVisualLevel',value='46890C80C3',freeze=true,setValue='1',additionalf=freezeVisualLevel,regsf='RAX'},
--{name='userDriverInVehicle',value='488B8B500200004885C974??4885F6',freeze=false,setValue=nil,additionalf=vehicleStructFill,regsf='RBX+592'}
}
function valueGatherer(key,value,isfreeze,setValue,afterCall,regsf)
	--messageDialog('init '..key)
	local ms=createMemScan()
	--local fl=createFoundList(ms)
	ms.newScan()
	ms.OnlyOneResult=true
	ms.firstScan(soExactValue,vtByteArray,rtTruncated,value,'','0','00007fffffffffff','+X-W-C',fsmNotAligned,'',true,false,false,false)
	ms.waitTillDone()
	--fl.initialize()
	--print('Addresses found',fl.Count)
	--print(string.format('Address is %X',ms.Result))
	--sleep(100)
	if(type(ms.Result)=='nil')then
		print('something goes wrong with scan',key)
		pause()
		return
	end
	_G['maa'..key]=ms.Result
	ms.newScan()
	--fl.destroy()
	ms.destroy()

	_G['myf'..key]=function()
		--messageDialog('Put '..key..' in table')
		local myAddress=load('return '..regsf)()
		debug_removeBreakpoint(_G['maa'..key])
		local mymemrec=AddressList.createMemoryRecord()
		mymemrec.Address=string.format('%X',myAddress)
		mymemrec.Description=key
		--sleep(100)
		if isfreeze==true then
			mymemrec.Active=true
		end
		--sleep(500)
		if type(setValue)=='string' then
			--mymemrec.Value=setValue
			--local t=createTimer()
			--t.Interval=2000
			createThread(function()
				sleep(10000)
				print('fired '..key)
				mymemrec.Value=setValue
				--writeInteger(myAddress,tonumber(setValue))
				--t.destroy()
			end)
		--else
			--print('value isn\'t set of',key,type(setValue))
		end
		_G['myf'..key]=nil
		if type(afterCall)=='function' then
			afterCall(myAddress)
		end
		_G['maa'..key]=nil
	end

	print(key..' hook',disassemble(_G['maa'..key]))

	debugProcess()
	--debug_setBreakpoint(string.format('%X',_G['maa'..key]),getInstructionSize(_G['maa'..key]),bptAccess,_G['myf'..key])
	debug_setBreakpoint(_G['maa'..key],_G['myf'..key])
end
for i,v in ipairs(valueTable) do
	valueGatherer(v.name,v.value,v.freeze,v.setValue,v.additionalf,v.regsf)
end
unpause()
