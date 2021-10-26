_G['mtype']=function(a)
	if type(a)=='userdata' then
		return 'class:'..a.ClassName
	else
		return type(a)
	end
end