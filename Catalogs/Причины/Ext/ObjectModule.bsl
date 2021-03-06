﻿
Процедура ПередЗаписью(Отказ)
	
	Если  ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если ЭтоНовый() Тогда
		Отказ = Истина;
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Добавление справочников доступно только в базе УТ!", ЭтотОбъект);
	КонецЕсли;
		
	МассивРеквизитов = Новый Массив;
	МассивРеквизитов.Добавить("Сделка");
	МассивРеквизитов.Добавить("Актуальная");
	
	Если ИзмененыРеквизиты(МассивРеквизитов) Тогда
		Отказ = Истина;
		СтрокаСпискаРеквизитов = "";
		Для Каждого Стр Из МассивРеквизитов Цикл
			СтрокаСпискаРеквизитов = СтрокаСпискаРеквизитов + ?(СтрокаСпискаРеквизитов="",""," ,") + """" + Стр + """";
		КонецЦикла;
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Запрет на изменение реквизитов: " + СтрокаСпискаРеквизитов, ЭтотОбъект);
	КонецЕсли;
	
КонецПроцедуры

Функция ИзмененыРеквизиты(МассивРеквизитов)
	
	СсылкаНаОбъект = ЭтотОбъект.Ссылка;
	РеквизитыИзменены = Ложь;
	
	Для Каждого Стр Из МассивРеквизитов Цикл
		Если ЭтотОбъект[Стр] <> СсылкаНаОбъект[Стр] Тогда
			РеквизитыИзменены = Истина;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	Возврат РеквизитыИзменены;
	
КонецФункции
	
Процедура ПеренестиОбъектыВТЧ() Экспорт
	СтрокиОтбора = ЭтотОбъект.Объекты.НайтиСтроки(Новый Структура("КлючСтроки",0));
	Для Каждого Стр Из СтрокиОтбора Цикл
		ЭтотОбъект.Объекты.Удалить(Стр);
	КонецЦикла;
	
	Для Каждого Стр Из ЭтотОбъект.Подарки Цикл
		Если Стр.КлючСтроки = 0 Тогда
			Стр.КлючСтроки = ПолучитьНовыйКлючСтроки();
			НовПодарок = ЭтотОбъект.Объекты.Добавить();
			ЗаполнитьЗначенияСвойств(НовПодарок, Стр,,"НомерСтроки");
		КонецЕсли;
	КонецЦикла;
		
КонецПроцедуры

Функция ПолучитьНовыйКлючСтроки(ИмяТЧ = "Подарки") Экспорт
	
	МаксКлюч = 0;
	Если МаксКлюч = 0 Тогда
		Если ЭтотОбъект[ИмяТЧ].Количество() > 1 Тогда
			Для Каждого Стр Из ЭтотОбъект[ИмяТЧ] Цикл
				МаксКлюч = Макс(МаксКлюч, Стр.КлючСтроки);
			КонецЦикла;
		КонецЕсли;
	КонецЕсли;
	
	МаксКлюч = МаксКлюч + 1;


	Возврат МаксКлюч;

КонецФункции 
