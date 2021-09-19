--[[exports.scoreboard:addScoreboardColumn ( "UID", 1, 1, 0.05 )
exports.scoreboard:addScoreboardColumn ( "GP", 1, 2, 0.05 )

exports.scoreboard:addScoreboardColumn ( "Morderstwa", 1, 5, 0.1 )
exports.scoreboard:addScoreboardColumn ( "Czas Gry", 1, 6, 0.09 )
exports.scoreboard:addScoreboardColumn ( "Zabite zombie", 1, 7, 0.113 )
]]
exports.scoreboard:scoreboardAddColumn("UID",getRootElement(),30,"UID",1)
exports.scoreboard:scoreboardAddColumn("GP",getRootElement(),50,"GP")
exports.scoreboard:scoreboardAddColumn("_Czas_Gry(Wyswietl)_",getRootElement(),70,"Czas gry(H)")
exports.scoreboard:scoreboardAddColumn("MORDERSTWA",getRootElement(),70,"Morderstwa")
