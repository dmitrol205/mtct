local function saveEnvironment()
	debug_getContext(true)
	local tab={}
	tab.rax=RAX
	tab.rbx=RBX
	tab.rcx=RCX
	tab.rdx=RDX
	tab.rsi=RSI
	tab.rdi=RDI
	tab.rbp=RBP
	tab.rsp=RSP
	tab.r8=R8
	tab.r9=R9
	tab.r10=R10
	tab.r11=R11
	tab.r12=R12
	tab.r13=R13
	tab.r14=R14
	tab.r15=R15
	tab.rip=RIP
	tab.eflags=EFLAGS
	tab.fp={}
	for i=0,7 do
		table.insert(tab.fp,load('return FP'..i))
	end
	--tab.fp={FP0,FP1,FP2,FP3,FP4,FP5,FP6,FP7}
	tab.xm={}
	for i=0,15 do
		table.insert(tab.xm,load('return XMM'..i))
	end
	--tab.xm={XMM0,XMM1,XMM2,XMM3,XMM4,XMM5,XMM6,XMM7,XMM8,XMM9,XMM10,XMM11,XMM12,XMM13,XMM14,XMM15}
	tab.stack={}
	for i=RSP,RSP+8*200,8 do
		table.insert(tab.stack,readQword(i))
	end
	return tab
end
local function tsh(bytes,val)
	return string.format('%'..(bytes*2)..'X',val)
end
local function f()
	print('executed')
	local t=saveEnvironment()
	local www=''
	for i=1,i<#t.stack do
		www=www..string.format('%16X',t.stack[i])
	end
	local scr=[[
alloc(newmem,4256)
label(mybase)
registersymbol(mybase)
label(mydata)
label(myend)
label(exit)
newmem:
mybase:
mov rax,]]..tsh(8,t.rax)..[[
mov rbx,]]..tsh(8,t.rbx)..[[
mov rcx,]]..tsh(8,t.rcx)..[[
mov rdx,]]..tsh(8,t.rdx)..[[
mov rsi,]]..tsh(8,t.rsi)..[[
mov rdi,]]..tsh(8,t.rdi)..[[
mov rbp,]]..tsh(8,t.rbp)..[[
mov rsp,]]..tsh(8,t.rsp)..[[
mov r8,]]..tsh(8,t.r8)..[[
mov r9,]]..tsh(8,t.r9)..[[
mov r10,]]..tsh(8,t.r10)..[[
mov r11,]]..tsh(8,t.r11)..[[
mov r12,]]..tsh(8,t.r12)..[[
mov r13,]]..tsh(8,t.r13)..[[
mov r14,]]..tsh(8,t.r14)..[[
mov r15,]]..tsh(8,t.r15)..[[
push ]]..tsh(8,t.eflags)..[[
popfq
call ]]..tsh(8,callfun)..[[
myend:
ret
mydata:

"mydata"+100:
db ]]..www..[[

exit:
createthread(mybase)
]]
	debug_removeBreakpoint(callfun)
	local v,c,r=autoAssemble(scr)
	if v then
		print('success')
	else
		print('error',c,r)
	end
end
detachIfPossible()
debugProcess(2)--VEH
_G['callfun']=nil
local x=aOBScan('48 8B 4B 38 E8 ?? ?? ?? ?? 84 C0 74 0B','+X-W-C',fsmAligned,'1')
print(x.Count)
if x.Count==1 then
	print(x.String[0])
	callfun=tonumber(x.String[0],16)+4
	debug_setBreakpoint(callfun,f)
	x.destroy()
else
	print('non unique address')
end