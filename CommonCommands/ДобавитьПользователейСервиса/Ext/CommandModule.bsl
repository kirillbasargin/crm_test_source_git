﻿
#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	СтруктураПользователя = ОткрытьФорму("ОбщаяФорма.ПользователиСервиса", ,
		ПараметрыВыполненияКоманды.Источник);
	
КонецПроцедуры

#КонецОбласти
