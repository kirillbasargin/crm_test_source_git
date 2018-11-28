﻿
Процедура ПриЗаписи(Отказ, Замещение)
	
	Если НЕ Отказ И ЭтотОбъект.Количество() Тогда
		СсылкаЗаявкаНаСделку = ЭтотОбъект.Отбор.ЗаявкаНаСделку.Значение;
		Если ЗначениеЗаполнено(СсылкаЗаявкаНаСделку) И ЭтотОбъект[0].Статус = Перечисления.СтатусыСделки.Отказ Тогда			
			РегистрыСведений.РассылкаПоСогласованиюЗаявокНаСделку.ЗаписатьРассылку(СсылкаЗаявкаНаСделку, Перечисления.СтатусыСделки.Отказ, ЭтотОбъект.Отбор.Период.Значение);
			//<792882>, Басаргин (26.03.2018) {
			Попытка
				ЗапросСсылка = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(СсылкаЗаявкаНаСделку, "ДокументОснование");
				Если ЗначениеЗаполнено(ЗапросСсылка) Тогда
					ЗапросОбъект = ЗапросСсылка.ПолучитьОбъект();
					Если НЕ ЗапросОбъект = Неопределено Тогда
						ЗапросОбъект.Стадия = Перечисления.СтадииЗапроса.Переговоры;
						ЗапросОбъект.Статус = Перечисления.СтатусыЗапроса.Отказ;
						ЗапросОбъект.РасшифровкаСтатуса = Справочники.ПричиныСтатусовЗапроса.РасторжениеСделки;
						ЗапросОбъект.ДополнительныеСвойства.Вставить("СистемноеПроведение", Истина);
						Если ДополнительныеСвойства.Свойство("АвторИзменения") И ЗначениеЗаполнено(ДополнительныеСвойства.АвторИзменения) Тогда
							ЗапросОбъект.ДополнительныеСвойства.Вставить("АвторВерсии", ДополнительныеСвойства.АвторИзменения);
						Иначе
							ЗапросОбъект.ДополнительныеСвойства.Вставить("АвторВерсии", Справочники.Пользователи.Робот);
						КонецЕсли;	
						//ЗапросОбъект.ОбменДанными.Загрузка = Истина;						
						ЗапросОбъект.Записать(РежимЗаписиДокумента.Проведение);    
					КонецЕсли;
				КонецЕсли;
			Исключение
				ЗаписьЖурналаРегистрации("ОбновитьЗапросПриОтменеСделки", 
					УровеньЖурналаРегистрации.Ошибка, 
					Метаданные.Документы.Запрос, 
					ЗапросОбъект.Ссылка,
					"При обновлении запроса по отмененной сделке произошла ошибка: " + ОписаниеОшибки());						
			КонецПопытки;
			//<792882> }			
		КонецЕсли;
	КонецЕсли;		
	
КонецПроцедуры

