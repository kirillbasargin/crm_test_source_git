﻿
&НаСервере
Процедура ОбновитьЛидыНаСервере()
	УправлениеОбращениямиCQ.ОбновлениеЛидовCQ();
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьЛиды(Команда)
	ОбновитьЛидыНаСервере();
КонецПроцедуры
