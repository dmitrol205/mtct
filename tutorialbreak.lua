local mem='8B417085C07F03'--tuttorial life
_G['ms']=createMemScan()
local fl=createFoundList(ms)
ms.newScan()
ms.OnlyOneResult=true
ms.firstScan(soExactValue,vtByteArray,rtTruncated,mem,'','0','00007fffffffffff','+X-W-C',fsmNotAligned,'',true,false,false,false)
ms.waitTillDone()
fl.initialize()
print('Addresses found',fl.Count)
print(string.format('Address is %X',ms.Result))
fl.destroy()
ms.destroy()