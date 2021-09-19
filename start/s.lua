startResource(getResourceFromName("DB"))
q=exports.db:pobierzTabeleWynikow("select * from Autostart")
for i,v in ipairs(q) do
	startResource(getResourceFromName(v.skrypt))
end