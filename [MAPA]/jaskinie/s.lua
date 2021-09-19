pliki={"wyspa_1.col","wyspa_1.dff"}
function kompiluj()
	for i,v in ipairs(pliki) do
		local file=fileOpen("zdekompilowane/"..v,true)
		buffor=fileRead(file,fileGetSize(file))
		fileClose(file)
		file=nil
		local file2=fileCreate("wyspy/"..v)
		fileWrite(file2,teaEncode(buffor,md5(v)))
		fileClose(file2)
		file2=nil
		buffor=nil
	end
end
--kompiluj()