﻿

#Область ОбработчикиПодписокНаСобытия

Процедура ОбработкаПолученияФормы(ВидФормы, Параметры, ВыбраннаяФорма, ДополнительнаяИнформация, СтандартнаяОбработка)
	
	#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
		
		Если Параметры <> Неопределено И Параметры.Свойство("ОткрытаПоСценарию") Тогда
			СтандартнаяОбработка = Ложь;
			ВидИнформации = Параметры.ВидКонтактнойИнформации;
			ВыбраннаяФорма = ИмяФормыВводаКонтактнойИнформации(ВидИнформации);
			
			Если ВыбраннаяФорма = Неопределено Тогда
				ВызватьИсключение НСтр("ru = 'Не обрабатываемый тип адреса: """ + ВидИнформации + """'");
			КонецЕсли;
		КонецЕсли;
		
	#КонецЕсли
	
КонецПроцедуры

#КонецОбласти

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

// Возвращает имя формы для редактирования типа контактной информации.
//
// Параметры:
//      ВидИнформации - ПеречислениеСсылка.ТипыКонтактнойИнформации, СправочникСсылка.ВидыКонтактнойИнформации -
//                      запрашиваемый тип.
//
// Возвращаемое значение:
//      Строка - полное имя формы.
//
Функция ИмяФормыВводаКонтактнойИнформации(Знач ВидИнформации)
	
	ТипИнформации = ТипВидаКонтактнойИнформации(ВидИнформации);
	
	ВсеТипы = "Перечисление.ТипыКонтактнойИнформации.";
	Если ТипИнформации = ПредопределенноеЗначение(ВсеТипы + "Адрес") Тогда
		
		Если Метаданные.Обработки.Найти("РасширенныйВводКонтактнойИнформации") = Неопределено Тогда
			Возврат "Обработка.ВводКонтактнойИнформации.Форма.ВводАдресаВСвободнойФорме";
		Иначе
			Возврат "Обработка.РасширенныйВводКонтактнойИнформации.Форма.ВводАдреса";
		КонецЕсли;
		
	ИначеЕсли ТипИнформации = ПредопределенноеЗначение(ВсеТипы + "Телефон") Тогда
		Возврат "Обработка.ВводКонтактнойИнформации.Форма.ВводТелефона";
		
	ИначеЕсли ТипИнформации = ПредопределенноеЗначение(ВсеТипы + "Факс") Тогда
		Возврат "Обработка.ВводКонтактнойИнформации.Форма.ВводТелефона";
		
	КонецЕсли;
	
	Возврат Неопределено;
	
КонецФункции

Функция ТипВидаКонтактнойИнформации(Знач ВидИнформации)
	Результат = Неопределено;
	
	Тип = ТипЗнч(ВидИнформации);
	Если Тип = Тип("ПеречислениеСсылка.ТипыКонтактнойИнформации") Тогда
		Результат = ВидИнформации;
	ИначеЕсли Тип = Тип("СправочникСсылка.ВидыКонтактнойИнформации") Тогда
		Результат = ВидИнформации.Тип;
	ИначеЕсли ВидИнформации <> Неопределено Тогда
		Данные = Новый Структура("Тип");
		ЗаполнитьЗначенияСвойств(Данные, ВидИнформации);
		Результат = Данные.Тип;
	КонецЕсли;
	
	Возврат Результат;
КонецФункции

#КонецОбласти

#КонецЕсли


