function _U(string)
	if Locales[Config.Language] == nil then
		lib.print.error("Unable to find language: ", Config.Language, "Defaulting to en")
		Config.Language = "en"
		return _U(string)
	end
	if Locales[Config.Language][string] == nil then
		return string
	end
	return Locales[Config.Language][string]
end