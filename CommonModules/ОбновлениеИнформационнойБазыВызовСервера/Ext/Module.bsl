﻿#Область СлужебныйПрограммныйИнтерфейс

// Для интеграции с подсистемой "Обновление конфигурации".
// См. макет МакетФайлаОбновленияКонфигурации обработки УстановкаОбновлений.
//
Функция ВыполнитьОбновлениеИнформационнойБазы(ВыполнятьОтложенныеОбработчики = Ложь) Экспорт
	
	ДатаНачала = ТекущаяДатаСеанса();
	Результат = ОбновлениеИнформационнойБазы.ВыполнитьОбновлениеИнформационнойБазы(ВыполнятьОтложенныеОбработчики);
	ДатаОкончания = ТекущаяДатаСеанса();
	ОбновлениеИнформационнойБазыСлужебный.ЗаписатьВремяВыполненияОбновления(ДатаНачала, ДатаОкончания);
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти
