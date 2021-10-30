detachIfPossible()
openProcess("MotorTown-Win64-Shipping.exe")
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
local loadList=function(memrec,reado,desco,dispasdd,lines)
	for i=1,#lines do
		memrec.DropDownList.add(lines[i])
	end
	memrec.DropDownReadOnly=reado
	memrec.DropDownDescriptionOnly=desco
	memrec.DisplayAsDropDownListItem=dispasdd
	return memrec
end
local vehFill=function(brec)
	local m0,m1,m2,m3,m4,m00=nil,nil,nil,nil,nil,nil
	m0=addRecordUnder(brec,'+0',true,'vehicle',{0})
	m0.Options='[moAllowManualCollapseAndExpand,moManualExpandCollapse]'
		--m1=loadList(addRecordUnder(m0,'+11',true,'VehicleModelReadOnly',{},vtByte),true,true,true,{'27:Ranton','66:Stinger','4A:Enfo GT','A8:Stella','DD:Van','70:Pickup','38:Spider','43:Elisa','C1:Trophy Taxi','B6:Tow Truck','CF:Truck','66:FL1','*:unrecorded'})
		m1=addRecordUnder(m0,'+50',true,'selfID',{})
		m1=addRecordUnder(m0,'+114',false,'timer',{},vtSingle)
		m1=addRecordUnder(m0,'+128',true,'trailerAttached(bool)',{})--FL1-tested
		m1=addRecordUnder(m0,'+468',true,'engineStructure?',{0})
			--m2=addRecordUnder(m1,'+D0',true,'someval',{})
			--m2=addRecordUnder(m1,'+D8',false,'engineWorkingReadOnly',{},vtByte)
			m2=addRecordUnder(m1,'+278',false,'heating',{},vtSingle)
		m1=addRecordUnder(m0,'+520',false,'gear',{248})
		m1=addRecordUnder(m0,'+538',true,'seatBaseAddress',{},vtGrouped)--vtQword
			m2=addRecordUnder(m1,'+8',false,'amount',{})
		m1.OnActivate=function(mr,bf,cur)
			--print(bf and 'true' or 'false',cur and 'true' or 'false')
			if bf then return true end
			for i=0,tonumber(mr[0].Value)-1 do
				m2=addRecordUnder(mr,'+0',true,'seat',{0,i*8})
				m3=addRecordUnder(m2,'+200',true,'humanID',{})
				m3=addRecordUnder(m2,'+20',true,'checkVehID',{})
				--m3=addRecordUnder(m2,'+A0',true,'someval',{})
				--m3=addRecordUnder(m2,'+50',true,'self?',{})
			end
			return true
		end
		m1.OnDeactivate=function(mr,bf,cur)
			if bf then return true end
			for i=mr.Count-1,0,-1 do
				if mr[i].Description~='amount' then
					mr[i].destroy()
				end
			end
			return true
		end
		m00=m0
		m0=addRecordUnder(m0,'+10',false,'hotfixOffset(+10)',{})--after 0.5.23
		m0.Options='[moAllowManualCollapseAndExpand,moManualExpandCollapse]'


		m1=addRecordUnder(m0,'+ED5',false,'cruiseControlReadOnly',{},vtByte)
		m1=addRecordUnder(m0,'+ED8',false,'cruiseControlSpeed',{},vtSingle)
		m1=addRecordUnder(m0,'+778',false,'autopilotReadOnly',{},vtByte)		
		m1=loadList(addRecordUnder(m0,'+C58',false,'driveMode',{}),true,true,true,{'0:Comfort','1:Sport','2:Drift','*:unknown'})
		m1=loadList(addRecordUnder(m0,'+770',false,'BlinkerMode',{},vtByte),true,true,true,{'0:Off','1:Left','2:Right','3:Hazard','*:unknown'})
		m1=loadList(addRecordUnder(m0,'+771',false,'Lights',{},vtByte),true,true,true,{'0:Off','1:Near','2:Far','*:unknown'})
		m1=addRecordUnder(m0,'+774',false,'sireneMode',{},nil,true)
		m1=addRecordUnder(m0,'+74C',false,'handleReadOnly',{},vtSingle)
		m1=addRecordUnder(m0,'+8A0',false,'fuel',{},vtSingle)
		m1=addRecordUnder(m0,'+1028',true,'cargoStructure?',{0})--pickup work/for truck +8 why?
			m2=addRecordUnder(m1,'+4C0',true,'someBase',{})
				m3=addRecordUnder(m2,'+8',false,'cargoAmount',{})
			m2=addRecordUnder(m1,'+A0',true,'someBase2',{0})
				m3=addRecordUnder(m2,'+F0',true,'someInterestingValIfEqu3',{0})
		m1=addRecordUnder(m0,'+FA4',true,'trailerAttached',{})--FL1-tested
		m1=addRecordUnder(m0,'+FA0',true,'trailerAttached(bool)',{})--FL1-tested
		m1=addRecordUnder(m0,'+F98',true,'trailerID',{})--FL1-tested
		
		
		m1=addRecordUnder(m0,'+C48',true,'parts',{},vtGrouped)
			m2=addRecordUnder(m1,'+8',false,'amount',{})
		m1.OnActivate=function(mr,bf,cur)
			if bf then return true end
			for i=0,tonumber(mr[0].Value)-1 do
				m2=addRecordUnder(mr,'+0',false,'part',{i*32})
				m3=addRecordUnder(m2,'+4',false,'0',{})
				m3=addRecordUnder(m2,'+8',true,'1',{})
				m3=addRecordUnder(m2,'+C',false,'2',{})
				m3=addRecordUnder(m2,'+10',false,'3',{})
				m3=addRecordUnder(m2,'+14',false,'damage',{},vtSingle)
				m3=addRecordUnder(m2,'+18',true,'4',{})
				m3=addRecordUnder(m2,'+1C',false,'5',{})
			end
			return true
		end
		m1.OnDeactivate=function(mr,bf,cur)
			if bf then return true end
			for i=mr.Count-1,0,-1 do
				if mr[i].Description~='amount' then
					mr[i].destroy()
				end
			end
			return true
		end
		m1=addRecordUnder(m0,'+944',false,'vehicleWeightReadOnly',{},vtSingle)--engine??(no)
		--m1=addRecordUnder(m0,'+8A8',true,'transmission???nope',{})
		m1=addRecordUnder(m0,'+8C0',true,'???seatRelated',{0})
			m2=addRecordUnder(m1,'+10',true,'???passengerID',{})
		
		m1=addRecordUnder(m0,'+ABC',false,'makeZero',{},nil,true)--val=-1
			loadList(m1,true,true,true,{'-1:Diasbled','0:Enabled','*:changes?'})
		m1=addRecordUnder(m0,'+A98',true,'change0',{})--34B64F04
			loadList(m1,true,true,true,{'00000000:Diasbled','34B64F04:Enabled','*:changes?'})
		m1=addRecordUnder(m0,'+A9C',true,'change1',{})--4BECF9F6
			loadList(m1,true,true,true,{'00000000:Diasbled','4BECF9F6:Enabled','*:changes?'})
		m1=addRecordUnder(m0,'+AA0',true,'change2',{})--844B2695
			loadList(m1,true,true,true,{'00000000:Diasbled','844B2695:Enabled','*:changes?'})
		m1=addRecordUnder(m0,'+AA4',true,'change3',{})--526493AE
			loadList(m1,true,true,true,{'00000000:Diasbled','526493AE:Enabled','*:changes?'})
		m1=addRecordUnder(m0,'+AB0',false,'valueEqu6',{})
		m1=addRecordUnder(m0,'+AB4',false,'valueEqu8',{})
		m1=addRecordUnder(m0,'+AB8',false,'garageIndex',{},nil,true)
		m1=addRecordUnder(m0,'+AA8',true,'userName(Unicode)',{0},vtString)
		
	m0.Collapsed=true
	m00.Collapsed=true
	--tunning +a98..+aa4,+abc change like in own
