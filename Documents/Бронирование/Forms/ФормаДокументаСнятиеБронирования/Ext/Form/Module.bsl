﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Если Параметры.Свойство("ЗначенияЗаполнения")
			И ТипЗнч(Параметры.ЗначенияЗаполнения) = Тип("Структура") 
			И Параметры.ЗначенияЗаполнения.Свойство("ВидОперации") Тогда
			
		Объект.ВидОперации 	= Параметры.ЗначенияЗаполнения.ВидОперации;	
		ДатаСоздания		= ТекущаяДата();
		Объект.Дата 		= ДатаСоздания;
				
		Если Параметры.ЗначенияЗаполнения.Свойство("ОснованиеДляСнятияБронирования") Тогда
			Объект.ОснованиеДляСнятияБронирования   = Параметры.ЗначенияЗаполнения.ОснованиеДляСнятияБронирования;			
			//<852115>, Басаргин (07.08.2018) {
			Объект.ДомКлик = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Объект.ОснованиеДляСнятияБронирования, "ДомКлик");	
			//<852115> }			
		КонецЕсли;
		
		Если Не ЗначениеЗаполнено(Объект.ОбъектНедвижимости) 			
				И Объект.ВидОперации = Перечисления.ВидыОперацииБронирования.СнятиеБронирования 
				И ЗначениеЗаполнено(Объект.ОснованиеДляСнятияБронирования) Тогда
			Объект.ОбъектНедвижимости = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Объект.ОснованиеДляСнятияБронирования, "ОбъектНедвижимости");
		КонецЕсли;
				
		Если ЗначениеЗаполнено(Объект.ОснованиеДляСнятияБронирования)
			И ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Объект.ОснованиеДляСнятияБронирования, "ВидОперации") = Перечисления.ВидыОперацииБронирования.СнятиеБронирования Тогда
			Сообщение 			= Новый СообщениеПользователю;
			Сообщение.Текст 	= "Документ снятия с бронирования можно вводить только на основании документа с видом операции ""Бронирование""!";
			Сообщение.Сообщить();
			Отказ				= Истина;
		КонецЕсли;
		
		Если Объект.ВидОперации = Перечисления.ВидыОперацииБронирования.СнятиеБронирования
				И НЕ ЗначениеЗаполнено(Объект.ОснованиеДляСнятияБронирования) Тогда
			Отказ = Истина;	
		КонецЕсли;
		
	КонецЕсли;	
	
	////<852115>, Басаргин (08.08.2018) {
	//Элементы.ДомКлик.Доступность = УправлениеДоступом.ЕстьРоль("БронированиеДомКлик", , ПользователиКлиентСервер.АвторизованныйПользователь());
	////<852115> }
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	Оповестить("СобытиеБронирования");
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормы

#КонецОбласти

#Область ОбработчикиКомандФормы


#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#КонецОбласти