end
local humFill=function(brec)
	local m0,m1,m2,m3,m4,m00=nil,nil,nil,nil,nil,nil
	m0=addRecordUnder(brec,'+0',true,'human',{0})
	m0.Options='[moAllowManualCollapseAndExpand,moManualExpandCollapse]'
		m1=addRecordUnder(m0,'+50',true,'selfID',{})
		m1=addRecordUnder(m0,'+670',true,'pos',{},vtSingle)
		m1=addRecordUnder(m0,'+674',true,'pos',{},vtSingle)
	m0.Collapsed=true
end
local vehicleStructFill=function(baseAddress)
	local myad=AddressList.getMemoryRecordByDescription('userDriverInVehicle')
	--myad.Type=vtGrouped
	--local vehparts='39:Transmission\n*:undeclared'
	myad.ShowAsHex=true
	vehFill(myad)
	humFill(myad)
end
local valueTable={{name='userDriverInVehicle',value='488B8B500200004885C974??4885F6',freeze=false,setValue=nil,additionalf=vehicleStructFill,regsf='RBX+592'}}
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
				sleep(3000)
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
function genVehSteal(base)
	local m0,m1,m2,m3,m4=nil,nil,nil,nil,nil
	if type(base)=='number' then
		base=string.format('%X',base)
	end
	m0=addRecordUnder(nil,base,true,'humanIDthatIsPassenger',{})
	m0.Options='[moAllowManualCollapseAndExpand,moManualExpandCollapse]'
		m1=addRecordUnder(m0,'-1E0',true,'vehicleID',{})
			m2=vehFill(m1)
	m0.Collapsed=true
end

genVehSteal('0')
--[[
43B926B8 vehicle
43B933F0 seat
434CDFC0 human?
]]
